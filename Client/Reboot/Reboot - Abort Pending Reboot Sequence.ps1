<# -----------------------------------------------------------------------------------------------------------------------------
        MECM - Pending Reboot - Abort Sequence
--------------------------------------------------------------------------------------------------------------------------------

        Version: 1.0.1

        Purpose:
            Used to reset the reboot countdown on a device that has a pending reboot related to MECM actions such as:
                - Application Deployment
                - Software Updates
                - Task Sequences
                - Etc.

        How to Use:
            Either run from PowerShell manually or add to MECM as an application and use the deployment logic there.

        To Do:
            - (Optional) Copy logs to network share/central log repository (for auditing/troubleshooting)
            - Add the following to the code for getting basic log info back real quick (simple query)
                Get-EventLog System -Newest 10000 | `
                Where EventId -in 41,1074,1076,6005,6006,6008,6009,6013 | `
                Format-Table TimeGenerated,EventId,UserName,Message -AutoSize -wrap

                Event ID: 41 - The system has rebooted without cleanly shutting down first. This error could be caused if the system stopped responding, crashed, or lost power unexpectedly.
                Event ID: 6005 - The Event log service was started.
                Event ID: 6006 - The Event log service was stopped
                Event ID: 6008 - The previous system shutdown at %1 on %2 was unexpected.
                Event ID: 6009 - Microsoft (R) Windows (R) %1 %2 %3 %4.
                Event ID: 6013 - The system uptime is %5 seconds.
                Event ID: 1074 - The process %1 has initiated the %5 of computer %2 on behalf of user %7 for the following reason. %3
                Event ID: 1076 - The reason supplied by user %6 for the last unexpected shutdown of this computer is. %1

        Operation:
            1. Creates Logging directory to store log files and exports
            2. Exports all available Windows Event logs to local folder
            3. Copies all MECM Agent logs to local folder
            4. Copies all MECM Agent Setup logs to local folder
            5. Gets Windows pending reboot Registry data
                - Pending File Rename Operations (HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager)
                - Component Based Servicing (HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing)
                - Windows Auto Update (HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update)
            6. Gets MECM pending reboot Registry data
                - Reboot Management (HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData)
            7. Remove pending reboot by clearing the registry keys that MECM uses to schedule a reboot
            8. Register Event Subscription to the PowerShell.Exiting event so that the MECM agent is restarted after PowerShell exits
            9. Exit event calls the script "MECM - Pending Reboot Removal - Exiting Script - v1.0.0.ps1"

        Exit Codes:
            0           The script exited successfully and will enqueue a subscription to the EngineEvent "Exiting" to restart the CcmExec service
            2001        The MECM Client SDK WMI method output indicated there was no reboot pending operation on the device.


----------------------------------------------------------------------------------------------------------------------------- #>


<# ---------------------------------------------------------------------------------------------
    Logging
------------------------------------------------------------------------------------------------
    Functions for logging output
------------------------------------------------------------------------------------------------ #>
#Region

    # Create log file if it doesn't exist
    function New-MECM_LogFile {
        [cmdletbinding()]
        Param (
            [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
            [string]
            $LogPath = "C:\ProgramData\VividRock\Scripts\Logging\",
            [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
            [string]
            $LogName = "VividRock_MECM_PendingRebootRemediation.log",
            [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 2)]
            [string]
            $Timestamp = (Get-Date -Format "yyyy-MM-dd_HHmmss_K")
        )

        begin {

        }

        process {
            # Create parent folder
                New-Item -Path $LogPath -ItemType Directory -Force | Out-Null

            # Create log file
                New-Item -Path $LogPath -Name $LogName -Force | Out-Null
        }

        end {

        }
    }

    # Output to log file
    function Write-MECM_LogOutput {
        [cmdletbinding()]
        Param (
            [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
            [string]
            $Message,
            [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
            [bool]
            $Timestamp = $false,
            [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 2)]
            [switch]
            $OutputConsole = $false
        )

        begin {
            # Get date and time in format
                $DateTime = (Get-Date -Format "yyyy-MM-dd_HHmmss_K")

            # Check log file exists
                if (!(Test-Path ($LogPath + $LogName))) {
                    New-MECM_LogFile -LogPath $LogPath -LogName $LogName -TimeStamp $Timestamp
                }

            # Formatting
                [string]$Delimeter = "  _  "
        }

        process {
            # Write the message to the file
                if ($Timestamp -eq $true) {
                    Out-File -FilePath $LogFullPath -InputObject "$DateTime $Delimeter $Message" -Append
                }
                elseif ($Timestamp -eq $false) {
                    Out-File -FilePath $LogFullPath -InputObject $Message -Append
                }

            # Write the message to the console if enabled
                if ($OutputConsole -eq $true) {
                    Write-Output -InputObject $Message
                }

        }

        end {

        }
    }

#EndRegion Logging


<# ---------------------------------------------------------------------------------------------
    Notification
------------------------------------------------------------------------------------------------
    Functions for creating notifications for the user
------------------------------------------------------------------------------------------------ #>
#Region

    # Send a toast notification to the user
    function New-ToastNotification {
        [cmdletbinding()]
        Param (
            [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
            [string]
            $Title,
            [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
            [string]
            $Message,
            [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 2)]
            [string]
            $ExpirationTime_Hours = 6
        )

        begin {

        }

        process {
            # Construct the Toast notification using XML and DOM constructors
                [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
                $Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)

                $RawXml = [xml] $Template.GetXml()
                ($RawXml.toast.visual.binding.text | Where-Object {$_.id -eq "1"}).AppendChild($RawXml.CreateTextNode($Title)) > $null
                ($RawXml.toast.visual.binding.text | Where-Object {$_.id -eq "2"}).AppendChild($RawXml.CreateTextNode($Message)) > $null

                $SerializedXml = New-Object Windows.Data.Xml.Dom.XmlDocument
                $SerializedXml.LoadXml($RawXml.OuterXml)

                $Toast = [Windows.UI.Notifications.ToastNotification]::new($SerializedXml)
                $Toast.Tag = "PowerShell"
                $Toast.Group = "PowerShell"
                $Toast.ExpirationTime = [DateTimeOffset]::Now.AddHours($ExpirationTime_Hours)

                $Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("PowerShell")
                $Notifier.Show($Toast);
        }

        end {

        }
    }

#EndRegion Notification


# Declare variables
    $script:LogPath = "C:\ProgramData\VividRock\Scripts\PendingReboot_AbortSequence\"
    $script:LogName = "VividRock_MECM_PendingReboot_AbortSequence.log"
    $script:LogFullPath = $LogPath + $LogName

# Create custom object for summary information
    $AbortSequence_Summary = [PSCustomObject]@{
        ComputerName = "$($env:COMPUTERNAME)"
        TimeStarted = "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss K")"
        PendingReboot = ""
        WindowsEventLogsExport = ""
        MECMAgentLogsExport = ""
        MECMAgentSetupLogsExport = ""
        WindowsPendingReboot = ""
        MECMPendingReboot = ""
        ScheduledRebootRemoved = ""
        WindowsShutdownAborted = ""
        MECMAgentRestart = ""
        ToastNotificationSent = ""
        TimeCompleted = ""
    }

# Write output header info
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" -OutputConsole
    Write-MECM_LogOutput -Message "  MECM - Pending Reboot - Abort Sequence - v1.0.1" -OutputConsole
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" -OutputConsole
    Write-MECM_LogOutput -Message "    Purpose:  Export log files and troubleshooting data before removing a pending reboot on the device." -OutputConsole
    Write-MECM_LogOutput -Message "    Executed:  $(Get-Date -Format "yyyy-MM-dd  HH:mm:ss")" -OutputConsole
    Write-MECM_LogOutput -Message "    Unix Epoch:  $([DateTimeOffset]::Now.ToUnixTimeSeconds())" -OutputConsole
    Write-MECM_LogOutput -Message "    Logging:  Enabled" -OutputConsole
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" -OutputConsole
    Write-MECM_LogOutput -Message " "


# Write section begin
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Begin Operation: Check if Reboot is Pending"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Started:  $(Get-Date -Format "yyyy-MM-dd  HH:mm:ss")"
    Write-MECM_LogOutput -Message "    Unix Epoch:  $([DateTimeOffset]::Now.ToUnixTimeSeconds())"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

# Declare Variables
    Write-MECM_LogOutput -Message "    Get MECM RebootPending"

    # Detect pending reboot:
        $Result = Invoke-CimMethod -Namespace root/ccm/ClientSDK -ClassName CCM_ClientUtilities -MethodName DetermineIfRebootPending

        if ($Result.RebootPending -eq $false) {
            # Add information to summary
                $AbortSequence_Summary.'PendingReboot' = "False"
                $AbortSequence_Summary.'WindowsEventLogsExport' = "Skipped"
                $AbortSequence_Summary.'MECMAgentLogsExport' = "Skipped"
                $AbortSequence_Summary.'MECMAgentSetupLogsExport' = "Skipped"
                $AbortSequence_Summary.'WindowsPendingReboot' = "Skipped"
                $AbortSequence_Summary.'MECMPendingReboot' = "Skipped"
                $AbortSequence_Summary.'ScheduledRebootRemoved' = "Skipped"
                $AbortSequence_Summary.'WindowsShutdownAborted' = "Skipped"
                $AbortSequence_Summary.'MECMAgentRestart' = "Skipped"
                $AbortSequence_Summary.'ToastNotificationSent' = "Skipped"
                $AbortSequence_Summary.'TimeCompleted' = "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss K")"

            # Write summary information to console
                Write-Output -InputObject $AbortSequence_Summary

            Write-MECM_LogOutput -Message "            - Reboot Pending: $($Result.RebootPending)"
            Write-MECM_LogOutput -Message "            - Script Execution: Exit"
            Write-MECM_LogOutput -Message "            - Exit Code: 2001"
            Exit 2001
        }
        else {
            # Do nothing and continue script operation
                Write-MECM_LogOutput -Message "            - Reboot Pending: $($Result.RebootPending)"
                Write-MECM_LogOutput -Message "            - Script Execution: Continue"

            # Add information to summary
                $AbortSequence_Summary.'PendingReboot' = "True"

        }

    Write-MECM_LogOutput -Message "    End Get MECM RebootPending"

# Write section end
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    End Operation: Check if Reboot is Pending"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Completed:  $(Get-Date -Format "yyyy-MM-dd  HH:mm:ss")"
    Write-MECM_LogOutput -Message "    Unix Epoch:  $([DateTimeOffset]::Now.ToUnixTimeSeconds())"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message " "




# Write section begin
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Begin Operation: Export Windows Event Logs"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Started:  $(Get-Date -Format "yyyy-MM-dd  HH:mm:ss")"
    Write-MECM_LogOutput -Message "    Unix Epoch:  $([DateTimeOffset]::Now.ToUnixTimeSeconds())"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

    # Declare Variables
        Write-MECM_LogOutput -Message "    Set Data"

        $EventLog_Logs = Get-WmiObject -Class Win32_NTEventlogFile
        $EventLog_LogNames = $EventLog_Logs.LogFileName -join ', '
            Write-MECM_LogOutput -Message "            - List of Log Names:  $EventLog_LogNames"
        $EventLog_ExportFolder = $LogPath + "Logs\Windows\"
            Write-MECM_LogOutput -Message "            - Export Folder:  $EventLog_ExportFolder"

        Write-MECM_LogOutput -Message "    End Set Data"

    # Create export folder
        Write-MECM_LogOutput -Message " "
        Write-MECM_LogOutput -Message "    Create Export Folder"

        If(Test-Path $EventLog_ExportFolder){
            Write-MECM_LogOutput -Message "            - Skipped:  Export folder already exists"
        }
        Else{
            try {
                New-Item -Path $EventLog_ExportFolder -ItemType Directory -Force | Out-Null
                Write-MECM_LogOutput -Message "            - Success:  Export folder created"
                Write-MECM_LogOutput -Message " "
            }
            catch {
                Write-MECM_LogOutput -Message "            - Error:  Could not create folder"
                Write-MECM_LogOutput -Message "            - Error Exception:  $Error[0].Exception"
                Write-MECM_LogOutput -Message " "
            }
        }


        Write-MECM_LogOutput -Message "    End Export Folder"

    # Export log files
        Write-MECM_LogOutput -Message " "

        # Iterate through each log file in the array
            Write-MECM_LogOutput -Message "    Export Logs"

            # Use for summary
                $EventLog_Status = 0

            ForEach($Log in $EventLog_Logs){
                try {
                    Write-MECM_LogOutput -Message "            - Log Name: $($Log.LogfileName)"
                    Write-MECM_LogOutput -Message "            - Number of Log Records: $($Log.NumberOfRecords)"

                    $EventLog_ExportPath = $EventLog_ExportFolder + $Log.LogFileName + ".evtx"
                    Write-MECM_LogOutput -Message "            - Export Path: $EventLog_ExportPath"

                    $Return = $Log.BackupEventlog($EventLog_ExportPath)
                    Write-MECM_LogOutput -Message "            - Success: Log exported"
                    Write-MECM_LogOutput -Message " "
                }
                catch {
                    # Use for summary
                        $EventLog_Status = $EventLog_Status + 1
                    Write-MECM_LogOutput -Message "            - Error: Could not export log"
                    Write-MECM_LogOutput -Message "            - Error Exception: $($Error[0].Exception)"
                    Write-MECM_LogOutput -Message " "
                }
            }

            # Add information to summary
                if ($EventLog_Status -ge "1") {
                    $AbortSequence_Summary.'WindowsEventLogsExport' = "$($EventLog_Status) Errors"
                }
                else {
                    $AbortSequence_Summary.'WindowsEventLogsExport' = "Success"
                }


            Write-MECM_LogOutput -Message "    End Export Logs"

# Write section end
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    End Operation: Export Windows Event Logs"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Completed:  $(Get-Date -Format "yyyy-MM-dd  HH:mm:ss")"
    Write-MECM_LogOutput -Message "    Unix Epoch:  $([DateTimeOffset]::Now.ToUnixTimeSeconds())"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message " "




# Write section begin
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Begin Operation: Export MECM Agent Logs"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Started:  $(Get-Date -Format "yyyy-MM-dd  HH:mm:ss")"
    Write-MECM_LogOutput -Message "    Unix Epoch:  $([DateTimeOffset]::Now.ToUnixTimeSeconds())"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

# Declare Variables
    Write-MECM_LogOutput -Message "    Set Data"

    $MECMAgent_SourceFolder = "C:\Windows\CCM\Logs\"
        Write-MECM_LogOutput -Message "            - Source Folder:  $MECMAgent_SourceFolder"
    $MECMAgent_LogNames = "All"
        Write-MECM_LogOutput -Message "            - List of Log Names:  $MECMAgent_LogNames"
    $MECMAgent_ExportFolder = $LogPath + "Logs\MECM Agent\"
        Write-MECM_LogOutput -Message "            - Export Folder:  $MECMAgent_ExportFolder"
    $MECMAgent_LogFiles = Get-ChildItem -Path $MECMAgent_SourceFolder -Recurse

    Write-MECM_LogOutput -Message "    End Set Data"

# Create export folder
    Write-MECM_LogOutput -Message " "
    Write-MECM_LogOutput -Message "    Create Export Folder"

    If(Test-Path $MECMAgent_ExportFolder){
        Write-MECM_LogOutput -Message "            - Skipped:  Export folder already exists"
    }
    Else{
        try {
            New-Item -Path $MECMAgent_ExportFolder -ItemType Directory -Force | Out-Null
            Write-MECM_LogOutput -Message "            - Success:  Export folder created"
        }
        catch {
            Write-MECM_LogOutput -Message "            - Error:  Could not create folder"
            Write-MECM_LogOutput -Message "            - Error Exception:  $Error[0].Exception"
            Write-MECM_LogOutput -Message " "
        }
    }

    Write-MECM_LogOutput -Message "    End Export Folder"

# Export log files
    Write-MECM_LogOutput -Message " "

    # Iterate through each log file in the array
        Write-MECM_LogOutput -Message "    Export Logs"

    # Use for summary
        $MECMAgentLog_Status = 0

        foreach ($Log in $MECMAgent_LogFiles) {
            Try{
                Write-MECM_LogOutput -Message "            - Log Name: $($Log.Name)"
                $MECMAgent_ExportPath = $MECMAgent_ExportFolder + $Log.Name
                Write-MECM_LogOutput -Message "            - Export Path: $MECMAgent_ExportPath"

                Copy-Item -Path $Log.PSPath -Destination $MECMAgent_ExportFolder -Force -Recurse
                Write-MECM_LogOutput -Message "            - Success: Log exported"
                Write-MECM_LogOutput -Message " "

            }
            Catch{
                # Use for summary
                    $MECMAgentLog_Status = $MECMAgentLog_Status + 1

                Write-MECM_LogOutput -Message "            - Error: Could not export log"
                Write-MECM_LogOutput -Message "            - Error Exception: $($Error[0].Exception)"
                Write-MECM_LogOutput -Message " "
            }
        }

    # Add information to summary
        if ($MECMAgentLog_Status -ge "1") {
            $AbortSequence_Summary.'MECMAgentLogsExport' = "$($MECMAgentLog_Status) Errors"
        }
        else {
            $AbortSequence_Summary.'MECMAgentLogsExport' = "Success"
        }

    Write-MECM_LogOutput -Message "    End Export Logs"



# Write section end
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    End Operation: Export MECM Agent Logs"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Completed:  $(Get-Date -Format "yyyy-MM-dd  HH:mm:ss")"
    Write-MECM_LogOutput -Message "    Unix Epoch:  $([DateTimeOffset]::Now.ToUnixTimeSeconds())"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message " "




# Write section begin
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Begin Operation: Export MECM Agent Setup Logs"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Started:  $(Get-Date -Format "yyyy-MM-dd  HH:mm:ss")"
    Write-MECM_LogOutput -Message "    Unix Epoch:  $([DateTimeOffset]::Now.ToUnixTimeSeconds())"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

# Declare Variables
    Write-MECM_LogOutput -Message "    Set Data"

    $MECMAgentSetup_SourceFolder = "C:\Windows\ccmsetup\Logs"
        Write-MECM_LogOutput -Message "            - Source Folder:  $MECMAgentSetup_SourceFolder"
    $MECMAgentSetup_LogNames = "All"
        Write-MECM_LogOutput -Message "            - List of Log Names:  $MECMAgentSetup_LogNames"
    $MECMAgentSetup_ExportFolder = $LogPath + "Logs\MECM Agent Setup\"
        Write-MECM_LogOutput -Message "            - Export Folder:  $MECMAgentSetup_ExportFolder"
    $MECMAgentSetup_LogFiles = Get-ChildItem -Path $MECMAgentSetup_SourceFolder -Recurse

    Write-MECM_LogOutput -Message "    End Set Data"

# Create export folder
    Write-MECM_LogOutput -Message " "
    Write-MECM_LogOutput -Message "    Create Export Folder"

    If(Test-Path $MECMAgentSetup_ExportFolder){
        Write-MECM_LogOutput -Message "            - Skipped:  Export folder already exists"
    }
    Else{
        try {
            New-Item -Path $MECMAgentSetup_ExportFolder -ItemType Directory -Force | Out-Null
            Write-MECM_LogOutput -Message "            - Success:  Export folder created"
        }
        catch {
            Write-MECM_LogOutput -Message "            - Error:  Could not create folder"
            Write-MECM_LogOutput -Message "            - Error Exception:  $Error[0].Exception"
            Write-MECM_LogOutput -Message " "
        }
    }

    Write-MECM_LogOutput -Message "    End Export Folder"

# Export log files
    Write-MECM_LogOutput -Message " "

    # Iterate through each log file in the array
        Write-MECM_LogOutput -Message "    Export Logs"

    # Use for summary
        $MECMAgentSetupLog_Status = 0

        foreach ($Log in $MECMAgentSetup_LogFiles) {
            Try{
                Write-MECM_LogOutput -Message "            - Log Name: $($Log.Name)"
                $MECMAgentSetup_ExportPath = $MECMAgentSetup_ExportFolder + $Log.Name
                Write-MECM_LogOutput -Message "            - Export Path: $MECMAgentSetup_ExportPath"

                Copy-Item -Path $Log.PSPath -Destination $MECMAgentSetup_ExportFolder -Force -Recurse
                Write-MECM_LogOutput -Message "            - Success: Log exported"
                Write-MECM_LogOutput -Message " "

            }
            Catch{
                # Use for summary
                    $MECMAgentSetupLog_Status = $MECMAgentSetupLog_Status + 1

                Write-MECM_LogOutput -Message "            - Error: Could not export log"
                Write-MECM_LogOutput -Message "            - Error Exception: $($Error[0].Exception)"
                Write-MECM_LogOutput -Message " "
            }
        }

    # Add information to summary
        if ($MECMAgentSetupLog_Status -ge "1") {
            $AbortSequence_Summary.'MECMAgentSetupLogsExport' = "$($MECMAgentSetupLog_Status) Errors"
        }
        else {
            $AbortSequence_Summary.'MECMAgentSetupLogsExport' = "Success"
        }

        Write-MECM_LogOutput -Message "    End Export Logs"


# Write section end
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    End Operation: Export MECM Agent Setup Logs"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Completed:  $(Get-Date -Format "yyyy-MM-dd  HH:mm:ss")"
    Write-MECM_LogOutput -Message "    Unix Epoch:  $([DateTimeOffset]::Now.ToUnixTimeSeconds())"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message " "




# Write section begin
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Begin Operation: Get Windows Pending Reboot Registry Data"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Started:  $(Get-Date -Format "yyyy-MM-dd  HH:mm:ss")"
    Write-MECM_LogOutput -Message "    Unix Epoch:  $([DateTimeOffset]::Now.ToUnixTimeSeconds())"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

    # Declare Variables
    Write-MECM_LogOutput -Message "    Set Data"

        $Registry_Keys = @{
            PendingFileRenameOperations = @{
                KeyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager"
                PropertyName = "PendingFileRenameOperations"
            }
            WindowsUpdate_AutoUpdate = @{
                KeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update"
                PropertyName = "RebootRequired"
            }
            ComponentBasedServicing = @{
                KeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing"
                PropertyName = "RebootPending"
            }
        }
        Write-MECM_LogOutput -Message "            - Hashtable Created:  Data set in nested hashtables"

    Write-MECM_LogOutput -Message "    End Set Data"


    # Get registry keys and values
        Write-MECM_LogOutput -Message " "
        Write-MECM_LogOutput -Message "    Get Registry Properties"

    # Use for summary
        $WindowsPendingReboot_Status = ""

    # Iterate through nested hashtables
        foreach($HashTable in $Registry_Keys.Values) {
            # Check if key exists
                if (Test-Path -Path $($HashTable.KeyPath)) {
                    try {
                        Write-MECM_LogOutput -Message "            - Key Path:  $($HashTable.KeyPath)"
                        Write-MECM_LogOutput -Message "            - Key Exists: True"
                        Write-MECM_LogOutput -Message "            - Property Name:  $($HashTable.PropertyName)"

                        # Check if property exists
                            $PropertyValue = Get-ItemProperty -Path $HashTable.KeyPath -Name $HashTable.PropertyName -ErrorAction SilentlyContinue

                            if ($PropertyValue -eq $null) {
                                Write-MECM_LogOutput -Message "            - Property Exists: False"
                            }
                            elseif ($PropertyValue -ne $null) {
                                Write-MECM_LogOutput -Message "            - Property Exists: True"
                                Write-MECM_LogOutput -Message "            - Property Value: $($PropertyValue.$($Hashtable.PropertyName))"

                                # Use for summary
                                    $WindowsPendingReboot_Status = "$($HashTable.PropertyName)"
                            }

                        Write-MECM_LogOutput -Message " "
                    }
                    catch {
                        Write-MECM_LogOutput -Message "            - Error:  Could not get registry property value"
                        Write-MECM_LogOutput -Message "            - Error Exception: $($Error[0].Exception)"
                        Write-MECM_LogOutput -Message " "
                    }
                }
                else {
                    Write-MECM_LogOutput -Message "            - Skipped:  Registry key path does not exist"
                    Write-MECM_LogOutput -Message " "
                }
        }

    # Add information to summary
        if ($WindowsPendingReboot_Status -ne "") {
            $AbortSequence_Summary.'WindowsPendingReboot' = "$($WindowsPendingReboot_Status)"
        }
        else {
            $AbortSequence_Summary.'WindowsPendingReboot' = "False"
        }

    Write-MECM_LogOutput -Message "    End Get Registry Properties"

# Write section end
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    End Operation: Get Windows Pending Reboot Registry Data"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Completed:  $(Get-Date -Format "yyyy-MM-dd  HH:mm:ss")"
    Write-MECM_LogOutput -Message "    Unix Epoch:  $([DateTimeOffset]::Now.ToUnixTimeSeconds())"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message " "




# Write section begin
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Begin Operation: Get MECM Pending Reboot Registry Data"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Started:  $(Get-Date -Format "yyyy-MM-dd  HH:mm:ss")"
    Write-MECM_LogOutput -Message "    Unix Epoch:  $([DateTimeOffset]::Now.ToUnixTimeSeconds())"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

# Declare Variables
    Write-MECM_LogOutput -Message "    Set Data"

        $MECMRegistry_RebootDataKeyPath = "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData"
        Write-MECM_LogOutput -Message "            - Key Path: $MECMRegistry_RebootDataKeyPath"

    Write-MECM_LogOutput -Message "    End Set Data"


# Get registry keys and values
    Write-MECM_LogOutput -Message " "
    Write-MECM_LogOutput -Message "    Get Registry Properties"

    # Use for summary
        $MECMPendingReboot_Status = ""

    # Iterate through list of property names
        # Check if key exists
            if (Test-Path -Path $MECMRegistry_RebootDataKeyPath) {
                try {
                    Write-MECM_LogOutput -Message "            - Key Exists: True"

                    # Get list of available properties in key path
                        $MECMRegistry_Properties = Get-Item -Path $MECMRegistry_RebootDataKeyPath
                        $MECMRegistry_PropertyNames = $MECMRegistry_Properties.Property
                        Write-MECM_LogOutput -Message "            - Properties Found: $($MECMRegistry_PropertyNames -join ", ")"
                        Write-MECM_LogOutput -Message " "

                    # Get property values
                        foreach ($Property in $MECMRegistry_PropertyNames) {
                            Write-MECM_LogOutput -Message "            - Property Name: $Property"
                            $PropertyValue = Get-ItemProperty -Path $MECMRegistry_RebootDataKeyPath -Name $Property
                            Write-MECM_LogOutput -Message "            - Property Value: $($PropertyValue.$Property)"
                            Write-MECM_LogOutput -Message " "

                            # Use for summary
                                if ($Property -eq "RebootBy") {
                                    if ($($PropertyValue.$Property) -eq "0" ) {
                                        $MECMPendingReboot_Status = "Non-mandatory (Deadline: Never)"
                                    }
                                    elseif ($($PropertyValue.$Property) -gt "0" ) {
                                        $MECMPendingReboot_Status = "Required (Deadline: $($PropertyValue.$Property))"
                                    }
                                }

                        }
                }
                catch {
                    Write-MECM_LogOutput -Message "            - Error:  Could not get registry property value"
                    Write-MECM_LogOutput -Message "            - Error Exception: $($Error[0].Exception)"
                    Write-MECM_LogOutput -Message " "
                }
            }
            else {
                Write-MECM_LogOutput -Message "            - Skipped:  Registry key path does not exist"
                Write-MECM_LogOutput -Message " "
            }

    # Add information to summary
        if ($MECMPendingReboot_Status -eq "") {
            $AbortSequence_Summary.'MECMPendingReboot' = "False"
        }
        else {
            $AbortSequence_Summary.'MECMPendingReboot' = "$($MECMPendingReboot_Status)"
        }

    Write-MECM_LogOutput -Message "    End Get Registry Properties"

# Write section end
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    End Operation: Get MECM Pending Reboot Registry Data"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Completed:  $(Get-Date -Format "yyyy-MM-dd  HH:mm:ss")"
    Write-MECM_LogOutput -Message "    Unix Epoch:  $([DateTimeOffset]::Now.ToUnixTimeSeconds())"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message " "




# Write section begin
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Begin Operation: Remove MECM Pending Reboot"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Started:  $(Get-Date -Format "yyyy-MM-dd  HH:mm:ss")"
    Write-MECM_LogOutput -Message "    Unix Epoch:  $([DateTimeOffset]::Now.ToUnixTimeSeconds())"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

# Declare Variables
    Write-MECM_LogOutput -Message "    Set Data"
        $MECM_RemovePendingReboot =@{
            Key1 = "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData"
            Key2 = "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Updates Management\Handler\UpdatesRebootStatus\*"
            Key3 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"
        }
    Write-MECM_LogOutput -Message "    End Set Data"


# Remove the pending reboot
    Write-MECM_LogOutput -Message " "
    Write-MECM_LogOutput -Message "    Remove Pending Reboot Registry Data"

    # Use for summary
        $RemoveMECMPendingReboot_Status = 0

    # Delete pending reboot Registry entries
        try {
            Write-MECM_LogOutput -Message "            - Key Path:  $($MECM_RemovePendingReboot.Key1)"
            # Check for key presence and delete
                if (Test-Path -Path $MECM_RemovePendingReboot.Key1) {
                    Write-MECM_LogOutput -Message "            - Key Exists:  True"
                    Remove-Item -path $($MECM_RemovePendingReboot.Key1) -Force -ErrorAction SilentlyContinue
                        # Use for summary
                            $RemoveMECMPendingReboot_Status = $RemoveMECMPendingReboot_Status + 1

                    Write-MECM_LogOutput -Message "            - Delete Key:  Successful"
                    Write-MECM_LogOutput -Message " "

                }
                else {
                    Write-MECM_LogOutput -Message "            - Key Exists:  False"
                    Write-MECM_LogOutput -Message " "
                }

            Write-MECM_LogOutput -Message "            - Key Path:  $($MECM_RemovePendingReboot.Key2)"
            # Check for key presence and delete
                if (Test-Path -Path $MECM_RemovePendingReboot.Key2) {
                    Write-MECM_LogOutput -Message "            - Key Exists:  True"
                    Remove-Item -path $($MECM_RemovePendingReboot.Key2) -Force -ErrorAction SilentlyContinue
                        # Use for summary
                            $RemoveMECMPendingReboot_Status = $RemoveMECMPendingReboot_Status + 1

                    Write-MECM_LogOutput -Message "            - Delete Key:  Successful"
                    Write-MECM_LogOutput -Message " "
                }
                else {
                    Write-MECM_LogOutput -Message "            - Key Exists:  False"
                    Write-MECM_LogOutput -Message " "
                }

            Write-MECM_LogOutput -Message "            - Key Path:  $($MECM_RemovePendingReboot.Key3)"
            # Check for key presence and delete
                if (Test-Path -Path $MECM_RemovePendingReboot.Key3) {
                    Write-MECM_LogOutput -Message "            - Key Exists:  True"
                    Remove-ItemProperty -path $($MECM_RemovePendingReboot.Key2) -name * -Force -ErrorAction SilentlyContinue
                        # Use for summary
                            $RemoveMECMPendingReboot_Status = $RemoveMECMPendingReboot_Status + 1

                    Write-MECM_LogOutput -Message "            - Delete Key Properties (All):  Successful"
                    Write-MECM_LogOutput -Message " "
                }
                else {
                    Write-MECM_LogOutput -Message "            - Key Exists:  False"
                    Write-MECM_LogOutput -Message " "
                }

        }
        catch {
            Write-MECM_LogOutput -Message "            - Error:  Could not delete registry keys/values"
            Write-MECM_LogOutput -Message "            - Error Exception:  $($Error[0].Exception)"
            Write-MECM_LogOutput -Message " "
        }

    # Add information to summary
        if ($RemoveMECMPendingReboot_Status -ge "1") {
            $AbortSequence_Summary.'ScheduledRebootRemoved' = "Success"
        }
        elseif ($RemoveMECMPendingReboot_Status -eq "0") {
            $AbortSequence_Summary.'ScheduledRebootRemoved' = "No Registry Keys Removed"
        }
        else {
            $AbortSequence_Summary.'ScheduledRebootRemoved' = "Unknown"
        }

        Write-MECM_LogOutput -Message "    End Remove Pending Reboot Registry Data"

    # Abort the shutdown countdown using Windows Shutdown command
        Write-MECM_LogOutput -Message " "
        Write-MECM_LogOutput -Message "    Abort Shutdown Using Windows Shutdown Command"

        # Use for summary
            $AbortWindowsShutdown_Status = ""

        # Use Shutdown command to abort current shutdown timer
        # Shutdown.exe output can't be stored in a variable for analysis so we have to check PowerShell to see if it was successful
            Write-MECM_LogOutput -Message "            - Shutdown Command: Attempting to execute command"
            shutdown.exe /a

            if ($LastExitCode -eq "1116") {
                Write-MECM_LogOutput -Message "            - Exit Code:  $($LastExitCode)"
                Write-MECM_LogOutput -Message "            - Error Exception:  $($Error[0].Exception)"

                # Use for summary
                    $AbortWindowsShutdown_Status = "Exit 1116: No shutdown was in progress"
            }
            elseif ($LastExitCode -eq "0") {
                Write-MECM_LogOutput -Message "            - Exit Code:  $($LastExitCode)"
                Write-MECM_LogOutput -Message "            - Success:  Shutdown successfully aborted"

                # Use for summary
                    $AbortWindowsShutdown_Status = "Exit 0: Shutdown successfully aborted"
            }
            else {
                Write-MECM_LogOutput -Message "            - Exit Code:  $($LastExitCode)"
                Write-MECM_LogOutput -Message "            - Unknown:  Unknown exit code received"

                # Use for summary
                    $AbortWindowsShutdown_Status = "Exit $($LastExitCode): Unknown exit code received"
            }

    # Add information to summary
        $AbortSequence_Summary.'WindowsShutdownAborted' = "$($AbortWindowsShutdown_Status)"

            Write-MECM_LogOutput -Message "    End Abort Shutdown Using Windows Shutdown Command"

# Write section end
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    End Operation: Remove MECM Pending Reboot"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Completed:  $(Get-Date -Format "yyyy-MM-dd  HH:mm:ss")"
    Write-MECM_LogOutput -Message "    Unix Epoch:  $([DateTimeOffset]::Now.ToUnixTimeSeconds())"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message " "




# Write section begin
    Write-MECM_LogOutput -Message "  "
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Begin Operation: Restart MECM Agent"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Started:  $(Get-Date -Format "yyyy-MM-dd  HH:mm:ss")"
    Write-MECM_LogOutput -Message "    Unix Epoch:  $([DateTimeOffset]::Now.ToUnixTimeSeconds())"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

# Begin Restart MECM Agent
    Write-MECM_LogOutput -Message "    Restart MECM Agent service"

# Use for summary
    $MECMAgentRestart_Status = ""

# Restarting Service
    $MECMAgent_Service = Get-Service -Name CcmExec
    Write-MECM_LogOutput -Message "            - Service Name:  $($MECMAgent_Service.Name)"
    try {
        if ($MECMAgent_Service.Status -eq "Running") {
            Write-MECM_LogOutput -Message "            - Service Status:  $((Get-Service -Name CcmExec).Status)"
            Write-MECM_LogOutput -Message "            - Action:  Restarting Service"
            Restart-Service -Name CcmExec -Force -WarningAction SilentlyContinue
                do {
                    Write-MECM_LogOutput -Message "                  - Service restarting ..."
                    Start-Sleep -Seconds 1
                } while ((Get-Service -Name CcmExec).Status -ne "Running")
            Write-MECM_LogOutput -Message "            - Service Status:  $((Get-Service -Name CcmExec).Status)"
            Write-MECM_LogOutput -Message "            - Success:  Service successfully restarted"

            # Use for summary
                $MECMAgentRestart_Status = "Success"
        }
        else {
            Write-MECM_LogOutput -Message "            - Service Status:  $($MECMAgent_Service.Status)"
            Start-Service -Name CcmExec -Force
            Write-MECM_LogOutput -Message "            - Success:  Service successfully started"

            # Use for summary
                $MECMAgentRestart_Status = "Success"
        }
    }
    catch {
        Write-Output $Error[0]
        Write-MECM_LogOutput -Message "            - Exit Code:  $($LastExitCode)"
        Write-MECM_LogOutput -Message "            - Error:  Unknown exit code received during service restart"

        # Use for summary
            $MECMAgentRestart_Status = "Error"
    }

# Add information to summary
    $AbortSequence_Summary.'MECMAgentRestart' = "$($MECMAgentRestart_Status)"

# End Restart MECM Agent
    Write-MECM_LogOutput -Message "    End Restart MECM Agent service"

# Write section end
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    End Operation: Restart MECM Agent"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Completed:  $(Get-Date -Format "yyyy-MM-dd  HH:mm:ss")"
    Write-MECM_LogOutput -Message "    Unix Epoch:  $([DateTimeOffset]::Now.ToUnixTimeSeconds())"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message " "




# Write section begin
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Begin Operation: Send Toast Notification"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Started:  $(Get-Date -Format "yyyy-MM-dd  HH:mm:ss")"
    Write-MECM_LogOutput -Message "    Unix Epoch:  $([DateTimeOffset]::Now.ToUnixTimeSeconds())"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

# Invoke function to send toast notification
    $ToastNotification_Title = "VividRock - MECM - Pending Reboot - Abort Sequence"
    $ToastNotification_Message = "Success! The pending reboot that was scheduled for this device has been successfully removed."

    Write-MECM_LogOutput -Message "    Send Notification"
    Write-MECM_LogOutput -Message "            - Title:  $($ToastNotification_Title)"
    Write-MECM_LogOutput -Message "            - Message:  $($ToastNotification_Message)"
        try {
            New-ToastNotification -Title $ToastNotification_Title -Message $ToastNotification_Message -ExpirationTime_Hours 12

            # Add information to summary
                $AbortSequence_Summary.'ToastNotificationSent' = "Success"
        }
        catch {
            # Add information to summary
                $AbortSequence_Summary.'ToastNotificationSent' = "Exit $($LastExitCode): Unknown error"
        }

    Write-MECM_LogOutput -Message "    End Send Notification"

# Write section end
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    End Operation: Send Toast Notification"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Completed:  $(Get-Date -Format "yyyy-MM-dd  HH:mm:ss")"
    Write-MECM_LogOutput -Message "    Unix Epoch:  $([DateTimeOffset]::Now.ToUnixTimeSeconds())"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message " "




# Write summary information to console
    $AbortSequence_Summary.'TimeCompleted' = "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss K")"
    Write-Output -InputObject $AbortSequence_Summary

# Write script end
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    End Script Execution"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message "    Completed:  $(Get-Date -Format "yyyy-MM-dd  HH:mm:ss")"
    Write-MECM_LogOutput -Message "    Unix Epoch:  $([DateTimeOffset]::Now.ToUnixTimeSeconds())"
    Write-MECM_LogOutput -Message "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-MECM_LogOutput -Message " "
    Write-MECM_LogOutput -Message " "
    Write-MECM_LogOutput -Message " "
    Write-MECM_LogOutput -Message " "

# Exit as successful to trigger the PowerShell.Exiting event
    Return $AbortSequence_Summary
    Exit 0