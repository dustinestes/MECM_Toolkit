#--------------------------------------------------------------------------------------------
# Write Output Header Info to SMSTS.log
#--------------------------------------------------------------------------------------------
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  Task Sequence Toolkit - Log Collection - Copy CCMSetup Logs"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:    Dustin Estes"
    Write-Host "    Company:   VividRock"
    Write-Host "    Date:      December 12, 2019"
    Write-Host "    Copyright: VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:   This script will copy the specified CCMSetup logs from their"
    Write-Host "                original location into the local Log Repository for"
    Write-Host "                point-in-time analysis."
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
        $Path_LogDirectory = $Object_MECM_TSEnvironment.Value("vr_Directory_TS_CCMSetup")
            Write-Host "      - vr_Directory_CCMSetup: " $Path_LogDirectory

        $DateTime_TSTimeStart = $Object_MECM_TSEnvironment.Value("vr_Meta_TimeStartUTC")

    # Paths
        $Path_CCMSetupLogSource = "C:\Windows\CCMSetup\Logs\"

    # Hashtables
        $Hashtable_CCMSetupLogNames = @(
            'ccmsetup';                # Records ccmsetup tasks for client setup, client upgrade, and client removal. Can be used to troubleshoot client installation problems.
            'Client.msi';              # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
        )

    Write-Host "      - Time Start: " $DateTime_TSTimeStart
    Write-Host "      - Source: " $Path_CCMSetupLogSource
    Write-Host "      - Destination: " $Path_LogDirectory
    Write-Host "      - Logs Included: " $Hashtable_CCMSetupLogNames

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

    # Get Existing Logs
        $Object_ExistingLogs = Get-ChildItem -Path $Path_CCMSetupLogSource -Recurse

    # Loop through list of log files and array of log names to find matches and copy the matching files
        ForEach($LogName in $Hashtable_CCMSetupLogNames){
            Write-Host "      - Searching for log file(s) containing: " $LogName
            $Temp_LogName = $LogName + '*'

                If($Object_ExistingLogs -Match $Temp_LogName){
                    # Do Nothing. Just using this If Statement to determine if there is NOT a match so simple output can be done
                }
                Else{
                    Write-Host "          No log files were found that contained the string" -ForegroundColor Red
                    Write-Host ""
                }

            ForEach($LogFile in $Object_ExistingLogs){
                If($LogFile -Like $Temp_LogName){
                    Write-Host "          Log File Found: " $LogFile -ForegroundColor Cyan
                    $ConcatLogPath = $Path_CCMSetupLogSource + $LogFile
                    Write-Host "      - Attempting to copy log file:" $ConcatLogPath

                    Try{
                        Copy-Item -Path $ConcatLogPath -Destination $Path_LogDirectory -Force -Recurse -ErrorAction Stop
                        Write-Host "      - Success: Log file copied"
                        Write-Host ""
                    }
                    Catch{
                        Write-Host "      - Error: Could not copy the log file"
                        Write-Host ""
                    }
                }
            }
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
