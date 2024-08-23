#--------------------------------------------------------------------------------------------
# Write Output Header Info to SMSTS.log
#--------------------------------------------------------------------------------------------
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - Task Sequences - Logging - CCM Logs"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:    Dustin Estes"
    Write-Host "    Company:   VividRock"
    Write-Host "    Date:      December 12, 2019"
    Write-Host "    Copyright: VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:   This script will copy the specified CCM logs from their original"
    Write-Host "               location into the local Log Repository for point-in-time analysis."
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
        $Path_LogDirectory = $Object_MECM_TSEnvironment.Value("vr_Directory_TS_Client")
            Write-Host "      - vr_Directory_TS_Client: " $Path_LogDirectory

        $DateTime_TSTimeStart = $Object_MECM_TSEnvironment.Value("vr_Meta_TimeStartUTC")

    # Paths
        $Path_CCMLogSource = "C:\Windows\CCM\Logs\"


    # Hashtables
        $Hashtable_ClientLogNames = @(
            'AlternateHandler';                # Records details when the client calls the Office click-to-run COM interface to download and install Microsoft 365 Apps for enterprise client updates. It's similar to use of WuaHandler when it calls the Windows Update Agent API to download and install Windows updates.
            'AppDiscovery';                # Records details about the discovery or detection of applications on client computers.
            'AppEnforce';                # Records details about enforcement actions (install and uninstall) taken for applications on the client.
            'AppGroupHandler';                # Records detection and enforcement information for application groups
            'AppIntentEval';                # Records details about the current and intended state of applications, their applicability, whether requirements were met, deployment types, and dependencies.
            'AssetAdvisor';                # Records the activities of Asset Intelligence inventory actions.
            'BgbHttpProxy';                # Records the activities of the notification HTTP proxy as it relays the messages of clients using HTTP to and from the notification server.
            'CAS';                # Records details when distribution points are found for referenced content.
            'CBS';                # Records servicing failures related to changes for Windows Updates or roles and features.
            'Ccm32BitLauncher';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'CcmCloud';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'CcmEval';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'CcmEvalTask';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'CcmExec';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'CcmMessaging';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'CcmNotificationAgent';                # Records the activities of the notification agent, such as client-server communication and information about tasks received and dispatched to other client agents.
            'ccmperf';                # Records activities related to the maintenance and capture of data related to client performance counters.
            'CcmRepair';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'CcmRestart';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'Ccmsdkprovider';                # Records the activities of the application management SDK.
            'ccmsetup';                # Records ccmsetup tasks for client setup, client upgrade, and client removal. Can be used to troubleshoot client installation problems.
            'CcmSqlCE';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'CCMVDIProvider';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'CertificateMaintenance';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'CIAgent';                # Records details about the process of remediation and compliance for compliance settings, software updates, and application management.
            'CIDownloader';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'CIStateStore';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'CIStore';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'CITaskManager';                # Records information about configuration item task scheduling.
            'CITaskMgr';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'ClientAuth';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'ClientIDManagerStartup';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'ClientLocation';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'ClientServicing';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'CMBITSManager';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'CmRcService';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'CoManagementHandler';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'ComplRelayAgent';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'ConfigMgrSoftwareCatalog';                # Records the activity of the Application Catalog, which includes its use of Silverlight.
            'ContentTransferManager';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'DCMAgent';                # Records high-level information about the evaluation, conflict reporting, and remediation of configuration items and applications.
            'DCMReporting';                # Records information about reporting policy platform results into state messages for configuration items.
            'DCMReports';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'DcmWmiProvider';                # Records information about reading configuration item synclets from WMI.
            'DdrProvider';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'DeltaDownload';                # Records information about the download of express updates and updates downloaded using Delivery Optimization.
            'DISM';                # Records all actions using DISM. If necessary, DISM.log will point to CBS.log for more details.
            'DmCertEnroll';                # Records details about certificate enrollment data on mobile device legacy clients.
            'DMCertResp.htm';                # Records the HTML response from the certificate server when the mobile device legacy client enroller program requests a PKI certificate.
            'DmClientSetup';                # Records client setup data for mobile device legacy clients.
            'DmClientXfer';                # Records client transfer data for mobile device legacy clients and for ActiveSync deployments.
            'DmCommonInstaller';                # Records client transfer file installation for configuring mobile device legacy client transfer files.
            'DmInstaller';                # Records whether DMInstaller correctly calls DmClientSetup, and whether DmClientSetup exits with success or failure for mobile device legacy clients.
            'DmSvc';                # Records client communication from mobile device legacy clients with a management point that is enabled for mobile devices.
            'EndpointProtectionAgent';                # Records details about the installation of the Endpoint Protection client and the application of antimalware policy to that client.
            'execmgr';                # Records details about packages and task sequences that run.
            'ExpressionSolver';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'ExternalEventAgent';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'FileBITS';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'FileSystemFile';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'FSPStateMessage';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'InternetProxy';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'InventoryAgent';                # Records activities of hardware inventory, software inventory, and heartbeat discovery actions on the client.
            'InventoryProvider';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'loadstate';                # Records details about the User State Migration Tool (USMT) and restoring user state data.
            'LocationServices';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'M365AHandler';                # Information about the Desktop Analytics settings policy
            'MaintenanceCoordinator';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'mtrmgr';                # Monitors all software metering processes.
            'OfficeAnalytics';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'PatchMyPC-ScriptRunner';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'PeerDPAgent';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'PolicyAgent';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'PolicyAgentProvider';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'PolicyEvaluator';                # Records details about the evaluation of policies on client computers, including policies from software updates.
            'PolicySdk';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'pwrmgmt';                # Records details about power management activities on the client computer, including monitoring and the enforcement of settings by the Power Management Client Agent.
            'PwrProvider';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'RebootCoordinator';                # Records details about the coordination of system restarts on client computers after software update installations.
            'ScanAgent';                # Records details about scan requests for software updates, the WSUS location, and related actions.
            'scanstate';                # Records details about the User State Migration Tool (USMT) and capturing user state data.
            'SCClient_VR@DESTES_1';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'SCClient_VR@DESTES_2';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'Scheduler';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'SCNotify_VR@DESTES_1';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'SCNotify_VR@DESTES_2';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'SCToastNotification_VR@DESTES_1';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'SCToastNotification_VR@DESTES_2';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'SdmAgent';                # Records details about the tracking of remediation and compliance. However, the software updates log file, Updateshandler.log, provides more informative details about installing the software updates that are required for compliance. This log file is shared with compliance settings.
            'SensorEndpoint';                # Records the execution of endpoint analytics policy and upload of client data to the site server.
            'SensorManagedProvider';                # Records the gathering and processing of events and information for endpoint analytics.
            'SensorWmiProvider';                # Records the activity of the WMI provider for the endpoint analytics sensor.
            'ServiceWindowManager';                # Records details about the evaluation of maintenance windows.
            'SettingsAgent';                # Enforcement of specific applications, records orchestration of application group evaluation, and details of co-management policies.
            'Setupact';                # Records details about Windows Sysprep and setup logs. For more information, see Log Files.
            'Setupapi';                # Records details about Windows Sysprep and setup logs.
            'Setuperr';                # Records details about Windows Sysprep and setup logs.
            'setuppolicyevaluator';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'smpisapi';                # Records details about the client state capture and restore actions, and threshold information.
            'SmsClientMethodProvider';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'smscliui';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'Smsts';                # Records task sequence activities.
            'SmsWusHandler';                # Records details about the scan process for the Inventory Tool for Microsoft Updates.
            'SoftwareCatalogUpdateEndpoint';                # Records activities for managing the URL for the Application Catalog shown in Software Center.
            'SoftwareCenterSystemTasks';                # Records activities related to Software Center prerequisite component validation.
            'SrcUpdateMgr';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'StateMessage';                # Records details about software update state messages that are created and sent to the management point.
            'StatusAgent';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'SWMTRReportGen';                # Generates a use data report that is collected by the metering agent. This data is logged in Mtrmgr.log.
            'SystemPerf';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'SystemTempLockdown';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'TSAgent';                # Records the outcome of task sequence dependencies before starting a task sequence.
            'TSDTHandler';                # For the task sequence deployment type. It logs the process from app enforcement (install or uninstall) to the launch of the task sequence. Use it with AppEnforce.log and smsts.log.
            'UpdatesDeployment';                # Records details about deployments on the client, including software update activation, evaluation, and enforcement. Verbose logging shows additional information about the interaction with the client user interface.
            'UpdatesHandler';                # Records details about software update compliance scanning and about the download and installation of software updates on the client.
            'UpdatesStore';                # Records details about compliance status for the software updates that were assessed during the compliance scan cycle.
            'UpdateTrustedSites';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'UserAffinity';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'UserAffinityProvider';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'VirtualApp';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'wedmtrace';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'WindowsAnalytics';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'WindowsUpdate';                # Records details about when the Windows Update Agent connects to the WSUS server and retrieves the software updates for compliance assessment, and whether there are updates to the agent components.
            'wpeinit';                # Unknown, log located on client device but not defined within Microsoft Docs Log Reference
            'WUAHandler';                # Records details about the Windows Update Agent on the client when it searches for software updates.
        )

    Write-Host "      - Time Start: " $DateTime_TSTimeStart
    Write-Host "      - Source: " $Path_CCMLogSource
    Write-Host "      - Destination: " $Path_LogDirectory
    Write-Host "      - Logs Included: " $Hashtable_ClientLogNames


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
        $Object_ExistingLogs = Get-ChildItem -Path $Path_CCMLogSource -Recurse

    # Loop Through Existing Logs and Find Matches to Hashtable
        ForEach($LogName in $Hashtable_ClientLogNames){
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
                    $ConcatLogPath = $Path_CCMLogSource + $LogFile
                    Write-Host "      - Attempting to copy log file: " $ConcatLogPath

                    Try{
                        Copy-Item -Path $ConcatLogPath -Destination $Path_LogDirectory -Force -Recurse
                        Write-Host "        - Success: Log file copied"
                        Write-Host ""
                    }
                    Catch{
                        Write-Host "        - Error: Could not copy the log file"
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
