#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$LogPath,                   # '\\[share]\Logging\Client Migration\'
    [string]$SiteCode,                  # 'ABC'
    [string]$SMSProvider               # '[ServerFQDN]'
)

#--------------------------------------------------------------------------------------------
Start-Transcript -Path "$($LogPath)\$($env:COMPUTERNAME).log" -Force -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  VividRock - MECM Toolkit - Client - Site Migration"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       2017-01-21"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    Migrates a client from one MECM site to another."
    Write-Host "    Links:      None"
    Write-Host "    Template:   1.1"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""

<#
    To Do:
        - Item
        - Item
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
        $Param_LogPath          = $LogPath
        $Param_SiteCode         = $SiteCode
        $Param_SMSProvider      = $SMSProvider

    # Metadata
        $Meta_Script_Start_DateTime     = Get-Date
        $Meta_Script_Complete_DateTime  = $null
        $Meta_Script_Complete_TimeSpan  = $null
        $Meta_Script_Result = $false,"Failure"

    # Names
        $Name_Log_Filename      = "$($env:COMPUTERNAME).log"

    # Paths
        $Path_Log_File          = $Param_LogPath + $Name_Log_Filename

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

    # Create Client COM Object
        Write-Host "    - Create Client COM Object"

        try {
            $Object_MECM_Client = New-Object -ComObject Microsoft.SMS.Client -ErrorAction Stop
            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1401 -Exit $true -Object $PSItem
        }

    # # Create TSEnvironment COM Object
    #     Write-Host "    - Create TSEnvironment COM Object"

    #     try {
    #         $Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
    #         Write-Host "        Status: Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1402 -Exit $true -Object $PSItem
    #     }


    # # Connect to MECM Infrastructure
    #     Write-Host "    - Connect to MECM Infrastructure"

    #     try {
    #         if (Test-Connection -ComputerName $Param_SMSProvider -Count 2 -Quiet) {
    #             # Import the PowerShell Module
    #                 Write-Host "        Import the PowerShell Module"

    #                 if((Get-Module ConfigurationManager -ErrorAction Stop) -in $null,"") {
    #                     Import-Module -Name "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" -ErrorAction Stop
    #                     Write-Host "            Status: Success"
    #                 }
    #                 else {
    #                     Write-Host "            Status: Already Imported"
    #                 }

    #             # Create the Site Drive
    #                 Write-Host "        Create the Site Drive"

    #                 if((Get-PSDrive -Name $Param_SiteCode -PSProvider CMSite -ErrorAction Stop) -in $null,"") {
    #                     New-PSDrive -Name $Param_SiteCode -PSProvider CMSite -Root $Param_SMSProvider -ErrorAction Stop
    #                     Write-Host "            Status: Success"
    #                 }
    #                 else {
    #                     Write-Host "            Status: Already Exists"
    #                 }

    #             # Set the Location
    #                 Write-Host "        Set the Location"

    #                 if ((Get-Location -ErrorAction Stop).Path -ne "$($Param_SiteCode):\") {
    #                     Set-Location "$($Param_SiteCode):\" -ErrorAction Stop
    #                     Write-Host "            Status: Success"
    #                 }
    #                 else {
    #                     Write-Host "            Status: Already Set"
    #                 }
    #         }
    #         else {
    #             Write-Host "        Status: MECM Server Unreachable"
    #             Throw "Status: MECM Server Unreachable"
    #         }
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1403 -Exit $true -Object $PSItem
    #     }

    # Register Event Subscription: PowerShell.Exiting
        Write-Host "    - Register Event Subscription: PowerShell.Exiting"

        try {
            Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action {
                try {
                    # Add Sleep to Event
                        Start-Sleep -Seconds 20 -ErrorAction Stop

                    # Import Modules
                        Import-Module -Name "Microsoft.PowerShell.Management" -ErrorAction Stop

                    # Restart Service
                        Out-File -FilePath $Path_Log_File -InputObject "Service Restarted: $(Get-Date -Format `"HH:mm:ss`")" -Append
                        $Temp_EventSubscription = Restart-Service -Name "CcmExec" -Force -PassThru -ErrorAction Stop
                        Out-File -FilePath $Path_Log_File -InputObject $Temp_EventSubscription -Append
                }
                catch {
                    Out-File -FilePath $Path_Log_File -InputObject $PSItem.Exception.Message -Append
                }
            } -SupportEvent -ErrorAction Stop

            Write-Host "        Status: Success"
        }
        catch {

            Write-vr_ErrorCode -Code 1404 -Exit $true -Object $PSItem
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

    # Write-Host "  Validation"

    # # Sub Directories
    #     Write-Host "    - Sub Directories"

    #     try {
    #         foreach ($Item in (Get-Variable -Name "Path_Local_*")) {
    #             Write-Host "        Path: $($Item.Value)"
    #             if (Test-Path -Path $Item.Value) {
    #                 Write-Host "            Status: Exists"
    #             }
    #             else {
    #                 New-Item -Path $Item.Value -ItemType Directory -Force -ErrorAction Stop | Out-Null
    #                 Write-Host "            Status: Created"
    #             }
    #         }
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

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

    # Set MECM Site Code
        Write-Host "    - Set MECM Site Code"

        try {
            Write-Host "        Current Site Code: $($Object_MECM_Client.GetAssignedSite())"
            Write-Host "        New Site Code: $($Param_SiteCode)"

            if (($Object_MECM_Client.GetAssignedSite()) -ne $Param_SiteCode) {
                $Object_MECM_Client.SetAssignedSite("$($Param_SiteCode)")
                Write-Host "        Status: Migrated"
            }
            else {
                Write-Host "        Status: Skipped"
                Write-Host "    - Unregister PowerShell.Exiting Subscription"
                Get-EventSubscriber -SourceIdentifier PowerShell.Exiting -Force -ErrorAction Stop | Unregister-Event -Force -ErrorAction Stop
                Write-Host "        Status: Unregistered"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
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
Return $Meta_Script_Result[1]