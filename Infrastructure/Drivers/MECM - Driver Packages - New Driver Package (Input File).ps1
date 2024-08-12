
# Import PowerShell Module
    Set-Location $env:SMS_ADMIN_UI_PATH
    Set-Location ..
    Import-Module .\ConfigurationManager.psd1

# Switch to CMSite PowerShell Drive
    Set-Location TCC:

# Update Help File for CM PowerShell Module
#    Update-Help -Module ConfigurationManager

# Get File Contents
    Write-Host "------------------------------------------------------------------------"
    Write-Host "  MECM - Driver Packages - New Driver Package"
    Write-Host "------------------------------------------------------------------------"
    Write-Host ""
    Write-Host "    Please provide the path to the New-CMDriverPackageList.csv file:  "
    Write-Host "    Note: Do not put quotes into the path provided"
    Write-Host ""
    Write-Host "------------------------------------------------------------------------"
    
    $Input = Read-Host -Prompt 'Path:  ' 

# Iterate through the file contents
    Import-Csv $Input | ForEach-Object {
    Write-Host "-- Creating Driver Package"
    Write-Host "      Name = $($_.Name)"
    Write-Host "      Version = $($_.Version)"
    Write-Host "      Driver Manufacturer = $($_.DriverManufacturer)"
    Write-Host "      Driver Model = $($_.DriverModel)"
    Write-Host "      Path = $($_.Path)"
    Write-Host "      Description = $($_.Description)"
    New-CMDriverPackage -Name $($_.Name) -Path $($_.Path) -Description $($_.Description)
#    New-CMDriverPackage -Name $($_.Name) -DriverManufacturer $($_.DriverManufacturer) -DriverModel $($_.DriverModel) -Path $($_.Path) -Description $($_.Description)
    Set-CMDriverPackage -Name $($_.Name) -Version $($_.Version)

    Write-Host "      Creation Complete"
    }

    Write-Host "-- Completed reading through the file"
    Write-Host "      End Script"
  