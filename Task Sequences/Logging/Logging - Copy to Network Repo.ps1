#--------------------------------------------------------------------------------------------
# Write Output Header Info to SMSTS.log
#--------------------------------------------------------------------------------------------
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  Task Sequence Toolkit - Log Collection - Copy to Network Repository"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:    Dustin Estes"
    Write-Host "    Company:   VividRock"
    Write-Host "    Date:      December 12, 2019"
    Write-Host "    Copyright: VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:   This script will copy all of the local logs to the Network"
    Write-Host "               Log Repository."
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Create COM Objects
#--------------------------------------------------------------------------------------------
    Write-Host "  Create COM Objects"

    # Create TS Environment COM Object
        try {
            $Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
        }
        catch {
            Write-Host "    - Error: Could not create COM Object"
            Write-Host "          $($Error[0].Exception)"
            Exit 1000
        }

    Write-Host "    - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Set Variables
#--------------------------------------------------------------------------------------------
    Write-Host "  Set Variables"

    # Get Task Sequence Variable Values
        $Path_Local_LogDirectory    = $Object_MECM_TSEnvironment.Value("vr_Directory_Logs")
        $Path_Network_LogRepository = $Object_MECM_TSEnvironment.Value("vr_Logging_NetworkRepository")
        $Device_Manufacturer        = $Object_MECM_TSEnvironment.Value("vr_Device_Manufacturer")
        $Device_SerialNumber        = $Object_MECM_TSEnvironment.Value("vr_Device_SerialNumber")
        $Device_Name                = $Object_MECM_TSEnvironment.Value("vr_Meta_ComputerName")
        $DateTime_TSTimeStampUTC    = $Object_MECM_TSEnvironment.Value("vr_Meta_TimeStampUTC")

    # Paths
        $Path_Network_LogRepository_Destination = $Path_Network_LogRepository + $Device_Manufacturer + "\" + $Device_SerialNumber + "\" + $DateTime_TSTimeStampUTC #+ "\Logs"

    # Log Output
        Write-Host "      - Time Stamp (UTC): " $DateTime_TSTimeStampUTC
        Write-Host "      - Manufacturer: " $Device_Manufacturer
        Write-Host "      - Device Name: " $Device_Name
        Write-Host "      - Device Serial #: " $Device_SerialNumber
        Write-Host "      - Source: " $Path_Local_LogDirectory
        Write-Host "      - Destination: " $Path_Network_LogRepository_Destination

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validate Data
#--------------------------------------------------------------------------------------------

    Write-Host "  Validate Data"

    # Validate Log Directory Exists
        Write-Host "      - Test Log Directory Exists: "$Path_Network_LogRepository_Destination

        If (Test-Path $Path_Network_LogRepository_Destination) {
            Write-Host "          Directory Exists"
        }
        Else {
            Write-Host "          Creating Directory..."
            try {
                New-Item -Path $Path_Network_LogRepository_Destination -ItemType Directory -ErrorAction Stop | Out-Null
            }
            catch {
                Write-Host "          Failed to Create Directory"
                $PSCmdlet.ThrowTerminatingError($PSItem)
                Exit 1
            }

            Write-Host "          Successfully Created Directory"
        }

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Main Execution
#--------------------------------------------------------------------------------------------

    Write-Host "  Main Execution"

    # Copy to Network Repo
        Write-Host "      - Attempting to Copy Logs to the Network Log Repository"
        Try{
            Copy-Item -Path "$Path_Local_LogDirectory\*" -Destination $Path_Network_LogRepository_Destination -Recurse -ErrorAction Stop
            Write-Host "          Executed Command = Copy-Item -Path $Path_Local_LogDirectory\* -Destination $Path_Network_LogRepository_Destination -Recurse -ErrorAction Stop"
            Write-Host "          Success: Local log files were copied to the Network Log Repository"
        }
        Catch{
            Write-Host "          Failure: Local log files were not copied to the Network Log Repository"
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
