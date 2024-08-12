# MECM Toolkit - Collections - SU - Software Update

| Property     | Value                                                                                                                                                                                                              |
|--------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Path         | \\Assets and Compliance\\Overview\\Device Collections\\VividRock\\SU - Software Update                                                                                                                             |
| Category     | Production                                                                                                                                                                                                         |
| Description  | All production collections are where you target deployments and implement change. These collections should utilize the Limit, Include, and Exclude collections for membership to ensure consistency.               |
| Type         | Software Update                                                                                                                                                                                                    |
| Description  | This is a set of collections used to deploy Software Updates within your organization.                                                                                                                             |

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

## Designing Your Dynamic Servicing Rings

A typical layout of servicing rings would look like the following. This same design could apply for servers as well as workstations to keep the two designs similar and easy to manage.

> This design is based on an environment with 6,000 devices and a low number of servicing rings.

| Ring      | Description                                                         | Target Audience     | Type     | Filter Range | Count |
|-----------|---------------------------------------------------------------------|---------------------|----------|--------------|-------|
| Ring 0    | For initial testing to ensure updates successfully deploy from MECM | MECM Engineering    | Static   | N/A          | 2-5   |
| Ring 1    | For early adoption testers to begin validation and UAT              | Pilot Testers       | Static   | N/A          | 10-50 |
| Ring 2    | Production rollout to small group of business devices               | Production Business | Dynamic  | %[0-1]       | 20%   |
| Ring 3    | Production rollout to medium group of business devices              | Production Business | Dynamic  | %[2-4]       | 30%   |
| Ring 4    | Production rollout to large group of business devices               | Production Business | Dynamic  | %[5-9]       | 50%   |
| Ring X    | For manual or long term deployment to sensitive devices             | Sensitive Devices   | Static   | N/A          | 0-50  |

&nbsp;

## List of Collections

- [MECM - Collections - SU - Software Update](#mecm---collections---su---software-update)
  - [About](#about)
  - [Prerequisites](#prerequisites)
  - [Designing Your Dynamic Servicing Rings](#designing-your-dynamic-servicing-rings)
  - [List of Collections](#list-of-collections)
  - [SU - Workstations - Windows 7 - Ring 0](#su---workstations---windows-7---ring-0)
    - [General](#general)
    - [Membership Rules](#membership-rules)
    - [Update Schedule](#update-schedule)
    - [PowerShell](#powershell)
    - [SQL Query](#sql-query)
  - [SU - Workstations - Windows 7 - Ring 1](#su---workstations---windows-7---ring-1)
    - [General](#general-1)
    - [Membership Rules](#membership-rules-1)
    - [Update Schedule](#update-schedule-1)
    - [PowerShell](#powershell-1)
    - [SQL Query](#sql-query-1)
  - [SU - Workstations - Windows 7 - Ring 2](#su---workstations---windows-7---ring-2)
    - [General](#general-2)
    - [Membership Rules](#membership-rules-2)
    - [Update Schedule](#update-schedule-2)
    - [PowerShell](#powershell-2)
    - [SQL Query](#sql-query-2)
  - [SU - Workstations - Windows 7 - Ring 3](#su---workstations---windows-7---ring-3)
    - [General](#general-3)
    - [Membership Rules](#membership-rules-3)
    - [Update Schedule](#update-schedule-3)
    - [PowerShell](#powershell-3)
    - [SQL Query](#sql-query-3)
  - [SU - Workstations - Windows 7 - Ring 4](#su---workstations---windows-7---ring-4)
    - [General](#general-4)
    - [Membership Rules](#membership-rules-4)
    - [Update Schedule](#update-schedule-4)
    - [PowerShell](#powershell-4)
    - [SQL Query](#sql-query-4)
  - [SU - Workstations - Windows 7 - Ring X](#su---workstations---windows-7---ring-x)
    - [General](#general-5)
    - [Membership Rules](#membership-rules-5)
    - [Update Schedule](#update-schedule-5)
    - [PowerShell](#powershell-5)
    - [SQL Query](#sql-query-5)
  - [SU - Workstations - Windows 10 - Ring 0](#su---workstations---windows-10---ring-0)
    - [General](#general-6)
    - [Membership Rules](#membership-rules-6)
    - [Update Schedule](#update-schedule-6)
    - [PowerShell](#powershell-6)
    - [SQL Query](#sql-query-6)
  - [SU - Workstations - Windows 10 - Ring 1](#su---workstations---windows-10---ring-1)
    - [General](#general-7)
    - [Membership Rules](#membership-rules-7)
    - [Update Schedule](#update-schedule-7)
    - [PowerShell](#powershell-7)
    - [SQL Query](#sql-query-7)
  - [SU - Workstations - Windows 10 - Ring 2](#su---workstations---windows-10---ring-2)
    - [General](#general-8)
    - [Membership Rules](#membership-rules-8)
    - [Update Schedule](#update-schedule-8)
    - [PowerShell](#powershell-8)
    - [SQL Query](#sql-query-8)
  - [SU - Workstations - Windows 10 - Ring 3](#su---workstations---windows-10---ring-3)
    - [General](#general-9)
    - [Membership Rules](#membership-rules-9)
    - [Update Schedule](#update-schedule-9)
    - [PowerShell](#powershell-9)
    - [SQL Query](#sql-query-9)
  - [SU - Workstations - Windows 10 - Ring 4](#su---workstations---windows-10---ring-4)
    - [General](#general-10)
    - [Membership Rules](#membership-rules-10)
    - [Update Schedule](#update-schedule-10)
    - [PowerShell](#powershell-10)
    - [SQL Query](#sql-query-10)
  - [SU - Workstations - Windows 10 - Ring X](#su---workstations---windows-10---ring-x)
    - [General](#general-11)
    - [Membership Rules](#membership-rules-11)
    - [Update Schedule](#update-schedule-11)
    - [PowerShell](#powershell-11)
    - [SQL Query](#sql-query-11)
  - [SU - Workstations - Windows 11 - Ring 0](#su---workstations---windows-11---ring-0)
    - [General](#general-12)
    - [Membership Rules](#membership-rules-12)
    - [Update Schedule](#update-schedule-12)
    - [PowerShell](#powershell-12)
    - [SQL Query](#sql-query-12)
  - [SU - Workstations - Windows 11 - Ring 1](#su---workstations---windows-11---ring-1)
    - [General](#general-13)
    - [Membership Rules](#membership-rules-13)
    - [Update Schedule](#update-schedule-13)
    - [PowerShell](#powershell-13)
    - [SQL Query](#sql-query-13)
  - [SU - Workstations - Windows 11 - Ring 2](#su---workstations---windows-11---ring-2)
    - [General](#general-14)
    - [Membership Rules](#membership-rules-14)
    - [Update Schedule](#update-schedule-14)
    - [PowerShell](#powershell-14)
    - [SQL Query](#sql-query-14)
  - [SU - Workstations - Windows 11 - Ring 3](#su---workstations---windows-11---ring-3)
    - [General](#general-15)
    - [Membership Rules](#membership-rules-15)
    - [Update Schedule](#update-schedule-15)
    - [PowerShell](#powershell-15)
    - [SQL Query](#sql-query-15)
  - [SU - Workstations - Windows 11 - Ring 4](#su---workstations---windows-11---ring-4)
    - [General](#general-16)
    - [Membership Rules](#membership-rules-16)
    - [Update Schedule](#update-schedule-16)
    - [PowerShell](#powershell-16)
    - [SQL Query](#sql-query-16)
  - [SU - Workstations - Windows 11 - Ring X](#su---workstations---windows-11---ring-x)
    - [General](#general-17)
    - [Membership Rules](#membership-rules-17)
    - [Update Schedule](#update-schedule-17)
    - [PowerShell](#powershell-17)
    - [SQL Query](#sql-query-17)
  - [SU - Servers - Windows Server 2019 - Ring 0](#su---servers---windows-server-2019---ring-0)
    - [General](#general-18)
    - [Membership Rules](#membership-rules-18)
    - [Update Schedule](#update-schedule-18)
    - [PowerShell](#powershell-18)
    - [SQL Query](#sql-query-18)
  - [SU - Servers - Windows Server 2019 - Ring 1](#su---servers---windows-server-2019---ring-1)
    - [General](#general-19)
    - [Membership Rules](#membership-rules-19)
    - [Update Schedule](#update-schedule-19)
    - [PowerShell](#powershell-19)
    - [SQL Query](#sql-query-19)
  - [SU - Servers - Windows Server 2019 - Ring 2](#su---servers---windows-server-2019---ring-2)
    - [General](#general-20)
    - [Membership Rules](#membership-rules-20)
    - [Update Schedule](#update-schedule-20)
    - [PowerShell](#powershell-20)
    - [SQL Query](#sql-query-20)
  - [SU - Servers - Windows Server 2019 - Ring 3](#su---servers---windows-server-2019---ring-3)
    - [General](#general-21)
    - [Membership Rules](#membership-rules-21)
    - [Update Schedule](#update-schedule-21)
    - [PowerShell](#powershell-21)
    - [SQL Query](#sql-query-21)
  - [SU - Servers - Windows Server 2019 - Ring 4](#su---servers---windows-server-2019---ring-4)
    - [General](#general-22)
    - [Membership Rules](#membership-rules-22)
    - [Update Schedule](#update-schedule-22)
    - [PowerShell](#powershell-22)
    - [SQL Query](#sql-query-22)
  - [SU - Servers - Windows Server 2019 - Ring X](#su---servers---windows-server-2019---ring-x)
    - [General](#general-23)
    - [Membership Rules](#membership-rules-23)
    - [Update Schedule](#update-schedule-23)
    - [PowerShell](#powershell-23)
    - [SQL Query](#sql-query-23)
- [Apdx A: Install All Collections](#apdx-a-install-all-collections)
- [Apdx B: Collection Template](#apdx-b-collection-template)
  - [SU - \[DeviceType\] - \[OperatingSystem\] - \[RingName\]](#su---devicetype---operatingsystem---ringname)
    - [General](#general-24)
    - [Membership Rules](#membership-rules-24)
    - [Update Schedule](#update-schedule-24)
    - [PowerShell](#powershell-24)
    - [SQL Query](#sql-query-24)
- [Apdx C: SQL Queries to Get Dynamic Ring Counts](#apdx-c-sql-queries-to-get-dynamic-ring-counts)
  - [Wildcard Characters](#wildcard-characters)
  - [Using the Resource's 'ResourceID' Column](#using-the-resources-resourceid-column)
    - [Example](#example)
    - [Getting Device Counts for Each Integer](#getting-device-counts-for-each-integer)
      - [Query](#query)
      - [Output](#output)
  - [Using the Resource's 'Name' Column](#using-the-resources-name-column)
    - [Example](#example-1)
    - [Getting Device Counts for Integers and Alphabetic Groups](#getting-device-counts-for-integers-and-alphabetic-groups)
      - [Query](#query-1)
      - [Output](#output-1)
  - [Other Sample Queries](#other-sample-queries)
    - [Count Devices in Odd/Evens Groups](#count-devices-in-oddevens-groups)
    - [Count Devices in First 5/Last 5 Digit Groups](#count-devices-in-first-5last-5-digit-groups)
- [Apdx D: Getting User Information from Devices in Rings](#apdx-d-getting-user-information-from-devices-in-rings)
  - [SQL Query](#sql-query-25)
    - [Output](#output-2)
  - [PowerShell Query](#powershell-query)

&nbsp;

## SU - Workstations - Windows 7 - Ring 0

For initial testing to ensure updates successfully deploy from MECM.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Workstations - Windows 7 - Ring 0                                                    |
| Comment                       | For initial testing to ensure updates successfully deploy from MECM.                      |
| Limiting Collection           | LIE - Operating System - Windows 7                                                        |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

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
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Workstations - Ring 0                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Workstations - Windows 7 - Ring 0"
    $Collection_Comment         = "For initial testing to ensure updates successfully deploy from MECM. `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows 7"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "20" -Minute "00" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Include     = "LIE - Servicing - Workstations - Ring 0"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Workstations - Windows 7 - Ring 1

For early adoption testers to begin validation and UAT

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Workstations - Windows 7 - Ring 1                                                    |
| Comment                       | For early adoption testers to begin validation and UAT                                    |
| Limiting Collection           | LIE - Operating System - Windows 7                                                        |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

### Membership Rules

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Direct                                                                                    |
| Resource Class                | System Resource                                                                           |
| Logic                         | Add devices for users who have opted in for early adoption testing                        |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Workstations - Ring 1                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Workstations - Windows 7 - Ring 1"
    $Collection_Comment         = "For early adoption testers to begin validation and UAT `n    Include: True `n    Exclude: False `n    Direct:  True `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows 7"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $MembershipRule_Include     = "LIE - Servicing - Workstations - Ring 1"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Workstations - Windows 7 - Ring 2

Production rollout to small group of business devices

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Workstations - Windows 7 - Ring 2                                                    |
| Comment                       | Production rollout to small group of business devices                                     |
| Limiting Collection           | LIE - Operating System - Windows 7                                                        |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

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
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Workstations - Ring 2                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Workstations - Windows 7 - Ring 2"
    $Collection_Comment         = "Production rollout to small group of business devices `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows 7"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "20" -Minute "00" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Include     = "LIE - Servicing - Workstations - Ring 2"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Workstations - Windows 7 - Ring 3

Production rollout to medium group of business devices

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Workstations - Windows 7 - Ring 3                                                    |
| Comment                       | Production rollout to medium group of business devices                                    |
| Limiting Collection           | LIE - Operating System - Windows 7                                                        |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

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
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Workstations - Ring 3                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Workstations - Windows 7 - Ring 3"
    $Collection_Comment         = "Production rollout to medium group of business devices `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows 7"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "20" -Minute "00" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Include     = "LIE - Servicing - Workstations - Ring 3"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Workstations - Windows 7 - Ring 4

Production rollout to large group of business devices

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Workstations - Windows 7 - Ring 4                                                    |
| Comment                       | Production rollout to large group of business devices                                     |
| Limiting Collection           | LIE - Operating System - Windows 7                                                        |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

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
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Workstations - Ring 4                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Workstations - Windows 7 - Ring 4"
    $Collection_Comment         = "Production rollout to large group of business devices `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows 7"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "20" -Minute "00" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Include     = "LIE - Servicing - Workstations - Ring 4"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Workstations - Windows 7 - Ring X

For manual or long term deployment to sensitive devices

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Workstations - Windows 7 - Ring X                                                    |
| Comment                       | For manual or long term deployment to sensitive devices                                   |
| Limiting Collection           | LIE - Operating System - Windows 7                                                        |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

### Membership Rules

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Direct                                                                                    |
| Resource Class                | System Resource                                                                           |
| Logic                         | Add devices for sensitive users or business processes where the device needs to be manually updated or prevented from automatically rebooting. |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Workstations - Ring X                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Workstations - Windows 7 - Ring X"
    $Collection_Comment         = "For manual or long term deployment to sensitive devices `n    Include: True `n    Exclude: False `n    Direct:  True `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows 7"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $MembershipRule_Include     = "LIE - Servicing - Workstations - Ring X"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Workstations - Windows 10 - Ring 0

For initial testing to ensure updates successfully deploy from MECM.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Workstations - Windows 10 - Ring 0                                                   |
| Comment                       | For initial testing to ensure updates successfully deploy from MECM.                      |
| Limiting Collection           | LIE - Operating System - Windows 10                                                       |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

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
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Workstations - Ring 0                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Workstations - Windows 10 - Ring 0"
    $Collection_Comment         = "For initial testing to ensure updates successfully deploy from MECM. `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows 10"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "20" -Minute "00" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Include     = "LIE - Servicing - Workstations - Ring 0"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Workstations - Windows 10 - Ring 1

For early adoption testers to begin validation and UAT

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Workstations - Windows 10 - Ring 1                                                   |
| Comment                       | For early adoption testers to begin validation and UAT                                    |
| Limiting Collection           | LIE - Operating System - Windows 10                                                       |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

### Membership Rules

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Direct                                                                                    |
| Resource Class                | System Resource                                                                           |
| Logic                         | Add devices for users who have opted in for early adoption testing                        |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Workstations - Ring 1                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Workstations - Windows 10 - Ring 1"
    $Collection_Comment         = "For early adoption testers to begin validation and UAT `n    Include: True `n    Exclude: False `n    Direct:  True `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows 10"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $MembershipRule_Include     = "LIE - Servicing - Workstations - Ring 1"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Workstations - Windows 10 - Ring 2

Production rollout to small group of business devices

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Workstations - Windows 10 - Ring 2                                                   |
| Comment                       | Production rollout to small group of business devices                                     |
| Limiting Collection           | LIE - Operating System - Windows 10                                                       |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

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
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Workstations - Ring 2                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Workstations - Windows 10 - Ring 2"
    $Collection_Comment         = "Production rollout to small group of business devices `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows 10"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "20" -Minute "00" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Include     = "LIE - Servicing - Workstations - Ring 2"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Workstations - Windows 10 - Ring 3

Production rollout to medium group of business devices

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Workstations - Windows 10 - Ring 3                                                   |
| Comment                       | Production rollout to medium group of business devices                                    |
| Limiting Collection           | LIE - Operating System - Windows 10                                                       |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

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
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Workstations - Ring 3                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Workstations - Windows 10 - Ring 3"
    $Collection_Comment         = "Production rollout to medium group of business devices `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows 10"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "20" -Minute "00" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Include     = "LIE - Servicing - Workstations - Ring 3"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Workstations - Windows 10 - Ring 4

Production rollout to large group of business devices

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Workstations - Windows 10 - Ring 4                                                   |
| Comment                       | Production rollout to large group of business devices                                     |
| Limiting Collection           | LIE - Operating System - Windows 10                                                       |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

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
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Workstations - Ring 4                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Workstations - Windows 10 - Ring 4"
    $Collection_Comment         = "Production rollout to large group of business devices `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows 10"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "20" -Minute "00" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Include     = "LIE - Servicing - Workstations - Ring 4"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Workstations - Windows 10 - Ring X

For manual or long term deployment to sensitive devices

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Workstations - Windows 10 - Ring X                                                   |
| Comment                       | For manual or long term deployment to sensitive devices                                   |
| Limiting Collection           | LIE - Operating System - Windows 10                                                       |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

### Membership Rules

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Direct                                                                                    |
| Resource Class                | System Resource                                                                           |
| Logic                         | Add devices for sensitive users or business processes where the device needs to be manually updated or prevented from automatically rebooting. |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Workstations - Ring X                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Workstations - Windows 10 - Ring X"
    $Collection_Comment         = "For manual or long term deployment to sensitive devices `n    Include: True `n    Exclude: False `n    Direct:  True `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows 10"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $MembershipRule_Include     = "LIE - Servicing - Workstations - Ring X"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Workstations - Windows 11 - Ring 0

For initial testing to ensure updates successfully deploy from MECM.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Workstations - Windows 11 - Ring 0                                                   |
| Comment                       | For initial testing to ensure updates successfully deploy from MECM.                      |
| Limiting Collection           | LIE - Operating System - Windows 11                                                       |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

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
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Workstations - Ring 0                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Workstations - Windows 11 - Ring 0"
    $Collection_Comment         = "For initial testing to ensure updates successfully deploy from MECM. `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows 11"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "20" -Minute "00" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Include     = "LIE - Servicing - Workstations - Ring 0"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Workstations - Windows 11 - Ring 1

For early adoption testers to begin validation and UAT

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Workstations - Windows 11 - Ring 1                                                   |
| Comment                       | For early adoption testers to begin validation and UAT                                    |
| Limiting Collection           | LIE - Operating System - Windows 11                                                       |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

### Membership Rules

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Direct                                                                                    |
| Resource Class                | System Resource                                                                           |
| Logic                         | Add devices for users who have opted in for early adoption testing                        |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Workstations - Ring 1                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Workstations - Windows 11 - Ring 1"
    $Collection_Comment         = "For early adoption testers to begin validation and UAT `n    Include: True `n    Exclude: False `n    Direct:  True `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows 11"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $MembershipRule_Include     = "LIE - Servicing - Workstations - Ring 1"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Workstations - Windows 11 - Ring 2

Production rollout to small group of business devices

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Workstations - Windows 11 - Ring 2                                                   |
| Comment                       | Production rollout to small group of business devices                                     |
| Limiting Collection           | LIE - Operating System - Windows 11                                                       |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

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
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Workstations - Ring 2                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Workstations - Windows 11 - Ring 2"
    $Collection_Comment         = "Production rollout to small group of business devices `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows 11"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "20" -Minute "00" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Include     = "LIE - Servicing - Workstations - Ring 2"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Workstations - Windows 11 - Ring 3

Production rollout to medium group of business devices

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Workstations - Windows 11 - Ring 3                                                   |
| Comment                       | Production rollout to medium group of business devices                                    |
| Limiting Collection           | LIE - Operating System - Windows 11                                                       |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

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
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Workstations - Ring 3                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Workstations - Windows 11 - Ring 3"
    $Collection_Comment         = "Production rollout to medium group of business devices `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows 11"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "20" -Minute "00" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Include     = "LIE - Servicing - Workstations - Ring 3"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Workstations - Windows 11 - Ring 4

Production rollout to large group of business devices

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Workstations - Windows 11 - Ring 4                                                   |
| Comment                       | Production rollout to large group of business devices                                     |
| Limiting Collection           | LIE - Operating System - Windows 11                                                       |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

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
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Workstations - Ring 4                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Workstations - Windows 11 - Ring 4"
    $Collection_Comment         = "Production rollout to large group of business devices `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows 11"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "20" -Minute "00" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Include     = "LIE - Servicing - Workstations - Ring 4"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Workstations - Windows 11 - Ring X

For manual or long term deployment to sensitive devices

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Workstations - Windows 11 - Ring X                                                   |
| Comment                       | For manual or long term deployment to sensitive devices                                   |
| Limiting Collection           | LIE - Operating System - Windows 11                                                       |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

### Membership Rules

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Direct                                                                                    |
| Resource Class                | System Resource                                                                           |
| Logic                         | Add devices for sensitive users or business processes where the device needs to be manually updated or prevented from automatically rebooting. |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Workstations - Ring X                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Workstations - Windows 11 - Ring X"
    $Collection_Comment         = "For manual or long term deployment to sensitive devices `n    Include: True `n    Exclude: False `n    Direct:  True `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows 11"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $MembershipRule_Include     = "LIE - Servicing - Workstations - Ring X"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Servers - Windows Server 2019 - Ring 0

For initial testing to ensure updates successfully deploy from MECM.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Servers - Windows Server 2019 - Ring 0                                               |
| Comment                       | For initial testing to ensure updates successfully deploy from MECM.                      |
| Limiting Collection           | LIE - Operating System - Windows Server 2019                                              |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

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
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Servers - Ring 0                                                        |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Servers - Windows Server 2019 - Ring 0"
    $Collection_Comment         = "For initial testing to ensure updates successfully deploy from MECM. `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows Server 2019"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "20" -Minute "00" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Include     = "LIE - Servicing - Servers - Ring 0"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Servers - Windows Server 2019 - Ring 1

For early adoption testers to begin validation and UAT

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Servers - Windows Server 2019 - Ring 1                                               |
| Comment                       | For early adoption testers to begin validation and UAT                                    |
| Limiting Collection           | LIE - Operating System - Windows Server 2019                                              |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

### Membership Rules

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Direct                                                                                    |
| Resource Class                | System Resource                                                                           |
| Logic                         | Add devices for servers that have opted in for early adoption testing                     |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Servers - Ring 1                                                        |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Servers - Windows Server 2019 - Ring 1"
    $Collection_Comment         = "For early adoption testers to begin validation and UAT `n    Include: True `n    Exclude: False `n    Direct:  True `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows Server 2019"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $MembershipRule_Include     = "LIE - Servicing - Servers - Ring 1"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Servers - Windows Server 2019 - Ring 2

Production rollout to small group of servers.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Servers - Windows Server 2019 - Ring 2                                               |
| Comment                       | Production rollout to small group of servers.                                             |
| Limiting Collection           | LIE - Operating System - Windows Server 2019                                              |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

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
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Servers - Ring 2                                                        |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Servers - Windows Server 2019 - Ring 2"
    $Collection_Comment         = "Production rollout to small group of servers. `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows Server 2019"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "20" -Minute "00" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Include     = "LIE - Servicing - Servers - Ring 2"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Servers - Windows Server 2019 - Ring 3

Production rollout to medium group of servers.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Servers - Windows Server 2019 - Ring 3                                               |
| Comment                       | Production rollout to medium group of servers.                                            |
| Limiting Collection           | LIE - Operating System - Windows Server 2019                                              |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

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
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Servers - Ring 3                                                        |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Servers - Windows Server 2019 - Ring 3"
    $Collection_Comment         = "Production rollout to medium group of servers. `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows Server 2019"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "20" -Minute "00" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Include     = "LIE - Servicing - Servers - Ring 3"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Servers - Windows Server 2019 - Ring 4

Production rollout to large group of servers.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Servers - Windows Server 2019 - Ring 4                                               |
| Comment                       | Production rollout to large group of servers.                                             |
| Limiting Collection           | LIE - Operating System - Windows Server 2019                                              |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

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
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Servers - Ring 4                                                        |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Servers - Windows Server 2019 - Ring 4"
    $Collection_Comment         = "Production rollout to large group of servers. `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows Server 2019"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "20" -Minute "00" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Include     = "LIE - Servicing - Servers - Ring 4"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
```

## SU - Servers - Windows Server 2019 - Ring X

For manual or long term deployment to sensitive servers

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - Servers - Windows Server 2019 - Ring X                                               |
| Comment                       | For manual or long term deployment to sensitive servers                                   |
| Limiting Collection           | LIE - Operating System - Windows Server 2019                                              |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

### Membership Rules

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Direct                                                                                    |
| Resource Class                | System Resource                                                                           |
| Logic                         | Add servers that are sensitive or need to be manually updated or prevented from automatically rebooting. |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | True                                                                                      |
| Type                          | Include                                                                                   |
| Collection Name(s)            | LIE - Servicing - Servers - Ring X                                                        |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disabled                                                                                  |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 8:00 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - Servers - Windows Server 2019 - Ring X"
    $Collection_Comment         = "For manual or long term deployment to sensitive servers `n    Include: True `n    Exclude: False `n    Direct:  True `n    Query:   False"
    $Collection_Limiting        = "LIE - Operating System - Windows Server 2019"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Periodic"
    $MembershipRule_Include     = "LIE - Servicing - Servers - Ring X"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- SQL query would have to be determined based on your membership logic
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

## SU - [DeviceType] - [OperatingSystem] - [RingName]

A collection of devices that have been identified for membership in [RingName] phase of servicing.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | SU - [DeviceType] - [OperatingSystem] - [RingName]                                        |
| Comment                       | A collection of devices that have been identified for membership in [RingName] phase of servicing. |
| Limiting Collection           | LIE - Operating System - [OperatingSystem]                                                |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\SU - Software Update                                       |

### Membership Rules

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | [True/False]                                                                              |
| Type                          | Direct                                                                                    |
| Resource Class                | System Resource                                                                           |
| Attribute Name                | [AttributeName]                                                                           |
| Value                         | [Value]                                                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | [True/False]                                                                              |
| Type                          | Query                                                                                     |
| Name                          | [QueryName]                                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | [QueryRule]                                                                               |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | [True/False]                                                                              |
| Type                          | Include                                                                                   |
| Collection Name(s)            | [IncludeCollectionName]                                                                   |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | [True/False]                                                                              |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [ExcludeCollectionName]                                                                   |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | [Enabled/Disabled]                                                                        |
| Full Updates                  | [Schedule]                                                                                |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\SU - Software Update"
    $Collection_Name            = "SU - [DeviceType] - [OperatingSystem] - [RingName]"
    $Collection_Comment         = "A collection of devices that have been identified for membership in [RingName] phase of servicing. `n    Include: [True/False] `n    Exclude: [True/False] `n    Direct:  [True/False] `n    Query:   [True/False]"
    $Collection_Limiting        = "LIE - Operating System - [OperatingSystem]"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "[Manual/Periodic/Continuous/Both]"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "20" -Minute "00" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Include     = "[IncludeCollectionName]"
    $MembershipRule_Exclude     = "[ExcludeCollectionName]"

# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -ExcludeCollectionName $MembershipRule_Exclude
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
select * from v_R_System
```

&nbsp;

# Apdx C: SQL Queries to Get Dynamic Ring Counts

These queries will help you get some basic data from your MECM database and determine how you would like to divvy up the members for each servicing ring in your servicing model.

> Note: the below is written with workstation devices in mind. However, this same methodology can be used to target servers. You can add a simple WHERE clause to filter the SQL output and as well as the Collection Membership Query.

&nbsp;

## Wildcard Characters

| Wildcard character | Description                                                                  | Example                                                                                                                                                                                                                                                                                             |
|--------------------|------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| %                  | Any string of zero or more characters.                                       | WHERE title LIKE '%computer%' finds all book titles with the word computer anywhere in the book title.                                                                                                                                                                                              |
| _ (underscore)     | Any single character.                                                        | WHERE au_fname LIKE '_ean' finds all four-letter first names that end with ean (Dean, Sean, and so on).                                                                                                                                                                                             |
| [ ]                | Any single character within the specified range [a-f] or set [abcdef].       | WHERE au_lname LIKE '[C-P]arsen' finds author last names ending with arsen and starting with any single character between C and P, for example Carsen, Larsen, Karsen, and so on. In range searches, the characters included in the range may vary depending on the sorting rules of the collation. |
| [^]                | Any single character not within the specified range [^a-f] or set [^abcdef]. | WHERE au_lname LIKE 'de[^l]%' finds all author last names starting with de and where the following letter isn't l.                                                                                                                                                                                  |

&nbsp;

## Using the Resource's 'ResourceID' Column

The ResourceID column is a great column to use for dynamic device assignment. You can use the last digit of a Resource's 'ResourceID' column to divide the resource count up into roughly even sets across 10 groups. These groups can then be combined in different ways to make up as many or as few servicing rings as possible.

- Every object in the MECM database gets one
- It is an int32 data type [0-9] so divides up into 10 roughly even groups
- Increments by 1 automatically so devices should round-robin across these 10 groups
- Offset the range filter so you can weight the results however you see fit
- Inherently keeps devices from one query/collection out of the other query/collection results since the device can only have one ending digit
- Use of number ranges mean a limited number of permutations which prevents you from having too many rings. Max: 10 Min: 01
- Set it and forget it style. Given the digits increment and reset in a predictable order, this should ensure whatever split you design should remain very nearly at those numbers throughout the lifecycle**
- This same query logic can be used when pulling information to send automated emails notifying someone of the upcoming updates. You can use the ResourceID (which is the main key used to join tables) and get information like ComputerName, Primary User, Primary User Email, and any other data that MECM stores.


### Example

The below example uses the 'like' operator to instruct SQL that the specified character string will match the provided pattern.

```sql
select * from v_R_System where v_R_System.ResourceID like '%[1-4]'
```

### Getting Device Counts for Each Integer

The below is a basic snippet and output that lets you quickly validate how many devices there are with an ending character for each integer.

#### Query

```sql
SELECT
	sum(case when ResourceID like '%[0]' then 1 else 0 end) AS 'EndsIn_0',
	sum(case when ResourceID like '%[1]' then 1 else 0 end) AS 'EndsIn_1',
	sum(case when ResourceID like '%[2]' then 1 else 0 end) AS 'EndsIn_2',
	sum(case when ResourceID like '%[3]' then 1 else 0 end) AS 'EndsIn_3',
	sum(case when ResourceID like '%[4]' then 1 else 0 end) AS 'EndsIn_4',
	sum(case when ResourceID like '%[5]' then 1 else 0 end) AS 'EndsIn_5',
	sum(case when ResourceID like '%[6]' then 1 else 0 end) AS 'EndsIn_6',
	sum(case when ResourceID like '%[7]' then 1 else 0 end) AS 'EndsIn_7',
	sum(case when ResourceID like '%[8]' then 1 else 0 end) AS 'EndsIn_8',
	sum(case when ResourceID like '%[9]' then 1 else 0 end) AS 'EndsIn_9',
	count(*) AS 'Total'
FROM
	v_R_System
WHERE
	-- Device is a Workstation Class OS
	v_R_System.Operating_System_Name_and0 like '%Workstation%'
	and
	-- Device Has a Client Installed
	v_R_System.Client0 = 1
```

#### Output

The below is a sample output from a production corporate environment in use over 7 years.

| EndsIn_0 | EndsIn_1 | EndsIn_2 | EndsIn_3 | EndsIn_4 | EndsIn_5 | EndsIn_6 | EndsIn_7 | EndsIn_8 | EndsIn_9 | Total |
|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|-------|
| 865      | 861      | 858      | 826      | 859      | 852      | 837      | 865      | 884      | 837      | 8544  |

&nbsp;

## Using the Resource's 'Name' Column

Another way of doing this is to use the Resource's 'Name' column. However, this has a number of drawbacks so I do not recommend using it unless you have to.

- Using the name relies heavily on manually verifying and reverifying that the count of devices in your range filters remains fairly constant
- Does not automatically divide into 10 equal* groups
- Does not ensure round-robin distribution because names of devices can be heavily weighted due to things like using site codes that ensure one group ends up with 1000s while a smaller site ends up with 10s or 100s

> Note: Using the SQL wildcards, you can create a match expression to look at the beginning, middle, and end of name strings to search for matching criteria.

### Example

The below example uses the 'like' operator to instruct SQL that the specified character string will match the provided pattern.

```sql
select * from v_R_System where v_R_System.ResourceID like '%[ABC]'
```

### Getting Device Counts for Integers and Alphabetic Groups

The below is a basic snippet and output that lets you quickly validate how many devices there are with an ending character in the specified ranges.

#### Query

```sql
SELECT
	sum(case when ResourceID like '%[0-4]' then 1 else 0 end) AS 'InRange_0-4',
	sum(case when ResourceID like '%[5-9]' then 1 else 0 end) AS 'InRange_5-9',
	sum(case when ResourceID like '%[A-I]' then 1 else 0 end) AS 'InRange_A-I',
    sum(case when ResourceID like '%[J-R]' then 1 else 0 end) AS 'InRange_J-R',
    sum(case when ResourceID like '%[S-Z]' then 1 else 0 end) AS 'InRange_S-Z',
	count(*) AS 'Total'
FROM
	v_R_System
```

#### Output

The below is a sample output from a production corporate environment in use over 7 years.

| EndsIn_0 | EndsIn_1 | EndsIn_2 | EndsIn_3 | EndsIn_4 | EndsIn_5 | EndsIn_6 | EndsIn_7 | EndsIn_8 | EndsIn_9 | Total |
|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|-------|
| 865      | 861      | 858      | 826      | 859      | 852      | 837      | 865      | 884      | 837      | 8544  |


&nbsp;

## Other Sample Queries

Here are some other ways you could divvy up devices.

### Count Devices in Odd/Evens Groups

Checks the ResourceID columns last digit to determine if it is in a range of odd or even numbers.

```sql
SELECT
	sum(case when ResourceID like '%[13579]' then 1 else 0 end) AS 'Odds',
	sum(case when ResourceID like '%[02468]' then 1 else 0 end) AS 'Evens',
    count(*) AS Total
FROM
	v_R_System
```

### Count Devices in First 5/Last 5 Digit Groups

Checks the ResourceID columns last digit to determine if it is in a range of the first 5 digits in series or the last 5 digits.

```sql
SELECT
	sum(case when ResourceID like '%[0-4]' then 1 else 0 end) AS 'First5',
	sum(case when ResourceID like '%[5-9]' then 1 else 0 end) AS 'Last5',
    count(*) AS Total
FROM
	v_R_System
```

&nbsp;

# Apdx D: Getting User Information from Devices in Rings

The following snippets can be used to help automate the process of gathering device owners/users and sending them a notification regarding the upcoming servicing event.

## SQL Query

```sql
USE CM_FS0

SELECT DISTINCT TOP(10)
	v_R_System.ResourceID as 'Resource ID',
	v_R_System.Name0 as 'Computer Name',
	v_UserMachineRelationship.UniqueUserName as 'Primary User',
	v_R_User.Mail0 as 'Primary User Email',
	v_R_System.User_Name0 as 'Last Logon User',
	v_R_User1.mail0 as 'Last Logon User Email'
FROM v_R_System
	left join v_UserMachineRelationship on v_R_System.ResourceID = v_UserMachineRelationship.MachineResourceID
	left join v_R_User on v_R_User.Unique_User_Name0 = v_UserMachineRelationship.UniqueUserName
	join v_R_User v_R_User1 on v_R_User1.User_Name0 = v_R_System.User_Name0
WHERE
	v_R_System.ResourceID like '%[0]'
	And v_UserMachineRelationship.RelationActive = '1'
	And v_R_System.Operating_System_Name_and0 like '%Microsoft Windows NT Workstation 10.0%'
```

### Output

| Resource ID | Computer Name | Primary User             | Primary User Email           | Last Logon User | Last Logon User Email        |
|-------------|---------------|--------------------------|------------------------------|-----------------|------------------------------|
| 16777001    | SN0123456789  | domain\instructor        | instructor@domain.com        | student         | student@domain.com           |
| 16777002    | SN9876543210  | waterworld\kevin.costner | kevin.costner@waterworld.com | dennis.hopper   | dennis.hopper@waterworld.com |

&nbsp;

## PowerShell Query

```powershell

```