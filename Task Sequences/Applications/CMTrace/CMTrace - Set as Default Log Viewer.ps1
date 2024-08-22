#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$FilePath                # '%vr_Directory_Tools%\CMTrace.exe'
)

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - CMTrace - Set as Default Log Viewer"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       December 19, 2019"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    This script will set the registry values that associate the"
    Write-Host "                CMTrace tool with the .LO_ and .LOG file types."
    Write-Host "    Links:      None"
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
        $Param_CMTrace_EXE       = $FilePath

    # Names

    # Paths

    # Registry
        $Registry_01 = @{
            "Path"          = "HKLM:\SOFTWARE\Classes\.lo_"
            "Name"          = "(Default)"
            "Value"         = "Log.File"
            "PropertyType"  = "String"
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

        $Registry_02 = @{
            "Path"          = "HKLM:\SOFTWARE\Classes\.log"
            "Name"          = "(Default)"
            "Value"         = "Log.File"
            "PropertyType"  = "String"
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

        $Registry_03 = @{
            "Path"          = "HKLM:\SOFTWARE\Classes\Log.File\shell\open\command"
            "Name"          = "(Default)"
            "Value"         = "$([char]34)$($Param_CMTrace_EXE)$([char]34) $([char]34)%1$([char]34)"
            "PropertyType"  = "String"
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

        $Registry_04 = @{
            "Path"          = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\CMtrace"
            "Name"          = "StubPath"
            "Value"         = '"reg.exe ADD HKCU\Software\Microsoft\Trace32 /v ""Register File Types"" /d 0 /f"'
            "PropertyType"  = "ExpandString"
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

        $Registry_05 = @{
            "Path"          = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\CMtrace"
            "Name"          = "Version"
            "Value"         = "1"
            "PropertyType"  = "String"
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

    # Hashtables

    # Arrays

    # Output to Log
        Write-Host "    - CMTrace Path: $($Param_CMTrace_EXE)"
        foreach ($Item in (Get-Variable -Name "Registry_0*")) {
            Write-Host "      - Registry: $($Item.Name)"
            Write-Host "            Path: $($Item.Value.Path)"
            Write-Host "            Name: $($Item.Value.Name)"
            Write-Host "            Value: $($Item.Value.Value)"
            Write-Host "            PropertyType: $($Item.Value.PropertyType)"
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

    # Validate Registry Path Exists
        foreach ($Item in (Get-Variable -Name "Registry_0*")) {
            Write-Host "    - Path: $($Item.Value.Path)"

            If (Test-Path $Item.Value.Path) {
                Write-Host "        Success: Path Exists"
            }
            Else {
                try {
                    New-Item -Path $Item.Value.Path -ItemType Directory -Force -ErrorAction Stop | Out-Null
                    Write-Host "        Missing: Path Created"
                }
                catch {
                    Write-Host "        Error: Path Could Not Be Created"
                    Write-Host "        Message: $($PSItem.Exception.Message)"
                    Exit 1201
                }
            }
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

    # Modify Registry
        foreach ($Item in (Get-Variable -Name "Registry_0*")) {
            Write-Host "    - $($Item.Value.Name)"
            Write-Host "        Path: $($Item.Value.Path)"

            try {
                # Add/Modify Property Value Pair
                    New-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -Value $Item.Value.Value -PropertyType $Item.Value.PropertyType -Force:$($Item.Value.Force) -ErrorAction $Item.Value.ErrorAction | Out-Null
                    Write-Host "        Success"
            }
            catch {
                Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
            }
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
