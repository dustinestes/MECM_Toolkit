# MECM Toolkit - Client - References - Error Codes

&nbsp;

## References

The following items are referenced in the code within this document. Familiarize yourself with them before moving on.

| Name                  | Type                        | Description                                                                                                       | Link |
|-----------------------|-----------------------------|-------------------------------------------------------------------------------------------------------------------|------|
| CCMSetup Return Codes | Documentation               | Provides information about the potential return codes for the CCMSetup installer.                                 | [Microsoft Learn](https://learn.microsoft.com/en-us/mem/configmgr/core/clients/deploy/about-client-installation-properties#ccmsetupReturnCodes) |

&nbsp;

## Table of Contents

- [MECM Toolkit - Client - References - Error Codes](#mecm-toolkit---client---references---error-codes)
  - [References](#references)
  - [Table of Contents](#table-of-contents)
- [CCMSetup.exe](#ccmsetupexe)
- [Appendices](#appendices)
  - [Apdx A: \[Name\]](#apdx-a-name)

&nbsp;

# CCMSetup.exe

Return codes related to the specified executable.

| Exit Code  | Source        | Description                                                                                                                                                                             | Possible Resolution                                                                              |
|------------|---------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------|
| 0          |               | Success
| 2          |               | The system cannot find the file specified<br>This error occur when the WMI service is corrupt                                                                                           | Technet Resolution<br>WMI Repair                                                                 |
| 5          |               | Access denied                                                                                                                                                                           | Make sure that the installation account is member of the Administrator Group                     |
| 6          |               | Error                                                                                                                                                                                   |                                                                                                  |
| 7          |               | Reboot Required                                                                                                                                                                         |                                                                                                  |
| 8          |               | Setup Already Running                                                                                                                                                                   |                                                                                                  |
| 9          |               | Prerequisite evaluation failure                                                                                                                                                         |                                                                                                  |
| 10         |               | Setup manifest hash validation failure                                                                                                                                                  |                                                                                                  |
| 52         |               | You were not connected because a duplicate name exists on the network                                                                                                                   | Check for duplicate name in DNS (IP)                                                             |
| 52         |               | You were not connected because a duplicate name exists on the network                                                                                                                   | Check for duplicate name in DNS (IP)                                                             |
| 53         |               | Unable to locate<br>Cannot connect to admin$<br>Computer Browser not started                                                                                                            | Add File & Print sharing to Exceptions in Firewall<br>Turn file And print Sharing on<br>KB920852 |
| 58         |               | The specified server cannot perform the requested operation                                                                                                                             |                                                                                                  |
| 64         | Windows       | The specified network name is no longer available                                                                                                                                       |                                                                                                  |
| 67         |               | Network name cannot be found                                                                                                                                                            | Check if client has a DNS entry or invalid DNS                                                   |
| 86         |               | Incorrect network configuration                                                                                                                                                         |                                                                                                  |
| 112        |               | Not enough disk space                                                                                                                                                                   | Free some space on the computer                                                                  |
| 1003       |               | Cannot complete this function                                                                                                                                                           |                                                                                                  |
| 1053       |               | The service did not respond to the start or control request in a timely fashion                                                                                                         |                                                                                                  |
| 1068       |               | The dependency service or group failed to start                                                                                                                                         |                                                                                                  |
| 1130       | Windows       | Not enough server storage is available to process this command                                                                                                                          |                                                                                                  |
| 1203       |               | The network path was either typed incorrectly, does not exist, or the network provider is not currently available<br>Please try retyping the path or contact your network administrator |                                                                                                  |
| 1208       | Windows       | An extended error has occurred                                                                                                                                                          |                                                                                                  |
| 1305       |               | The revision level is unknown                                                                                                                                                           |                                                                                                  |
| 1396       | Login Failure | The target account name is incorrect                                                                                                                                                    | Check for duplicate name in DNS (IP)<br>NBTSTAT -a reverse lookup                                |
| 1450       | Windows       | Insufficient system resources exist to complete the requested service                                                                                                                   |                                                                                                  |
| 1603       |               | CCMExec could not be stopped                                                                                                                                                            | Reboot and install the client as administrator                                                   |
| 1618       | MSI           | This error is cause by a multiple client.msi installation at the same time                                                                                                              | Stop all related MSI install process                                                             |
| 1789       |               | The trust relationship between this workstation and the primary domain failed                                                                                                           | KB2771040                                                                                        |
| 12002      |               | Failed to send HTTP Request                                                                                                                                                             | Check firewall ports                                                                             |
| 8007045D   | MSI           | Setup was unable to create the WMI namespace CCM                                                                                                                                        | Delete all SCCM folders and rebuilt wmi Repository                                               |
| 800706BA   | WMI           | Unable to connect to WMI on remote machine                                                                                                                                              | Prajwal Desai post                                                                               |
| 80041001   | MSI           | Setup was unable to create the WMI namespace CCM<br>Warning 25101. Setup was unable to delete WMI namespace CIMV2\SMS                                                                   | WMI Repair                                                                                       |
| 8004103B   | WMI           | Unable to create the WMI Namespace                                                                                                                                                      | Rebuild WMI Repository                                                                           |
| 80070070   |               | Setup failed due to unexpected circumstances                                                                                                                                            | Rebuild WMI Repository                                                                           |
| 87D0029E   | WMI           | CCMSetup Failed                                                                                                                                                                         | Prajwal Desai post                                                                               |
| 2147023174 |               | The RPC server is unavailable                                                                                                                                                           | Check out firewall or AntiVirus                                                                  |
| 2147024891 |               | Access is denied                                                                                                                                                                        |                                                                                                  |
| 2147749889 | WMI           | Generic failure                                                                                                                                                                         |                                                                                                  |
| 2147749890 | WMI           | Not found                                                                                                                                                                               | WMI Repair                                                                                       |
| 2147749904 | WMI           | Invalid class                                                                                                                                                                           |                                                                                                  |
| 2147749908 | WMI           | Initialization failure                                                                                                                                                                  |                                                                                                  |
| 2147942405 |               | Access is Denied                                                                                                                                                                        | Missing Firewall rules<br>MacAfee-HIPS                                                           |
| 2147944122 |               | The RPC server is unavailable                                                                                                                                                           | KB899965<br>Dcom is miss-configured for security                                                 |
| 2148007941 |               | Server Execution Failed                                                                                                                                                                 |                                                                                                  |

&nbsp;

# Appendices

A collection of sections that provide detailed explanation or understanding to the above topic but are not necessary within the main body of the topic.

## Apdx A: [Name]

[Text]