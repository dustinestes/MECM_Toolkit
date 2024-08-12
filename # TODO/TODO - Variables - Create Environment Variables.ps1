<#
TODO
- Update this script to match newer template
- Update to do simple enumeration of the core variables that begin with vr_Directory
#>




#--------------------------------------------------------------------------------------------
# Write Output Header Info to SMSTS.log
#--------------------------------------------------------------------------------------------
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  Task Sequence Toolkit - Configure OS Environment - Create Environment Variables"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:    Dustin Estes"
    Write-Host "    Company:   VividRock"
    Write-Host "    Date:      December 12, 2019"
    Write-Host "    Copyright: VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:   Creates helpful environment variables used throughout the life"
    Write-Host "               of the OS environment."
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
# Create Functions
#--------------------------------------------------------------------------------------------

    Write-Host "  Create Functions"

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Set Variables
#--------------------------------------------------------------------------------------------

    Write-Host "  Set Variables"

    # Get Task Sequence Variable Values
        $Path_LogDirectory = $Object_MECM_TSEnvironment.Value("vr_Directory_TaskSequences")
            Write-Host "      - vr_Directory_TaskSequences: " $Path_LogDirectory

        $Name_ClientAcronym = $Object_MECM_TSEnvironment.Value("vr_Organization_Acronym")
            Write-Host "      - vr_Organization_Acronym: " $Name_ClientAcronym

    # Paths

    # Names
        $Name_LogFile = $Path_LogDirectory + "\VividRock_TaskSeqeunceToolkit_EnvironmentVariables.log"

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validate Data
#--------------------------------------------------------------------------------------------

    Write-Host "  Validate Data"

    # Validate Log Directory Exists
        Write-Host "      - Log Directory Exists: "$Path_LogDirectory

        If (Test-Path $Path_LogDirectory) {
            Write-Host "          Directory Found"
        }
        Else {
            Write-Host "          Directory Not Found..."
            try {
                New-Item -Path $Path_LogDirectory -ItemType Directory -ErrorAction Stop | Out-Null
            }
            catch {
                Write-Host "          Failed to Create Directory"
                $PSCmdlet.ThrowTerminatingError($PSItem)
            }

            Write-Host "          Successfully Created Directory"
        }

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Transform Data
#--------------------------------------------------------------------------------------------

    Write-Host "  Transform Data"

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Main Execution
#--------------------------------------------------------------------------------------------

    Write-Host "  Main Execution"

    # Create Environment Variables
        Write-Host "      - Create Environment Variables"

        # Customize for Client if Set
            if ($Name_ClientAcronym) {
                Write-Host "          Client Customization Enabled"

                $Temp_Name1 = $Name_ClientAcronym + "_Directory_RootDir"
                Write-Host "          $($Temp_Name1) = "$($Object_MECM_TSEnvironment.Value("vr_Directory_RootDir"))
                [System.Environment]::SetEnvironmentVariable( "$Temp_Name1", $($Object_MECM_TSEnvironment.Value("vr_Directory_RootDir")), "Machine" )

                $Temp_Name2 = $Name_ClientAcronym + "_Directory_MECM"
                Write-Host "          $($Temp_Name2) = "$($Object_MECM_TSEnvironment.Value("vr_Directory_MECM"))
                [System.Environment]::SetEnvironmentVariable( "$Temp_Name2", $($Object_MECM_TSEnvironment.Value("vr_Directory_MECM")), "Machine" )

                $Temp_Name3 = $Name_ClientAcronym + "_Directory_Cache"
                Write-Host "          $($Temp_Name3) = "$($Object_MECM_TSEnvironment.Value("vr_Directory_Cache"))
                [System.Environment]::SetEnvironmentVariable( "$Temp_Name3", $($Object_MECM_TSEnvironment.Value("vr_Directory_Cache")), "Machine" )

                $Temp_Name4 = $Name_ClientAcronym + "_Directory_Logs"
                Write-Host "          $($Temp_Name4) = "$($Object_MECM_TSEnvironment.Value("vr_Directory_Logs"))
                [System.Environment]::SetEnvironmentVariable( "$Temp_Name4", $($Object_MECM_TSEnvironment.Value("vr_Directory_Logs")), "Machine" )

                $Temp_Name5 = $Name_ClientAcronym + "_Directory_Tools"
                Write-Host "          $($Temp_Name5) = "$($Object_MECM_TSEnvironment.Value("vr_Directory_Tools"))
                [System.Environment]::SetEnvironmentVariable( "$Temp_Name5", $($Object_MECM_TSEnvironment.Value("vr_Directory_Tools")), "Machine" )
            }
            else {
                Write-Host "          Client Customization Not Enabled"

                [System.Environment]::SetEnvironmentVariable( "vr_Directory_RootDir", $($Object_MECM_TSEnvironment.Value("vr_Directory_RootDir")), "Machine" )
                    Write-Host "          vr_Directory_RootDir = "$($Object_MECM_TSEnvironment.Value("vr_Directory_RootDir"))
                [System.Environment]::SetEnvironmentVariable( "vr_Directory_MECM", $($Object_MECM_TSEnvironment.Value("vr_Directory_MECM")), "Machine" )
                    Write-Host "          vr_Directory_MECM = "$($Object_MECM_TSEnvironment.Value("vr_Directory_MECM"))
                [System.Environment]::SetEnvironmentVariable( "vr_Directory_Cache", $($Object_MECM_TSEnvironment.Value("vr_Directory_Cache")), "Machine" )
                    Write-Host "          vr_Directory_Cache = "$($Object_MECM_TSEnvironment.Value("vr_Directory_Cache"))
                [System.Environment]::SetEnvironmentVariable( "vr_Directory_Logs", $($Object_MECM_TSEnvironment.Value("vr_Directory_Logs")), "Machine" )
                    Write-Host "          vr_Directory_Logs = "$($Object_MECM_TSEnvironment.Value("vr_Directory_Logs"))
                [System.Environment]::SetEnvironmentVariable( "vr_Directory_Tools", $($Object_MECM_TSEnvironment.Value("vr_Directory_Tools")), "Machine" )
                    Write-Host "          vr_Directory_Tools = "$($Object_MECM_TSEnvironment.Value("vr_Directory_Tools"))
            }



    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Set Task Sequence Variables
#--------------------------------------------------------------------------------------------

    Write-Host "  Set Task Sequence Variables"

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
