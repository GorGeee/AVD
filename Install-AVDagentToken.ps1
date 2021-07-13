<#
.PURPOSE
    Silent Installation of FSLogix

.CREATEDBY
    George Zajakovski - https://www.linkedin.com/in/gzajakovski/
#>

# User Vars
$WorkingDir = "C:\temp\cubesys\"
$LogFile = "$WorkingDir\Install.log"
$AppName = "AVD-Agents"

#Set Variables
$RegToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IkU3MDE1QTU5NzU5N0Y3RDg1MjMyRTRBOTA3QTU0OTYyNzNBNEIxMjAiLCJ0eXAiOiJKV1QifQ.eyJSZWdpc3RyYXRpb25JZCI6ImJlMWFkYWZmLWRmNzEtNDgzNS04NDBmLWFlZDExN2ZjNGFiZCIsIkJyb2tlclVyaSI6Imh0dHBzOi8vcmRicm9rZXItZy11cy1yMC53dmQubWljcm9zb2Z0LmNvbS8iLCJEaWFnbm9zdGljc1VyaSI6Imh0dHBzOi8vcmRkaWFnbm9zdGljcy1nLXVzLXIwLnd2ZC5taWNyb3NvZnQuY29tLyIsIkVuZHBvaW50UG9vbElkIjoiNjU3ZWZkZWYtMGRlZi00MTE2LTgxNWQtZmQ4MGVmZThiOTJhIiwiR2xvYmFsQnJva2VyVXJpIjoiaHR0cHM6Ly9yZGJyb2tlci53dmQubWljcm9zb2Z0LmNvbS8iLCJHZW9ncmFwaHkiOiJVUyIsIm5iZiI6MTYxMjEzMzgwOCwiZXhwIjoxNjEyNzg5MjAwLCJpc3MiOiJSREluZnJhVG9rZW5NYW5hZ2VyIiwiYXVkIjoiUkRtaSJ9.V2HYHiMW0L-V-fceXJPxZYcObb4ZWIB4ViEqM6i7a_VzVqc09_dD-HCBSUO4WBnRI4eMj-3Rse_wSY45rcCB9U5pdznyzbIp4kiKEWbXvBPlBOJBhq4ZmVo2RFvCpAeDAUVitwSiD4cba5y_hl5TOKVqCrtWR3Q6eZGHoxs2XauftgJ6oBvGc-nRynuI-85liA2UUvYMw0trlzpHJ3DSuE9BIy4BE0sbIvXBc0jcjLsP79hXd_2rcx6-CIZxdHZlgAMKhwMi4sjicfFqR59nXJjQaKLQmY4V3_yHgmsyk8jOT_8X1_yHMtH5PSG__e9nKPMGSuaA9ZC44cgwoZCgfg"

# Software URLs
$WVDAgentInstaller = "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrmXv"
$WVDBootLoaderInstaller = "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrxrH"

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

# Download all source file async and wait for completion
Log "Downloading WVD Agent"
Invoke-WebRequest -Uri $WVDAgentInstaller -OutFile "$WorkingDir\Microsoft.RDInfra.RDAgent.Installer-x64.msi"

Log "Downloading WVD Bootloader"
Invoke-WebRequest -Uri $WVDBootLoaderInstaller -OutFile "$WorkingDir\Microsoft.RDInfra.RDAgentBootLoader.Installer-x64.msi"

# Install the WVD Agent
Log "Install the WVD Agent"
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $WorkingDir\Microsoft.RDInfra.RDAgent.Installer-x64.msi", "/quiet", "/qn", "/norestart", "/passive", "REGISTRATIONTOKEN=$RegToken", "/l* $WorkingDir\AVDAgent.log" | Wait-process

# Wait to ensure WVD Agent has enough time to finish
Start-sleep 30

# Install the WVD Bootloader
Log "Install the Boot Loader"
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $WorkingDir\Microsoft.RDInfra.RDAgentBootLoader.Installer-x64.msi", "/quiet", "/qn", "/norestart", "/passive", "/l* $WorkingDir\AVDBootLoader.log" | Wait-process

Log "Finished"
Log ""