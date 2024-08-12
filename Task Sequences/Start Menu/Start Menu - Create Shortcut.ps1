#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$FolderName,                # 'Microsoft Configuration Manager'
    [string]$ShortcutName,              # 'Configuration Manager'
    [string]$Target,                    # 'C:\Windows\System32\control.exe smscfgrc'
    [string]$Arguments,                 # 'smscfgrc'
    [string]$Icon                       # 'C:\Windows\System32\control.exe,0'
)

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  Task Sequence Toolkit - Start Menu - Create Shortcut"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       August 21, 2019"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    Create a Start Menu shortcut using the paramter values."
    Write-Host "    Links:      [Links to Helpful Source Material]"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""

#EndRegion Header
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Variables
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Variables

    Write-Host "  Variables"

    # Parameters
        $Param_FolderName   = $FolderName
        $Param_ShortcutName = $ShortcutName
        $Param_Target       = $Target
        $Param_Arguments    = $Arguments
        $Param_Icon         = $Icon

    # Names

    # Paths
        $Path_StartMenu     = $env:ProgramData + "\Microsoft\Windows\Start Menu\Programs\" + $FolderName

    # Hashtables

    # Arrays

    # Output to Log
        if ($Param_FolderName -in $null,"") {
            Write-Host "    - Folder Name: Not Defined"
        }
        else {
            Write-Host "    - Folder Name: $($Param_FolderName)"
        }

        Write-Host "    - Shortcut Name: $($Param_ShortcutName)"
        Write-Host "    - Target: $($Param_Target)"
        Write-Host "    - Arguments: $($Param_Arguments)"
        Write-Host "    - Icon: $($Param_Icon)"
        Write-Host "    - StartMenu Path: $($Path_StartMenu)"

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
                        Write-Host "        Return"
                        Return
                    }
                    Default {
                        Write-Host "        Unknown Exit option in Write-vr_ErrorCode parameter"
                    }
                }
            }
        }

        Write-Host "        Success"

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

    # Validate StartMenu Path
        Write-Host "    - Validate StartMenu Path"

        try {
            if (Test-Path -Path $Path_StartMenu) {
                Write-Host "        Exists"
            }
            else {
                New-Item -Path $Path_StartMenu -Name $Param_FolderName -ItemType "Directory" -ErrorAction Stop | Out-Null
                Write-Host "        Created"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1401 -Exit $true -Object $PSItem
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

    # Enable NetJoinLegacyAccountReuse
        Write-Host "    - Create Shortcut"

        try {
            # Create COM Object
                $Temp_COM   = New-Object -ComObject ("WScript.Shell") -ErrorAction Stop

            # Create Shortcut Object
                $Temp_Shortcut              = $Temp_COM.CreateShortcut($Path_StartMenu + "\" + $Param_ShortcutName + ".lnk")
                $Temp_Shortcut.TargetPath   = $Param_Target
                $Temp_Shortcut.IconLocation = $Param_Icon
                $Temp_Shortcut.Arguments    = $Param_Arguments
                $Temp_Shortcut.Save()

            Write-Host "        Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Execution
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Cleanup
#   Error Range: 1800 - 1899
#--------------------------------------------------------------------------------------------
#Region Cleanup

    # Write-Host "  Cleanup"

    # # [StepName]
    #     Write-Host "    - [StepName]"

    #     try {

    #         Write-host "        Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1801 -Exit $true -Object $PSItem
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Cleanup
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Output
#   Error Range: 1900 - 1999
#--------------------------------------------------------------------------------------------
#Region Output

    # Write-Host "  Output"

    # # [StepName]
    #     Write-Host "    - [StepName]"

    #     try {

    #         Write-host "        Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1901 -Exit $true -Object $PSItem
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Output
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Footer
#--------------------------------------------------------------------------------------------
#Region Footer

    Write-Host ""
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  End of Script"
    Write-Host "------------------------------------------------------------------------------"

#EndRegion Footer
#--------------------------------------------------------------------------------------------
