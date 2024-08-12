#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$Source,                    # -Source '%Win7_OnlineUpdates_Stage01%'
    [string]$LogPath                    # -LogPath '%vr_Directory_Logs_Updates%'
)

#--------------------------------------------------------------------------------------------
# Start-Transcript -Path "C:\VividRock\MECM Toolkit\Task Sequences\Software Updates\Install Package of Updates.log"

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - Task Sequences - Software Updates - Install Package of Updates"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       March 23, 2020"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    This script will take an input path from the TS step and install"
    Write-Host "                all Windows Updates located in that path, including sub-folders."
    Write-Host "    Links:      None"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""

<#
    To Do:
        - None
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
        $Param_Source = $Source
        $Param_LogPath = $LogPath

    # Metadata
        $Meta_Script_Start_DateTime     = Get-Date
        $Meta_Script_Complete_DateTime  = $null
        $Meta_Script_Complete_TimeSpan  = $null
        [bool]$Meta_Script_Success = $false

    # Names

    # Paths

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
    #         Write-Host "        Status: Success"
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

    # Source Directory Exists
        Write-Host "    - Source Directory Exists"

        try {
            if (Test-Path -Path $Param_Source -ErrorAction Stop) {
                Write-Host "        Status: Exists"
            }
            else {
                Write-Host "        Error: Not Exists"
                Write-Host "        Command Name: Test-Path"
                Exit 1502
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
        }

    # Log Directory Exists
        Write-Host "    - Log Directory Exists"

        try {
            if (Test-Path -Path $Param_LogPath -ErrorAction Stop) {
                Write-Host "        Status: Exists"
            }
            else {
                New-Item -Path $Param_LogPath -ItemType Directory -Force -ErrorAction Stop | Out-Null
                Write-Host "        Status: Created"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1502 -Exit $true -Object $PSItem
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

    Write-Host "  Data Gather"

    # Get Updates
        Write-Host "    - Get Updates"

        try {
            $Dataset_Updates_SourceContent = Get-ChildItem -Path $Param_Source -Recurse -Include "*.msu" -File -ErrorAction Stop
            $Dataset_Updates_SourceContent_Count = ($Dataset_Updates_SourceContent | Measure-Object -ErrorAction Stop).Count
            Write-Host "        Count: $($Dataset_Updates_SourceContent_Count)"
            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Data Gather
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1700 - 1799
#--------------------------------------------------------------------------------------------
#Region Execution

    Write-Host "  Execution"

    # Install Updates
        Write-Host "    - Install Updates"

        try {
            foreach ($Item in $Dataset_Updates_SourceContent) {
                $Temp_Updates_Log = $Param_LogPath + "\" + ($Item.Name -replace ".msu",".log")
                $Temp_Construct_Expression = "cmd.exe /c wusa.exe $($Item.FullName) /quiet /norestart /Log:$($Temp_Updates_Log)"
                Write-Host "        Filename: $($Item.Name)"
                Write-Host "        Log Path: $($Temp_Updates_Log)"
                Write-Host "        Command: $($Temp_Construct_Expression)"
                $Result_WUSA_Install = Invoke-Expression -Command $Temp_Construct_Expression -Verbose -ErrorAction Stop
            }
            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
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
    #             Write-Host "        Status: Skipped"
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
        Write-Host "  Script Result: $($Meta_Script_Success)"
        Write-Host "  Script Started: $($Meta_Script_Start_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
        Write-Host "  Script Completed: $($Meta_Script_Complete_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
        Write-Host "  Total Time: $($Meta_Script_Complete_TimeSpan.Days) days, $($Meta_Script_Complete_TimeSpan.Hours) hours, $($Meta_Script_Complete_TimeSpan.Minutes) minutes, $($Meta_Script_Complete_TimeSpan.Seconds) seconds, $($Meta_Script_Complete_TimeSpan.Milliseconds) milliseconds"
        Write-Host "------------------------------------------------------------------------------"
        Write-Host "  End of Script"
        Write-Host "------------------------------------------------------------------------------"

#EndRegion Footer
#--------------------------------------------------------------------------------------------

Return $Meta_Script_Success
# Stop-Transcript