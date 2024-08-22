#--------------------------------------------------------------------------------------------
# Write Output Header Info to SMSTS.log
#--------------------------------------------------------------------------------------------
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - Log Collection - Windows Upgrade Logs"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:    Dustin Estes"
    Write-Host "    Company:   VividRock"
    Write-Host "    Date:      December 12, 2019"
    Write-Host "    Copyright: VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:   This script will attempt to locate all the log files associated"
    Write-Host "               with the different phases of the upgrade process and then copy"
    Write-Host "               them to a central location for analysis."
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

    # Copy Logs to LogDirectory
        function Copy-vr_LogFiles ($LogFile) {
            If (Test-Path $LogFile){
                Copy-Item $LogFile $Path_LogDirectory
                Write-Host "            Success" -ForegroundColor Green
            }
            Else {
                Write-Host "            File does not exist"
            }
        }

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Set Variables
#--------------------------------------------------------------------------------------------
    Write-Host "  Set Variables"

    # Get Task Sequence Variable Values
        $Path_LogDirectory = $Object_MECM_TSEnvironment.Value("vr_Directory_Upgrades")
            Write-Host "      - vr_Directory_Upgrades: " $Path_LogDirectory

    # Create Array of Log File Paths
        # Link to Microsoft Support Document that was used to populate the list:
        # https://support.microsoft.com/en-us/help/928901/log-files-that-are-created-when-you-upgrade-to-a-new-version-of-window

        $HashTable_WindowsUpgradeLogFiles = @(
            'C:\Windows\Panther\Setupact.log'
            'C:\Windows\panther\setuperr.log'
            'C:\Windows\inf\setupapi.app.log'
            'C:\Windows\inf\setupapi.dev.log'
            'C:\Windows\panther\PreGatherPnPList.log'
            'C:\Windows\panther\PostApplyPnPList.log'
            'C:\Windows\panther\miglog.xml'
            'C:\$Windows.~BT\Sources\panther\setupact.log'
            'C:\$Windows.~BT\Sources\panther\miglog.xml'
            'C:\Windows\setupapi.log'
            'C:\Windows\Logs\MoSetup\BlueBox.log'
            'C:\Windows\panther\setupact.log'
            'C:\Windows\panther\miglog.xml'
            'C:\Windows\inf\setupapi.app.log'
            'C:\Windows\inf\setupapi.dev.log'
            'C:\Windows\panther\PreGatherPnPList.log'
            'C:\Windows\panther\PostApplyPnPList.log'
            'C:\Windows\memory.dmp'
            'C:\$Windows.~BT\Sources\panther\setupact.log'
            'C:\$Windows.~BT\Sources\panther\miglog.xml'
            'C:\$Windows.~BT\sources\panther\setupapi\setupapi.dev.log'
            'C:\$Windows.~BT\sources\panther\setupapi\setupapi.app.log'
            'C:\Windows\memory.dmp'
            'C:\$Windows.~BT\Sources\Rollback\setupact.log'
            'C:\$Windows.~BT\Sources\Rollback\setupact.err'
        )

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

    # Copy Log Files
        Write-Host "      - Copy Log Files"

        foreach ($Item in $HashTable_WindowsUpgradeLogFiles) {
            Write-Host "          $Item"
            Copy-vr_LogFiles -LogFile $Item
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
