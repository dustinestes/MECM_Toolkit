# MECM Toolkit - Collections - LIE - Roles & Features

| Property     | Value                                                                                                                                                                                                              |
|--------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Path         | \\Assets and Compliance\\Overview\\Device Collections\\VividRock\\# LIE - Limit, Include, Exclude\\Roles & Features                                                                                                |
| Category     | LIE                                                                                                                                                                                                                |
| Description  | All LIE collections should be used to Limit, Include, and Exclude objects on all other collections.                                                                                                                |
| Type         | Roles & Features                                                                                                                                                                                                   |
| Description  | This is a set of collections that can be used as to identify devices that have a specific role or feature enabled or disabled.                                                                                     |

&nbsp;

## About

Each section will provide a collection name, description, query snippet, PowerShell creation snippet, and other helpful details.

If you want to build the entire bundle of collections, there will be an appendix at the end that provides a script and information on how to use PowerShell to create the entire bundle.

&nbsp;

## Prerequisites

The following prerequisites are needed before running any of the code snippets within this document.

1. You must run all PowerShell scripts within an instance that is already connected to an MECM PS Drive (SITE:\\). To do so, run the following code, replacing the items in square brackets.

    ```powershell
    # Site configuration
        $SiteCode = "[SiteCode]"
        $ProviderMachineName = "[SiteServerFQDN]"

    # Import the ConfigurationManager.psd1 module
        Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"

    # Connect to the site's drive if it is not already present
        New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName

    # Set the current location to be the site code.
        Set-Location "$($SiteCode):\"
    ```

2. You need to create the expected folder structure within the MECM Console Environment by running the code located at this link: [link name](https://wwww.com)
   - You could also change the defined folder path in the scripts below if you wanted to place them in a custom path.

&nbsp;

## Resources

Install States [Link](https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-optionalfeature)

- Enabled (1)
- Disabled (2)
- Absent (3)
- Unknown (4)

&nbsp;

## List of Collections

- [MECM - Collections - LIE - Roles \& Features](#mecm---collections---lie---roles--features)
  - [About](#about)
  - [Prerequisites](#prerequisites)
  - [Resources](#resources)
  - [List of Collections](#list-of-collections)
  - [Roles \& Features - IIS-WebServerRole - Enabled](#roles--features---iis-webserverrole---enabled)
    - [General](#general)
    - [Membership Rules](#membership-rules)
    - [Update Schedule](#update-schedule)
    - [PowerShell](#powershell)
    - [SQL Query](#sql-query)
  - [Roles \& Features - \[RoleFeatureName\]](#roles--features---rolefeaturename)
    - [General](#general-1)
    - [Membership Rules](#membership-rules-1)
    - [Update Schedule](#update-schedule-1)
    - [PowerShell](#powershell-1)
    - [SQL Query](#sql-query-1)
- [Apdx A: Install All Collections](#apdx-a-install-all-collections)
- [Apdx B: Collection Template](#apdx-b-collection-template)
  - [Roles \& Features - \[RoleFeatureName\]](#roles--features---rolefeaturename-1)
    - [General](#general-2)
    - [Membership Rules](#membership-rules-2)
    - [Update Schedule](#update-schedule-2)
    - [PowerShell](#powershell-2)
    - [SQL Query](#sql-query-2)
- [Apdx C: List of Optional Features](#apdx-c-list-of-optional-features)
  - [SQL Query](#sql-query-3)
  - [Example Output](#example-output)
  - [To Do](#to-do)

&nbsp;

## Roles & Features - IIS-WebServerRole - Enabled

A collection of devices with the IIS-WebServerRole - Enabled in the Enabled state.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Roles & Features - IIS-WebServerRole - Enabled                                      |
| Comment                       | A collection of devices with the IIS-WebServerRole in the Enabled (1) state.              |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Roles & Features          |

### Membership Rules

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Direct                                                                                    |
| Resource Class                | System Resource                                                                           |
| Attribute Name                | [AttributeName]                                                                           |
| Value                         | [Value]                                                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Query                                                                                     |
| Name                          | Win32_OptionalFeature - IIS-WebServerRole - Enabled                                       |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select *  from  SMS_R_System inner join SMS_G_System_OPTIONAL_FEATURE on SMS_G_System_OPTIONAL_FEATURE.ResourceId = SMS_R_System.ResourceId where SMS_G_System_OPTIONAL_FEATURE.Name = "IIS-WebServer" and SMS_G_System_OPTIONAL_FEATURE.InstallState = "1" |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Include                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Enabled                                                                                   |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Roles & Features"
    $Collection_Name            = "LIE - Roles & Features - IIS-WebServerRole - Enabled"
    $Collection_Comment         = "A collection of devices with the IIS-WebServerRole in the Enabled state. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Win32_OptionalFeature - IIS-WebServerRole - Enabled'
    $MembershipRule_QueryLogic  = 'select *  from  SMS_R_System inner join SMS_G_System_OPTIONAL_FEATURE on SMS_G_System_OPTIONAL_FEATURE.ResourceId = SMS_R_System.ResourceId where SMS_G_System_OPTIONAL_FEATURE.Name = "IIS-WebServer" and SMS_G_System_OPTIONAL_FEATURE.InstallState = "1"'

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionQueryMembershipRule -InputObject $Object_Collection -RuleName $MembershipRule_Name -QueryExpression $MembershipRule_QueryLogic
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
select * from v_R_System inner join v_GS_OPTIONAL_FEATURE on v_GS_OPTIONAL_FEATURE.ResourceID = v_R_System.ResourceID where v_GS_OPTIONAL_FEATURE.Name0 = 'IIS-WebServer' and v_GS_OPTIONAL_FEATURE.InstallState0 = '1'
```

## Roles & Features - [RoleFeatureName]

A collection of devices with the [RoleFeatureName] in the [State] state.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Roles & Features - [RoleFeatureName]                                                |
| Comment                       | A collection of devices with the [RoleFeatureName] in the [State] state.                  |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Roles & Features          |

### Membership Rules

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Direct                                                                                    |
| Resource Class                | System Resource                                                                           |
| Attribute Name                | [AttributeName]                                                                           |
| Value                         | [Value]                                                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Include                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Enabled                                                                                   |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Roles & Features"
    $Collection_Name            = "LIE - Roles & Features - [RoleFeatureName]"
    $Collection_Comment         = "A collection of devices with the [RoleFeatureName] in the [State] state. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = '[QueryName]'
    $MembershipRule_QueryLogic  = '[QueryRule]'

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionQueryMembershipRule -InputObject $Object_Collection -RuleName $MembershipRule_Name -QueryExpression $MembershipRule_QueryLogic
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
select * from v_R_System
```

&nbsp;

# Apdx A: Install All Collections

This code snippet will install all of the collections that are defined within this document.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
Set-Noun
```

&nbsp;

# Apdx B: Collection Template

## Roles & Features - [RoleFeatureName]

A collection of devices with the [RoleFeatureName] in the [State] state.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Roles & Features - [RoleFeatureName]                                                |
| Comment                       | A collection of devices with the [RoleFeatureName] in the [State] state.                  |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Roles & Features          |

### Membership Rules

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Direct                                                                                    |
| Resource Class                | System Resource                                                                           |
| Attribute Name                | [AttributeName]                                                                           |
| Value                         | [Value]                                                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Include                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Enabled                                                                                   |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Roles & Features"
    $Collection_Name            = "LIE - Roles & Features - [RoleFeatureName]"
    $Collection_Comment         = "A collection of devices with the [RoleFeatureName] in the [State] state. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = '[QueryName]'
    $MembershipRule_QueryLogic  = '[QueryRule]'

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionQueryMembershipRule -InputObject $Object_Collection -RuleName $MembershipRule_Name -QueryExpression $MembershipRule_QueryLogic
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
select * from v_R_System
```

&nbsp;

# Apdx C: List of Optional Features

This is a list of Optional Features taken from the SQL database of a number of MECM environments and concatenated here.

> Note: It does not necessarily represent every possible option that could exist in the column of the table. You should run the script in your own environment and combine the two datasets to get an accurate idea of the options you can search for.

## SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query to get the information listed below.

```sql
select distinct Caption0 from v_GS_OPTIONAL_FEATURE order by Caption0
```

## Example Output

This is a known list of items output from MECM. It does not represent all possible options as those can change over time, builds, and versions of windows.

```text
.NET Environment
.NET Environment 3.5
.NET Extensibility
.NET Extensibility 3.5
.NET Extensibility 4.5
.NET Extensibility 4.6
.NET Extensibility 4.7
.NET Extensibility 4.8
.NET Framework 3.5 (includes .NET 2.0 and 3.0)
.NET Framework 3.5 Features
.NET Framework 4.5
.NET Framework 4.5 Features
.NET Framework 4.6
.NET Framework 4.6 Advanced Services
.NET Framework 4.6 Features
.NET Framework 4.7
.NET Framework 4.7 Advanced Services
.NET Framework 4.7 Features
.NET Framework 4.8
.NET Framework 4.8 Advanced Services
.NET Framework 4.8 Features
Active Directory Administrative Center
Active Directory Application Mode
Active Directory Certificate Services
Active Directory Certificate Services Management Tools
Active Directory Domain Controller
Active Directory Domain Controller Tools
Active Directory Federation Services
Active Directory Federation Services Proxy
Active Directory Lightweight Directory Services
Active Directory Lightweight Directory Services Tools
Active Directory Mail Based Intersite Messaging
Active Directory PowerShell
Active Directory Rights Management Services Tools
Administrative Tools
AdminUI
API and PowerShell cmdlets
Application Development Features
Application Initialization
ASP
ASP.NET
ASP.NET 3.5
ASP.NET 4.5
ASP.NET 4.6
ASP.NET 4.7
ASP.NET 4.8
Background Intelligent Transfer Service (BITS)
Background Intelligent Transfer Service (BITS) Server Extensions for File Upload
Basic Authentication
BitLocker Drive Encryption
BitLocker Drive Encryption Remote Administration Tool
BitLocker Network Unlock
BitLocker Recovery Password Viewer
BITS Compact Server
Business Scan Server
CCFFilter
Centralized SSL Certificate Support
Certificate Service
Certificate Services Enrollment Policy Server
Certificate Services Enrollment Server
Certification Authority Management Tools
CGI
Chess Titans
Claims-aware Application Support
Client Certificate Mapping Authentication
Client for NFS
Common HTTP Features
Configuration APIs
Container Image Manager
Containers
Custom Logging
Custom Logon
Data Center Bridging
Data Deduplication
Database
DataCenterBridging LLDP Tools
Default Document
Deployment Server
Deployment Server Language Pack
Desktop Experience
Device Health Attestation
Device Lockdown
DFS Management
DFS Namespace
DFS Replication
DHCP Server feature
DHCP Server Tools
DHCPServer RSAT Client Tools
Digest Authentication
DirectAccess Server Management Tools
Directory Browsing
DirectPlay
DNS Server
DNS Server Tools
Dynamic Content Compression
Enhanced Storage
Failover Cluster AdminPak
Failover Cluster Automation Server
Failover Cluster Command Interface
Failover Cluster FullServer
Failover Cluster Management Tools
Failover Cluster Module for Windows PowerShell
Failover Clustering Tools
Fax Management
Fax Server
Federation Service
Federation Service Proxy
Federation support for Rights Management Services
File Server Role
File Server VSS Agent Service
FreeCell
FSRM Infrastructure
FSRM Infrastructure Services
FSRM Management Tools
FTP Extensibility
FTP Server
FTP Service
Games
Guarded Host
GUI for Windows Defender
Handwriting Recognition
Hardened Fabric Encryption Task
HCS MMC
HCS Runtime
Health and Diagnostics
Hearts
Host Guardian - Hyper-V support
HTTP Activation
HTTP Errors
HTTP Logging
HTTP Redirection
Hyper-V
Hyper-V Components
Hyper-V GUI Management Tools
Hyper-V Hypervisor
Hyper-V Management Clients Language Package
Hyper-V Management Console
Hyper-V Management Tools
Hyper-V Module for Windows PowerShell
Hyper-V Offline
Hyper-V Online
Hyper-V Platform
Hyper-V PowerShell cmdlets
Hyper-V Services
I/O Quality of Service
IIS 6 Management Compatibility
IIS 6 Management Console
IIS 6 Scripting Tools
IIS 6 WMI Compatibility
IIS Client Certificate Mapping Authentication
IIS Management Console
IIS Management Scripts and Tools
IIS Management Service
IIS Metabase and IIS 6 configuration compatibility
Indexing Service
Ink and Handwriting Services
Ink Support
Internet Authentication Service (NT Service) feature
Internet Backgammon
Internet Checkers
Internet Explorer 10
Internet Explorer 11
Internet Explorer 8
Internet Explorer 9
Internet Games
Internet Information Services
Internet Information Services Hostable Web Core
Internet Printing Client
Internet Printing Server
Internet Spades
IP Security
IPAM Management Tools
IPAM Server Feature
ISAPI Extensions
ISAPI Filters
iSCSI Target Server
iSCSI Target Server - Disk Providers
iSCSI Target Server Powershell
iSNS Server service
Key Distribution Service PowerShell Cmdlets
Keyboard Filter
Legacy Components
Legacy SIS Language Pack
Logging Tools
LPD Print Service
LPR Port Monitor
Mahjong Titans
Management OData IIS Extension
Media Features
Media Foundation
Message Queuing
Message Queuing (MSMQ) Activation
Message Queuing Services
Microsoft .NET Framework 3.5.1
Microsoft Defender Antivirus
Microsoft Defender Application Guard
Microsoft Message Queue (MSMQ) Server
Microsoft Message Queue (MSMQ) Server Core
Microsoft MultipathIo
Microsoft Print to PDF
Microsoft Windows AuthManager
Microsoft Windows Deployment Services
Microsoft Windows Deployment Services Admin Pack
Microsoft Windows Deployment Services Admin Pack Language Pack
Microsoft Windows Deployment Services Language Pack
Microsoft Windows Host Credential Authorization Protocol feature
Microsoft Windows ServerCore Foundational PowerShell Cmdlets
Microsoft Windows ServerCore WOW64
Microsoft Windows ServerCore-FullServer
Microsoft XPS Document Writer
Microsoft-Windows-BootEvent-Collector-Opt-Package
Microsoft-Windows-FCI-Client-Package
Microsoft-Windows-RemoteFX-EmbeddedVideoCap-Setup-Package-Inner
Microsoft-Windows-RemoteFX-Server-Setup-Package-Inner
Microsoft-Windows-Server-Core-Package-DisplayName
Microsoft-Windows-Server-Gui-Mgmt-Package-DisplayName
Microsoft-Windows-Server-Gui-Mgmt-Package-DisplayName_onecore
Microsoft-Windows-Server-Gui-Shell-Package-DisplayName
Microsoft-Windows-Server-Shell-Package-DisplayName
Minesweeper
More Games
MSMQ Active Directory Domain Services Integration
MSMQ DCOM Proxy
MSMQ HTTP Support
MSMQ routing server
MSMQ Triggers
Multicasting Support
MultiPoint Connector
MultiPoint Connector Services
MultiPoint Manager and MultiPoint Dashboard
MultiPoint Services
Named Pipe Activation
Network Controller
Network Controller Tools
Network Device Enrollment Services
Network Load Balancing
Network Load Balancing Management Client
Network Policy and Access Services
Network Virtualization
NFS Administrative Tools
NIS
NPS Management Tools
NPS MMC
NTVDM
OData Services for Management IIS Extension
ODBC Logging
OEM-Appliance-OOBE
Online Revocation Services
Online Revocation Services Management Tools
Peer Name Resolution Protocol(PNRP)
Performance Features
PKIClient PowerShell Cmdlets
Print and Document Services
Print Management
Process Model
PSync
Purble Place
QWAVE component
RAS Connection Manager Administration Kit (CMAK)
Ras Server All
Ras Server feature
Ras Server MMC feature
Ras Server Routing Protocols
Remote Access
Remote Access Management Tools
Remote Access module for Windows PowerShell
Remote Access Server
Remote Administration pack for Background Intelligent Transfer Service (BITS) Server Extensions
Remote Administration pack for Shielded VM Tools
Remote Assistance
Remote Desktop Services
Remote Desktop Services Application Server
Remote Desktop Services Application Server Admin Pack
Remote Desktop Services Gateway
Remote Desktop Services Gateway Admin Pack
Remote Desktop Services Licensing Diagnosis Pack
Remote Desktop Services Session Broker Tools Admin Pack
Remote Desktop Services Session Directory Server
Remote Desktop Services Web Access
Remote Differential Compression
Remote Differential Compression API Support
Request Filtering
Request Monitor
ResumeKeyFilter
Rights Management Services
RIP Listener
Root node for feature RSAT tools
RPC over HTTP proxy
RSAT-NIS
Scan Management
Security
Server Core Drivers
Server Core non-critical fonts - (Fonts-BitmapFonts).
Server Core non-critical fonts - (Fonts-MinConsoleFonts).
Server Core non-critical fonts - (Fonts-UAPFonts).
Server Core non-critical fonts - (Font-TrueTypeFonts).
Server Core non-critical fonts components - (Fonts-Support).
Server Core WOW64 Drivers
Server Drivers
Server for NFS
Server Migration Tools
Server Printer Drivers
ServerCore East Asian IME
ServerCore East Asian IME WOW64
Server-Gui-RSAT-Package_ShareMGMT-RsatClient-Tools-Langpack
Server-Gui-RSAT-Package_SNMP-Gui-Tools-RSAT
Server-Side Includes
Services for NFS
Shell Launcher
Simple Network Management Protocol (SNMP)
Simple Network Management Protocol (SNMP) for Server Core
Simple TCPIP services (i.e. echo, daytime etc)
Single Instance Store Limited
SMB 1.0/CIFS Automatic Removal
SMB 1.0/CIFS Client
SMB 1.0/CIFS File Sharing Support
SMB 1.0/CIFS Server
SMB Bandwidth Limit
SMB Direct
SMBHashGeneration
SmbWitness
SMTP Service
SMTP Service Admin Pack
Software Load Balancer
Solitaire
Spider Solitaire
SQL Server Connectivity
Static Content
Static Content Compression
Storage Manager for SAN
Storage Migration Service
Storage Migration Service Management
Storage Migration Service Proxy
Storage Replica
Storage Replica Module for Windows PowerShell
Subsystem for UNIX-based Applications
Subsystem for UNIX-based Applications [Deprecated]
System Data Archiver
System Insights
System Insights Module for Windows PowerShell
Tablet PC Components
TCP Activation
TCP Port Sharing
Telnet Client
Telnet Server
Terminal Services Licensing
Terminal Services Licensing Admin Pack
TFTP Client
TLS Session Ticket Key Commands
Tracing
Transport Server
Transport Server Language Pack
Trusted Platform Module Service PowerShell Cmdlets
Unbranded Boot
Unified Write Filter
URL Authorization
User Interface Management Console
User Interfaces and Infrastructure
Virtual Machine Platform
VM Host Agent
VM Shielding Tools for Fabric Management
Volume Activation Services
Volume Activation Tools
WCF Services
Web Enrollment Services
Web Management Tools
WebDAV Publishing
WebDAV Redirector
WebSocket Protocol
WID Connectivity
WID Database
Windows Authentication
Windows Biometric Framework
Windows Communication Foundation HTTP Activation
Windows Communication Foundation Non-HTTP Activation
Windows Defender
Windows Defender Antivirus
Windows Defender Application Guard
Windows Defender Features
Windows DFS Replication Service
Windows DVD Maker
Windows Fax and Scan
Windows Fax and Scan Configuration
Windows Feedback Forwarder
Windows File Replication Service
Windows Gadget Platform
Windows Hypervisor Platform
Windows Identity Foundation 3.5
Windows Internal Database
Windows Media Center
Windows Media Player
Windows PowerShell
Windows PowerShell 2.0
Windows PowerShell 2.0 Engine
Windows PowerShell Desired State Configuration Service
Windows PowerShell Integrated Scripting Environment
Windows PowerShell Web Access
Windows Print Server Role Settings
Windows Process Activation Service
Windows Projected File System
Windows Projected File System (Beta)
Windows Recovery Disc
Windows Remote Management (WinRM) IIS Extension
Windows Sandbox
Windows Search
Windows Search Service
Windows Server Backup
Windows Server Backup Powershell Commandlets
Windows Server Backup SnapIn
Windows Server Print Client
Windows Server Print Client Management UI
Windows Server Update Services
Windows Server Update Services Tools
Windows Standards-Based Storage Management
Windows Subsystem for Linux
Windows Subsystem for Linux (Beta)
Windows System Resource Manager
Windows System Resource Manager RSAT
Windows TIFF IFilter
Windows Token-based Application Support
WINS Management
WINS Runtime
WINS Server Tools
Wireless Networking
WMI SNMP Provider
Work Folders
Work Folders Client
World Wide Web Services
WSS-Product-Package
WSUS Services
XPS Services
XPS Viewer
```





## To Do



select * from v_R_System inner join v_GS_OPTIONAL_FEATURE on v_GS_OPTIONAL_FEATURE.ResourceID = v_R_System.ResourceID where v_GS_OPTIONAL_FEATURE.Caption0 = '' and v_GS_OPTIONAL_FEATURE.InstallState0 = '1'



Active Directory Certificate Services
Active Directory Domain Controller
Active Directory Federation Services
Active Directory Lightweight Directory Services
Active Directory Mail Based Intersite Messaging
Active Directory Rights Management Services
BitLocker Drive Encryption
BitLocker Network Unlock
Certificate Service
Certificate Services Enrollment Policy Server
Certificate Services Enrollment Server
Data Deduplication
Deployment Server
DFS Management
DFS Namespace
DFS Replication

DHCP Server feature
DirectAccess Server
DNS Server

Failover Cluster Automation Server
Failover Cluster FullServer

Federation Service
Federation Service Proxy

File Server Role

FTP Server

Hyper-V Hypervisor

Internet Information Services
Internet Information Services Hostable Web Core

IP Security

IPAM Server Feature

Microsoft Defender Antivirus
Microsoft Defender Application Guard

Microsoft Windows Deployment Services
Network Load Balancing
Network Policy and Access Services
Print Management
Ras Server feature
Remote Access Server
Remote Desktop Services
Remote Desktop Services Gateway
Remote Desktop Services Web Access
Simple Network Management Protocol (SNMP)
Simple Network Management Protocol (SNMP) for Server Core
SMB 1.0/CIFS Client
SMB 1.0/CIFS File Sharing Support
SMB 1.0/CIFS Server
SMTP Service
Software Load Balancer
Subsystem for UNIX-based Applications
Subsystem for UNIX-based Applications [Deprecated]
Telnet Server
Unified Write Filter
Volume Activation Services
WID Database
Windows Defender Antivirus
Windows Defender Application Guard
Windows Hypervisor Platform
Windows Print Server Role Settings
Windows Process Activation Service
Windows Sandbox
Windows Server Backup
Windows Server Print Client
Windows Server Update Services
Windows Subsystem for Linux
