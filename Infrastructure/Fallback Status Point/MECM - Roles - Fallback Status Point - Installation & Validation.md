# MECM - Roles - Fallback Status Point - Installation & Validation

---
## About
---

You can use a fallback status point to monitor client deployments targeted to Windows computers. This can help identify the Windows computer clients that are unmanaged because they can't communicate with a management point.

> Note: A fallback status point isn't required to monitor client activity and client health.

The following client types don't use a fallback status point:

- Mac computers
- Mobile devices that are enrolled by Configuration Manager
- Mobile devices that are managed by using the Exchange Server connector

The fallback status point always communicates with clients over HTTP using unauthenticated connections and sending data in clear text. This makes the fallback status point vulnerable to attacks. It is recommended you always dedicate a server to running the fallback status point and never install the role with other site system roles on the same server.

&nbsp;

---
## Prerequisites
---

### Roles and Features

The following roles and features need to be installed on the target FSP site system prior to adding the site system to the hierarchy and installing the MECM role.

- Web Server (IIS)
  > Include all defaults
  -  IIS 6 Management Compatilibility  -  IIS 6 Metabase Compatibility
  -  IIS 6 WMI Compatibility
- BITS IIS Server Extension

&nbsp;

### Specific Drive Installation

If you want to ensure any MECM role is not installed on a specific drive of the site ystem, perform the following:

1. Add an empty file with the following name/extension to the root of each drive you DO NOT want the FSP to utilize:
   - NO_SMS_ON_DRIVE.SMS
2. Set the file to hidden to reduce likelihood of accidental deletion

&nbsp;

---
## Ports
---

&nbsp;

---
## Installation
---

Once the prerequisites are met and the ports are open for communication, you can install the role.

1. Open the MECM Console
2. Navigate to: \Administration\Overview\Site Configuration\Servers and Site System Roles
3. Click Create Site System Server
4. Follow the wizard providing the data necessary to install the FSP role
5. Utilize the troubleshooting section below to determine if the installation was successful or not

&nbsp;

---
## Validation
---

### FSP Role Installation

These logs can be monitored to determine the status of the Role installation.

1. Open the below Log(s)
2. Monitor for the Success Messages associated with each Log

| Log Name        | Server                 | Folder       | Description                                             | Success Messages                                                                                                                                                                                                               |
|-----------------|------------------------|--------------|---------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| SMSFSPSetup.log | FSP Site System Server | C:\SMS\Logs\ | Tracks installation of the FSP prerequisites and role.  | Installing the SMSFSP<br>fsp.msi exited with return code 0<br>Installation was successful                                                                                                                                      |
| fsmMSI.log      | FSP Site System Server | C:\SMS\Logs\ | Tracks the MSI specific log output of the installation. | Windows Installer installed the product. Product Name: ConfigMgr Fallback Status Point. Product Version: 5.00.9096.1000. Product Language: 1033. Manufacturer: Microsoft Corporation. Installation success or error status: 0. |

&nbsp;

### Client Agent Installation Logs

Once the role is installed, you can test the functionality of the FSP server by attempting to install a client agent on an endpoint.

> CCMSetup.exe SMSSITECODE=[sitecode] FSP=[servername]

1. Attempt to install the client using the command line above (or the properties using client push installation)
2. Open the below Log(s)
3. Monitor for the Success Messages associated with each Log

| Log Name     | Server                | Folder                   | Description                                   | Success Messages                                                                                          |
|--------------|-----------------------|--------------------------|-----------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| ccmsetup.log | Client Agent Endpoint | C:\Windows\ccmsetup\Logs | Tracks installation of the MECM Client Agent. | Sending Fallback Status Point message to '[servername]'<br>State message with... has been sent to the FSP |
|              |                       |                          |                                               |                                                                                                           |              |                       |                          |                                               |                  |

&nbsp;

### FSP Site System Server Functionality

Once a client has submitted state messages to the FSP, you can check the FSP server logs to ensure it has received them and has successfully forwarded the messages.

> Note: that the FSP Manager scans and sends files on a 1-hour interval. You can force it to run immediately by using the Configuration Manager Service Manager tool to stop/start the SMS_Fallback_STATUS_POINT service on the FSP server.

#### Check for State Message Receipt

You can check for the presence of state message files.

> Note: These files may be transferred before you have time to check, depending on if the process has run or not. Check the log in the below step to see if the files were transferred before you could check for their presence.

1. Open the State Message staging folder: C:\Windows\CCM\FSPStaging
2. Check for the existence of state messages sent to the FSP by the recently installed client

#### Check for State Message Transfer

1. Open the below Log(s)
2. Monitor for the Success Messages associated with each Log

> To force the FSP to transfer the current messages, perform the following:
>
> 1. Open Configuration Manager Service Manager
> 2. Expand the node for the FSP Site System
> 3. Stop/Start the SMS_FALLBACK_STATUS_POINT service
> 4. Then check the logs to ensure the files were copied successfully

| Log Name   | Server                 | Folder       | Description                                                      | Success Messages                       |
|------------|------------------------|--------------|------------------------------------------------------------------|----------------------------------------|
| fspmgr.log | FSP Site System Server | C:\SMS\Logs\ | Tracks the FSP role for start/stop as well file copy operations. | Successfully copied X out of X file(s) |
|            |                        |              |                                                                  |                                        |


&nbsp;

---
## Related Reports
---

&nbsp;

---
## Troubleshooting
---

### Behavior Scenarios

The following scenarios and role behavior may help you pinpoint any issues you are having with the role:

#### Unsuccessful Install

If you simply just install IIS  without the components, the install not complete successfully.

### Successfull Install but Unsuccessful State Messages

With IIS 6 Management Compatibility installed, the FSP will insall but will not work correctly. Client state messages will fail to reach the FSP due to the missing IIS components required to communicate.

&nbsp;

---
## Appendix
---

### Registry Locations

The below registry locations were discovered on a server running the FSP role.

> Note: There may be more locations than this. This list is an attempt to reference only those locations that contain information about the role, its configuration, and relevant information.

| Registry Path                                                                                                                         | Location            | Description                                                                                                                                                 |
|---------------------------------------------------------------------------------------------------------------------------------------|---------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\                                                                             | FSP Site System     | This is a standard MSI installation entry created during the FSP role installation.                                                                         |
| HKLM\SOFTWARE\Microsoft\CCM\FSP                                                                                                       | Primary Site Server | Shows HostName and IntranetHostName of FSP role provider(s).                                                                                                |
| HKLM\SOFTWARE\Microsoft\CCM\Logging\FSPStateMessage                                                                                   | FSP Site System     | Defines the LogPath for the state message logging. (See the @Global key for the LogDirectory where this log file will be maintained)                        |
| HKLM\SOFTWARE\Microsoft\SMS\COMPONENTS\SMS_SITE_COMPONENT_MANAGER\Component Servers\[servername]\Components\SMS_FALLBACK_STATUS_POINT | Primary Site Server | Provides FSP component information.                                                                                                                         |
| HKLM\SOFTWARE\Microsoft\SMS\COMPONENTS\SMS_EXECUTIVE\Threads\SMS_FALLBACK_STATUS_POINT                                                | FSP Site System     | Provides information regarding the component's current state, startup type, DLLs, etc.                                                                      |
| HKLM\SOFTWARE\Microsoft\SMS\Operations Management\Components\SMS_FALLBACK_STATUS_POINT                                                | FSP Site System     | Provides install state and monitoring configuration for OM.                                                                                                 |
| HKLM\SOFTWARE\Microsoft\SMS\Operations Management\SMS Server Role\SMS Fallback Status Point                                           | FSP Site System     | Provides availability state, site code, and version of the FSP for monitoring.                                                                              |
| HKLM\SOFTWARE\Microsoft\SMS\Tracing\SMS_FALLBACK_STATUS_POINT                                                                         | FSP Site System     | Defines the logging configurations for the FSP role: enabled, debug, logginglevel, max history, max size, file name.                                        |
| HKLM\SOFTWARE\Microsoft\SMS\IIS                                                                                                       | Primary Site Server | Note sure. Seems to indicate roles installed that are using the IIS feature. Property exists called "FSPCWSId" alongside properties for MP, DP, and others. |
| HKLM\SOFTWARE\Microsoft\SMS\FSP                                                                                                       | FSP Site System     | Provides the configuration of the FSP Role, install dir, IIS configurations, state message outbox path, etc.                                                |
| HKLM\SOFTWARE\Microsoft\SMS\FSP\Logging\fspisapi                                                                                      | FPS Site System     | Defines the logging location for the fspisapi component of the FSP role.                                                                                    |
|                                                                                                                                       |                     |                                                                                                                                                             |
|                                                                                                                                       |                     |                                                                                                                                                             |

### Folder Locations

C:\Windows\CCM\FSPStaging
C:\Windows\CCM\SMS_FSP