# Set windows page file to 32GB
$SystemInfo=Get-WmiObject -Class Win32_ComputerSystem -EnableAllPrivileges
$SystemInfo.AutomaticManagedPageFile = $false
$PageFile = Get-WmiObject -Class Win32_PageFileSetting -Filter "SettingID='pagefile.sys @ C:'"
Set-WmiInstance -Class Win32_PageFileSetting -Arguments @{name="C:\pagefile.sys"; InitialSize = 32768; MaximumSize = 32768} ` -EnableAllPrivileges |Out-Null

# Disable hibernate, which automatically deletes hiberfil.sys
Start-Process 'powercfg.exe' -Verb runAs -ArgumentList '/h off'

Get-AppxPackage *3dbuilder* | Remove-AppxPackage
Get-AppxPackage *windowsalarms* | Remove-AppxPackage
Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage
Get-AppxPackage *windowscamera* | Remove-AppxPackage
Get-AppxPackage *officehub* | Remove-AppxPackage
Get-AppxPackage *skypeapp* | Remove-AppxPackage
Get-AppxPackage *getstarted* | Remove-AppxPackage
Get-AppxPackage *zunemusic* | Remove-AppxPackage
Get-AppxPackage *windowsmaps* | Remove-AppxPackage
Get-AppxPackage *solitairecollection* | Remove-AppxPackage
Get-AppxPackage *bingfinance* | Remove-AppxPackage
Get-AppxPackage *zunevideo* | Remove-AppxPackage
Get-AppxPackage *bingnews* | Remove-AppxPackage
Get-AppxPackage *onenote* | Remove-AppxPackage
Get-AppxPackage *people* | Remove-AppxPackage
Get-AppxPackage *windowsphone* | Remove-AppxPackage
Get-AppxPackage *photos* | Remove-AppxPackage
Get-AppxPackage *windowsstore* | Remove-AppxPackage
Get-AppxPackage *bingsports* | Remove-AppxPackage
Get-AppxPackage *soundrecorder* | Remove-AppxPackage
Get-AppxPackage *bingweather* | Remove-AppxPackage
Get-AppxPackage *xboxapp* | Remove-AppxPackage
Get-AppxPackage *FarmVille2CountryEscape* | Remove-AppxPackage
Get-AppxPackage *Microsoft.XboxIdentityProvider* | Remove-AppxPackage
Get-AppxPackage *king.com.CandyCrushSodaSaga* | Remove-AppxPackage
Get-AppxPackage *Microsoft.Advertising.Xaml* | Remove-AppxPackage
Get-AppxPackage *Microsoft.WindowsFeedbackHub* | Remove-AppxPackage
Get-AppxPackage *Microsoft.StorePurchaseApp* | Remove-AppxPackage
Get-AppxPackage *Microsoft.Messaging* | Remove-AppxPackage
Get-AppxPackage *PandoraMediaInc* | Remove-AppxPackage
Get-AppxPackage *Drawboard.DrawboardPDF* | Remove-AppxPackage
Get-AppxPackage *Twitter* | Remove-AppxPackage
Get-AppxPackage *Candy* | Remove-AppxPackage
Get-AppxPackage *FarmVille* | Remove-AppxPackage
Get-AppxPackage *One* | Remove-AppxPackage

write-host Stopping OneDrive
taskkill /f /im OneDrive.exe
timeout /t 3 /nobreak

write-host Uninstalling OneDrive
& $env:SystemRoot\SysWOW64\OneDriveSetup.exe /uninstall
timeout /t 3 /nobreak


write-host Removeing OneDrive from the Explorer Side Panel
REG DELETE "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
REG DELETE "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f

# Remove home group from windows explorer and stop associated services
Set-Service HomeGroupProvider -StartupType Disabled
Stop-Service HomeGroupProvider

# Disable superfetch
Set-Service SysMain -StartupType Disabled
Stop-Service SysMain