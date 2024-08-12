#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

# param (
#     [string]$ParamName                # [ExampleInputValues]
# )

#--------------------------------------------------------------------------------------------
Start-Transcript -Path "C:\VividRock\MECM Toolkit\Logs\Client\CMG - Set Client to Internet.log"  -Append -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  VividRock - MECM Toolkit - Client - Cloud Management Gateway - Set Client to Internet"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       January 12, 2020"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    Allows you to switch a client location between intranet and"
    Write-Host "                internet for testing & validation of a CMG configuration."
    Write-Host "    Links:      https://learn.microsoft.com/en-us/mem/configmgr/core/clients/manage/cmg/configure-clients"
    Write-Host "    Template:   1.0"
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
        $Registry_01 = @{
            "Path"          = "HKLM:\SOFTWARE\Microsoft\CCM\Security"
            "Name"          = "ClientAlwaysOnInternet"
            "Value"         = "1"
            "PropertyType"  = "DWORD"
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

    # WMI
        $WMI_Namespace_Path = "root\Ccm\LocationServices"
        $WMI_Class_Name     = "SMS_ActiveMPCandidate"

    # Datasets

    # Temporary

    # Output to Log
        Write-Host "    - Registry"
        foreach ($Item in (Get-Variable -Name "Registry_0*")) {
            Write-Host "        Path: $($Item.Value.Path)"
            Write-Host "        Name: $($Item.Value.Name)"
            Write-Host "        Value: $($Item.Value.Value)"
            Write-Host "        PropertyType: $($Item.Value.PropertyType)"
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

    # WMI Class
        Write-Host "    - WMI Class"

        try {
            Get-CimClass -Namespace $WMI_Namespace_Path -ClassName $WMI_Class_Name -ErrorAction Stop | Out-Null
            Write-host "        Status: Exists"
        }
        catch {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
        }

    # CMG Policy
        Write-Host "    - CMG Policy"

        try {
            $Temp_CMG_Policy = Get-CimInstance -Namespace $WMI_Namespace_Path -ClassName $WMI_Class_Name -ErrorAction Stop | Where-Object -Property "Type" -eq "Internet" -ErrorAction Stop | Sort-Object -Property "Index" -ErrorAction Stop

            if ($Temp_CMG_Policy) {
                Write-Host "        Status: Applied"

                foreach ($Item in $Temp_CMG_Policy) {
                    $Temp_Item_Name = [regex]::Match($Item.MP, "^[^/]*")

                    Write-host "        Name: $($Temp_Item_Name)"
                    Write-host "            Index: $($Item.Index)"
                    Write-host "            Address: $($Item.MP)"
                    Write-host "            Version: $($Item.Version)"
                    Write-host "            Reachable: $($ProgressPreference = 'SilentlyContinue'; Test-NetConnection -ComputerName $Temp_Item_Name -ErrorAction Stop -InformationLevel Quiet; $ProgressPreference = 'Continue')"
                }
            }
            else {
                Write-Host "        Status: Not Applied"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
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

    # Modify Registry
        Write-Host "    - Modify Registry"

        try {
            foreach ($Item in (Get-Variable -Name "Registry_0*")) {
                Write-Host "        $($Item.Value.Name)"
                New-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -Value $Item.Value.Value -PropertyType $Item.Value.PropertyType -Force:$($Item.Value.Force) -ErrorAction $Item.Value.ErrorAction | Out-Null
                Write-Host "            Status: Success"
                $Meta_Script_Success = $true
            }
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
Stop-Transcript