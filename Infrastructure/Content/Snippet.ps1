$Name = "HP - WinPE 10-11 - 2.5"

if (Get-CMApplication -Name $Name -Fast) {
Write-Host "Application"
}
elseif (Get-CMPackage -Name $Name -Fast) {
Write-Host "Legacy Package"
}
elseif (Get-CMSoftwareUpdateDeploymentPackage -Name $Name) {
Write-Host "Software Update Package"
}
elseif (Get-CMDriverPackage -Name $Name -Fast) {
Write-Host "Driver Package"
}
elseif (Get-CMOperatingSystemImage -Name $Name) {
Write-Host "Operating System Image"
}
elseif (Get-CMOperatingSystemInstaller -Name $Name) {
Write-Host "Operating System Upgrade Package"
}
elseif (Get-CMBootImage -Name $Name) {
Write-Host "Boot Image"
}
else {
Write-Host "Unknown Object"
}


Start-CMContentDistribution -ApplicationID -DistributionPointGroupName "2 - All - On Premises - Tier 1"

#Start-Sleep -Seconds 120
