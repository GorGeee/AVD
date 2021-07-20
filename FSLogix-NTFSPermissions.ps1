<#
.PURPOSE
    Replicates the NTFS permissions for 2 seperate UNC paths....
    Files / folders must already be copied

.CREATEDBY
    George Zajakovski - https://www.linkedin.com/in/gzajakovski/
#>

# User Vars
$WorkingDir = "C:\temp\cubesys\"
$LogFile = "$WorkingDir\Install.log"
$AppName = "FSLogix-NTFSPermissions"


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

# Do not change the filter. Its used to ignore any already mounted profiles.
$Profiles = Get-ChildItem "$oldStorageAcc" -Recurse -filter "Profile*.vhd*" | Select -ExpandProperty FullName

ForEach ($profile in $Profiles) {
    
    Write-Host "Checking: $profile" -ForegroundColor Yellow
    
    # Split based on your requirements...
    $vhd = $profile.Split('\')[6]
    # Write-Host "VHD = $VHD"
    
    $username = $profile.Split('\')[5]
    # Write-Host "Username/SID = $username"

    # Remove -WhatIf to make things happen
    Get-Acl $oldStorageAcc\$username | Set-Acl $newStorageAcc\$username -WhatIf 
    Get-Acl $oldStorageAcc\$username\$vhd | Set-Acl $newStorageAcc\$username\$vhd -WhatIf
    
    # Check profile folder perms
    $a = Get-Acl $oldStorageAcc\$username
    $b = Get-Acl $newStorageAcc\$username

    # Check VHD/x perms
    $c = Get-Acl $oldStorageAcc\$username\$vhd
    $d = Get-Acl $newStorageAcc\$username\$vhd
   

    If ($a.Owner -eq $b.Owner) {} else {Write-Host "Error matching owner on profile folder: $username" -ForegroundColor red ; Log "$(TimeNow) - Error matching owner on profile folder: $username" }
    If ($c.Owner -eq $d.Owner) {} else {Write-Host "Error matching owner on VHD: $VHD" -ForegroundColor red ; Log "$(TimeNow) - Error matching owner on VHD: $username" }
        

    Add-Content -Path 'c:\temp\test.csv' -Value "`"$oldStorageAcc\$username\$vhd`",`"$newStorageAcc\$username\$vhd`""
    
}

Log "$(TimeNow) - # [END]: $AppName #"
Log ""