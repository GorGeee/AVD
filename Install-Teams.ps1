<#
.PURPOSE
    Silent clean installation of Optimized Microsoft Teams

.CREATEDBY
    George Zajakovski
#>

$ScriptName = "Install-Teams.ps1"

$WorkingDir = "C:\temp\cubesys\"
$LogFile = "$WorkingDir\Install.log"

If (!(Test-Path $WorkingDir)) { 
    New-Item $WorkingDir -ItemType Directory 
    New-Item $LogFile
}

Function log {
	Param([string]$string)
 	$string | Out-File -FilePath $LogFile -append
}

function TimeNow(){
    $time = Get-Date
    $AusEast = $Time.AddHours(10.0)
    return $AusEast
}

Log "$(TimeNow) - Start $ScriptName Script"

Log "$(TimeNow) - Set Teams required regKey"
New-Item -Path HKLM:\SOFTWARE\Microsoft -Name "Teams" 
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Teams -Name "IsWVDEnvironment" -Type "Dword" -Value "1"
Log "$(TimeNow) - Finished required regKey"

# Download WebRTC
Log "$(TimeNow) - Downloading WebRTC"
$WebRTCurl = 'https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE4AQBt'
Invoke-WebRequest -Uri $WebRTCurl -OutFile "$WorkingDir\WebRTC.msi"
Log "$(TimeNow) - Download complete"

# Install WebRTC
Log "$(TimeNow) - Installing WebRTC"
Start-Process C:\Windows\System32\msiexec.exe -ArgumentList "/i $WorkingDir\WebRTC.msi /qn" -Wait
Log "$(TimeNow) - Install of WebRTC Complete"

# Download Microsoft Teams
Log "$(TimeNow) - Downloading Teams"
$TeamsURL = "https://teams.microsoft.com/downloads/desktopurl?env=production&plat=windows&arch=x64&managedInstaller=true&download=true"
Invoke-WebRequest -Uri $TeamsURL -OutFile "$WorkingDir\Teams_windows_x64.msi"
Log "$(TimeNow) - Download complete"

# Install Teams Machine-Wide
Log "$(TimeNow) - Installing Teams"
Start-Process C:\Windows\System32\msiexec.exe -ArgumentList "/i $WorkingDir\Teams_windows_x64.msi /l*v $WorkingDir\teams_log.log ALLUSER=1 /qn" -Wait
Log "$(TimeNow) - Install of Teams complete"