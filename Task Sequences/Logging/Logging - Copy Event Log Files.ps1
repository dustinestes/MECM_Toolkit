#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$Destination                # '%vr_Directory_TS_EventLogs%'
)

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  Task Sequence Toolkit - Log Collection - Copy Event Log Files"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       December 12, 2019"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    This script will copy the Event Log files to the central log"
    Write-Host "                repository."
    Write-Host "    Links:      None"
    Write-Host "    Directory:  %SystemRoot%\System32\winevt\Logs"
    Write-Host "    Registry:   HKLM:\SYSTEM\CurrentControlSet\Services\EventLog"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""

#EndRegion Header
#--------------------------------------------------------------------------------------------



#--------------------------------------------------------------------------------------------
# Variables
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Variables

    Write-Host "  Set Variables"

    # Parameters
        $Param_Log_Destination = $Destination

    # Names

    # Paths
        $Path_Log_Source = "$($env:SystemRoot)\System32\winevt\Logs"

    # Files

    # Hashtables

    # Arrays
        $Array_LogFileNames = @(
            # Windows Logs
                "Application.evtx"
                "Security.evtx"
                "Setup.evtx"
                "System.evtx"
                "ForwardedEvents.evtx"

            # Applications & Services
                "Arellia.evtx"
                # "CrowdStrike-Falcon Sensor-CSFalconService%4Operational.evtx"
                # "HardwareEvents.evtx"
                # "Internet Explorer.evtx"
                # "Key Management Service.evtx"
                # "Microsoft-AppV-Client%4Admin.evtx"
                # "Microsoft-AppV-Client%4Operational.evtx"
                # "Microsoft-AppV-Client%4Virtual Applications.evtx"
                # "Microsoft-Client-License-Flexible-Platform%4Admin.evtx"
                # "Microsoft-Client-Licensing-Platform%4Admin.evtx"
                # "Microsoft-User Experience Virtualization-Agent Driver%4Operational.evtx"
                # "Microsoft-User Experience Virtualization-App Agent%4Operational.evtx"
                # "Microsoft-User Experience Virtualization-IPC%4Operational.evtx"
                # "Microsoft-User Experience Virtualization-SQM Uploader%4Operational.evtx"
                "Microsoft-Windows-AAD%4Operational.evtx"
                # "Microsoft-Windows-All-User-Install-Agent%4Admin.evtx"
                # "Microsoft-Windows-AllJoyn%4Operational.evtx"
                # "Microsoft-Windows-AppHost%4Admin.evtx"
                # "Microsoft-Windows-AppID%4Operational.evtx"
                # "Microsoft-Windows-ApplicabilityEngine%4Operational.evtx"
                # "Microsoft-Windows-Application Server-Applications%4Admin.evtx"
                # "Microsoft-Windows-Application Server-Applications%4Operational.evtx"
                # "Microsoft-Windows-Application-Experience%4Program-Compatibility-Assistant.evtx"
                # "Microsoft-Windows-Application-Experience%4Program-Compatibility-Troubleshooter.evtx"
                # "Microsoft-Windows-Application-Experience%4Program-Inventory.evtx"
                # "Microsoft-Windows-Application-Experience%4Program-Telemetry.evtx"
                # "Microsoft-Windows-Application-Experience%4Steps-Recorder.evtx"
                # "Microsoft-Windows-AppLocker%4EXE and DLL.evtx"
                # "Microsoft-Windows-AppLocker%4MSI and Script.evtx"
                # "Microsoft-Windows-AppLocker%4Packaged app-Deployment.evtx"
                # "Microsoft-Windows-AppLocker%4Packaged app-Execution.evtx"
                # "Microsoft-Windows-AppModel-Runtime%4Admin.evtx"
                # "Microsoft-Windows-AppReadiness%4Admin.evtx"
                # "Microsoft-Windows-AppReadiness%4Operational.evtx"
                # "Microsoft-Windows-AppXDeployment%4Operational.evtx"
                # "Microsoft-Windows-AppXDeploymentServer%4Operational.evtx"
                # "Microsoft-Windows-AppXDeploymentServer%4Restricted.evtx"
                # "Microsoft-Windows-AppxPackaging%4Operational.evtx"
                # "Microsoft-Windows-AssignedAccess%4Admin.evtx"
                # "Microsoft-Windows-AssignedAccessBroker%4Admin.evtx"
                # "Microsoft-Windows-Audio%4CaptureMonitor.evtx"
                # "Microsoft-Windows-Audio%4Operational.evtx"
                # "Microsoft-Windows-Audio%4PlaybackManager.evtx"
                # "Microsoft-Windows-Authentication User Interface%4Operational.evtx"
                # "Microsoft-Windows-BackgroundTaskInfrastructure%4Operational.evtx"
                # "Microsoft-Windows-Backup.evtx"
                # "Microsoft-Windows-Biometrics%4Operational.evtx"
                # "Microsoft-Windows-BitLocker%4BitLocker Management.evtx"
                # "Microsoft-Windows-BitLocker-DrivePreparationTool%4Admin.evtx"
                # "Microsoft-Windows-BitLocker-DrivePreparationTool%4Operational.evtx"
                # "Microsoft-Windows-Bits-Client%4Operational.evtx"
                # "Microsoft-Windows-Bluetooth-BthLEPrepairing%4Operational.evtx"
                # "Microsoft-Windows-Bluetooth-MTPEnum%4Operational.evtx"
                # "Microsoft-Windows-BranchCache%4Operational.evtx"
                # "Microsoft-Windows-BranchCacheSMB%4Operational.evtx"
                # "Microsoft-Windows-CertificateServicesClient-Lifecycle-System%4Operational.evtx"
                # "Microsoft-Windows-CertificateServicesClient-Lifecycle-User%4Operational.evtx"
                # "Microsoft-Windows-Cleanmgr%4Diagnostic.evtx"
                # "Microsoft-Windows-CloudRestoreLauncher%4Operational.evtx"
                # "Microsoft-Windows-CloudStore%4Initialization.evtx"
                # "Microsoft-Windows-CloudStore%4Operational.evtx"
                # "Microsoft-Windows-CodeIntegrity%4Operational.evtx"
                # "Microsoft-Windows-Compat-Appraiser%4Operational.evtx"
                # "Microsoft-Windows-Containers-BindFlt%4Operational.evtx"
                # "Microsoft-Windows-Containers-Wcifs%4Operational.evtx"
                # "Microsoft-Windows-Containers-Wcnfs%4Operational.evtx"
                # "Microsoft-Windows-CoreApplication%4Operational.evtx"
                # "Microsoft-Windows-CoreSystem-SmsRouter-Events%4Operational.evtx"
                # "Microsoft-Windows-CorruptedFileRecovery-Client%4Operational.evtx"
                # "Microsoft-Windows-CorruptedFileRecovery-Server%4Operational.evtx"
                # "Microsoft-Windows-Crypto-DPAPI%4BackUpKeySvc.evtx"
                # "Microsoft-Windows-Crypto-DPAPI%4Operational.evtx"
                # "Microsoft-Windows-Crypto-NCrypt%4Operational.evtx"
                # "Microsoft-Windows-DAL-Provider%4Operational.evtx"
                # "Microsoft-Windows-DataIntegrityScan%4Admin.evtx"
                # "Microsoft-Windows-DataIntegrityScan%4CrashRecovery.evtx"
                # "Microsoft-Windows-DateTimeControlPanel%4Operational.evtx"
                # "Microsoft-Windows-Deduplication%4Diagnostic.evtx"
                # "Microsoft-Windows-Deduplication%4Operational.evtx"
                # "Microsoft-Windows-Deduplication%4Scrubbing.evtx"
                # "Microsoft-Windows-DeviceGuard%4Operational.evtx"
                # "Microsoft-Windows-DeviceManagement-Enterprise-Diagnostics-Provider%4Admin.evtx"
                # "Microsoft-Windows-DeviceManagement-Enterprise-Diagnostics-Provider%4Operational.evtx"
                # "Microsoft-Windows-Devices-Background%4Operational.evtx"
                # "Microsoft-Windows-DeviceSetupManager%4Admin.evtx"
                # "Microsoft-Windows-DeviceSetupManager%4Operational.evtx"
                # "Microsoft-Windows-DeviceSync%4Operational.evtx"
                # "Microsoft-Windows-DeviceUpdateAgent%4Operational.evtx"
                # "Microsoft-Windows-Dhcp-Client%4Admin.evtx"
                # "Microsoft-Windows-Dhcpv6-Client%4Admin.evtx"
                # "Microsoft-Windows-Diagnosis-DPS%4Operational.evtx"
                # "Microsoft-Windows-Diagnosis-PCW%4Operational.evtx"
                # "Microsoft-Windows-Diagnosis-PLA%4Operational.evtx"
                # "Microsoft-Windows-Diagnosis-Scheduled%4Operational.evtx"
                # "Microsoft-Windows-Diagnosis-Scripted%4Admin.evtx"
                # "Microsoft-Windows-Diagnosis-Scripted%4Operational.evtx"
                # "Microsoft-Windows-Diagnosis-ScriptedDiagnosticsProvider%4Operational.evtx"
                # "Microsoft-Windows-Diagnostics-Networking%4Operational.evtx"
                # "Microsoft-Windows-Diagnostics-Performance%4Operational.evtx"
                # "Microsoft-Windows-DiskDiagnostic%4Operational.evtx"
                # "Microsoft-Windows-DiskDiagnosticDataCollector%4Operational.evtx"
                # "Microsoft-Windows-DiskDiagnosticResolver%4Operational.evtx"
                # "Microsoft-Windows-DSC%4Admin.evtx"
                # "Microsoft-Windows-DSC%4Operational.evtx"
                # "Microsoft-Windows-DucUpdateAgent%4Operational.evtx"
                # "Microsoft-Windows-DxgKrnl-Admin.evtx"
                # "Microsoft-Windows-DxgKrnl-Operational.evtx"
                # "Microsoft-Windows-EapHost%4Operational.evtx"
                # "Microsoft-Windows-EapMethods-RasChap%4Operational.evtx"
                # "Microsoft-Windows-EapMethods-RasTls%4Operational.evtx"
                # "Microsoft-Windows-EapMethods-Sim%4Operational.evtx"
                # "Microsoft-Windows-EapMethods-Ttls%4Operational.evtx"
                # "Microsoft-Windows-EDP-Application-Learning%4Admin.evtx"
                # "Microsoft-Windows-EDP-Audit-Regular%4Admin.evtx"
                # "Microsoft-Windows-EDP-Audit-TCB%4Admin.evtx"
                # "Microsoft-Windows-EventCollector%4Operational.evtx"
                # "Microsoft-Windows-Fault-Tolerant-Heap%4Operational.evtx"
                # "Microsoft-Windows-FeatureConfiguration%4Operational.evtx"
                # "Microsoft-Windows-FileHistory-Core%4WHC.evtx"
                # "Microsoft-Windows-FileHistory-Engine%4BackupLog.evtx"
                # "Microsoft-Windows-FMS%4Operational.evtx"
                # "Microsoft-Windows-Folder Redirection%4Operational.evtx"
                # "Microsoft-Windows-Forwarding%4Operational.evtx"
                # "Microsoft-Windows-GenericRoaming%4Admin.evtx"
                "Microsoft-Windows-GroupPolicy%4Operational.evtx"
                # "Microsoft-Windows-HelloForBusiness%4Operational.evtx"
                # "Microsoft-Windows-Help%4Operational.evtx"
                # "Microsoft-Windows-HomeGroup Control Panel%4Operational.evtx"
                # "Microsoft-Windows-HomeGroup Listener Service%4Operational.evtx"
                # "Microsoft-Windows-HomeGroup Provider Service%4Operational.evtx"
                # "Microsoft-Windows-HotspotAuth%4Operational.evtx"
                # "Microsoft-Windows-Hyper-V-Guest-Drivers%4Admin.evtx"
                # "Microsoft-Windows-Hyper-V-Hypervisor-Admin.evtx"
                # "Microsoft-Windows-Hyper-V-Hypervisor-Operational.evtx"
                # "Microsoft-Windows-Hyper-V-VID-Admin.evtx"
                # "Microsoft-Windows-IdCtrls%4Operational.evtx"
                # "Microsoft-Windows-IKE%4Operational.evtx"
                # "Microsoft-Windows-International-RegionalOptionsControlPanel%4Operational.evtx"
                # "Microsoft-Windows-Iphlpsvc%4Operational.evtx"
                # "Microsoft-Windows-IPxlatCfg%4Operational.evtx"
                # "Microsoft-Windows-KdsSvc%4Operational.evtx"
                # "Microsoft-Windows-Kernel-ApphelpCache%4Operational.evtx"
                # "Microsoft-Windows-Kernel-Boot%4Operational.evtx"
                # "Microsoft-Windows-Kernel-EventTracing%4Admin.evtx"
                # "Microsoft-Windows-Kernel-IO%4Operational.evtx"
                # "Microsoft-Windows-Kernel-LiveDump%4Operational.evtx"
                # "Microsoft-Windows-Kernel-PnP%4Configuration.evtx"
                # "Microsoft-Windows-Kernel-PnP%4Driver Watchdog.evtx"
                # "Microsoft-Windows-Kernel-Power%4Thermal-Operational.evtx"
                # "Microsoft-Windows-Kernel-ShimEngine%4Operational.evtx"
                # "Microsoft-Windows-Kernel-StoreMgr%4Operational.evtx"
                # "Microsoft-Windows-Kernel-WDI%4Operational.evtx"
                # "Microsoft-Windows-Kernel-WHEA%4Errors.evtx"
                # "Microsoft-Windows-Kernel-WHEA%4Operational.evtx"
                # "Microsoft-Windows-KeyboardFilter%4Admin.evtx"
                # "Microsoft-Windows-Known Folders API Service.evtx"
                # "Microsoft-Windows-LanguagePackSetup%4Operational.evtx"
                "Microsoft-Windows-LAPS%4Operational.evtx"
                # "Microsoft-Windows-LiveId%4Operational.evtx"
                "Microsoft-Windows-MBAM%4Admin.evtx"
                "Microsoft-Windows-MBAM%4Analytic.etl"
                "Microsoft-Windows-MBAM%4Debug.etl"
                "Microsoft-Windows-MBAM%4Operational.evtx"
                # "Microsoft-Windows-MemoryDiagnostics-Results%4Debug.evtx"
                # "Microsoft-Windows-Mobile-Broadband-Experience-Parser-Task%4Operational.evtx"
                # "Microsoft-Windows-ModernDeployment-Diagnostics-Provider%4Admin.evtx"
                # "Microsoft-Windows-ModernDeployment-Diagnostics-Provider%4Autopilot.evtx"
                # "Microsoft-Windows-ModernDeployment-Diagnostics-Provider%4Diagnostics.evtx"
                # "Microsoft-Windows-ModernDeployment-Diagnostics-Provider%4ManagementService.evtx"
                # "Microsoft-Windows-Mprddm%4Operational.evtx"
                # "Microsoft-Windows-MUI%4Admin.evtx"
                # "Microsoft-Windows-MUI%4Operational.evtx"
                # "Microsoft-Windows-NcdAutoSetup%4Operational.evtx"
                # "Microsoft-Windows-NCSI%4Operational.evtx"
                # "Microsoft-Windows-NdisImPlatform%4Operational.evtx"
                # "Microsoft-Windows-NetworkLocationWizard%4Operational.evtx"
                # "Microsoft-Windows-NetworkProfile%4Operational.evtx"
                # "Microsoft-Windows-NetworkProvider%4Operational.evtx"
                # "Microsoft-Windows-NetworkProvisioning%4Operational.evtx"
                # "Microsoft-Windows-NlaSvc%4Operational.evtx"
                # "Microsoft-Windows-Ntfs%4Operational.evtx"
                # "Microsoft-Windows-Ntfs%4WHC.evtx"
                # "Microsoft-Windows-NTLM%4Operational.evtx"
                # "Microsoft-Windows-OcpUpdateAgent%4Operational.evtx"
                # "Microsoft-Windows-OfflineFiles%4Operational.evtx"
                # "Microsoft-Windows-OneBackup%4Debug.evtx"
                # "Microsoft-Windows-OOBE-Machine-DUI%4Operational.evtx"
                # "Microsoft-Windows-PackageStateRoaming%4Operational.evtx"
                # "Microsoft-Windows-ParentalControls%4Operational.evtx"
                # "Microsoft-Windows-Partition%4Diagnostic.evtx"
                # "Microsoft-Windows-PerceptionRuntime%4Operational.evtx"
                # "Microsoft-Windows-PerceptionSensorDataService%4Operational.evtx"
                # "Microsoft-Windows-PersistentMemory-Nvdimm%4Operational.evtx"
                # "Microsoft-Windows-PersistentMemory-PmemDisk%4Operational.evtx"
                # "Microsoft-Windows-PersistentMemory-ScmBus%4Certification.evtx"
                # "Microsoft-Windows-PersistentMemory-ScmBus%4Operational.evtx"
                # "Microsoft-Windows-Policy%4Operational.evtx"
                # "Microsoft-Windows-PowerShell%4Admin.evtx"
                # "Microsoft-Windows-PowerShell%4Operational.evtx"
                # "Microsoft-Windows-PowerShell-DesiredStateConfiguration-FileDownloadManager%4Operational.evtx"
                # "Microsoft-Windows-PrintBRM%4Admin.evtx"
                # "Microsoft-Windows-PrintService%4Admin.evtx"
                # "Microsoft-Windows-Privacy-Auditing%4Operational.evtx"
                # "Microsoft-Windows-Program-Compatibility-Assistant%4CompatAfterUpgrade.evtx"
                # "Microsoft-Windows-Provisioning-Diagnostics-Provider%4Admin.evtx"
                # "Microsoft-Windows-Provisioning-Diagnostics-Provider%4AutoPilot.evtx"
                # "Microsoft-Windows-Provisioning-Diagnostics-Provider%4ManagementService.evtx"
                # "Microsoft-Windows-PushNotification-Platform%4Admin.evtx"
                # "Microsoft-Windows-PushNotification-Platform%4Operational.evtx"
                # "Microsoft-Windows-ReadyBoost%4Operational.evtx"
                # "Microsoft-Windows-ReadyBoostDriver%4Operational.evtx"
                # "Microsoft-Windows-ReFS%4Operational.evtx"
                # "Microsoft-Windows-Regsvr32%4Operational.evtx"
                # "Microsoft-Windows-RemoteApp and Desktop Connections%4Admin.evtx"
                # "Microsoft-Windows-RemoteApp and Desktop Connections%4Operational.evtx"
                # "Microsoft-Windows-RemoteAssistance%4Admin.evtx"
                # "Microsoft-Windows-RemoteAssistance%4Operational.evtx"
                # "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Admin.evtx"
                # "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx"
                # "Microsoft-Windows-RemoteDesktopServices-RemoteFX-Synth3dvsc%4Admin.evtx"
                # "Microsoft-Windows-RemoteDesktopServices-SessionServices%4Operational.evtx"
                # "Microsoft-Windows-Resource-Exhaustion-Detector%4Operational.evtx"
                # "Microsoft-Windows-Resource-Exhaustion-Resolver%4Operational.evtx"
                # "Microsoft-Windows-RestartManager%4Operational.evtx"
                # "Microsoft-Windows-RetailDemo%4Admin.evtx"
                # "Microsoft-Windows-RetailDemo%4Operational.evtx"
                # "Microsoft-Windows-SearchUI%4Operational.evtx"
                # "Microsoft-Windows-Security-Adminless%4Operational.evtx"
                # "Microsoft-Windows-Security-Audit-Configuration-Client%4Operational.evtx"
                # "Microsoft-Windows-Security-EnterpriseData-FileRevocationManager%4Operational.evtx"
                # "Microsoft-Windows-Security-LessPrivilegedAppContainer%4Operational.evtx"
                # "Microsoft-Windows-Security-Mitigations%4KernelMode.evtx"
                # "Microsoft-Windows-Security-Mitigations%4UserMode.evtx"
                # "Microsoft-Windows-Security-Netlogon%4Operational.evtx"
                # "Microsoft-Windows-Security-SPP-UX-GenuineCenter-Logging%4Operational.evtx"
                # "Microsoft-Windows-Security-SPP-UX-Notifications%4ActionCenter.evtx"
                # "Microsoft-Windows-Security-UserConsentVerifier%4Audit.evtx"
                # "Microsoft-Windows-SecurityMitigationsBroker%4Operational.evtx"
                # "Microsoft-Windows-SENSE%4Operational.evtx"
                # "Microsoft-Windows-SenseIR%4Operational.evtx"
                # "Microsoft-Windows-SettingSync%4Debug.evtx"
                # "Microsoft-Windows-SettingSync%4Operational.evtx"
                # "Microsoft-Windows-SettingSync-Azure%4Debug.evtx"
                # "Microsoft-Windows-SettingSync-Azure%4Operational.evtx"
                # "Microsoft-Windows-SettingSync-OneDrive%4Debug.evtx"
                # "Microsoft-Windows-SettingSync-OneDrive%4Operational.evtx"
                # "Microsoft-Windows-Shell-ConnectedAccountState%4ActionCenter.evtx"
                # "Microsoft-Windows-Shell-Core%4ActionCenter.evtx"
                # "Microsoft-Windows-Shell-Core%4AppDefaults.evtx"
                # "Microsoft-Windows-Shell-Core%4LogonTasksChannel.evtx"
                # "Microsoft-Windows-Shell-Core%4Operational.evtx"
                # "Microsoft-Windows-ShellCommon-StartLayoutPopulation%4Operational.evtx"
                # "Microsoft-Windows-SmartCard-Audit%4Authentication.evtx"
                # "Microsoft-Windows-SmartCard-DeviceEnum%4Operational.evtx"
                # "Microsoft-Windows-SmartCard-TPM-VCard-Module%4Admin.evtx"
                # "Microsoft-Windows-SmartCard-TPM-VCard-Module%4Operational.evtx"
                # "Microsoft-Windows-SmbClient%4Audit.evtx"
                # "Microsoft-Windows-SmbClient%4Connectivity.evtx"
                # "Microsoft-Windows-SMBClient%4Operational.evtx"
                # "Microsoft-Windows-SmbClient%4Security.evtx"
                # "Microsoft-Windows-SMBDirect%4Admin.evtx"
                # "Microsoft-Windows-SMBServer%4Audit.evtx"
                # "Microsoft-Windows-SMBServer%4Connectivity.evtx"
                # "Microsoft-Windows-SMBServer%4Operational.evtx"
                # "Microsoft-Windows-SMBServer%4Security.evtx"
                # "Microsoft-Windows-SMBWitnessClient%4Admin.evtx"
                # "Microsoft-Windows-SMBWitnessClient%4Informational.evtx"
                # "Microsoft-Windows-StateRepository%4Operational.evtx"
                # "Microsoft-Windows-StateRepository%4Restricted.evtx"
                # "Microsoft-Windows-Storage-ClassPnP%4Operational.evtx"
                # "Microsoft-Windows-Storage-Storport%4Health.evtx"
                # "Microsoft-Windows-Storage-Storport%4Operational.evtx"
                # "Microsoft-Windows-Storage-Tiering%4Admin.evtx"
                # "Microsoft-Windows-StorageManagement%4Operational.evtx"
                # "Microsoft-Windows-StorageSettings%4Diagnostic.evtx"
                # "Microsoft-Windows-StorageSpaces-Driver%4Diagnostic.evtx"
                # "Microsoft-Windows-StorageSpaces-Driver%4Operational.evtx"
                # "Microsoft-Windows-StorageSpaces-ManagementAgent%4WHC.evtx"
                # "Microsoft-Windows-StorageSpaces-SpaceManager%4Diagnostic.evtx"
                # "Microsoft-Windows-StorageSpaces-SpaceManager%4Operational.evtx"
                # "Microsoft-Windows-Store%4Operational.evtx"
                # "Microsoft-Windows-Storsvc%4Diagnostic.evtx"
                # "Microsoft-Windows-SystemSettingsThreshold%4Operational.evtx"
                # "Microsoft-Windows-TaskScheduler%4Maintenance.evtx"
                # "Microsoft-Windows-TaskScheduler%4Operational.evtx"
                # "Microsoft-Windows-TCPIP%4Operational.evtx"
                # "Microsoft-Windows-TenantRestrictions%4Operational.evtx"
                # "Microsoft-Windows-TerminalServices-ClientUSBDevices%4Admin.evtx"
                # "Microsoft-Windows-TerminalServices-ClientUSBDevices%4Operational.evtx"
                # "Microsoft-Windows-TerminalServices-LocalSessionManager%4Admin.evtx"
                # "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx"
                # "Microsoft-Windows-TerminalServices-PnPDevices%4Admin.evtx"
                # "Microsoft-Windows-TerminalServices-PnPDevices%4Operational.evtx"
                # "Microsoft-Windows-TerminalServices-Printers%4Admin.evtx"
                # "Microsoft-Windows-TerminalServices-Printers%4Operational.evtx"
                # "Microsoft-Windows-TerminalServices-RDPClient%4Operational.evtx"
                # "Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Admin.evtx"
                # "Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evtx"
                # "Microsoft-Windows-TerminalServices-ServerUSBDevices%4Admin.evtx"
                # "Microsoft-Windows-TerminalServices-ServerUSBDevices%4Operational.evtx"
                # "Microsoft-Windows-Time-Service%4Operational.evtx"
                # "Microsoft-Windows-Time-Service-PTP-Provider%4PTP-Operational.evtx"
                # "Microsoft-Windows-Troubleshooting-Recommended%4Admin.evtx"
                # "Microsoft-Windows-Troubleshooting-Recommended%4Operational.evtx"
                # "Microsoft-Windows-TWinUI%4Operational.evtx"
                # "Microsoft-Windows-TZSync%4Operational.evtx"
                # "Microsoft-Windows-TZUtil%4Operational.evtx"
                # "Microsoft-Windows-UAC%4Operational.evtx"
                # "Microsoft-Windows-UAC-FileVirtualization%4Operational.evtx"
                # "Microsoft-Windows-UniversalTelemetryClient%4Operational.evtx"
                # "Microsoft-Windows-User Control Panel%4Operational.evtx"
                "Microsoft-Windows-User Device Registration%4Admin.evtx"
                # "Microsoft-Windows-User Profile Service%4Operational.evtx"
                # "Microsoft-Windows-User-Loader%4Operational.evtx"
                # "Microsoft-Windows-UserPnp%4ActionCenter.evtx"
                # "Microsoft-Windows-UserPnp%4DeviceInstall.evtx"
                # "Microsoft-Windows-UserSettingsBackup-BackupUnitProcessor%4Operational.evtx"
                # "Microsoft-Windows-UserSettingsBackup-Orchestrator%4Operational.evtx"
                # "Microsoft-Windows-VDRVROOT%4Operational.evtx"
                # "Microsoft-Windows-VerifyHardwareSecurity%4Admin.evtx"
                # "Microsoft-Windows-VHDMP-Operational.evtx"
                # "Microsoft-Windows-Volume%4Diagnostic.evtx"
                # "Microsoft-Windows-VolumeSnapshot-Driver%4Operational.evtx"
                # "Microsoft-Windows-VPN%4Operational.evtx"
                # "Microsoft-Windows-VPN-Client%4Operational.evtx"
                # "Microsoft-Windows-Wcmsvc%4Operational.evtx"
                # "Microsoft-Windows-WDAG-PolicyEvaluator-CSP%4Operational.evtx"
                # "Microsoft-Windows-WDAG-PolicyEvaluator-GP%4Operational.evtx"
                # "Microsoft-Windows-WebAuthN%4Operational.evtx"
                # "Microsoft-Windows-WER-PayloadHealth%4Operational.evtx"
                # "Microsoft-Windows-WFP%4Operational.evtx"
                # "Microsoft-Windows-Win32k%4Operational.evtx"
                # "Microsoft-Windows-Windows Defender%4Operational.evtx"
                # "Microsoft-Windows-Windows Defender%4WHC.evtx"
                # "Microsoft-Windows-Windows Firewall With Advanced Security%4ConnectionSecurity.evtx"
                "Microsoft-Windows-Windows Firewall With Advanced Security%4Firewall.evtx"
                # "Microsoft-Windows-Windows Firewall With Advanced Security%4FirewallDiagnostics.evtx"
                # "Microsoft-Windows-WindowsBackup%4ActionCenter.evtx"
                # "Microsoft-Windows-WindowsSystemAssessmentTool%4Operational.evtx"
                "Microsoft-Windows-WindowsUpdateClient%4Operational.evtx"
                # "Microsoft-Windows-WinHttp%4Operational.evtx"
                # "Microsoft-Windows-WinINet%4Operational.evtx"
                # "Microsoft-Windows-WinINet-Config%4ProxyConfigChanged.evtx"
                # "Microsoft-Windows-Winlogon%4Operational.evtx"
                # "Microsoft-Windows-WinRM%4Operational.evtx"
                # "Microsoft-Windows-Winsock-WS2HELP%4Operational.evtx"
                # "Microsoft-Windows-Wired-AutoConfig%4Operational.evtx"
                # "Microsoft-Windows-WLAN-AutoConfig%4Operational.evtx"
                # "Microsoft-Windows-WMI-Activity%4Operational.evtx"
                # "Microsoft-Windows-WMPNSS-Service%4Operational.evtx"
                # "Microsoft-Windows-WorkFolders%4Operational.evtx"
                # "Microsoft-Windows-WorkFolders%4WHC.evtx"
                # "Microsoft-Windows-Workplace Join%4Admin.evtx"
                # "Microsoft-Windows-WPD-ClassInstaller%4Operational.evtx"
                # "Microsoft-Windows-WPD-CompositeClassDriver%4Operational.evtx"
                # "Microsoft-Windows-WPD-MTPClassDriver%4Operational.evtx"
                # "Microsoft-Windows-WWAN-SVC-Events%4Operational.evtx"
                # "Microsoft-WindowsPhone-Connectivity-WiFiConnSvc-Channel.evtx"
                "OAlerts.evtx"
                # "OpenSSH%4Admin.evtx"
                # "OpenSSH%4Operational.evtx"
                # "Parameters.evtx"
                # "SMSApi.evtx"
                # "State.evtx"
                "Windows PowerShell.evtx"
        )

    # Output to Log
        Write-Host "    - Source: $($Path_Log_Source)"
        Write-Host "    - Destination: $($Param_Log_Destination)"
        Write-Host "    - Log Files"
        foreach ($Item in $Array_LogFileNames) {
            Write-Host "        $($Item)"
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Variables
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Functions
#   Error Range: 1300 - 1399
#--------------------------------------------------------------------------------------------
#Region Functions

    Write-Host "  Functions"

    # Write Error Codes
        Write-Host "    - Write-vr_ErrorCode"
        function Write-vr_ErrorCode ($Code,$Exit,$Object) {
            # Code: XXXX   4-digit code to identify where in script the operation failed
            # Exit: Boolean option to define if  exits or not
            # Object: The error object created when the script encounters an error ($Error[0], $PSItem, etc.)

            begin {

            }

            process {
                Write-Host "        Error: $($Object.Exception.ErrorId)"
                Write-Host "        Command Name: $($Object.CategoryInfo.Activity)"
                Write-Host "        Message: $($Object.Exception.Message)"
                Write-Host "        Line/Position: $($Object.Exception.Line)/$($Object.Exception.Offset)"
            }

            end {
                switch ($Exit) {
                    $true {
                        Write-Host "        Exit: $($Code)"
                        Exit $Code
                    }
                    $false {
                        Write-Host "        Return"
                        Return
                    }
                    Default {
                        Write-Host "        Unknown Exit option in Write-vr_ErrorCode parameter"
                    }
                }
            }
        }

        Write-Host "        Success"

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Functions
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Environment
#   Error Range: 1400 - 1499
#--------------------------------------------------------------------------------------------
#Region Environment

    # Write-Host "  Environment"



    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Environment
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validation
#   Error Range: 1500 - 1599
#--------------------------------------------------------------------------------------------
#Region Validation

    Write-Host "  Validation"

    # Destination Exists
        Write-Host "    - Destination Exists"

        If (Test-Path $Param_Log_Destination) {
            Write-Host "        Success"
        }
        Else {
            Write-Host "        Directory Not Found..."
            try {
                New-Item -Path $Param_Log_Destination -ItemType Directory -ErrorAction Stop | Out-Null
                Write-Host "        Successfully Created Directory"
            }
            catch {
                Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
            }
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Validation
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1600 - 1699
#--------------------------------------------------------------------------------------------
#Region Execution

    Write-Host "  Main Execution"

    # Copy Log Files
        Write-Host "    - Copy Log Files"

        foreach ($Item in $Array_LogFileNames) {
            try {
                Copy-Item -Path $($Path_Log_Source + "\" + $Item) -Destination $Param_Log_Destination -Force -ErrorAction Stop
                Write-Host "        $($Item): Success"
            }
            catch {
                Write-Host "        $($Item): $($PSItem.Exception.Message)"
                #Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
            }
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Execution
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Cleanup
#   Error Range: 1800 - 1899
#--------------------------------------------------------------------------------------------
#Region Cleanup

    # Write-Host "  Cleanup"

    # # [StepName]
    #     Write-Host "    - [StepName]"

    #     try {

    #         Write-host "        Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1801 -Exit $true -Object $PSItem
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Cleanup
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Output
#   Error Range: 1900 - 1999
#--------------------------------------------------------------------------------------------
#Region Output

    # Write-Host "  Output"

    # # [StepName]
    #     Write-Host "    - [StepName]"

    #     try {

    #         Write-host "        Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1901 -Exit $true -Object $PSItem
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Output
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Footer
#--------------------------------------------------------------------------------------------
#Region Footer

    Write-Host ""
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  End of Script"
    Write-Host "------------------------------------------------------------------------------"

#EndRegion Footer
#--------------------------------------------------------------------------------------------
