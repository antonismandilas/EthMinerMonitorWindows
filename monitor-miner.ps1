# ANTONIS MANDILAS 2018
# The script produces a log file per day, every time it is executed it writes a result in a file.
# It invokes the JsonRPC endpoint of ethminer to monitor the GPUs. If any of them reports a 0 hash rate restarts the miner.
# When the scripts fails to connet to the miner, it issues a restart of the. 
# All commands are conifgurable.

$Logfile = ".\$(gc env:computername)-" + (Get-Date -Format "yyyy-MM-dd") +".log"
$MinerExecutionCommand = '<PATH_TO_SCRIPT>\launch-ethminer.bat'
$MinerRestartCommand='<PATH_TO_SCRIPT>\restart.bat'
$EthMinerAddress='127.0.0.1'
$EthMinerPort=3333

Function LogWrite
{
   Param (
   [parameter(ValueFromPipeline)]
   [String]$logstring)

   Write-Host $logstring
   
   Add-content $Logfile -value $logstring
}

function Invoke-JsonRPC {
	Param(
		[parameter(Mandatory=$true)]
		[String]$RPCServerHost,
		[parameter(Mandatory=$true)]
		[int]$RPCServerPort,
		[parameter(Mandatory=$true)]
		[String]$RPCCommand
	)

	$result = ''

	$tcpConnection = New-Object System.Net.Sockets.TcpClient($RPCServerHost, $RPCServerPort)
	$tcpStream = $tcpConnection.GetStream()
	$reader = New-Object System.IO.StreamReader($tcpStream)
	$writer = New-Object System.IO.StreamWriter($tcpStream)
	$writer.AutoFlush = $true
		
	if ($tcpConnection.Connected)
	{
		$writer.WriteLine($RPCCommand + '\n')
				
		if ($tcpStream.DataAvailable)
		{
			$result = $reader.ReadLine()
		} else {
			LogWrite 'No Data available!!!!!'
		}

	} else
	{
		LogWrite 'Cannot connecto to miner!!!!'
		LogWrite "Restart miner...".
		start $MinerRestartCommand
	}
	
	$reader.Close()
	$writer.Close()
	$tcpStream.Close()
	$tcpConnection.Close()
	
	return $result
}

LogWrite (Get-Date -Format g)

$RPCResult = Invoke-JsonRPC $EthMinerAddress $EthMinerPort '{"method": "miner_getstat1", "jsonrpc": "2.0", "id": 5 }'

$ResultJsonObject = ConvertFrom-Json -InputObject $RPCResult

LogWrite ("Shares: " + $ResultJsonObject.result[1] + "`nGPU(s) Hash Rate(s): " + $ResultJsonObject.result[3])

$HashRatesPerCard = $ResultJsonObject.result[3] -split ';'

for ($i=0; $i -lt $HashRatesPerCard.length; $i++) {
	if ($HashRatesPerCard[$i] -eq "0") {
		LogWrite ("GPU " + $i + " has stopped mining. Restarting miner..")
				
		Stop-Process -Name "ethminer"
		
		start $MinerExecutionCommand
		
		Get-Process -Name 'ethminer' | Format-Table id, name | Out-String | LogWrite
		
		LogWrite "ethminer restarted!".
		
		break
	}
}