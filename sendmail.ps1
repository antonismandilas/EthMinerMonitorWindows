. "<PATH_TO_SCRIPTS>\Invoke-JsonRPC.ps1"

$temp = ""

$response = Invoke-RestMethod -Uri 'https://api.ethermine.org/miner/<YOUR_ETH_ADDRESS>/currentStats' -DisableKeepAlive

$Body = "Unpaid balance`n============================`n" + $response.data.unpaid + "`n`n"

$Body += "Valid shares`n============================`n" + $response.data.validShares + "`n`n"

$Body += "Invalid shares`n============================`n" + $response.data.invalidShares + "`n`n"

$Body += "Stale shares`n============================`n" + $response.data.staleShares + "`n`n"

$Body += "Average hashrate the last 24 hours`n============================`n" + $response.data.averageHashrate + "`n`n"

$Body += "Current hashrate `n============================`n" + $response.data.currentHashrate + "`n`n"

$Body += "ethminer stats `n============================`n"
$RPCResult = Invoke-JsonRPC '127.0.0.1' 3333 '{"method": "miner_getstat1", "jsonrpc": "2.0", "id": 5 }'
$ResultJsonObject = ConvertFrom-Json -InputObject $RPCResult

$Body = $Body + "Shares: " + $ResultJsonObject.result[1] + " - GPU(s) Hash Rate(s): " + $ResultJsonObject.result[3]
$Body = $Body + " - GPU(s) Temperature(s): " + $ResultJsonObject.result[6]


$EmailFrom = "<>"
$EmailTo = "<>"
$SMTPServer = "<>"
$Username = "<>"
$Password = "<>"
$Subject = "Win Miner 1 -- Report"
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
$SMTPClient.EnableSsl = $true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)