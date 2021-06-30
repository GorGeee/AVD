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

# Create the working directory if it doesnt exist
If (!(Test-Path $WorkingDir)) { 
    New-Item $WorkingDir -ItemType Directory | Out-Null
}

# Create the logfile if it doesnt exist
If (!(Test-Path $WorkingDir\$LogFile)) { 
    New-Item $LogFile | Out-Null
}

Function log {
	Param([string]$string)
 	$string | Out-File -FilePath $LogFile -append
    Write-Host $string
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
Start-Process -FilePath "$WorkingDir\$AppName.exe" -ArgumentList "/VERYSILENT" -Passthru | Out-Null
Log "$(TimeNow) - Installed $AppName"

Log "$(TimeNow) - # [END]: $AppName #"
Log ""