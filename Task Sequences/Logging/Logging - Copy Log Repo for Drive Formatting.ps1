#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$Source,
    [string]$Destination
)

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Write Output Header Info to SMSTS.log
#--------------------------------------------------------------------------------------------
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - Logging - Copy Log Repository for Drive Formatting"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:    Dustin Estes"
    Write-Host "    Company:   VividRock"
    Write-Host "    Date:      December 19, 2019"
    Write-Host "    Copyright: VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:   This script will copy the log repository content before or after"
    Write-Host "               the drive partitioning occurs to avoid deletion and retain data."
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Set Variables
#--------------------------------------------------------------------------------------------
    Write-Host "  Set Variables"

    # Paths
        $Path_Log_Source        = $Source
        $Path_Log_Destination   = $Destination

    # Output to Log
        Write-Host "      - Source: $($Path_Log_Source)"
        Write-Host "      - Destination: $($Path_Log_Destination)"

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validate Data
#--------------------------------------------------------------------------------------------

    Write-Host "  Validate Data"

    # Validate Source Directory Exists
        Write-Host "      - Source Directory Exists"

        If (Test-Path $Path_Log_Source) {
            Write-Host "          Success: Directory Exists"
        }
        Else {
            Write-Host "          Error: Directory Not Exists"
            Exit 1001
        }

    # Validate Destination Directory Exists
        Write-Host "      - Destination Directory Exists"

        If (Test-Path $Path_Log_Destination) {
            Write-Host "          Success: Directory Exists"
        }
        Else {
            try {
                New-Item -Path $Path_Log_Destination -ItemType Directory -Force -ErrorAction Stop | Out-Null
                Write-Host "          Success: Created Directory"
            }
            catch {
                Write-Host "          Error: Could not Create Destination Directory"
                Exit 1003
            }
        }

    # Enumerate Source Content
        Write-Host "      - Enumerate Source Content"

        try {
            $Temp_SourceContent = Get-ChildItem -Path $Path_Log_Source -Recurse -ErrorAction Stop
            foreach ($Item in $Temp_SourceContent) {
                Write-Host "          $($Item.FullName)"
            }
            Write-Host "          Total Count: $($Temp_SourceContent.Count)"
        }
        catch {
            Write-Host "          Error: Failed to Enumerate the List of Source Content"
            Exit 1002
        }

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Main Execution
#--------------------------------------------------------------------------------------------

    Write-Host "  Main Execution"

    # Copy Source Content to Destination
        Write-Host "      - Copy Source Content to Destination"

        try {
            Copy-Item -Path $Path_Log_Source -Destination $Path_Log_Destination -Recurse -Force -ErrorAction Stop
            Write-Host "          Success: Content Copied"
        }
        catch {
            Write-Host "          Error: Failed to Copy Source Content to Destination"
            Exit 1004
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
