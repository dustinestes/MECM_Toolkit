#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string[]]$NetProfile,                  # 'Domain', 'Private', 'Public'
    [string]$Enabled                        # 'True', 'False'
)

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Write Output Header Info to SMSTS.log
#--------------------------------------------------------------------------------------------

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  Task Sequence Toolkit - Firewall - Set Windows Firewall State"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       August 13, 2019"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    Set the enabled state of each network profile on the Windows"
    Write-Host "                firewall."
    Write-Host "    Links:      [Links to Helpful Source Material]"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Set Variables
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------

    Write-Host "  Set Variables"

    # Parameters
        $Param_Profiles     = $NetProfile
        $Param_Enabled      = $Enabled

    # Names

    # Paths

    # Hashtables

    # Arrays

    # Output to Log
        Write-Host "    - Parameters" 
        Write-Host "        Profiles: $($Param_Profiles -join ", ")"
        Write-Host "        Enabled: $($Param_Enabled)"

    Write-Host "    - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Create Functions
#   Error Range: 1300 - 1399
#--------------------------------------------------------------------------------------------

    Write-Host "  Create Functions"

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

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validate Data
#   Error Range: 1400 - 1499
#--------------------------------------------------------------------------------------------

    # Write-Host "  Validate Data"



    # Write-Host "    - Complete"
    # Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Main Execution
#   Error Range: 1500 - 1599
#--------------------------------------------------------------------------------------------

    Write-Host "  Main Execution"

    # Disable Windows Firewall
        Write-Host "    - Disable Windows Firewall"

        try {
            Set-NetFirewallProfile -Name $Param_Profiles -Enabled $Param_Enabled -ErrorAction Stop
            Write-Host "        Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
        }


    Write-Host "    - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# End of Script
#--------------------------------------------------------------------------------------------

    Write-Host ""
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  End of Script"
    Write-Host "------------------------------------------------------------------------------"

#--------------------------------------------------------------------------------------------
