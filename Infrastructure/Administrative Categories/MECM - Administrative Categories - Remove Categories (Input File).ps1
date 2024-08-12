
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
    Write-Host "  MECM - Administrative Categories - Remove Categories"
    Write-Host "------------------------------------------------------------------------"
    Write-Host ""
    Write-Host "    Please provide the path to the Remove-CMCategoryList.txt file:  "
    Write-Host "    Note: Do not put quotes into the path provided"
    Write-Host ""
    Write-Host "------------------------------------------------------------------------"
    
    $CategoryList = Read-Host -Prompt 'Path:  ' 

# Iterate through the file contents
    ForEach ($line in (Get-Content $CategoryList)) {
        Write-Host "-- Removing Administrative Category: $line"
        Remove-CMCategory -Name $line -CategoryType DriverCategories -Force
        Write-Host "      Removal Complete"
        }
    Write-Host "-- Completed reading through Category file"
    Write-Host "      End Script"
  