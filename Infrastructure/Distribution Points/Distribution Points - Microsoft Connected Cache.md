# MECM Toolkit - Infrastructure - Distribution Points - Microsoft Connected Cache

Microsoft Connected Cache is a solution that utilizes Delivery Optimization and on-premises servers for localizing Microsoft's cloud content. It allows you to cache certain content on-premises to reduce impact to your WAN links. This feature can be enabled on MECM Distribution Points to allow them to service not only your standard MECM Clients, but also your cloud-only and co-managed devices that may come on-premises.

This cache server will provide ton-demand content source services to clients enabled for Delivery Optimization. Access to the cache servers is controlled by a client's membership within MECM Boundary Groups with a DP configured for Microsoft Connected Cache.

<br>

## Table of Contents

- [MECM Toolkit - Infrastructure - Distribution Points - Microsoft Connected Cache](#mecm-toolkit---infrastructure---distribution-points---microsoft-connected-cache)
  - [Table of Contents](#table-of-contents)
  - [General Information](#general-information)
    - [Supported Clients](#supported-clients)
    - [Supported Operating Systems](#supported-operating-systems)
    - [Supported Content Types](#supported-content-types)
  - [How It Works](#how-it-works)
      - [Process Overview](#process-overview)
  - [Considerations](#considerations)
    - [Application Request Routing (ARR)](#application-request-routing-arr)
    - [Proxy Servers for Internet Access](#proxy-servers-for-internet-access)
    - [Limit Roles on the Connected Cache Server](#limit-roles-on-the-connected-cache-server)
    - [Cache Drive](#cache-drive)
      - [Size](#size)
      - [Behavior](#behavior)
    - [Memory and Processor](#memory-and-processor)
    - [Log File Size](#log-file-size)
    - [Peer-to-Peer Caching](#peer-to-peer-caching)
  - [Prerequisites](#prerequisites)
    - [Licensing](#licensing)
    - [Distribution Point](#distribution-point)
    - [Network Access](#network-access)
  - [Design](#design)
  - [Implement](#implement)
    - [Server Configuration](#server-configuration)
    - [Client Settings Policy](#client-settings-policy)
  - [Validate](#validate)
    - [Server](#server)
      - [Log Files](#log-files)
    - [Client](#client)
      - [Configuration](#configuration)
      - [Operation](#operation)
  - [Monitor](#monitor)
- [Appendices](#appendices)
  - [Apdx A: References](#apdx-a-references)
  - [Apdx B: Automation](#apdx-b-automation)
    - [PowerShell](#powershell)
      - [Script](#script)
    - [Configuration Manager SDK](#configuration-manager-sdk)
      - [Script](#script-1)
  - [Apdx C: Error Codes](#apdx-c-error-codes)

<br>

## General Information

### Supported Clients

- Clients that utilize on-premises Distribution Points
- Co-managed clients
- Cloud-only clients

### Supported Operating Systems

- Windows 10 (1511 or later)
- Windows 11 (all)
- Windows Server 2019 (1809 or later)

### Supported Content Types

The types of content supported by Microsoft Connected Cache and Delivery Optimization differs by OS type (Client, Server) and the technology utilized. Below is a brief list of a few of these supported types. For more information, please see: [What is Delivery Optimization](https://learn.microsoft.com/en-us/windows/deployment/do/waas-delivery-optimization)

> Note: This Connected Cache content is not the same as MECM's internal Distribution Point content and, therefore, is stored separately from the MECM content.

- Windows Update (feature updates, quality updates, language packs, drivers)
- Windows 10/11 UWP Store Apps
- Windows 11 Win32 Store Apps
- Windows Defender Definition Updates
- Intune Win32 Apps
- Microsoft 365 Apps and Updates
- Edge Browser Updates
- Dynamic Updates
- If you enable Windows Update for Business policies: Windows feature and quality updates
- For co-management workloads:
  - Windows Update for Business: Windows feature and quality updates
  - Office Click-to-Run apps: Microsoft 365 Apps and updates
  - Client apps: Microsoft Store apps (UWP) and updates
  - Endpoint Protection: Windows Defender definition updates
Intune Win32 apps

## How It Works

Clients configured to use the Connected Cache server no longer request Microsoft cloud-managed content from the internet as their preferred source. Clients will utilize the cache server located within their boundary group before falling back to the Microsoft Content Delivery Network (CDN). This caching server utilizes the IIS feature for Application Request Routing (ARR) to quickly respond to future requests of the same content. If configured, clients will also utilize peers within their network to locate content provided through the Delivery Optimization solution.

#### Process Overview

1. Client checks for content and gets the address for the Content Delivery Network (CDN)
2. Configuration Manager configures Delivery Optimization (DO) settings on the client, including the Connected Cache server name
3. Client determines content source (in this order):
   - Connected Cache server
     - If the Connected Cache server doesn't have the content, the server will download it from the CDN to the cache and serve it to the client
   - Microsoft Content Delivery Network (CDN)
     - If the Connected Cache server fails to respond, the client will download the content directly from the CDN
   - Peer Network
     - Clients will also use Delivery Optimization to get content from peers
4. Content is downloaded and utilized

<br>

## Considerations

### Application Request Routing (ARR)

This IIS role provides the underlying modules and technology that enable the Connected Cache server to cache content and answer http requests from clients.

> Important: Microsoft does not guarantee that this role won't conflict with other applications on the server that also use this feature. So, it is not recommended to install this on servers where this conflict would occur.

- To avoid conflicts or issues, this role should not exist already or b preinstalled on Distribution Points prior to enabling them for Connected Cache within the MECM console
- MECM will automatically install and configure the role

### Proxy Servers for Internet Access

Connected Cache can use an unauthenticated proxy server for its internet access.

### Limit Roles on the Connected Cache Server

It is not recommended to configure a Distribution Point for Connected Cache if it has other MECM Site roles (i.e. Management Point). Connected Cache should only be enabled on standalone Distribution Points.

### Cache Drive

#### Size

Disk space required for each Connected Cache server may vary based on organizational requirements. The default space of 100 GB should be enough for the following:

- A feature update
- 2 - 3 months of quality and Microsoft 365 App updates
- Microsoft Intune apps and Windows inbox apps

#### Behavior

- Selecting Automatic will honor the NO_SMS_ON_DRIVE.SMS file and exclude cache content from these drives.
- Selecting a specific drive will NOT honor the NO_SMS_ON_DRIVE.SMS file and include cache content on the specified drive.
  - This is an ideal scenario if you wanted to isolate a single drive to be used ONLY by Connected Cache so MECM will ignore the drive but Connected Cache will not

### Memory and Processor

The Connected Cache server should not consume much system memory or processor time. If you experience significant resource consumption, analyze the IIS and ARR log files for more details.

### Log File Size

The IIS and ARR log files can generate a large amount of data depending on their usage. These logs should follow the best practices for cleanup and management which can be found here: [Managing IIS log file storage](https://learn.microsoft.com/en-us/iis/manage/provisioning-and-managing-iis/managing-iis-log-file-storage#overview)

### Peer-to-Peer Caching

Peer-to-peer caching for Delivery Optimization allows devices to chare content with each other when they share the same subnet. In order to enable or disable this feature, you would simply configure the following client setting in MECM:

| Client Settings Tab | Setting Name | Enabled | Disabled |
|-|-|-|-|
| Delivery Optimization | Use Configuration Manager Boundary Groups for Delivery Optimization Group ID | Yes | No |

<br>

## Prerequisites

To implement this feature, you will need to meet the following prerequisites:

### Licensing

Each device that gets content from a Connected Cache-enabled Distribution Point needs one of the following licenses.

- Windows Enterprise E3 or E5, included in Microsoft 365 F3, E3, or E5
- Windows Education A3 or A5, included in Microsoft 365 A3 or A5
- Windows Virtual Desktop Access (VDA) E3 or E5

### Distribution Point

Connected Cache with Configuration Manager requires the following:

- An On-premises Distribution Point
- Microsoft .NET Framework 4.7.2 or later
- Default Website enabled on port 80
- IIS Application Request Routing (ARR)
  - DO NOT Preinstall. Here for informational purposes.

### Network Access

Distribution Points

- Internet access to the Microsoft Cloud CDN endpoints for caching content. See: [Internet Access Requirements](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/network/internet-endpoints)
- Accesss to the endpoints for Co-managed and Intune Win32 apps. See: [Network Requirements for PowerShell Scripts and Win32 Apps](https://learn.microsoft.com/en-us/mem/intune-service/fundamentals/intune-endpoints#network-requirements-for-powershell-scripts-and-win32-apps)

Clients

- Access to the Distribution Point (HTTP/HTTPS)
- Must be a member of a Boundary Group with a Connected Cache enabled Distribution Point
- Access to the Microsoft Cloud CDN endpoints for direct content access (if you want clients to fallback to internet)

<br>

## Design

The following table will help outline some design decisions that need to be made prior to implementation:

|

<br>

## Implement

The following information provides step-by-step instructions on how to implement this solution within your MECM environment.

### Server Configuration

1. Open the Configuration Manager console
2. Navigate to: \Administration\Overview\Distribution Points
3. Right Click a Distribution Point
4. Click Properties
5. On the General tab, configure the following
   - [X] Enable this distribution point to be used as Microsoft Connected Cache server
   - [X] By checking the box, I confirm that I have the required license subscription
   - Local drive to be used: [DriveLetter]
   - Disk space: [GB/Percentage] [Number]
   - [X] Retain cache when disabling the Connected Cache server
6. Click OK

> Proceed to the Validate section for information on validating the server installation and operation

### Client Settings Policy

1. Open the Configuration Manager console
2. Navigate to: \Administration\Overview\Client Settings
3. You can do one of the following:
   - Create a new client setting (for testing/validation)
   - Edit an existing client setting (will likely affect production machines)
4. Enable the Delivery Optimization tab
5. On the Delivery Optimization tab, make the following configurations:
   - [ ] Use Configuration Manager Boundary Groups for Delivery Optimization Group ID
     - Only Required if you want to enable peer-to-peer caching (see above)
   - [X] Enable devices managed by Configuration Manager to use Microsoft Connected Cache servers for content download
6. If applicable, deploy the Client Setting policy to target devices

> Proceed to the Validate section for information on validating the client configuration and operation

<br>

## Validate

Once enabled, you will want to validate that the role is functioning properly before marking the change as production worthy.

### Server

#### Log Files

| Log | Log Type | Location | Path |
|-|-|-|-|
| Application Request Routing (ARR) | Install | Log Distribution Point | ```%temp%\arr_setup.log``` |
| Connected Cache | Install | Distribution Point | ```\\<servername>\SMS_DP$\Ms.Dsp.Do.Inc.Setup\DoincSetup.log```|
| Connected Cache | Install | Management Point | ```\\<servername>\SMS_<sitecode>\Logs\DistMgr.log``` |
| Connected Cache | Operational | All | ```%SystemDrive%\Doinc\Product\Install\Logs```|
| IIS | Operational | All | ```%SystemDrive%\inetpub\logs\LogFiles``` |


### Client

#### Configuration

First, you will want to validate the target device has the correct resultant client settings:

1. Open the Configuration Manager consol
2. Navigate to: \Assets and Compliance\Overview\Devices
3. Right click the device
4. Select Client Settings\Resultant Client Settings
5. Ensure the desired configuration appears on the Delivery Optimization tab
   - If it does not, you need to ensure deployment is properly targeted and that there is not a conflict with other client settings policies and their priority order
6. Click OK

#### Operation

TODO

<br>

## Monitor

TODO

<br>

# Appendices

A collection of sections that provide detailed explanation or understanding to the above topic but are not necessary within the main body of the topic.



## Apdx A: References

The following items are referenced in the code within this document. Familiarize yourself with them before moving on.

| Name                  | Type                        | Description                                                                                                       | Link |
|-----------------------|-----------------------------|-------------------------------------------------------------------------------------------------------------------|------|
| Microsoft Connected Cache with Configuration Manager | Documentation |  | [Microsoft Learn](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/microsoft-connected-cache) |
| Troubleshoot Microsoft Connected Cache with Configuration Manager | Documentation |  | [Microsoft Learn](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/deploy/configure/troubleshoot-microsoft-connected-cache) |
| Delivery Optimization | Documentation               | | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/deployment/do/waas-delivery-optimization) |
| Application Request Routing (ARR) | IIS Role        | This is the technology behind how delivery optimization works on Connected Cache servers. | [Microsoft Learn](https://learn.microsoft.com/en-us/iis/extensions/planning-for-arr/application-request-routing-version-2-overview) |

<br>

## Apdx B: Automation

### PowerShell

TODO

#### Script

```powershell
```

### Configuration Manager SDK

TODO

#### Script

```c#
```

<br>

## Apdx C: Error Codes

| Code | Description |
|-|-|
| 0x00000000 | Success |
| 0x00000BC2 | Success, reboot required |
| 0x00000643 | Generic install failure |
| 0x00D00001 | Connected Cache setup can only be run if Internet Information Services (IIS) has been installed |
| 0x00D00002 | Connected Cache setup can only be run if a 'Default Web Site' exists on the server |
| 0x00D00003 | You can't install Connected Cache if Application Request Routing (ARR) is already installed |
| 0x00D00004 | Connected Cache setup can only be run if Application Request Routing (ARR) was installed by the Install.ps1 script |
| 0x00D00005 | Connected Cache setup requires a PowerShell session running as Administrator |
| 0x00D00006 | Connected Cache setup can only be run from a 64-bit PowerShell environment |
| 0x00D00007 | Connected Cache setup can only be run on a Windows Server |
| 0x00D00008 | Failure: The number of cache drives specified must match the number of cache drive size percentages specified |
| 0x00D00009 | Failure: A valid cache node ID must be supplied |
| 0x00D0000A | Failure: A valid cache drive set must be supplied |
| 0x00D0000B | Failure: A valid cache drive size percent set must be supplied |
| 0x00D0000C | Failure: A valid cache drive size percent set or cache drive size in GB must be supplied |
| 0x00D0000D | Failure: A valid cache drive size percent set and cache drive size in GB cannot both be supplied |
| 0x00D0000E | Failure: The number of cache drives specified must match the number of cache drives size in GB specified |
| 0x00D0000F | Failure: Couldn't back up the applicationhost.config file from $AppHostConfig to $AppHostConfigDestinationName |
| 0x00D00010 | Failure: Couldn't back up the Default Web Site web.config file from $WebsiteConfigFilePath to $WebConfigDestinationName |
| 0x00D00011 | Failure: An exception occurred in SetupARRWebFarm.ps1 |
| 0x00D00012 | Failure: An exception occurred in SetupARRWebFarmRewriteRules.ps1 |
| 0x00D00013 | Failure: An exception occurred in SetupARRWebFarmProperties.ps1 |
| 0x00D00014 | Failure: An exception occurred in SetupAllowableServerVariables.ps1 |
| 0x00D00015 | Failure: An exception occurred in SetupFirewallRules.ps1 |
| 0x00D00016 | Failure: An exception occurred in SetupAppPoolProperties.ps1 |
| 0x00D00017 | Failure: An exception occurred in SetupARROutboundRules.ps1 |
| 0x00D00018 | Failure: An exception occurred in SetupARRDiskCache.ps1 |
| 0x00D00019 | Failure: An exception occurred in SetupARRProperties.ps1 |
| 0x00D0001A | Failure: An exception occurred in SetupARRHealthProbes.ps1 |
| 0x00D0001B | Failure: An exception occurred in VerifyIISSItesStarted.ps1 |
| 0x00D0001C | Failure: An exception occurred in SetDrivesToHealthy.ps1 |
| 0x00D0001D | Failure: An exception occurred in VerifyCacheNodeSetup.ps1 |
| 0x00D0001E | You can't install Connected Cache if the Default Web Site isn't on port 80 |
| 0x00D0001F | Failure: The cache drive allocation in percentage can't exceed 100 |
| 0x00D00020 | Failure: The cache drive allocation in GB can't exceed the drive's free space |
| 0x00D00021 | Failure: The cache drive allocation in percentage must be greater than 0 |
| 0x00D00022 | Failure: The cache drive allocation in GB must be greater than 0 |
| 0x00D00023 | Failure: An exception occurred in RegisterScheduledTask_CacheNodeKeepAlive |
| 0x00D00024 | Failure: An exception occurred in RegisterScheduledTask_Maintenance |
| 0x00D00025 | Failure: An exception occurred setting up the rewrite rules for HTTPS farm: $FarmName |
| 0x00D00026 | Failure: An exception occurred setting up the rewrite rules for HTTP farm: $FarmName |
| 0x00D00027 | You can't install Connected Cache because dependent software "Application Request Routing (ARR)" failed to install. See the log file located at %temp%\arr_setup.log |