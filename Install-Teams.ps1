<#
.PURPOSE
    Silent clean installation of Optimized Microsoft Teams

.CREATEDBY
    George Zajakovski - https://www.linkedin.com/in/gzajakovski/
#>

# User Vars
$WorkingDir = "C:\temp\cubesys\"
$LogFile = "$WorkingDir\Install.log"
$AppName = "Teams"

# Software URLs
$WebRTCurl = 'https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE4AQBt'
$TeamsURL = "https://teams.microsoft.com/downloads/desktopurl?env=production&plat=windows&arch=x64&managedInstaller=true&download=true"

#################### 
### SCRIPT BEGIN ###
#################### 

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

Log "$(TimeNow) - # [BEGIN]: $AppName #"

Log "$(TimeNow) - Set Teams required regKey"
New-Item -Path HKLM:\SOFTWARE\Microsoft -Name "Teams" -Force | Out-Null
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Teams -Name "IsWVDEnvironment" -Type "Dword" -Value "1" -Force | Out-Null
Log "$(TimeNow) - Finished required regKey"

# Download WebRTC
Log "$(TimeNow) - Downloading WebRTC"
Invoke-WebRequest -Uri $WebRTCurl -OutFile "$WorkingDir\WebRTC.msi"
Log "$(TimeNow) - Download complete"

# Install WebRTC
Log "$(TimeNow) - Installing WebRTC"
Start-Process C:\Windows\System32\msiexec.exe -ArgumentList "/i $WorkingDir\WebRTC.msi /qn" -Wait
Log "$(TimeNow) - Installed WebRTC"

# Download Microsoft Teams
Log "$(TimeNow) - Downloading $AppName"
Invoke-WebRequest -Uri $TeamsURL -OutFile "$WorkingDir\$AppName.msi"
Log "$(TimeNow) - Download complete"

# Install Teams Machine-Wide
Log "$(TimeNow) - Installing $AppName"
Start-Process C:\Windows\System32\msiexec.exe -ArgumentList "/i $WorkingDir\$AppName.msi /l*v $WorkingDir\$AppName.log ALLUSER=1 /qn" -Wait
Log "$(TimeNow) - Installed $AppName"

Log "$(TimeNow) - # [END]: $AppName #"
Log ""