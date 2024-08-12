#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

# param (
#     [string]$ParamName                # [ExampleInputValues]
# )

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  Infrastructure Toolkit - [Collection] - [SpecificOperation]"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       [Date]"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    [Description]"
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
        $Param_ParamName = $ParamName

    # Metadata

    # Names

    # Paths

    # Files

    # Hashtables

    # Arrays

    # Registry
        $Registry_01 = @{
            "Path"          = "HKLM:\SOFTWARE\"
            "Name"          = ""
            "Value"         = ""
            "PropertyType"  = ""
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

    # Output to Log
        Write-Host "    - Parameters"
        Write-Host "        ParamName: $($Param_ParamName)"
        Write-Host "    - Array Items"
        foreach ($Item in $Array) {
            Write-Host "        $($Item)"
        }
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

    # [FunctionName]
        Write-Host "    - [FunctionName]"
        function Verb-Noun ($ParamName) {

            begin {

            }

            process {
                try {

                }
                catch {
                    Write-Host "        Error"
                    Write-Host "        Command Name: $($PSItem.Exception.CommandName)"
                    Write-Host "        Message: $($PSItem.Exception.Message)"
                    Exit 1300
                }
            }

            end {

            }

        }

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

    Write-Host "  Environment"

    # Create TSEnvironment COM Object
        Write-Host "    - Create TSEnvironment COM Object"

        try {
            $Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
            Write-host "        Success"
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
        foreach ($Item in (Get-Variable -Name "Service_0*")) {
            Write-Host "    - $($Item.Name)"

            try {

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
# Output
#   Error Range: 1800 - 1899
#--------------------------------------------------------------------------------------------
#Region Output

    Write-Host "  Output"

    # [StepName]
        Write-Host "    - [StepName]"

        try {

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

    # [StepName]
        Write-Host "    - [StepName]"

        try {

            Write-host "        Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1901 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Cleanup
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
