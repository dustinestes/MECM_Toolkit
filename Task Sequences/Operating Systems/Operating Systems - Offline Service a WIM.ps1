#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

# param (
#     [string]$ParamName                # [ExampleInputValues]
# )

#--------------------------------------------------------------------------------------------
Start-Transcript -Path "C:\VividRock\MECM Toolkit\Task Sequences\Operating Systems\Offline Servicing\Logs\VividRock_OfflineServicing.log"

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  Task Sequence Toolkit - Operating Systems - Offline Service a WIM"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       April 19, 2020"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    A script to perform offline servicing of an Operating System"
    Write-Host "                WIM."
    Write-Host "    Links:      https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/mount-and-modify-a-windows-image-using-dism?view=windows-11"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""
<#
  To Do:
    - Add in logic to detect already downloaded WIM and Updates
    - Remove output of Update list from validation
    - Remove output of update list from apply windowspackage section
    - Add progress bar output to apply windowspackage section
    - Change console output to just display simple x/x for long data streams
    - Prompt to dismount WIM (troubleshooting)
    - Remove output of all files from cleanup and just show how many success/failures occurred
    - Add path output to console for changelog section so user knows where to look
        Change success to include "status" prefix

#>


#EndRegion Header
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Variables
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Variables

    Write-Host "  Variables"

    # Parameters
        # $Param_ParamName = $ParamName

    # Metadata
        $Meta_Script_Start_DateTime     = Get-Date
        $Meta_Script_Complete_DateTime  = $null
        $Meta_Script_Complete_TimeSpan  = $null
        $Meta_DateTime                  = (Get-Date).ToUniversalTime()
        $Meta_DateTime_TimeStamp        = $Meta_DateTime.ToString("yyyy-MM-dd_HHmmss")

    # Names

    # Paths
        $Path_Local_RootDir         = "C:\VividRock\MECM Toolkit\Task Sequences\Operating Systems\Offline Servicing\"
        $Path_Local_Logs            = "$Path_Local_RootDir\Logs"
        $Path_Local_Mount           = "$Path_Local_RootDir\Mount"
        $Path_Local_Updates         = "$Path_Local_RootDir\Updates"
        $Path_Local_WIMOriginal     = "$Path_Local_RootDir\WIM\Original"
        $Path_Local_WIMUpdated      = "$Path_Local_RootDir\WIM\Updated"
        $Path_Local_Scratch         = "$Path_Local_RootDir\Scratch"

        $Path_Source_WIM            = "\\vividrock.com\repo\Operating Systems\Windows 7\6.1.7601\17514 (MS)\WIM\install.wim"
        $Path_Source_Updates        = "\\vividrock.com\repo\Software Updates\Standalone\Windows 7\Offline Servicing"

    # Files
        $File_WIM_Original          = "$($Path_Local_WIMOriginal)\$(Split-Path -Path $Path_Source_WIM -Leaf)"
        $File_WIM_Updated           = "$($Path_Local_WIMUpdated)\Install_$($Meta_DateTime_TimeStamp).wim"

    # Hashtables

    # Arrays

    # Registry

    # WMI

    # Output to Log
        Write-Host "    - Paths"
        Write-Host "        Source WIM: $($Path_Source_WIM)"
        Write-Host "        Source Updates: $($Path_Source_Updates)"
        Write-Host "        Output WIM: $($File_WIM_Updated)"

        Write-Host "    - Directory Structure"
        foreach ($Item in (Get-Variable -Name "Path_Local_*" | Sort-Object -Property Value)) {
            Write-Host "        $($Item.Value)"
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Variables
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Functions
#   Error Range: 1300 - 1399
#--------------------------------------------------------------------------------------------
#Region Functions

    Write-Host "  Functions"

    # Write Error Codes
        Write-Host "    - Write-vr_ErrorCode"
        function Write-vr_ErrorCode ($Code,$Exit,$Object) {
            # Code: XXXX   4-digit code to identify where in script the operation failed
            # Exit: Boolean option to define if  exits or not
            # Object: The error object created when the script encounters an error ($Error[0], $PSItem, etc.)

            begin {

            }

            process {
                Write-Host "        Error: $($Object.Exception.ErrorId)"
                Write-Host "        Command Name: $($Object.CategoryInfo.Activity)"
                Write-Host "        Message: $($Object.Exception.Message)"
                Write-Host "        Line/Position: $($Object.Exception.Line)/$($Object.Exception.Offset)"
            }

            end {
                switch ($Exit) {
                    $true {
                        Write-Host "        Exit: $($Code)"
                        Exit $Code
                    }
                    $false {
                        Write-Host "        Continue Processing..."
                    }
                    Default {
                        Write-Host "        Unknown Exit option in Write-vr_ErrorCode parameter"
                    }
                }
            }
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Functions
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Environment
#   Error Range: 1400 - 1499
#--------------------------------------------------------------------------------------------
#Region Environment

    # Write-Host "  Environment"

    # # Create TSEnvironment COM Object
    #     Write-Host "    - Create TSEnvironment COM Object"

    #     try {
    #         $Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
    #         Write-host "        Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1401 -Exit $true -Object $PSItem
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Environment
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validation
#   Error Range: 1500 - 1599
#--------------------------------------------------------------------------------------------
#Region Validation

    Write-Host "  Validation"

    # Source WIM
        Write-Host "    - Source WIM"

        try {
            if (Test-Path -Path $Path_Source_WIM) {
                Write-Host "        Status: Exists"
            }
            else {
                Write-Host "        Status: Not Exists"
                Exit 1502
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
        }

    # Source Updates
        Write-Host "    - Source Updates"

        try {
            if (Test-Path -Path $Path_Source_Updates) {
                Write-Host "        Directory: Exists"

                $Temp_Source_Updates = Get-ChildItem -Path $Path_Source_Updates -Recurse -ErrorAction Stop

                if ($Temp_Source_Updates.Count -in "",$null,"0") {
                    Write-Host "        Status: No Updates Found"
                    Exit 1505
                }
                else {
                    Write-Host "        Updates Found: $(($Temp_Source_Updates | Measure-Object).Count)"

                    # foreach ($Item in $Temp_Source_Updates) {
                    #     Write-Host "            $($Item.Name)"
                    # }
                }
            }
            else {
                Write-Host "        Status: Not Exists"
                Exit 1504
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1503 -Exit $true -Object $PSItem
        }

    # Root Directory
        Write-Host "    - Root Directory"

        try {
            if (Test-Path -Path $Path_Local_RootDir) {
                Write-Host "        Status: Exists"
            }
            else {
                New-Item -Path $Path_Local_RootDir -ItemType Directory -Force -ErrorAction Stop | Out-Null
                Write-Host "        Status: Created"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1506 -Exit $true -Object $PSItem
        }

    # Sub Directories
        Write-Host "    - Sub Directories"

        try {
            foreach ($Item in (Get-Variable -Name "Path_Local_*")) {
                Write-Host "        Path: $($Item.Value)"
                if (Test-Path -Path $Item.Value) {
                    Write-Host "            Status: Exists"
                }
                else {
                    New-Item -Path $Item.Value -ItemType Directory -Force -ErrorAction Stop | Out-Null
                    Write-Host "            Status: Created"
                }
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1507 -Exit $true -Object $PSItem
        }

    # Output WIM
        Write-Host "    - Output WIM"

        try {
            if (Test-Path -Path $File_WIM_Updated) {
                Write-Host "        Status: Exists"
            }
            else {
                Write-Host "        Status: Not Exists"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1508 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Validation
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1600 - 1699
#--------------------------------------------------------------------------------------------
#Region Execution

    Write-Host "  Execution"

    # Download WIM
        Write-Host "    - Download WIM"

        try {
            Write-Host "        File: $($Path_Source_WIM)"
            Copy-Item -Path $Path_Source_WIM -Destination $Path_Local_WIMOriginal -ErrorAction Stop
            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
        }

    # Create Output WIM
        Write-Host "    - Create Output WIM"

        try {
            Write-Host "        File: $($File_WIM_Updated)"
            Copy-Item -Path $File_WIM_Original -Destination $File_WIM_Updated -ErrorAction Stop
            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1602 -Exit $true -Object $PSItem
        }

    # Copy Updates Locally
        Write-Host "    - Copy Updates Locally"

        try {
            # # Per Item Output
            #     foreach ($Item in (Get-ChildItem -Path $Path_Source_Updates)) {
            #         Write-Host "        File: $($Item.Name)"
            #         Copy-Item -Path $Item.FullName -Destination $Path_Local_Updates -ErrorAction Stop
            #         Write-Host "            Status: Success"
            #     }

            # Progress Output
                $Counter_Updates_Downloaded = 0
                $Counter_Updates_Total = ($Temp_Source_Updates | Measure-Object).Count
                $Counter_Updates_PercentComplete = 0
                Write-Host "        Count: $($Counter_Updates_Total)"

                foreach ($Item in $Temp_Source_Updates) {
                    Write-Progress -Id 0 -Activity "Copy Updates Locally" -Status "Status: $($Counter_Updates_Downloaded) / $($Counter_Updates_Total)" -CurrentOperation "Filename: $($Item.Name)" -PercentComplete $Counter_Updates_PercentComplete -ErrorAction Stop
                    Copy-Item -Path $Item.FullName -Destination $Path_Local_Updates -ErrorAction Stop

                    $Counter_Updates_Downloaded += 1
                    $Counter_Updates_PercentComplete = [math]::Ceiling(($Counter_Updates_Downloaded / $Counter_Updates_Total) * 100)
                }

                Write-Progress -Id 0 -Activity "Completed" -Completed -ErrorAction Stop
                Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1603 -Exit $true -Object $PSItem
        }

    # Mount WIM Image
        Write-Host "    - Mount WIM Image"

        try {
            $Temp_Local_WIMOriginal_Data = Get-WindowsImage -ImagePath $File_WIM_Original -ErrorAction Stop

            Write-Host "        Index: $($Temp_Local_WIMOriginal_Data.ImageIndex)"
            Write-Host "        Name: $($Temp_Local_WIMOriginal_Data.ImageName)"
            Write-Host "        Size: $([System.Math]::Round(($Temp_Local_WIMOriginal_Data.ImageSize / 1GB), 2)) GB"
            Write-Host "        Mount Point: $($Path_Local_Mount)"
            $Temp_Servicing_MountImage = Mount-WindowsImage -Path $Path_Local_Mount -ImagePath $File_WIM_Updated -Index $Temp_Local_WIMOriginal_Data.ImageIndex -LogPath ($Path_Local_Logs + "\01_VR_Mount-WIM-Image.log") -LogLevel WarningsInfo -ScratchDirectory $Path_Local_Scratch -ErrorAction Stop
            Write-Host "        Status: Success"

            $Temp_Local_WIMOriginal_Packages = Get-WindowsPackage -Path $Path_Local_Mount -LogPath ($Path_Local_Logs + "\02_VR_Get-Update-Packages.log") -LogLevel WarningsInfo -ScratchDirectory $Path_Local_Scratch -ErrorAction Stop
        }
        catch {
            Write-vr_ErrorCode -Code 1604 -Exit $true -Object $PSItem
        }

    # Add Update Packages
        Write-Host "    - Add Update Packages"

        try {
            # Per Item Output
                # $Temp_Local_Updates = Get-ChildItem -Path $Path_Local_Updates -ErrorAction Stop

                # foreach ($Item in $Temp_Local_Updates) {
                #     Write-Host "        File: $($Item.Name)"
                #     $Temp_Servicing_AddPackages = Add-WindowsPackage -Path $Path_Local_Mount -PackagePath $Item.FullName -LogPath ($Path_Local_Logs + "\03_VR_Add-Update-Packages.log") -LogLevel WarningsInfo -ScratchDirectory $Path_Local_Scratch -ErrorAction Stop
                #     Write-Host "            Restart Needed: $($Temp_Servicing_AddPackages.RestartNeeded)"
                #     Write-Host "            Status: Success"
                # }

            # Progress Output
                $Temp_Local_Updates = Get-ChildItem -Path $Path_Local_Updates -ErrorAction Stop

                $Counter_Updates_Installed = 0
                $Counter_Updates_Total = ($Temp_Local_Updates | Measure-Object).Count
                $Counter_Updates_PercentComplete = 0
                Write-Host "        Count: $($Counter_Updates_Total)"

                foreach ($Item in $Temp_Local_Updates) {
                    Write-Progress -Id 0 -Activity "Add Updates to WIM" -Status "Status: $($Counter_Updates_Installed) / $($Counter_Updates_Total)" -CurrentOperation "Name: $($Item.Name)" -PercentComplete $Counter_Updates_PercentComplete -ErrorAction Stop
                    Add-WindowsPackage -Path $Path_Local_Mount -PackagePath $Item.FullName -LogPath ($Path_Local_Logs + "\03_VR_Add-Update-Packages.log") -LogLevel WarningsInfo -ScratchDirectory $Path_Local_Scratch -ErrorAction Stop

                    $Counter_Updates_Installed += 1
                    $Counter_Updates_PercentComplete = [math]::Ceiling(($Counter_Updates_Installed / $Counter_Updates_Total) * 100)
                }

                Write-Progress -Id 0 -Activity "Completed" -Completed -ErrorAction Stop
                Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1605 -Exit $false -Object $PSItem
        }

    # Verify Update Packages
        Write-Host "    - Verify Update Packages"

        try {
            $Temp_Local_WIMUpdated_Packages = Get-WindowsPackage -Path $Path_Local_Mount -LogPath ($Path_Local_Logs + "\04_VR_Verify-Update-Packages.log") -LogLevel WarningsInfo -ScratchDirectory $Path_Local_Scratch -ErrorAction Stop
            $Temp_Local_WIMUpdated_Packages_Installed = $Temp_Local_WIMUpdated_Packages | Where-Object -Property InstallTime -ge ((Get-Date).AddDays(-1))

            foreach ($Item in $Temp_Local_WIMUpdated_Packages_Installed) {
                Write-Host "        Name: $($Item.PackageName)"
                Write-Host "            State: $($Item.PackageState)"
                Write-Host "            Type: $($Item.ReleaseType)"
                Write-Host "            Install Time: $($Item.InstallTime)"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1606 -Exit $true -Object $PSItem
        }

    # # Reduce Size
    # #     Dism /Image:C:\test\offline /cleanup-image /StartComponentCleanup /ResetBase
    # #     Dism /Unmount-Image /MountDir:C:\test\offline /Commit
    # #     Dism /Export-Image /SourceImageFile:C:\Images\install.wim /SourceIndex:1 /DestinationImageFile:C:\Images\install_cleaned.wim
    #     Write-Host "    - Mount WIM Image"

    #     try {

    #         Write-Host "        Status: Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1607 -Exit $true -Object $PSItem
    #     }

    # Save WIM Changes
        Write-Host "    - Save WIM Changes"

        try {
            $Temp_Servicing_SaveImage = Save-WindowsImage -Path $Path_Local_Mount -CheckIntegrity -LogPath ($Path_Local_Logs + "\05_VR_Save-WIM-Changes.log") -LogLevel WarningsInfo -ScratchDirectory $Path_Local_Scratch -ErrorAction Stop
            Write-Host "        Path: $($Temp_Servicing_SaveImage.Path)"
            Write-Host "        Restart Needed: $($Temp_Servicing_SaveImage.RestartNeeded)"
            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1608 -Exit $true -Object $PSItem
        }

    # Dismount WIM Image
        Write-Host "    - Dismount WIM Image"

        try {
            $Temp_Servicing_DismountImage = Dismount-WindowsImage -Discard -Path $Path_Local_Mount -LogPath ($Path_Local_Logs + "\06_VR_Dismount-WIM-Image.log") -LogLevel WarningsInfo -ScratchDirectory $Path_Local_Scratch -ErrorAction Stop
            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1609 -Exit $true -Object $PSItem
        }

    # Output WIM Information
        Write-Host "    - Output WIM Information"

        try {
            $Temp_Local_WIMOriginal_Data    = Get-WindowsImage -ImagePath $File_WIM_Original -ErrorAction Stop
            $Temp_Local_WIMUpdated_Data     = Get-WindowsImage -ImagePath $File_WIM_Updated -ErrorAction Stop

            Write-Host "        Original WIM"
            Write-Host "            Index: $($Temp_Local_WIMOriginal_Data.ImageIndex)"
            Write-Host "            Name: $($Temp_Local_WIMOriginal_Data.ImageName)"
            Write-Host "            Size: $([System.Math]::Round(($Temp_Local_WIMOriginal_Data.ImageSize / 1GB), 2)) GB"
            Write-Host "            Package Count: $($Temp_Local_WIMOriginal_Packages.Count)"
            Write-Host "        Updated WIM"
            Write-Host "            Index: $($Temp_Local_WIMUpdated_Data.ImageIndex)"
            Write-Host "            Name: $($Temp_Local_WIMUpdated_Data.ImageName)"
            Write-Host "            Size: $([System.Math]::Round(($Temp_Local_WIMUpdated_Data.ImageSize / 1GB), 2)) GB"
            Write-Host "            Package Count: $($Temp_Local_WIMUpdated_Packages.Count)"

            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1610 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Execution
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Output
#   Error Range: 1800 - 1899
#--------------------------------------------------------------------------------------------
#Region Output

    Write-Host "  Output"

    # Change Log
        Write-Host "    - Change Log"

        try {
            # Write Header
                $Temp_ChangeLog_Header = @"
------------------------------------------------------------------------------
  Offline Servicing - Change Log
------------------------------------------------------------------------------
    Creator:    $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)
    Date:       $($Meta_DateTime.ToString("yyyy-MM-dd")) (UTC)
    Time:       $($Meta_DateTime.ToString("HH:mm:ss")) (UTC)
    Source:     This offline serviced copy of the WIM file was created using
                the Task Sequence Toolkit - Operating Systems - Offline Servicing
                script.
    Links:      https://www.vividrock.com
------------------------------------------------------------------------------

Information
  - Operating System: $($Temp_Local_WIMUpdated_Data.ImageName)
  - Index: $($Temp_Local_WIMUpdated_Data.ImageIndex)
  - Size: $([System.Math]::Round(($Temp_Local_WIMUpdated_Data.ImageSize / 1GB), 2)) GB
  - Package Count: $($Temp_Local_WIMUpdated_Packages.Count)

Packages Installed
"@
            Out-File -FilePath ($Path_Local_WIMUpdated + "\ChangeLog_$($Meta_DateTime_TimeStamp).txt") -InputObject $Temp_ChangeLog_Header -Append -ErrorAction Stop
            Out-File -FilePath ($Path_Local_WIMUpdated + "\ChangeLog_$($Meta_DateTime_TimeStamp).txt") -InputObject $Temp_Local_WIMUpdated_Packages_Installed -Append -ErrorAction Stop
            Write-host "        Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1801 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Output
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Cleanup
#   Error Range: 1900 - 1999
#--------------------------------------------------------------------------------------------
#Region Cleanup

    Write-Host "  Cleanup"

    # Confirm Cleanup
        Write-Host "    - Confirm Cleanup"

        do {
            $Temp_Cleanup_UserInput = Read-Host -Prompt "        Do you want to automatically clean up the unecessary content and leave only the updated WIM file? [Y]es or [N]o" -ErrorAction Stop
        } until (
            $Temp_Cleanup_UserInput -in "Y","Yes","N","No"
        )


    # Delete Original WIM
        Write-Host "    - Delete Original WIM"

        try {
            if ($Temp_Cleanup_UserInput -in "Y","Yes") {
                Write-host "        File: $($File_WIM_Original)"
                Remove-Item -Path $File_WIM_Original -Force -ErrorAction Stop
                Write-Host "            Status: Success"
            }
            else {
                Write-Host "        Status: Skipped"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1901 -Exit $true -Object $PSItem
        }

    # Delete Updates
        Write-Host "    - Delete Updates"

        try {
            if ($Temp_Cleanup_UserInput -in "Y","Yes") {
                if ($Temp_Local_Updates.Count -in "",$null,"0") {
                    Write-Host "        Status: No Files Found"
                }
                else {
                    foreach ($Item in $Temp_Local_Updates) {
                        Write-host "        File: $($Item.Name)"
                        Remove-Item -Path $Item.FullName -Force -ErrorAction Stop
                        Write-Host "            Status: Success"
                    }
                }
            }
            else {
                Write-Host "        Status: Skipped"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1902 -Exit $true -Object $PSItem
        }

    # Delete Scratch Space
        Write-Host "    - Delete Scratch Space"

        try {
            if ($Temp_Cleanup_UserInput -in "Y","Yes") {
                $Temp_Local_Scratch = Get-ChildItem -Path $Path_Local_Scratch -ErrorAction Stop

                if ($Temp_Local_Scratch.Count -in "",$null,"0") {
                    Write-Host "        Status: No Files Found"
                }
                else {
                    foreach ($Item in $Temp_Local_Scratch) {
                        Write-host "        $($Item.Name)"
                        Remove-Item -Path $Item.FullName -Force -ErrorAction Stop
                        Write-Host "            Status: Success"
                    }
                }
            }
            else {
                Write-Host "        Status: Skipped"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1903 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Cleanup
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Footer
#--------------------------------------------------------------------------------------------
#Region Footer

    # Gather Data
        $Meta_Script_Complete_DateTime  = Get-Date
        $Meta_Script_Complete_TimeSpan  = New-TimeSpan -Start $Meta_Script_Start_DateTime -End $Meta_Script_Complete_DateTime

    # Output
        Write-Host ""
        Write-Host "------------------------------------------------------------------------------"
        Write-Host "  Script Started: $($Meta_Script_Start_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
        Write-Host "  Script Completed: $($Meta_Script_Complete_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
        Write-Host "  Total Time: $($Meta_Script_Complete_TimeSpan.Days) days $($Meta_Script_Complete_TimeSpan.Hours) hours $($Meta_Script_Complete_TimeSpan.Minutes) minutes $($Meta_Script_Complete_TimeSpan.Seconds) seconds $($Meta_Script_Complete_TimeSpan.Milliseconds) milliseconds"
        Write-Host "------------------------------------------------------------------------------"
        Write-Host "  End of Script"
        Write-Host "------------------------------------------------------------------------------"

#EndRegion Footer
#--------------------------------------------------------------------------------------------
Stop-Transcript