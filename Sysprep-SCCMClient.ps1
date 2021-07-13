<#
.PURPOSE
    Sysprep of SCCM client before capture

.CREATEDBY
    George Zajakovski - https://www.linkedin.com/in/gzajakovski/
#>

# User Vars
$WorkingDir = "C:\windows\temp\cubesys\"
$LogFile = "$WorkingDir\Install.log"
$AppName = "Sysprep-SCCMClient"


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

# Check if SCCM agent is installed
If (Test-Path C:\Windows\CCM\Logs) { 

    If ($status.Status -eq Stopped) {
    MMC.exe
    # delete the 2 certs in Local Computer > SMS
    Remove-Item $env:SystemRoot\SMSCFG.ini -Force

    } else {
        Log "$(TimeNow) - CCMExec is still running"
    }


} else { 
    Log "$(TimeNow) - SCCM client not found"
    Log "$(TimeNow) - # [END]: $AppName #"
    exit
}

# Install
Log "$(TimeNow) - Stopping SMS service"
Stop-Service -Name CcmExec
$status = Get-Service -Name CcmExec




Log "$(TimeNow) - # [END]: $AppName #"
Log ""










net stop "SMS Agent Host"

