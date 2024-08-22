#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$Source,            # %Cache_StartMenu01%
    [string]$Destination        # "C:\VividRock\MECM\Cache\StartMenu"
)

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Write Output Header Info to SMSTS.log
#--------------------------------------------------------------------------------------------
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - Start Menu - Copy Start Menu Files to Cache"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:    Dustin Estes"
    Write-Host "    Company:   VividRock"
    Write-Host "    Date:      December 24, 2019"
    Write-Host "    Copyright: VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:   This script will copy the Start Menu files to the cache path."
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Set Variables
#--------------------------------------------------------------------------------------------
    Write-Host "  Set Variables"

    # Paths
        $Path_Source_Folder = "$Source\*"
        $Path_Target_Folder = $Destination

    # Output to Log
        Write-Host "      - Source Folder: $($Path_Source_Folder)"
        Write-Host "      - Target Folder: $($Path_Target_Folder)"

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validate Data
#--------------------------------------------------------------------------------------------

    Write-Host "  Validate Data"

    # Validate Source Path Exists
        Write-Host "      - Source Path Exists"

        If (Test-Path $Path_Source_Folder) {
            Write-Host "          Success: Source Path Exists"
        }
        Else {
            Write-Host "          Error: Source Path Not Exists"
            Exit 1201
        }

    # Validate Target Path Exists
        Write-Host "      - Target Path Exists"

        If (Test-Path $Path_Target_Folder) {
            Write-Host "          Success: Target Path Exists"
        }
        Else {
            Write-Host "          Error: Target Path Not Exists"
            Exit 1202
        }

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Main Execution
#--------------------------------------------------------------------------------------------

    Write-Host "  Main Execution"

    # Enable NetJoinLegacyAccountReuse
        Write-Host "      - Copy Source Files"

        try {
            # Define Variables
                $Temp_Source_Files = Get-Item -Path $Path_Source_Folder -ErrorAction Stop

            # Copy Files
                Write-Host "          File Count: $($Item.Count)"
                foreach ($Item in $Temp_Source_Files) {
                    Write-Host "          File: $($Item.FullName)"
                    Copy-Item -Path $Path_Source_Folder -Destination $Path_Target_Folder -Force -ErrorAction Stop
                    Write-Host "          Status: Success"
                    Write-Host ""
                }

            Write-Host "          Complete: Source Files Copied to Target Path"
        }
        catch {
            Write-Host "          Error: Failed to Copy Source Files to Target Path"
            Write-Host $Error[0]
            Exit 1401
        }

    Write-Host "      - Complete"
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
