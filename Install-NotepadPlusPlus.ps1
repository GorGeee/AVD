<#
.PURPOSE
    Install the latest Notepad++ application

.CREATEDBY
    George Zajakovski - https://www.linkedin.com/in/gzajakovski/
#>

# User Vars
$WorkingDir = "C:\temp\cubesys\"
$LogFile = "$WorkingDir\Install.log"
$AppName = "NotePadPlusPlus"

# Software URLs
$NPPlusURL = "https://notepad-plus-plus.org"

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

# Find latest version
Log "$(TimeNow) - Grabbing latest version"
$BasePage = Invoke-WebRequest -Uri $NPPlusURL -UseBasicParsing
$ChildPath = $BasePage.Links | Where-Object { $_.outerHTML -like '*Current Version*' } | Select-Object -ExpandProperty href

# Grab the version number for logging
$Version = $ChildPath.Split('/')[2]
Log "$(TimeNow) - Found '$Version'"

# Find the Installer based on the OS arch
$DownloadPageUri = $NPPlusURL + $ChildPath
$DownloadPage = Invoke-WebRequest -Uri $DownloadPageUri -UseBasicParsing

If ( [System.Environment]::Is64BitOperatingSystem ) {
    $DownloadUrl = $DownloadPage.Links | Where-Object { $_.outerHTML -like '*npp.*.Installer.x64.exe"*' } | Select-Object -ExpandProperty href
} else {
    $DownloadUrl = $DownloadPage.Links | Where-Object { $_.outerHTML -like '*npp.*.Installer.exe"*' } | Select-Object -ExpandProperty href
}
Log "$(TimeNow) - Download URL = $DownloadUrl"

$AppExecutable = Split-Path -Path $DownloadUrl -Leaf

# Download the application
Log "$(TimeNow) - Downloading $AppName"
Invoke-WebRequest -Uri $DownloadUrl -OutFile "$WorkingDir\$AppExecutable" | Out-Null
Log "$(TimeNow) - Download complete"

# Install the application
Log "$(TimeNow) - Installing $AppName"
Start-Process -FilePath "$WorkingDir\$AppExecutable" -ArgumentList "/S" -Wait
Log "$(TimeNow) - Install complete"

Log "$(TimeNow) - # [END]: $AppName #"
Log ""