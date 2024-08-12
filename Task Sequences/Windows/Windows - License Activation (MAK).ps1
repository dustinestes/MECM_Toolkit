#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$MAK                # 'XXXXX-XXXXX-XXXXX-XXXXX-XXXXX' / '%%'
)

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  Task Sequence Toolkit - Windows - License Activation (MAK)"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       November 23, 2019"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    This script will attempt to activate the device with the provided"
    Write-Host "                MAK License key."
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
        $Param_MAK = $MAK

    # Names

    # Paths

    # Hashtables

    # Arrays

    # Output to Log
        Write-Host "    - Parameter: $($Param_ParamName)"
        Write-Host "    - Array Items"
        foreach ($Item in $Array) {
            Write-Host "        $($Item)"
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
# Validation
#   Error Range: 1400 - 1499
#--------------------------------------------------------------------------------------------
#Region Validaion

    Write-Host "  Validation"



    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Validation
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1500 - 1599
#--------------------------------------------------------------------------------------------
#Region Execution

    Write-Host "  Execution"

    # Enable NetJoinLegacyAccountReuse
        foreach ($Item in (Get-Variable -Name "Service_0*")) {
            Write-Host "    - $($Item.Name)"

            try {
                # Add/Modify Property Value Pair
                    New-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -Value $Item.Value.Value -PropertyType $Item.Value.PropertyType -Force:$($Item.Value.Force) -ErrorAction $Item.Value.ErrorAction | Out-Null
                    Write-Host "        Success"
            }
            catch {
                Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
            }
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Main Execution
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
