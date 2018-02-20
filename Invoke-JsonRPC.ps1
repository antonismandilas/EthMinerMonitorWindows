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
		$writer.WriteLine($RPCCommand)

		if ($tcpStream.DataAvailable)
		{
			$result = $reader.ReadLine()
		} else {
			Write-Host 'No Data available!!!!!'
		}

	} else
	{
			Write-Host 'TCP NOT CONNECTED!!!'
	}

	$reader.Close()
	$writer.Close()
	$tcpConnection.Close()
	
	return $result
}