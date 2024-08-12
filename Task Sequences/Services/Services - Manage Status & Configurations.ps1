#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

# param (
#     [string]$Parameter
# )

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Write Output Header Info to SMSTS.log
#--------------------------------------------------------------------------------------------
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  Task Sequence Toolkit - Services - Manage Status & Configurations"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:    Dustin Estes"
    Write-Host "    Company:   VividRock"
    Write-Host "    Date:      December 24, 2019"
    Write-Host "    Copyright: VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:   This script will apply configurations and change the current"
    Write-Host "               state of the defined services."
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Set Variables
#--------------------------------------------------------------------------------------------
    Write-Host "  Set Variables"

    # Paths

    # Service Status Changes
        $Service_Status_01 = @{
            "Action"        = ""        # Start, Stop, Restart, Pause, Resume
            "DisplayName"   = ""        # SNMP Trap  Accepts wildcards
            "Include"       = ""        #
            "Exclude"       = ""        #
            "PassThru"      = $false    # $true, $false
            "ErrorAction"   = "Stop"
        }

    # Service Configuration Changes
        $Service_01 = @{
            #"Action"        = ""        # Start, Stop, Restart, Pause, Resume
            "Name"   = ""        # SNMP Trap  Accepts wildcards
            "Include"       = ""        #
            "Exclude"       = ""        #
            "PassThru"      = $false    # $true, $false
            "ErrorAction"   = "Stop"
        }

    # Output to Log
        foreach ($Item in (Get-Variable -Name "Service_0*")) {
            Write-Host "    - Change: $($Item.Name)"
            Write-Host "        Path: $($Item.Value.Path)"
            Write-Host "        Name: $($Item.Value.Name)"
            Write-Host "        Value: $($Item.Value.Value)"
            Write-Host "        PropertyType: $($Item.Value.PropertyType)"
        }

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validate Data
#--------------------------------------------------------------------------------------------

    Write-Host "  Validate Data"

    # Validate Service Path Exists
        foreach ($Item in (Get-Variable -Name "Service_0*")) {
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

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Modify Service
#--------------------------------------------------------------------------------------------

    Write-Host "  Modify Service"

    # Enable NetJoinLegacyAccountReuse
        foreach ($Item in (Get-Variable -Name "Service_0*")) {
            Write-Host "    - $($Item.Name)"

            try {
                # Add/Modify Property Value Pair
                    New-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -Value $Item.Value.Value -PropertyType $Item.Value.PropertyType -Force:$($Item.Value.Force) -ErrorAction $Item.Value.ErrorAction | Out-Null
                    Write-Host "        Success: Service Change Was Made"
            }
            catch {
                Write-Host "        Error: Service Change Could Not be Made"
                Write-Host "        Message: $($PSItem.Exception.Message)"
                Exit 1301
            }
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
