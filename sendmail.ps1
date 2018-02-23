# ANTONIS MANDILAS 2018
# version v1.0.1

. ".\Invoke-JsonRPC.ps1"

$EthMinerAddress='127.0.0.1'
$EthMinerPort=3333

$response = Invoke-RestMethod -Uri 'https://api.ethermine.org/miner/<YOUR_ETH_ADDRESS>/currentStats' -DisableKeepAlive

$Body = "Unpaid balance`n============================`n" + $response.data.unpaid + "`n`n"

$Body += "Valid shares`n============================`n" + $response.data.validShares + "`n`n"

$Body += "Invalid shares`n============================`n" + $response.data.invalidShares + "`n`n"

$Body += "Stale shares`n============================`n" + $response.data.staleShares + "`n`n"

$Body += "Average hashrate the last 24 hours`n============================`n" + $response.data.averageHashrate + "`n`n"

$Body += "Current hashrate `n============================`n" + $response.data.currentHashrate + "`n`n"

$Body += "ethminer stats `n============================`n"
$RPCResult = Invoke-JsonRPC $EthMinerAddress $EthMinerPort '{"method": "miner_getstat1", "jsonrpc": "2.0", "id": 5 }'
$ResultJsonObject = ConvertFrom-Json -InputObject $RPCResult

$HashRateShares = $ResultJsonObject.result[2] -split ';'
$HashRatesPerCard = $ResultJsonObject.result[3] -split ';'
$TemperaturesPerCard = $ResultJsonObject.result[6] -split ';'

$Body = $Body + "Uptime: " + $ResultJsonObject.result[1]
$Body = $Body + "`nShares: " + $HashRateShares[1] + ", average : " + [math]::Round(($HashRateShares[1] / $ResultJsonObject.result[1]),2) + " shares / minute"
$Body = $Body + "`nCurrent hashrate: " + $HashRateShares[0]
$Body = $Body + "`nGPU(s) Hash Rate(s): " + $HashRatesPerCard
$Body = $Body + "`nGPU(s) Temperature(s): " + $TemperaturesPerCard


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