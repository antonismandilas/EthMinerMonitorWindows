# ANTONIS MANDILAS 2018
# version v1.0.1

# The script produces a log file per day, every time it is executed it writes a result in a file.
# It invokes the JsonRPC endpoint of ethminer to monitor the GPUs. If any of them reports a 0 hash rate restarts the miner.
# When the scripts fails to connet to the miner, it issues a restart of the. 
# All commands are conifgurable.

$ScriptsBathPath = ".\"

. ($ScriptsBathPath + "\Invoke-JsonRPC.ps1")
. ($ScriptsBathPath + "\LogWrite.ps1")

$MinerExecutionCommand = $ScriptsBathPath + 'launch-ethminer.bat'
$MinerRestartCommand= $ScriptsBathPath + 'restart.bat'
$EthMinerAddress='127.0.0.1'
$EthMinerPort=3333

LogWrite (Get-Date -Format g)

$RPCResult = Invoke-JsonRPC $EthMinerAddress $EthMinerPort '{"method": "miner_getstat1", "jsonrpc": "2.0", "id": 5 }'

$ResultJsonObject = ConvertFrom-Json -InputObject $RPCResult

if (-not ([string]::IsNullOrEmpty($ResultJsonObject.error))) {
	LogWrite ("Could not read from ethminer RPC, error : " + $ResultJsonObject.error)

	if ($ResultJsonObject.error -eq "tcp-not-connected") {
		LogWrite ("Restarting rig..")
		start $MinerRestartCommand
	}
} else {
	$HashRateShares = $ResultJsonObject.result[2] -split ';'
	$HashRatesPerCard = $ResultJsonObject.result[3] -split ';'

	LogWrite ("Uptime: " + $ResultJsonObject.result[1])
	LogWrite ("Shares: " + $HashRateShares[1] + ", average : " +  [math]::Round(($HashRateShares[1] / $ResultJsonObject.result[1]),2) + " shares / minute.")
	LogWrite ("Current hashrate : " + $HashRateShares[0] / 1000 + " MH/s")
	LogWrite ("GPU(s) Hash Rate(s): " + $HashRatesPerCard)

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

}