#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$LogPath,                   # '%vr_Logging_PrimaryLog%'
    [string[]]$TSVariables              # '%vr_Meta_TaskSequenceName%','%vr_Meta_DateStartUTC%','%vr_Meta_TimeStartUTC%','%vr_Device_Manufacturer%','%vr_Device_Model%','%vr_Device_ChassisType%','%vr_Device_DeviceType%','%vr_Device_Virtual%','%vr_Device_SerialNumber%','%vr_Device_AssetTag%','%vr_Network_Description%','%vr_Network_MACAddress%','%vr_Network_IPAddress%','%vr_Network_IPSubnet%','%vr_Network_DefaultIPGateway%','%vr_Network_DHCPServer%','%vr_Network_DNSDomain%','%vr_Network_DNSServerSearchOrder%','%_SMSTSLaunchMode%','%_SMSTSMP%','%_SMSTSDiskLabel1%'
)

$MECM_Log_Message = @(
    "------------------------------------------------------------------------------------------------------"
    "  MECM Toolkit - Task Sequences - Logging - Advanced Logging Integration"
    "------------------------------------------------------------------------------------------------------"
    "  Author:    Dustin Estes"
    "  Company:   VividRock"
    "  Date:      December 21, 2019"
    "  Copyright: VividRock LLC - All Rights Reserved"
    "  Purpose:   This log provides overall step progression of the Task Sequence for improved troubleshooting."
    "------------------------------------------------------------------------------------------------------"
    ""
    "------------------------------------------------------------------------------------------------------"
    "  Starting TS Execution: $($TSVariables[0])"
    "------------------------------------------------------------------------------------------------------"
    "  Log Path: $($LogPath)"
    "  Start Date (UTC): $($TSVariables[1])"
    "  Start Time (UTC): $($TSVariables[2])"
    "------------------------------------------------------------------------------------------------------"
    ""
    "------------------------------------------------------------------------------------------------------"
    "  Hardware Information"
    "------------------------------------------------------------------------------------------------------"
    "  Manufacturer: $($TSVariables[3])"
    "  Model: $($TSVariables[4])"
    "  Chassis Type: $($TSVariables[5])"
    "  Device Type: $($TSVariables[6])"
    "  Virtual: $($TSVariables[7])"
    "  Serial #: $($TSVariables[8])"
    "  Asset Tag: $($TSVariables[9])"
    ""
    "------------------------------------------------------------------------------------------------------"
    "  Network Information"
    "------------------------------------------------------------------------------------------------------"
    "  Network Adapter: $($TSVariables[10])"
    "  MAC Address: $($TSVariables[11])"
    "  IP Addresses: $($TSVariables[12])"
    "  IP Subnet: $($TSVariables[13])"
    "  IP Gateway: $($TSVariables[14])"
    "  DHCP Server: $($TSVariables[15])"
    "  DNS Domain: $($TSVariables[16])"
    "  DNS Servers: $($TSVariables[17])"
    ""
    "------------------------------------------------------------------------------------------------------"
    "  MECM Information"
    "------------------------------------------------------------------------------------------------------"
    "  Launch Mode: $($TSVariables[18])"
    "  Management Point: $($TSVariables[19])"
    "  Boot Disk: $($TSVariables[20])"
    "------------------------------------------------------------------------------------------------------"
    ""
    "------------------------------------------------------------------------------------------------------"
    "  Begin Initialize Group"
    "------------------------------------------------------------------------------------------------------"
    "  Logging"
    "    - Create Log File"
)
$MECM_Log_Type = " type=`"1`""
    #Info = 1, Warning = 2, Error = 3

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
            Exit 1000
        }

    }

#--------------------------------------------------------------------------------------------