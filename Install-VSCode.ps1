<#
.PURPOSE
    Silent clean installation of VS Code

.CREATEDBY
    George Zajakovski - https://www.linkedin.com/in/gzajakovski/
#>

# User Vars
$WorkingDir = "C:\temp\cubesys\"
$LogFile = "$WorkingDir\Install.log"
$AppName = "VSCode"

# Software URLs
$VSCodeURL = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64"

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

# Download 
Log "$(TimeNow) - Downloading $AppName"
Invoke-WebRequest -Uri $VSCodeURL -OutFile "$WorkingDir\$AppName.exe"
Log "$(TimeNow) - Download complete"

# Install
Log "$(TimeNow) - Installing $AppName"
Start-Process -FilePath "$WorkingDir\$AppName.exe" -ArgumentList "/VERYSILENT" -Passthru
Log "$(TimeNow) - Installed $AppName"

Log "$(TimeNow) - # [END]: $AppName #"