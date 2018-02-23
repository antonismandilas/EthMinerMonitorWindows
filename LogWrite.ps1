# ANTONIS MANDILAS 2018
# version v1.0.1

$Logfile = ".\$(gc env:computername)-" + (Get-Date -Format "yyyy-MM-dd") +".log"

Function LogWrite {
	Param (
		[parameter(ValueFromPipeline)]
		[String]$logstring)

   Write-Host $logstring
   
   Add-content $Logfile -value $logstring
}