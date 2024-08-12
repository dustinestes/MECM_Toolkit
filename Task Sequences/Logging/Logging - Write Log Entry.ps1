param ([string]$LogPath,[string[]]$TSVariables)

$MECM_Log_Message = @(
    "------------------------------------------------------------------------------------------------------"
    "    Starting TS Execution: $($TSVariables[0])"
    "------------------------------------------------------------------------------------------------------"
    "    Log Path: $($LogPath)"
    "    Start Date (UTC): $($TSVariables[1])"
    "    Start Time (UTC): $($TSVariables[2])"
    "    Manufacturer: $($TSVariables[3])"
    "    Model: $($TSVariables[4])"
    "    Serial Number: $($TSVariables[5])"
    "    Asset Tag: $($TSVariables[6])"
    "------------------------------------------------------------------------------------------------------"
    "---- Begin Initialize Group ----"
    "  - Create Log File"
)
$MECM_Log_Type = " type=`"1`""
    #Info = 1, Warning = 2, Error = 3

#--------------------------------------------------------------------------------------------
# Write Output Header Info to SMSTS.log
#--------------------------------------------------------------------------------------------
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  VividRock - MECM Toolkit - Logging - Write Log Entry"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:    Dustin Estes"
    Write-Host "    Company:   VividRock"
    Write-Host "    Date:      December 21, 2019"
    Write-Host "    Copyright: VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:   This script will create a log entry into the SMSTS.log file"
    Write-Host "               during the Task Sequence process."
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""
#--------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------
# Construct & Output Log Entry
#--------------------------------------------------------------------------------------------
    foreach ($Item in $MECM_Log_Message) {
        $MECM_Log_MessagePrefix = "<![LOG["
        $MECM_Log_MessageSuffix = "]LOG]!>"
        $MECM_Log_Time          = "<time=`"$((Get-Date).ToUniversalTime().ToString("HH:mm:ss.ffffff"))`""
        $MECM_Log_Date          = "date=`"$((Get-Date).ToUniversalTime().ToString("M-d-yyyy"))`""
        $MECM_Log_Component     = " component=`"Logging`""
        $MECM_Log_Context       = " context=`"$([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)`""
        $MECM_Log_Thread        = " thread=`"$([Threading.Thread]::CurrentThread.ManagedThreadId)`""
        $MECM_Log_File          = " file=`"VividRock MECM Toolkit`">"
        $MECM_Log_Constructed   = $MECM_Log_MessagePrefix + $Item + $MECM_Log_MessageSuffix + $MECM_Log_Time + $MECM_Log_Date + $MECM_Log_Component + $MECM_Log_Context + $MECM_Log_Type + $MECM_Log_Thread + $MECM_Log_File

        try {
            Out-File -FilePath "$LogPath" -InputObject "$MECM_Log_Constructed" -Encoding utf8 -Append -Force -ErrorAction Stop
        }
        catch {
            <#Do this if a terminating exception happens#>
        }
    }
#--------------------------------------------------------------------------------------------