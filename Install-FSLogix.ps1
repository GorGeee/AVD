<#
.PURPOSE
    Silent Installation of FSLogix

.CREATEDBY
    George Zajakovski
#>

$ScriptName = "Install-FSLogix.ps1"

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

# Download FSLogix
Log "$(TimeNow) - Downloading FSLogix"
$FSLogixURL = "https://aka.ms/fslogix_download"
Invoke-WebRequest -Uri $FSLogixURL -OutFile "$WorkingDir\fslogix.zip"
Log "$(TimeNow) - Download complete"

# Extract FSLogix package
Log "$(TimeNow) - Extracting FSLogix"
Expand-Archive "$WorkingDir\fslogix.zip" -DestinationPath $WorkingDir\FSLogix

# Install Teams Machine-Wide
Log "$(TimeNow) - Installing FSLogix Core"
Start-Process -FilePath "$WorkingDir\FSLogix\x64\Release\FSLogixAppsSetup.exe" -ArgumentList "/install /quiet" -Wait -Passthru
Log "$(TimeNow) - Installing FSLogix App Mask"
Start-Process -FilePath "$WorkingDir\FSLogix\x64\Release\FSLogixAppsRuleEditorSetup.exe" -ArgumentList "/install /quiet" -Wait -Passthru
Log "$(TimeNow) - Install of FSLogix complete"