
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
    Write-Host "  MECM - Drivers - Import New Drivers"
    Write-Host "------------------------------------------------------------------------"
    Write-Host ""
    Write-Host "    Please provide the path to the New-CMDriverList.csv file:  "
    Write-Host "    Note: Do not put quotes into the path provided"
    Write-Host ""
    Write-Host "------------------------------------------------------------------------"
    
    $Input = Read-Host -Prompt 'Path:  ' 

# Iterate through the file contents
    Import-Csv $Input | ForEach-Object {
    Write-Host "-- Importing all Drivers in path "
    Write-Host "      Path = $($_.Path)"
    Write-Host "      Administrative Categories = $($_.AdministrativeCategory)"
    Write-Host "      Driver Package = $($_.DriverPackage)"
    Import-CMDriver -Path $($_.Path) -AdministrativeCategory (Get-CMCategory -Name "$($_.AdministrativeCategory)") -DriverPackage (Get-CMDriverPackage -Name "$($_.DriverPackage)") -ImportFolder -ImportDuplicateDriverOption AppendCategory 
    Write-Host "      Import Complete"
    }

    Write-Host "-- Completed reading through the file"
    Write-Host "      End Script"
  