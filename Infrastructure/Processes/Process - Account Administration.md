# MECM Toolkit - Processes - Administration - Reset Service Account Passwords

| Author: Dustin Estes  |  Date: 2017-06-03  |  Metadata: MECM, Password, Reset, Service Account |

&nbsp;

## Introduction

This process document outlines how to reset the service account passwords for all components that are traditionally integrated into an MECM environment.

> Note: Any 3rd party integrations or custom solutions will not be included here since it is impossible to account for all unknown possibilities.

&nbsp;

## Table of Contents

- [MECM Toolkit - Processes - Administration - Reset Service Account Passwords](#mecm-toolkit---processes---administration---reset-service-account-passwords)
  - [Introduction](#introduction)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
  - [Service Accounts](#service-accounts)
- [Process](#process)
  - [Reset Passwords](#reset-passwords)
  - [Update Applications with New Password](#update-applications-with-new-password)
    - [SQL Server Accounts](#sql-server-accounts)
      - [SQL Server Database Engine service](#sql-server-database-engine-service)
      - [SQL Server Agent service](#sql-server-agent-service)
      - [SQL Server Reporting Services](#sql-server-reporting-services)
    - [MECM Accounts](#mecm-accounts)
      - [MECM Installation](#mecm-installation)
      - [Proxy Internet Access](#proxy-internet-access)
      - [Network Access](#network-access)
      - [Domain Join](#domain-join)
      - [MECM Client Push Installation](#mecm-client-push-installation)
- [Apdx A: Script Snippets](#apdx-a-script-snippets)
  - [Update All SQL Accounts](#update-all-sql-accounts)
    - [Snippet](#snippet)
    - [Sample Output](#sample-output)
  - [Update All MECM Accounts](#update-all-mecm-accounts)
    - [Snippet](#snippet-1)
    - [Sample Output](#sample-output-1)
  - [Get All Site Systems with Proxy Server Configured](#get-all-site-systems-with-proxy-server-configured)
    - [Snippet](#snippet-2)
    - [Sample Output](#sample-output-2)
  - [Get All Task Sequences with an "Apply Network Settings Action" Step](#get-all-task-sequences-with-an-apply-network-settings-action-step)
    - [Snippet](#snippet-3)
    - [Sample Output](#sample-output-3)
- [Apdx B: Event Logs](#apdx-b-event-logs)
  - [SQL Server Events](#sql-server-events)
    - [SQL Server Database Engine service](#sql-server-database-engine-service-1)
    - [SQL Server Agent service](#sql-server-agent-service-1)
    - [SQL Server Reporting Services](#sql-server-reporting-services-1)
    - [General](#general)
      - [Details](#details)
  - [MECM Events](#mecm-events)

&nbsp;

## Prerequisites

The following prerequisites are needed before performing any of the below processes.

1. You must be an MECM Administrator (where MECM accounts are concerned)
2. You must be a SQL Administrator (where SQL accounts are concerned)

&nbsp;

## Service Accounts

Below is a table providing some basic information about every recommended service account and where it would be applied.

> Note: Environments vary so you will need to determine what accounts your organziation has associated to each Usage below and then reset the passwords and perform the udpates accordingly.

| Name                 | Usage                                                 | Description                                                                                                                                       | Locations                                                                                                                |
|----------------------|-------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| MECM.EnterpriseAdmin | MECM Installation                                     | Used to initially install the MECM Site and as an enterprise administration account in case of emergency.                                         | None. Should only be used to install MECM.                                                                               |
| MECM.SQLServer       | SQL Server Database Engine service                    | SQL Server Services account used as the log on account for the database instance.                                                                 | SQL Server Configuration Manager:<br>SQL Server Services\SQL Server ([InstanceName])                                     |
| MECM.SQLServerAgent  | SQL Server Agent service                              | SQL Server Services account used as the log on account for the server agent.                                                                      | SQL Server Configuration Manager:<br>SQL Server Services\SQL Server Agent ([InstanceName])                               |
| MECM.SQLReporting    | SQL Server Reporting Services                         | SQL Reporting Services account used to read data inside the MECM database when generating reports.                                                | Report Server Configuration Manager:<br>  - Service Account node<br>  - Database node                                    |
| MECM.SiteServerProxy | Proxy Internet Access                                 | Used to configure the site servers with access to the internet through an internet proxy server.                                                  | MECM Console:<br>\Administration\Overview\Site Configuration\Servers and Site System Roles                               |
| MECM.NetworkAccess   | Network Access                                        | Used during OSD to access content from DPs before the device joins the domain. Also used by Workgroup devices and devices from untrusted domains. | MECM Console:<br>\Administration\Overview\Site Configuration\Sites\Configure Site Components\Software Distribution       |
| MECM.DomainJoin      | Domain Join                                           | Used during OSD/Task Sequences to join the device to the domain.                                                                                  | MECM Console:<br>\Software Library\Overview\Operating Systems\Task Sequences                                             |
| MECM.ClientPush      | MECM Client Push Installation                         | Used as the Client Push Installation account and should have local admin access to the target devices.                                            | MECM Console:<br>\Administration\Overview\Site Configuration\Sites\Client Installation Settings\Client Push Installation |

&nbsp;

# Process

## Reset Passwords

This process is not included in here because it differs between organizations. This section is here merely to illustrate where in the process it would need to occur.

&nbsp;

## Update Applications with New Password
These steps don't necessarily have to be performed in any order. However, the below steps are laid out in a kind of "ground up" order so that everything from the SQL base up to the MECM accounts are updated in the order in which they may be used.

### SQL Server Accounts

If necessary, you can find some detailed information at the following link(s).

- [SQL Configuration Manager - Change the Password of the Accounts Used](https://learn.microsoft.com/en-us/sql/database-engine/configure-windows/scm-services-change-the-password-of-the-accounts-used?view=sql-server-ver16)
- [Best practices for changing the service account for the report server in SQL Server Reporting Services](https://learn.microsoft.com/en-us/troubleshoot/sql/reporting-services/best-practices-change-service-account)

#### SQL Server Database Engine service

> Note: The password takes effect immediately, without restarting SQL Server.

1. Open SQL Server Configuration Manager
2. Click the SQL Server Services node in the navigation pane
3. Right click "SQL Server ([InstanceName])
4. Click Properties
5. On the Log On tab, perform the following:
   1. Enter the new password in the "Password" field
   2. Enter the new password in the "Confirm Password" field
   3. Click OK
6. Done

#### SQL Server Agent service

> Note: On a stand-alone instance of SQL Server, the password takes effect immediately, without restarting SQL Server. On a clustered instance, SQL Server might take the SQL Server resource offline, and require a restart.

1. Open SQL Server Configuration Manager
2. Click the SQL Server Services node in the navigation pane
3. Right click "SQL Server Agent ([InstanceName])
4. Click Properties
5. On the Log On tab, perform the following:
   1. Enter the new password in the "Password" field
   2. Enter the new password in the "Confirm Password" field
   3. Click OK
6. Done

#### SQL Server Reporting Services

1. Open Reporting Services Configuration Manager
2. Connect to the instance of SQL Server Reporting Services
3. Click the Service Account node in the navigation pane
4. Change the password in the Report Server Service Account section
5. Click Apply
6. Click the Database node in the navigation pane
7. Change the password in the Current Report Server Database Credential
8. Click Apply
9. Click the Server node in the navigation pane
10. Click Stop
11. Click Start (after waiting a few seconds)
12. Done

### MECM Accounts

If necessary, you can find some detailed information at the following link(s).

- [SQL Configuration Manager - Change the Password of the Accounts Used](https://learn.microsoft.com/en-us/sql/database-engine/configure-windows/scm-services-change-the-password-of-the-accounts-used?view=sql-server-ver16)
- [Best practices for changing the service account for the report server in SQL Server Reporting Services](https://learn.microsoft.com/en-us/troubleshoot/sql/reporting-services/best-practices-change-service-account)

#### MECM Installation

> Because this account should only be used to install the MECM environment, it will not be configured on any of the individual services or components. Therefore, nothing else should e done after resetting the password in Active Directory.

1. Do Nothing
2. Done

#### Proxy Internet Access

You can run the PowerShell snippet in the appendix section to get back a list of the site system servers in your environment that have roles utilizing the a Proxy Internet configuration. The output will also provide detailed properties to show which ones are actually using defined accounts or ones that are using.

- [Get All Site Systems With Proxy Server Configured](#get-all-site-systems-with-proxy-server-configured)

1. Open the MECM Console
2. Click the Administration workspace
3. Expand the Security node
4. Click Accounts
5. Right click the Proxy Internet Access account
6. Click Properties
7. Click Set
8. On the User Account window, perform the following:
   1. Enter the new password in the Password field
   2. Reenter the new password in the Confirm Password field
   3. (Optional) You can use the verify feature if needed
   4. Click OK
9.  Click OK
10. Done

#### Network Access

1. Open the MECM Console
2. Click the Administration workspace
3. Expand the Security node
4. Click Accounts
5. Right click the Network Access account
6. Click Properties
7. Click Set
8. On the User Account window, perform the following:
   1. Enter the new password in the Password field
   2. Reenter the new password in the Confirm Password field
   3. (Optional) You can use the verify feature if needed
   4. Click OK
9.  Click OK
10. Done

#### Domain Join



1. Open the MECM Console
2.

#### MECM Client Push Installation

1. Open the MECM Console
2.


&nbsp;

# Apdx A: Script Snippets

&nbsp;

## Update All SQL Accounts

This code snippet will update all accounts used within the SQL environment.

> Note: You must run this in an administrative PowerShell instance.

### Snippet

```powershell
Set-Noun
```

### Sample Output

```

```
&nbsp;

## Update All MECM Accounts

This code snippet will update all accounts used within the MECM environment.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

### Snippet

```powershell
Set-Noun
```

### Sample Output

```

```

&nbsp;

## Get All Site Systems with Proxy Server Configured

This snippet will search the whole MECM site and iterate across site system servers looking for ones that are configured to use a proxy. If they are using a proxy, it will output the configuration details so you can see which ones are configured for the user account you need to update the password for.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

### Snippet

```powershell
# Input
    # None

# Get Data
    $Temp_Array = @()
    $MECM_SiteSystemServers_Object = Get-CMSiteSystemServer -AllSite

# Iterate Through Object
    foreach ($Item in $MECM_SiteSystemServers_Object) {
        $Temp_Object = $null
        $Temp_Object = [pscustomobject]@{
                "ServerName"           = $Item.NetworkOSPath.Replace("\\","")
                "UseProxy"              = $null
                "ProxyName"             = $null
                "ProxyServerPort"       = $null
                "AnonymousProxyAccess"  = $null
                "ProxyUserName"         = $null
        }
        foreach ($Property in $Item.Props) {
            switch ($Property.PropertyName) {
                "UseProxy" {if ($Property.Value -eq 0) {$Temp_Object.UseProxy = $false} else {$Temp_Object.UseProxy = $true}}
                "ProxyName" {$Temp_Object.ProxyName = $Property.Value2}
                "ProxyServerPort" {$Temp_Object.ProxyServerPort = $Property.Value}
                "AnonymousProxyAccess" {if ($Property.Value -eq 0) {$Temp_Object.AnonymousProxyAccess = $false} else {$Temp_Object.AnonymousProxyAccess = $true}}
                "ProxyUserName" {if ($Property.Value2 -in "",$null) {$Temp_Object.ProxyUserName = "Not Configured"} else {$Temp_Object.ProxyUserName = $Property.Value2}}
                default {}
            }
        }

        $Temp_Array += $Temp_Object
    }

# Output Data
    $Temp_Array | Where-Object -Property "UseProxy" -eq $true
```

### Sample Output

```
ServerName           : DEV-SRV-01.vividrock.com
UseProxy             : True
ProxyName            : 10.1.1.10
ProxyServerPort      : 1234
AnonymousProxyAccess : True
ProxyUserName        : Not Configured

ServerName           : DEV-SRV-02.vividrock.com
UseProxy             : True
ProxyName            : vr-proxy-01
ProxyServerPort      : 1234
AnonymousProxyAccess : false
ProxyUserName        : vividrock.com\proxyserviceaccount
```

&nbsp;

## Get All Task Sequences with an "Apply Network Settings Action" Step

This snippet will search the whole MECM site and iterate across all Task Sequences. It will then get and filter all steps so only the Apply Network Settings Steps are left. It then iterates over each of these steps and outputs the configuration data.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

### Snippet

```powershell
# Input
    # None

# Get Data
    $Temp_Array = @()
    $MECM_TaskSequences_Object = Get-CMTaskSequence -Fast

# Iterate Through Object
    foreach ($TaskSequence in $MECM_TaskSequences_Object) {
        # Clear Variables for Next Iteration
            $Temp_TaskSequence_Steps    = $null
            $Temp_Object                = $null

        # Get Steps for Task Sequence
            try {
                $Temp_TaskSequence_Steps = Get-CMTaskSequenceStep -InputObject $TaskSequence | Where-Object -Property "SmsProviderObjectPath" -eq "SMS_TaskSequence_ApplyNetworkSettingsAction" -ErrorAction Stop

                # Iterate Through Steps
                    foreach ($Step in $Temp_TaskSequence_Steps) {
                        $Temp_Object = [pscustomobject]@{
                            "TaskSequenceName"      = $TaskSequence.Name
                            "ObjectPath"            = $TaskSequence.ObjectPath
                            "StepName"              = $Step.Name
                            "DomainUserName"        = $Step.DomainUserName
                            "DomainName"            = $Step.DomainName
                            "DomainOUName"          = $Step.DomainOUName
                            "Enabled"               = $Step.Enabled
                            "Status"                = "Success"
                        }

                        # Add Custom Object to Array of Objects
                            $Temp_Array += $Temp_Object
                    }
            }
            catch {
                $Temp_Object = [pscustomobject]@{
                    "TaskSequenceName"      = $TaskSequence.Name
                    "ObjectPath"            = $null
                    "StepName"              = $null
                    "DomainUserName"        = $null
                    "DomainName"            = $null
                    "DomainOUName"          = $null
                    "Enabled"               = $null
                    "Status"                = "Error"
                }

                # Add Custom Object to Array of Objects
                    $Temp_Array += $Temp_Object
            }
    }

# Output Data
    $Temp_Array
```

### Sample Output

The below sample output illustrates how the script will create multiple entries for a single Task Sequence if it finds more than one Apply Network Settings step. You can see the last two objects have the same Task Sequence Name but different Step Names.

```
TaskSequenceName : TST - Install Windows 10 - v1.0.20
ObjectPath       : /2 - Testing/
StepName         : Join - Domain
DomainUserName   : VIVIDROCK\MECM.JoinDomain
DomainName       : VIVIDROCK.COM
DomainOUName     :
Enabled          : True
Status           : Success

TaskSequenceName : DEV - Install Windows 10 - v1.0.18
ObjectPath       : /1 - Development/
StepName         : Join - Domain (test.vividrock.com)
DomainUserName   : VIVIDROCK\MECM.JoinDomain
DomainName       : TEST.VIVIDROCK.COM
DomainOUName     :
Enabled          : True
Status           : Success

TaskSequenceName : DEV - Install Windows 10 - v1.0.18
ObjectPath       : /1 - Development/
StepName         : Join - Domain (prod.vividrock.com)
DomainUserName   : VIVIDROCK\MECM.JoinDomain
DomainName       : PROD.VIVIDROCK.COM
DomainOUName     :
Enabled          : True
Status           : Success
```

&nbsp;

# Apdx B: Event Logs

&nbsp;

## SQL Server Events

All events associated with an expired or incorrect password configured within the SQL environment.

### SQL Server Database Engine service

[ToBeFilledIn]

### SQL Server Agent service

[ToBeFilledIn]

### SQL Server Reporting Services

[ToBeFilledIn]

### General

| Field         | Value                   |
|---------------|-------------------------|
| Log Name      | Application             |
| Source        | SMS Server              |
| Date          | [datetime]              |
| Event ID      | 7402                    |
| Task Category | SMS_SRS_REPORTING_POINT |
| Level         | Error                   |
| Keywords      | Classic                 |
| User          | N/A                     |
| Computer      | [ServerFQDN]            |

On [MM]/[DD]/[YYYY] [HH]:[MM]:[SS] [AM/PM], component SMS_SRS_REPORTING_POINT on computer [ServerFQDN] reported:   Reporting Point failed to monitor SQL Reporting Services Server on "[ServerFQDN]".

#### Details

```xml
    <Event xmlns="http://schemas.microsoft.com/win/2004/08/events/event">
    <System>
        <Provider Name="SMS Server" />
        <EventID Qualifiers="49152">7402</EventID>
        <Level>2</Level>
        <Task>85</Task>
        <Keywords>0x80000000000000</Keywords>
        <TimeCreated SystemTime="[YYYY]-[MM]-[DD]T[HH]:[MM]:[SS].[MS]Z" />
        <EventRecordID>69488</EventRecordID>
        <Channel>Application</Channel>
        <Computer>[ServerFQDN]</Computer>
        <Security />
    </System>
    <EventData>
        <Data>[ServerFQDN]</Data>
        <Data>
        </Data>
        <Data>
        </Data>
        <Data>
        </Data>
        <Data>
        </Data>
        <Data>
        </Data>
        <Data>
        </Data>
        <Data>
        </Data>
        <Data>
        </Data>
        <Data>
        </Data>
        <Data>On [MM]/[DD]/[YYYY] [HH]:[MM]:[SS] [AM/PM], component SMS_SRS_REPORTING_POINT on computer [ServerFQDN] reported:  </Data>
        <Data>
        </Data>
    </EventData>
    </Event>
```

&nbsp;

## MECM Events
