# Remove Mapped Drive
    Write-Host "  - Checking if Drive In Use"
    Write-Host "      Drive Letter: R"
    try {
        if(Get-PSDrive -Name "R" -ErrorAction SilentlyContinue) {
            Write-Host "      In Use: True"
            Remove-PSDrive -Name "R" -Force -ErrorAction Stop
            Write-Host "      Remove: Successful"
        }
        else {
            Write-Host "      In Use: False"
        }
    }
    catch {
        Write-Host "      Error: $($PSItem.Exception.Message)"
        Exit 1001
    }
