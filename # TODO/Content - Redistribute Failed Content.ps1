<# ---------------------------------------------------------------------------------------------
    Logging
------------------------------------------------------------------------------------------------
    Section for configuring logging output
------------------------------------------------------------------------------------------------ #>
#Region

    $Log = "$env:USERPROFILE\Downloads\VividRock\MECM Toolkit - DP Content Redistribution.log"
    Start-Transcript -Path $Log -Force

#EndRegion Logging


# Get Failed Content Distributions
    $Translate_Content_ObjectTypeID = @{
        "2"     =   @{
            ObjectTypeID = "SMS_Package"
            FriendlyName    = "Package"
        }
        "14"    =   @{
            ObjectTypeID = "SMS_OperatingSystemInstallPackage"
            FriendlyName    = "Operating System Install Package"
        }
        "18"    =   @{
            ObjectTypeID = "SMS_ImagePackage"
            FriendlyName    = "Image Package"
        }
        "19"    =   @{
            ObjectTypeID = "SMS_BootImagePackage"
            FriendlyName    = "Boot Image Package"
        }
        "21"    =   @{
            ObjectTypeID = "SMS_DeviceSettingPackage"
            FriendlyName    = "Device Settings Package"
        }
        "23"    =   @{
            ObjectTypeID = "SMS_DriverPackage"
            FriendlyName    = "Driver Package"
        }
        "24"    =   @{
            ObjectTypeID = "SMS_SoftwareUpdatesPackage"
            FriendlyName    = "Software Updates Package"
        }
        "31"    =   @{
            ObjectTypeID = "SMS_Application"
            FriendlyName    = "Application"
        }
    }

# Set Variables
    $Exclude_Packages = "VR100018", "VR10001C"

# Get Data
    $Temp_Content_FailedDistributions = Get-CMDistributionStatus | Where-Object -FilterScript {($_.NumberErrors -gt 0) -and ($_.ObjectID -notin $Exclude_Packages)} | Sort-Object -Property ObjectID

# Display for User
    $CalculatedProperty_ObjectID = @{
        Label = 'ObjectID'
        Expression = {
            if ($_.ObjectTypeID -eq "31") {
                $_.PackageID
            }
            else {
                $_.ObjectID
            }
        }
    }
    Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    #$Temp_Content_FailedDistributions | Select-Object -Property ObjectID,SoftwareName,@{name='Object Type';expr={$Translate_Content_ObjectTypeID.$($_.ObjectTypeID).FriendlyName}},DateCreated,Targeted,NumberSuccess,NumberInProgress,NumberErrors,NumberUnknown,SourceSize -First 10 | Format-Table
    $Temp_Content_FailedDistributions | Select-Object -Property $CalculatedProperty_ObjectID,SoftwareName,@{name='Object Type';expr={$Translate_Content_ObjectTypeID.$($_.ObjectTypeID).FriendlyName}},DateCreated,Targeted,NumberSuccess,NumberInProgress,NumberErrors,NumberUnknown,SourceSize | Format-Table
    Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Pause

# Perform Content Redistribution
    foreach ($Item in ($Temp_Content_FailedDistributions)) {
        if ($(Get-CMDistributionStatus | Where-Object -Property NumberInProgress -ge 1).Count -gt 9) {
            Write-Host "Content Queue at Maximum of 10"
            Write-Host "Waiting for jobs to finish"
            Write-Host "Waiting ." -NoNewline
            do {
                Write-Host "." -NoNewline
                Start-Sleep -Seconds 180
            } until (
                $(Get-CMDistributionStatus | Where-Object -Property NumberInProgress -ge 1).Count -lt 10
            )

            Write-Host ""
        }
        else {
            Write-Host ""
            Write-Host "Adding job to queue..."
            Write-Host ""

        }

        Write-Host "  $($Item.SoftwareName)"
        switch ($Item.ObjectTypeID) {
            "2"  {
                # Package
                Write-Host "      - Object ID: $($Item.ObjectID)"
                Write-Host "      - Status: " -NoNewLine
                Get-CMPackage -Id $Item.ObjectID -Fast | Invoke-CMContentRedistribution -DistributionPointGroupName "2 - All - On Premises"
                Write-Host "Successfully Started" -ForegroundColor Green
            }
            "14" {
                # Operating System Install Package
                Write-Host "      - Object ID: $($Item.ObjectID)"
                Write-Host "      - Status: " -NoNewLine
                Get-CMOperatingSystemInstaller -Id $Item.ObjectID | Invoke-CMContentRedistribution -DistributionPointGroupName "2 - All - On Premises"
                Write-Host "Successfully Started" -ForegroundColor Green
            }
            "18" {
                # Image Package
                Write-Host "      - Object ID: $($Item.ObjectID)"
                Write-Host "      - Status: " -NoNewLine
                Get-CMOperatingSystemImage -Id $Item.ObjectID | Invoke-CMContentRedistribution -DistributionPointGroupName "2 - All - On Premises"
                Write-Host "Successfully Started" -ForegroundColor Green
            }
            "19" {
                # Boot Image Package
                Write-Host "      - Object ID: $($Item.ObjectID)"
                Write-Host "      - Status: " -NoNewLine
                Get-CMBootImage -Id $Item.ObjectID | Invoke-CMContentRedistribution -DistributionPointGroupName "2 - All - On Premises"
                Write-Host "Successfully Started" -ForegroundColor Green
            }
            "21" {
                # Device Settings Package
                # Write-Host "      - Object ID: $($Item.ObjectID)"
                # Write-Host "      - Status: " -NoNewLine
                #-Id $Item.ObjectID | Invoke-CMContentRedistribution -DistributionPointGroupName "2 - All - On Premises"
                # Write-Host "Successfully Started" -ForegroundColor Green
                Write-Host "Error: Unkown command for this object type. Investigate further."
            }
            "23" {
                # Driver Package
                Write-Host "      - Object ID: $($Item.ObjectID)"
                Write-Host "      - Status: " -NoNewLine
                Get-CMDriverPackage -Id $Item.ObjectID -Fast | Invoke-CMContentRedistribution -DistributionPointGroupName "2 - All - On Premises"
                Write-Host "Successfully Started" -ForegroundColor Green
            }
            "24" {
                # Software Updates Package
                Write-Host "      - Object ID: $($Item.ObjectID)"
                Write-Host "      - Status: " -NoNewLine
                Get-CMSoftwareUpdateDeploymentPackage -Id $Item.ObjectID | Invoke-CMContentRedistribution -DistributionPointGroupName "2 - All - On Premises"
                Write-Host "Successfully Started" -ForegroundColor Green
            }
            "31" {
                # Application
                Write-Host "      - Object ID: $($Item.PackageID)"
                Write-Host "      - CI ID: $((Get-CMApplication -Name $Item.SoftwareName -Fast).CI_ID)"
                Write-Host "      - Status: " -NoNewLine
                Get-CMApplication -Name $Item.SoftwareName -Fast | Invoke-CMContentRedistribution -DistributionPointGroupName "2 - All - On Premises"
                Write-Host "Successfully Started" -ForegroundColor Green
            }
            Default {}
        }


        # Sleep So MECM Can Process Content Distribution Request
            Start-Sleep -Seconds 600

        Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    }




<# ---------------------------------------------------------------------------------------------
    Exit
------------------------------------------------------------------------------------------------
    Provide any final operations after script execution
------------------------------------------------------------------------------------------------ #>
#Region

    # Log - Stop
    Stop-Transcript

    # Exit with Success Code
    #    Exit 0

#EndRegion Exit





# Invoke-CMContentValidation -ApplicationID "VR10001C" -DistributionPointName "ServerFQDN"


# Get-CMDistributionStatus | Where-Object -FilterScript {$_.NumberErrors -gt 0} | Select -Property * -First 2 | Format-Table
# Get-CMDistributionStatus | Where-Object -FilterScript {($_.NumberErrors -gt 0) -and ($_.ObjectID -eq "VR100018")} | Select -Property * -First 2
# Invoke-CMContentValidation -OperatingSystemImageId "VR100018" -DistributionPointName "[ServerFQDN]"


# Get-CMOperatingSystemImage -Id "VR10004A" | Invoke-CMContentRedistribution -DistributionPointName "[ServerFQDN]"
# Get-CMApplication -Name "Beyond Compare 4.1.9 - 4.1.9.21719" | Invoke-CMContentRedistribution -DistributionPointName "[ServerFQDN]" -Verbose



# Invoke-CMContentRedistribution -DistributionPointName "[ServerFQDN]" -WhatIf -Verbose