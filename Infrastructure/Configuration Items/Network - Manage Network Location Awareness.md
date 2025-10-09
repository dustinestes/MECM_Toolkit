# MECM Toolkit - Configuration Items - Network - Manage Network Location Awareness

Network Location Awareness is the service within Windows that determines what type of network the device is connected to. It determines whether a device is connected to a Domain, Private, or Public network and then assigns this profile to the connection. Along with this profile assignment comes some important configurations such as the Windows Firewall which can behave very differently based on the type of network.

There exists a race condition wherein a device can boot up and assign a profile before all services are able to startup or communicate effectively resulting in an incorrect profile asignment. This profile assignment will remain until an event is seen where the network connection changes. This is not ideal for devices like servers or workstations that remain plugged in. Therefore, it may be necessary to create a scheduled task that can monitor the connection profile to ensure the desired state is achieved.

<br>

## Table of Contents

- [MECM Toolkit - Configuration Items - Network - Manage Network Location Awareness](#mecm-toolkit---configuration-items---network---manage-network-location-awareness)
  - [Table of Contents](#table-of-contents)
  - [Configuration Item](#configuration-item)
    - [Usage](#usage)
    - [Parameters](#parameters)
    - [Script](#script)
- [Appendices](#appendices)
  - [Appendix A: \[Name\]](#appendix-a-name)


## Configuration Item

Use this snippet to perform discovery and remediation as part of a Configuration Item and Baseline.

### Usage

The script is written using the multipurpose template so you only have to change the Operation Type parameter to suit both the Discovery and Remediation scenarios.

1. Copy script to discovery/remediation section of a Configuration Item
2. Change the parameter value of $Operation_Type to match the operation being performed
3. Do this for both types of operations
4. Save and test

### Parameters

There are other parameters in the script, but only the ones listed below should be modified to address your use-case.

| Name | Type | Description | Example Value |
|-|-|-|-|
| Operation_Type | String | Tells the script whether its performing discovery operations or remediation operations. | Discovery/Remediation |
| MECMClient_Cache_OlderThanDays | Integer | Used to pass a positive integer representing how old (in number of days) that content is based on when it was downloaded. | 25 |

### Script


```powershell

```

<br>

# Appendices

## Appendix A: [Name]

[Description]