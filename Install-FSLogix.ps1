<#
.PURPOSE
    Silent Installation of FSLogix

.CREATEDBY
    George Zajakovski - https://www.linkedin.com/in/gzajakovski/
#>

# User Vars
$WorkingDir = "C:\temp\cubesys\"
$LogFile = "$WorkingDir\Install.log"
$AppName = "FSLogix"

# Software URLs
$FSLogixURL = "https://aka.ms/fslogix_download"

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

# Download FSLogix
Log "$(TimeNow) - Downloading $AppName"
Invoke-WebRequest -Uri $FSLogixURL -OutFile "$WorkingDir\$AppName.zip"
Log "$(TimeNow) - Download $AppName"

# Extract FSLogix package
Log "$(TimeNow) - Extracting $AppName"
Expand-Archive "$WorkingDir\$AppName.zip" -DestinationPath $WorkingDir\$AppName

# Install Teams Machine-Wide
Log "$(TimeNow) - Installing $AppName Core"
Start-Process -FilePath "$WorkingDir\FSLogix\x64\Release\FSLogixAppsSetup.exe" -ArgumentList "/install /quiet" -Wait -Passthru
Log "$(TimeNow) - Installing $AppName App Mask"
Start-Process -FilePath "$WorkingDir\FSLogix\x64\Release\FSLogixAppsRuleEditorSetup.exe" -ArgumentList "/install /quiet" -Wait -Passthru
Log "$(TimeNow) - Install of $AppName complete"

Log "$(TimeNow) - # [END]: $AppName #"
Log ""