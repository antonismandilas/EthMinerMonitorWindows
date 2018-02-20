# ANTONIS MANDILAS 2018

$response = Invoke-RestMethod -Uri 'https://api.ethermine.org/miner/<YOUR_ETH_ADDRESS>/currentStats' -DisableKeepAlive

$Body = "Unpaid balance`n============================`n" + $response.data.unpaid + "`n`n"

$Body += "Valid shares`n============================`n" + $response.data.validShares + "`n`n"

$Body += "Invalid shares`n============================`n" + $response.data.invalidShares + "`n`n"

$Body += "Stale shares`n============================`n" + $response.data.staleShares + "`n`n"

$Body += "Average hashrate the last 24 hours`n============================`n" + $response.data.averageHashrate + "`n`n"

$Body += "Current hashrate `n============================`n" + $response.data.currentHashrate + "`n`n"

$EmailFrom = "<>"
$EmailTo = "<>"
$SMTPServer = "<>"
$Username = "<>"
$Password = "<>"
$Subject = "Win Miner 1 -- System Startup"
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
$SMTPClient.EnableSsl = $true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)