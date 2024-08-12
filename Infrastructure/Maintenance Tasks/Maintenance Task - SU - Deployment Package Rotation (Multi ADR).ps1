#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$SiteCode,                  # 'ABC'
    [string]$SMSProvider,           	# 'servername.domain.com'
    [string]$ADRName,               	# 'SU - Servers - Windows Server'
    [string]$SourceDir,             	# '\\[ServerName]\[Folder]'
    [array]$DPGroups                	# ('[GroupName]',s'[GroupName]')
)

#--------------------------------------------------------------------------------------------
Start-Transcript -Path "C:\VividRock\MECM Toolkit\Logs\Maintenance Tasks\Deployment Package Rotation.log" -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  VividRock - MECM Toolkit - Maintenance Tasks - Deployment Package Rotation"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       October 23, 2018"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    This script runs as a Scheduled Task and performs the tasks"
    Write-Host "                necessary to rotate Deployment Packages associated with the"
    Write-Host "                defined ADR. This ensures that the Deployment Packages do not"
    Write-Host "                grow to a size that is too large."
    Write-Host "    Links:      None"
    Write-Host "    Template:   1.0"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""

<#
    How To Use:
        Note: Perform all of the below steps on the Primary Site Server

        Create a Maintenance Tasks Service Account (if not already exists)
            1. Create account in AD: MECM_MaintTasks
            2. Grant the account the following MECM Role(s):
                - Software Update Manager

        Create Source Content
            1. Save this script to a directory accessible by the Primary Site Server
                i.e. \\[servername]\[share]\VividRock\MECM Toolkit\Maintenance Tasks\Maintenance Task - SU - Deployment Package Rotation.ps1

        Create Scheduled Task
            1. Create Folder Structure: Task Scheduler Library / [CompanyName] / MECM / Maintenance Tasks
            2. Create Scheduled Task
                General Tab
                    Name: Software Updates - Deployment Package Rotation - [ADR Name]
                    Description: This script runs as a Scheduled Task and performs the tasks necessary to rotate Deployment Packages associated with the defined ADR. This ensures that the Deployment Packages do not grow to a size that is too large.
                    User Account: MECM_MaintTasks
                    Run Option: Run whether user is logged on or not
                Triggers Tab
                    Note: Set this so that it will run prior to the ADR schedule. Ideally with plenty of time for it to complete and any further validation to be performed.
                    For Example: If you setting this up for Patch Tuesday ADRs that run 1 day after the Second Tuesday of every Month, you could set this to run on the Second Monday of every Month.
                Action Tab
                    Action: Start a Program
                        Program/Script: powershell.exe
                        Arguments: -NoProfile -NoLogo -WindowStyle Hidden -ExecutionPolicy Bypass -File "" -SiteCode "" -SMSProvider "" -ADRName "" -SourceDir "" -DPGroups "",""
                        Start In: "\\[]pathtofile]"

    To Do:
        - Finish configuring the script to allow and process an array of ADR names
            - Test

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
        $Param_SiteCode     = $SiteCode
        $Param_SMSProvider  = $SMSProvider
        $Param_ADRName      = $ADRName
        $Param_SourceDir    = $SourceDir
        $Param_DPGroups     = $DPGroups

    # Metadata
        $Meta_Script_Start_DateTime     = Get-Date
        $Meta_Script_Complete_DateTime  = $null
        $Meta_Script_Complete_TimeSpan  = $null
        $Meta_Script_Result = $false,"Failure"

    # Names
        $Name_Month_Numerical   = Get-Date -Format "MM"
        $Name_SoftwareUpdates_DeploymentPackage = "$($Param_ADRName) - $($Name_Month_Numerical)"

    # Paths
        $Path_SoftwareUpdates_DeploymentPackage_Source  = "$($Param_SourceDir)\$($Name_Month_Numerical)"

    # Settings
        $Settings_SoftwareUpdates_DeploymentPackage_Description = "This Deployment Package is created as part of the VividRock - MECM Toolkit - Maintenance Tasks - Deployment Package Rotation script."
        $Settings_SoftwareUpdates_DeploymentPackage_BinaryReplicationEnabled = $true

    # Files

    # Hashtables

    # Arrays

    # Registry

    # WMI

    # Datasets

    # Temporary

    # Output to Log
        Write-Host "    - Parameters"
        foreach ($Item in (Get-Variable -Name "Param_*")) {
            Write-Host "        $(($Item.Name) -replace 'Param_',''): $($Item.Value)"
        }
        Write-Host "    - Names"
        foreach ($Item in (Get-Variable -Name "Name_*")) {
            Write-Host "        $(($Item.Name) -replace 'Name_',''): $($Item.Value)"
        }
        Write-Host "    - Paths"
        foreach ($Item in (Get-Variable -Name "Path_*")) {
            Write-Host "        $(($Item.Name) -replace 'Path_',''): $($Item.Value)"
        }
        Write-Host "    - Settings"
        foreach ($Item in (Get-Variable -Name "Setting_*")) {
            Write-Host "        $(($Item.Name) -replace 'Setting_',''): $($Item.Value)"
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
                        Stop-Transcript
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

    Write-Host "  Environment"

    # # Create TSEnvironment COM Object
    #     Write-Host "    - Create TSEnvironment COM Object"

    #     try {
    #         $Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
    #         Write-Host "        Status: Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1401 -Exit $true -Object $PSItem
    #     }

    # Connect to MECM Infrastructure
        Write-Host "    - Connect to MECM Infrastructure"

        try {
            if (Test-Connection -ComputerName $Param_SMSProvider -Count 2 -Quiet) {
                # Import the PowerShell Module
                    Write-Host "        Import the PowerShell Module"

                    if((Get-Module ConfigurationManager -ErrorAction Stop) -in $null,"") {
                        Import-Module -Name "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" -ErrorAction Stop
                        Write-Host "            Status: Success"
                    }
                    else {
                        Write-Host "            Status: Already Imported"
                    }

                # Create the Site Drive
                    Write-Host "        Create the Site Drive"

                    if((Get-PSDrive -Name $Param_SiteCode -PSProvider CMSite -ErrorAction Stop) -in $null,"") {
                        New-PSDrive -Name $Param_SiteCode -PSProvider CMSite -Root $Param_SMSProvider -ErrorAction Stop
                        Write-Host "            Status: Success"
                    }
                    else {
                        Write-Host "            Status: Already Exists"
                    }

                # Set the Location
                    Write-Host "        Set the Location"

                    if ((Get-Location -ErrorAction Stop).Path -ne "$($Param_SiteCode):\") {
                        Set-Location "$($Param_SiteCode):\" -ErrorAction Stop
                        Write-Host "            Status: Success"
                    }
                    else {
                        Write-Host "            Status: Already Set"
                    }
            }
            else {
                Write-Host "        Status: MECM Server Unreachable"
                Throw "Status: MECM Server Unreachable"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1401 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Environment
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validation
#   Error Range: 1500 - 1599
#--------------------------------------------------------------------------------------------
#Region Validation

    Write-Host "  Validation"

    # ADR Exists
        Write-Host "    - ADR Exists"

        try {
            Write-Host "        Name: $($Param_ADRName)"

            if (Get-CMSoftwareUpdateAutoDeploymentRule -Fast -Name $Param_ADRName -ErrorAction Stop) {
                Write-Host "            Status: Exists"
            }
            else {
                Write-Host "            Status: Not Exists"
                Throw "ADR not found in the MECM environment"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
        }

    # Distribution Point Groups Exist
        Write-Host "    - Distribution Point Groups Exist"

        try {
            foreach ($Item in $Param_DPGroups) {
                Write-Host "        Name: $($Item)"

                if (Get-CMDistributionPointGroup -Name $Item -ErrorAction Stop) {
                    Write-Host "            Status: Exists"
                }
                else {
                    Write-Host "            Status: Not Exists"
                    Throw "Distribution Point Group not found in the MECM environment"
                }
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1502 -Exit $true -Object $PSItem
        }

    # Source Directory Exists
        Write-Host "    - Source Directory Exists"

        try {
            Write-Host "        Source Directory: $($Param_SourceDir)"
            Write-Host "        Month: $($Name_Month_Numerical)"
            Write-Host "        Full Path: $($Path_SoftwareUpdates_DeploymentPackage_Source)"

            if (Test-Path -Path "filesystem::$($Path_SoftwareUpdates_DeploymentPackage_Source)" -ErrorAction Stop) {
                Write-Host "            Status: Exists"
            }
            else {
                New-Item -Path "filesystem::$($Path_SoftwareUpdates_DeploymentPackage_Source)" -ItemType Directory -ErrorAction Stop | Out-Null
                Write-Host "            Status: Created"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1503 -Exit $true -Object $PSItem
        }

    # Source Directory Empty
        Write-Host "    - Source Directory Empty"

        try {
            Write-Host "        Expected File Count: 0"
            Write-Host "        Actual File Count: $((Get-ChildItem -Path "filesystem::$($Path_SoftwareUpdates_DeploymentPackage_Source)" -Recurse -ErrorAction Stop).Count)"

            if ((Get-ChildItem -Path "filesystem::$($Path_SoftwareUpdates_DeploymentPackage_Source)" -Recurse -ErrorAction Stop).Count -eq 0) {
                Write-Host "            Status: No Files Found"
            }
            else {
                Write-Host "            Status: Files Found"
                Throw "Files found in directory. Directory must be empty."
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1504 -Exit $true -Object $PSItem
        }

    # Software Update Deployment Package Not Exists
        Write-Host "    - Software Update Deployment Package Not Exists"

        try {
            Write-Host "        Name: $($Name_SoftwareUpdates_DeploymentPackage)"

            if (Get-CMSoftwareUpdateDeploymentPackage -Name $Name_SoftwareUpdates_DeploymentPackage) {
                Write-Host "            Status: Deployment Package with Same Name Found"
                Throw "A Deployment Package with the same name was found. This script does not overwrite or alter existing pacakges."
            }
            else {
                Write-Host "            Status: Deployment Package Not Found"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1505 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Validation
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Data Gather
#   Error Range: 1600 - 1699
#--------------------------------------------------------------------------------------------
#Region Data Gather

    # Write-Host "  Data Gather"

    # # [StepName]
    #     Write-Host "    - [StepName]"

    #     try {

    #         Write-Host "        Status: Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
    #     }

    # # [StepName]
    #     foreach ($Item in (Get-Variable -Name "Path_*")) {
    #         Write-Host "    - $($Item.Name)"

    #         try {

    #             Write-Host "        Status: Success"
    #         }
    #         catch {
    #             Write-vr_ErrorCode -Code 1602 -Exit $true -Object $PSItem
    #         }
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Data Gather
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1700 - 1799
#--------------------------------------------------------------------------------------------
#Region Execution

    Write-Host "  Execution"

    # Create Update Deployment Package
        Write-Host "    - Create Update Deployment Package"

        try {
            $Temp_UpdatePackage = New-CMSoftwareUpdateDeploymentPackage -Name $Name_SoftwareUpdates_DeploymentPackage -Description $Settings_SoftwareUpdates_DeploymentPackage_Description -Path $Path_SoftwareUpdates_DeploymentPackage_Source -Fast -ErrorAction Stop
            Write-Host "        Status: Success"
            Write-Host "        Name: $($Temp_UpdatePackage.Name)"
            Write-Host "        Description: $($Temp_UpdatePackage.Description)"
            Write-Host "        Package ID: $($Temp_UpdatePackage.PackageID)"
            Write-Host "        Source Path: $($Temp_UpdatePackage.PkgSourcePath)"
        }
        catch {
            Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
        }
        finally {
            $Temp_UpdatePackage = $null
        }

    # Set Binary Differential Replication
        Write-Host "    - Set Binary Differential Replication"
        Write-Host "        Setting: $($Settings_SoftwareUpdates_DeploymentPackage_BinaryReplicationEnabled)"

        try {
            if ($Settings_SoftwareUpdates_DeploymentPackage_BinaryReplicationEnabled) {
                $Temp_CIMInstance = Get-CimInstance -ComputerName $Param_SMSProvider -Namespace "root/sms/site_$($Param_SiteCode)" -ClassName "SMS_SoftwareUpdatesPackage" -Filter "PackageID = `"$((Get-CMSoftwareUpdateDeploymentPackage -Name $Name_SoftwareUpdates_DeploymentPackage).PackageID)`""
                $Temp_CIMInstance | Set-CimInstance -Property @{PkgFlags = $Temp_CIMInstance.PkgFlags -bor 0x04000000}
                Write-Host "        Status: Success"
            }
            else {
                Write-Host "        Status: Skipped. Setting is not enabled."
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1702 -Exit $true -Object $PSItem
        }
        finally {
            $Temp_CIMInstance = $null
        }

    # Distribute Update Deployment Package
        Write-Host "    - Distribute Update Deployment Package"

        try {
            foreach ($Item in $Param_DPGroups) {
                Write-Host "        Name: $($Item)"
                Start-CMContentDistribution -DeploymentPackageName $Name_SoftwareUpdates_DeploymentPackage -DistributionPointGroupName $Item -ErrorAction Stop
            }

            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1703 -Exit $true -Object $PSItem
        }

    # Configure Automated Deployment Rule
        Write-Host "    - Configure Automated Deployment Rule"

        try {
            Set-CMSoftwareUpdateAutoDeploymentRule -Name $Param_ADRName -DeploymentPackageName $Name_SoftwareUpdates_DeploymentPackage -ErrorAction Stop
            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1704 -Exit $true -Object $PSItem
        }

    # Determine Script Result
        $Meta_Script_Result = $true,"Success"

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Execution
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Output
#   Error Range: 1800 - 1899
#--------------------------------------------------------------------------------------------
#Region Output

    # Write-Host "  Output"

    # # [StepName]
    #     Write-Host "    - [StepName]"

    #     try {

    #         Write-Host "        Status: Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1801 -Exit $true -Object $PSItem
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Output
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Cleanup
#   Error Range: 1900 - 1999
#--------------------------------------------------------------------------------------------
#Region Cleanup

    # Write-Host "  Cleanup"

    # # Confirm Cleanup
    #     Write-Host "    - Confirm Cleanup"

    #     do {
    #         $Temp_Cleanup_UserInput = Read-Host -Prompt "        Do you want to automatically clean up the unecessary content from this script? [Y]es or [N]o" -ErrorAction Stop
    #     } until (
    #         $Temp_Cleanup_UserInput -in "Y","Yes","N","No"
    #     )

    # # [StepName]
    #     Write-Host "    - [StepName]"

    #     try {
    #         if ($Temp_Cleanup_UserInput -in "Y", "Yes") {

    #             Write-Host "        Status: Success"
    #         }
    #         else {
    #             Write-Host "            Status: Skipped"
    #         }
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1901 -Exit $true -Object $PSItem
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

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
        Write-Host "  Script Result: $($Meta_Script_Result[0])"
        Write-Host "  Script Started: $($Meta_Script_Start_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
        Write-Host "  Script Completed: $($Meta_Script_Complete_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
        Write-Host "  Total Time: $($Meta_Script_Complete_TimeSpan.Days) days, $($Meta_Script_Complete_TimeSpan.Hours) hours, $($Meta_Script_Complete_TimeSpan.Minutes) minutes, $($Meta_Script_Complete_TimeSpan.Seconds) seconds, $($Meta_Script_Complete_TimeSpan.Milliseconds) milliseconds"
        Write-Host "------------------------------------------------------------------------------"
        Write-Host "  End of Script"
        Write-Host "------------------------------------------------------------------------------"

#EndRegion Footer
#--------------------------------------------------------------------------------------------

Stop-Transcript
Return $Meta_Script_Result[0]