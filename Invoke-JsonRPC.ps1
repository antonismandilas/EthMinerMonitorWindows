# ANTONIS MANDILAS 2018
# version v1.0.1

. ".\LogWrite.ps1"

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

	if ($tcpConnection.Connected) {
		$writer.WriteLine($RPCCommand)

		if ($tcpStream.DataAvailable) {
			$result = $reader.ReadLine()
		} else {
			LogWrite 'No Data available!!!!!'

			$result = "{'error' : 'no-data-available'}";
		}
	} else {
		LogWrite 'TCP NOT CONNECTED!!!'

		$result = "{'error' : 'tcp-not-connected'}";
	}

	$reader.Close()
	$writer.Close()
	$tcpConnection.Close()

	return $result
}