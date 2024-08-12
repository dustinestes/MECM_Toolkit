# MECM Toolkit - Collections - LIE - Operating System

| Property     | Value                                                                                                                                                                                                              |
|--------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Path         | \\Assets and Compliance\\Overview\\Device Collections\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System                                                                                                |
| Category     | LIE                                                                                                                                                                                                                |
| Description  | All LIE collections should be used to Limit, Include, and Exclude objects on all other collections.                                                                                                                |
| Type         | Operating System                                                                                                                                                                                                   |
| Description  | This is a set of collections that can be used as to identify devices that have specific Operating System characteristics.                                                                                          |

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

## List of Collections

- [MECM - Collections - LIE - Operating System](#mecm---collections---lie---operating-system)
  - [About](#about)
  - [Prerequisites](#prerequisites)
  - [List of Collections](#list-of-collections)
  - [Operating System - Architecture - 32-bit](#operating-system---architecture---32-bit)
    - [General](#general)
    - [Membership Rules](#membership-rules)
    - [Update Schedule](#update-schedule)
    - [PowerShell](#powershell)
    - [SQL Query](#sql-query)
  - [Operating System - Architecture - 64-bit](#operating-system---architecture---64-bit)
    - [General](#general-1)
    - [Membership Rules](#membership-rules-1)
    - [Update Schedule](#update-schedule-1)
    - [PowerShell](#powershell-1)
    - [SQL Query](#sql-query-1)
  - [Operating System - Windows XP](#operating-system---windows-xp)
    - [General](#general-2)
    - [Membership Rules](#membership-rules-2)
    - [Update Schedule](#update-schedule-2)
    - [PowerShell](#powershell-2)
    - [SQL Query](#sql-query-2)
  - [Operating System - Windows 7](#operating-system---windows-7)
    - [General](#general-3)
    - [Membership Rules](#membership-rules-3)
    - [Update Schedule](#update-schedule-3)
    - [PowerShell](#powershell-3)
    - [SQL Query](#sql-query-3)
  - [Operating System - Windows 8](#operating-system---windows-8)
    - [General](#general-4)
    - [Membership Rules](#membership-rules-4)
    - [Update Schedule](#update-schedule-4)
    - [PowerShell](#powershell-4)
    - [SQL Query](#sql-query-4)
  - [Operating System - Windows 8.1](#operating-system---windows-81)
    - [General](#general-5)
    - [Membership Rules](#membership-rules-5)
    - [Update Schedule](#update-schedule-5)
    - [PowerShell](#powershell-5)
    - [SQL Query](#sql-query-5)
  - [Operating System - Windows 10](#operating-system---windows-10)
    - [General](#general-6)
    - [Membership Rules](#membership-rules-6)
    - [Update Schedule](#update-schedule-6)
    - [PowerShell](#powershell-6)
    - [SQL Query](#sql-query-6)
  - [Operating System - Windows 10 - \< 21H2](#operating-system---windows-10----21h2)
    - [General](#general-7)
    - [Membership Rules](#membership-rules-7)
    - [Update Schedule](#update-schedule-7)
    - [PowerShell](#powershell-7)
    - [SQL Query](#sql-query-7)
  - [Operating System - Windows 10 - 21H2](#operating-system---windows-10---21h2)
    - [General](#general-8)
    - [Membership Rules](#membership-rules-8)
    - [Update Schedule](#update-schedule-8)
    - [PowerShell](#powershell-8)
    - [SQL Query](#sql-query-8)
  - [Operating System - Windows 10 - 22H2](#operating-system---windows-10---22h2)
    - [General](#general-9)
    - [Membership Rules](#membership-rules-9)
    - [Update Schedule](#update-schedule-9)
    - [PowerShell](#powershell-9)
    - [SQL Query](#sql-query-9)
  - [Operating System - Windows 11](#operating-system---windows-11)
    - [General](#general-10)
    - [Membership Rules](#membership-rules-10)
    - [Update Schedule](#update-schedule-10)
    - [PowerShell](#powershell-10)
    - [SQL Query](#sql-query-10)
  - [Operating System - Windows 11 - \< 21H2](#operating-system---windows-11----21h2)
    - [General](#general-11)
    - [Membership Rules](#membership-rules-11)
    - [Update Schedule](#update-schedule-11)
    - [PowerShell](#powershell-11)
    - [SQL Query](#sql-query-11)
  - [Operating System - Windows 11 - 21H2](#operating-system---windows-11---21h2)
    - [General](#general-12)
    - [Membership Rules](#membership-rules-12)
    - [Update Schedule](#update-schedule-12)
    - [PowerShell](#powershell-12)
    - [SQL Query](#sql-query-12)
  - [Operating System - Windows 11 - 22H2](#operating-system---windows-11---22h2)
    - [General](#general-13)
    - [Membership Rules](#membership-rules-13)
    - [Update Schedule](#update-schedule-13)
    - [PowerShell](#powershell-13)
    - [SQL Query](#sql-query-13)
  - [Operating System - Windows Server 2003](#operating-system---windows-server-2003)
    - [General](#general-14)
    - [Membership Rules](#membership-rules-14)
    - [Update Schedule](#update-schedule-14)
    - [PowerShell](#powershell-14)
    - [SQL Query](#sql-query-14)
  - [Operating System - Windows Server 2003 R2](#operating-system---windows-server-2003-r2)
    - [General](#general-15)
    - [Membership Rules](#membership-rules-15)
    - [Update Schedule](#update-schedule-15)
    - [PowerShell](#powershell-15)
    - [SQL Query](#sql-query-15)
  - [Operating System - Windows Server 2008](#operating-system---windows-server-2008)
    - [General](#general-16)
    - [Membership Rules](#membership-rules-16)
    - [Update Schedule](#update-schedule-16)
    - [PowerShell](#powershell-16)
    - [SQL Query](#sql-query-16)
  - [Operating System - Windows Server 2008 R2](#operating-system---windows-server-2008-r2)
    - [General](#general-17)
    - [Membership Rules](#membership-rules-17)
    - [Update Schedule](#update-schedule-17)
    - [PowerShell](#powershell-17)
    - [SQL Query](#sql-query-17)
  - [Operating System - Windows Server 2012](#operating-system---windows-server-2012)
    - [General](#general-18)
    - [Membership Rules](#membership-rules-18)
    - [Update Schedule](#update-schedule-18)
    - [PowerShell](#powershell-18)
    - [SQL Query](#sql-query-18)
  - [Operating System - Windows Server 2012 R2](#operating-system---windows-server-2012-r2)
    - [General](#general-19)
    - [Membership Rules](#membership-rules-19)
    - [Update Schedule](#update-schedule-19)
    - [PowerShell](#powershell-19)
    - [SQL Query](#sql-query-19)
  - [Operating System - Windows Server 2016](#operating-system---windows-server-2016)
    - [General](#general-20)
    - [Membership Rules](#membership-rules-20)
    - [Update Schedule](#update-schedule-20)
    - [PowerShell](#powershell-20)
    - [SQL Query](#sql-query-20)
  - [Operating System - Windows Server 2019](#operating-system---windows-server-2019)
    - [General](#general-21)
    - [Membership Rules](#membership-rules-21)
    - [Update Schedule](#update-schedule-21)
    - [PowerShell](#powershell-21)
    - [SQL Query](#sql-query-21)
  - [Operating System - Windows Server 2022](#operating-system---windows-server-2022)
    - [General](#general-22)
    - [Membership Rules](#membership-rules-22)
    - [Update Schedule](#update-schedule-22)
    - [PowerShell](#powershell-22)
    - [SQL Query](#sql-query-22)
  - [Operating System - Windows Edition - Pro](#operating-system---windows-edition---pro)
    - [General](#general-23)
    - [Membership Rules](#membership-rules-23)
    - [Update Schedule](#update-schedule-23)
    - [PowerShell](#powershell-23)
    - [SQL Query](#sql-query-23)
  - [Operating System - Windows Edition - Pro for Workstations](#operating-system---windows-edition---pro-for-workstations)
    - [General](#general-24)
    - [Membership Rules](#membership-rules-24)
    - [Update Schedule](#update-schedule-24)
    - [PowerShell](#powershell-24)
    - [SQL Query](#sql-query-24)
  - [Operating System - Windows Edition - Enterprise](#operating-system---windows-edition---enterprise)
    - [General](#general-25)
    - [Membership Rules](#membership-rules-25)
    - [Update Schedule](#update-schedule-25)
    - [PowerShell](#powershell-25)
    - [SQL Query](#sql-query-25)
  - [Operating System - Windows Edition - Education](#operating-system---windows-edition---education)
    - [General](#general-26)
    - [Membership Rules](#membership-rules-26)
    - [Update Schedule](#update-schedule-26)
    - [PowerShell](#powershell-26)
    - [SQL Query](#sql-query-26)
  - [Operating System - Windows Edition - Server Essentials](#operating-system---windows-edition---server-essentials)
    - [General](#general-27)
    - [Membership Rules](#membership-rules-27)
    - [Update Schedule](#update-schedule-27)
    - [PowerShell](#powershell-27)
    - [SQL Query](#sql-query-27)
  - [Operating System - Windows Edition - Server Standard](#operating-system---windows-edition---server-standard)
    - [General](#general-28)
    - [Membership Rules](#membership-rules-28)
    - [Update Schedule](#update-schedule-28)
    - [PowerShell](#powershell-28)
    - [SQL Query](#sql-query-28)
  - [Operating System - Windows Edition - Server Standard Azure Edition](#operating-system---windows-edition---server-standard-azure-edition)
    - [General](#general-29)
    - [Membership Rules](#membership-rules-29)
    - [Update Schedule](#update-schedule-29)
    - [PowerShell](#powershell-29)
    - [SQL Query](#sql-query-29)
  - [Operating System - Windows Edition - Server Datacenter](#operating-system---windows-edition---server-datacenter)
    - [General](#general-30)
    - [Membership Rules](#membership-rules-30)
    - [Update Schedule](#update-schedule-30)
    - [PowerShell](#powershell-30)
    - [SQL Query](#sql-query-30)
  - [Operating System - Windows Edition - Server Datacenter Azure Edition](#operating-system---windows-edition---server-datacenter-azure-edition)
    - [General](#general-31)
    - [Membership Rules](#membership-rules-31)
    - [Update Schedule](#update-schedule-31)
    - [PowerShell](#powershell-31)
    - [SQL Query](#sql-query-31)
  - [Operating System - Windows Servicing Channel - General Availability](#operating-system---windows-servicing-channel---general-availability)
    - [General](#general-32)
    - [Membership Rules](#membership-rules-32)
    - [Update Schedule](#update-schedule-32)
    - [PowerShell](#powershell-32)
    - [SQL Query](#sql-query-32)
  - [Operating System - Windows Servicing Channel - Long-Term Servicing Channel](#operating-system---windows-servicing-channel---long-term-servicing-channel)
    - [General](#general-33)
    - [Membership Rules](#membership-rules-33)
    - [Update Schedule](#update-schedule-33)
    - [PowerShell](#powershell-33)
    - [SQL Query](#sql-query-33)
  - [\[To Do\] Operating System - Windows Servicing Channel - Windows Insider](#to-do-operating-system---windows-servicing-channel---windows-insider)
    - [General](#general-34)
    - [Membership Rules](#membership-rules-34)
    - [Update Schedule](#update-schedule-34)
    - [PowerShell](#powershell-34)
    - [SQL Query](#sql-query-34)
- [Apdx A: Install All Collections](#apdx-a-install-all-collections)
- [Apdx B: Collection Template](#apdx-b-collection-template)
  - [Operating System - \[CollectionName\]](#operating-system---collectionname)
    - [General](#general-35)
    - [Membership Rules](#membership-rules-35)
    - [Update Schedule](#update-schedule-35)
    - [PowerShell](#powershell-35)
    - [SQL Query](#sql-query-35)

&nbsp;

## Operating System - Architecture - 32-bit

A collection of devices with a 32-bit Operating System installed.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Architecture - 32-bit                                            |
| Comment                       | A collection of devices with a 32-bit Operating System installed.                         |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | SystemType = "x86-based PC"                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceID = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.SystemType = "x86-based PC" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Architecture - 32-bit"
    $Collection_Comment         = "A collection of devices with a 32-bit Operating System installed. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'SystemType = "x86-based PC"'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceID = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.SystemType = "x86-based PC"'

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
select * from v_R_System inner join v_GS_COMPUTER_SYSTEM on v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_COMPUTER_SYSTEM.SystemType0 = 'x86-based PC'
```

## Operating System - Architecture - 64-bit

A collection of devices with a 64-bit Operating System installed.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Architecture - 64-bit                                            |
| Comment                       | A collection of devices with a 64-bit Operating System installed.                         |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | SystemType = "x64-based PC"                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceID = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.SystemType = "x64-based PC" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Architecture - 64-bit"
    $Collection_Comment         = "A collection of devices with a 64-bit Operating System installed. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'SystemType = "x64-based PC"'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceID = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.SystemType = "x64-based PC"'

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
select * from v_R_System inner join v_GS_COMPUTER_SYSTEM on v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_COMPUTER_SYSTEM.SystemType0 = 'x64-based PC'
```

## Operating System - Windows XP

A collection of all devices running Windows XP.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows XP                                                        |
| Comment                       | A collection of all devices running Windows XP.                                            |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows XP%                                                        |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows XP%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows XP"
    $Collection_Comment         = "A collection of all devices running Windows XP. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows XP%'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows XP%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows XP%'
```

## Operating System - Windows 7

A collection of all devices running Windows 7.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows 7                                                        |
| Comment                       | A collection of all devices running Windows 7.                                            |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows 7%                                                        |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 7%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows 7"
    $Collection_Comment         = "A collection of all devices running Windows 7. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows 7%'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 7%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows 7%'
```

## Operating System - Windows 8

A collection of all devices running Windows 8.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows 8                                                        |
| Comment                       | A collection of all devices running Windows 8.                                            |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows 8%                                                        |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 8%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows 8"
    $Collection_Comment         = "A collection of all devices running Windows 8. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows 8%'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 8%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows 8%'
```

## Operating System - Windows 8.1

A collection of all devices running Windows 8.1.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows 8.1                                                        |
| Comment                       | A collection of all devices running Windows 8.1.                                            |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows 8.1%                                                        |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 8.1%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows 8.1"
    $Collection_Comment         = "A collection of all devices running Windows 8.1. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows 8.1%'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 8.1%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows 8.1%'
```

## Operating System - Windows 10

A collection of all devices running Windows 10.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows 10                                                       |
| Comment                       | A collection of all devices running Windows 10.                                           |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows 10%                                                       |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 10%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows 10"
    $Collection_Comment         = "A collection of all devices running Windows 10. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows 10%'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 10%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows 10%'
```

## Operating System - Windows 10 - < 21H2

A collection of all devices running Windows 10 where the build is < 21H2.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows 10 - < 21H2                                              |
| Comment                       | A collection of all devices running Windows 10 where the build is < 21H2.                 |
| Limiting Collection           | LIE - Operating System - Windows 10                                                       |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows 10% and Build < 21H2                                      |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 10%" and SMS_R_System.Build < "10.0.19044" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows 10 - < 21H2"
    $Collection_Comment         = "A collection of all devices running Windows 10 where the build is < 21H2. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - Operating System - Windows 10"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows 10% and Build < 21H2'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 10%" and SMS_R_System.Build < "10.0.19044"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows 10%' and v_GS_OPERATING_SYSTEM.Version0 < '10.0.19044'
```

## Operating System - Windows 10 - 21H2

A collection of all devices running Windows 10 where the build is = 21H2.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows 10 - 21H2                                              |
| Comment                       | A collection of all devices running Windows 10 where the build is = 21H2.                 |
| Limiting Collection           | LIE - Operating System - Windows 10                                                       |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows 10% and Build = 21H2                                      |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 10%" and SMS_R_System.Build >= "10.0.19044" and SMS_R_System.Build < "10.0.19045" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows 10 - 21H2"
    $Collection_Comment         = "A collection of all devices running Windows 10 where the build is = 21H2. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - Operating System - Windows 10"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows 10% and Build = 21H2'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 10%" and SMS_R_System.Build >= "10.0.19044" and SMS_R_System.Build < "10.0.19045"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows 10%' and v_GS_OPERATING_SYSTEM.Version0 >= '10.0.19044' and v_GS_OPERATING_SYSTEM.Version0 < '10.0.19045'
```

## Operating System - Windows 10 - 22H2

A collection of all devices running Windows 10 where the build is = 22H2.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows 10 - 22H2                                              |
| Comment                       | A collection of all devices running Windows 10 where the build is = 22H2.                 |
| Limiting Collection           | LIE - Operating System - Windows 10                                                       |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows 10% and Build = 22H2                                      |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 10%" and SMS_R_System.Build >= "10.0.19045" and SMS_R_System.Build < "10.0.19046" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows 10 - 22H2"
    $Collection_Comment         = "A collection of all devices running Windows 10 where the build is = 22H2. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - Operating System - Windows 10"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows 10% and Build = 22H2'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 10%" and SMS_R_System.Build >= "10.0.19045" and SMS_R_System.Build < "10.0.19046"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows 10%' and v_GS_OPERATING_SYSTEM.Version0 >= '10.0.19045' and v_GS_OPERATING_SYSTEM.Version0 < '10.0.19046'
```

## Operating System - Windows 11

A collection of all devices running Windows 11.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows 11                                                       |
| Comment                       | A collection of all devices running Windows 11.                                           |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows 11%                                                       |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 11%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows 11"
    $Collection_Comment         = "A collection of all devices running Windows 11. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows 11%'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 11%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows 11%'
```

## Operating System - Windows 11 - < 21H2

A collection of all devices running Windows 11 where the build is < 21H2.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows 11 - < 21H2                                              |
| Comment                       | A collection of all devices running Windows 11 where the build is < 21H2.                 |
| Limiting Collection           | LIE - Operating System - Windows 11                                                       |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows 11% and Build < 21H2                                      |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 11%" and SMS_R_System.Build < "10.0.22000" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows 11 - < 21H2"
    $Collection_Comment         = "A collection of all devices running Windows 11 where the build is < 21H2. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - Operating System - Windows 11"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows 11% and Build < 21H2'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 11%" and SMS_R_System.Build < "10.0.22000"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows 11%' and v_GS_OPERATING_SYSTEM.Version0 < '10.0.22000'
```

## Operating System - Windows 11 - 21H2

A collection of all devices running Windows 11 where the build is = 21H2.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows 11 - 21H2                                              |
| Comment                       | A collection of all devices running Windows 11 where the build is = 21H2.                 |
| Limiting Collection           | LIE - Operating System - Windows 11                                                       |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows 11% and Build = 21H2                                      |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 11%" and SMS_R_System.Build >= "10.0.22000" and SMS_R_System.Build < "10.0.22621" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows 11 - 21H2"
    $Collection_Comment         = "A collection of all devices running Windows 11 where the build is = 21H2. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - Operating System - Windows 11"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows 11% and Build = 21H2'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 11%" and SMS_R_System.Build >= "10.0.22000" and SMS_R_System.Build < "10.0.22621"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows 11%' and v_GS_OPERATING_SYSTEM.Version0 >= '10.0.22000' and v_GS_OPERATING_SYSTEM.Version0 < '10.0.22621'
```

## Operating System - Windows 11 - 22H2

A collection of all devices running Windows 11 where the build is = 22H2.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows 11 - 22H2                                              |
| Comment                       | A collection of all devices running Windows 11 where the build is = 22H2.                 |
| Limiting Collection           | LIE - Operating System - Windows 11                                                       |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows 11% and Build = 22H2                                      |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 11%" and SMS_R_System.Build >= "10.0.22621" and SMS_R_System.Build < "10.0.24000" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows 11 - 22H2"
    $Collection_Comment         = "A collection of all devices running Windows 11 where the build is = 22H2. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - Operating System - Windows 11"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows 11% and Build = 22H2'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "Microsoft Windows 11%" and SMS_R_System.Build >= "10.0.22621" and SMS_R_System.Build < "10.0.24000"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows 11%' and v_GS_OPERATING_SYSTEM.Version0 >= '10.0.22621' and v_GS_OPERATING_SYSTEM.Version0 < '10.0.24000'
```

## Operating System - Windows Server 2003

A collection of all devices running Windows Server 2003.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Server 2003                                              |
| Comment                       | A collection of all devices running Windows Server 2003.                                  |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows Server 2003%                                              |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Microsoft Windows Server 2003%" and SMS_G_System_OPERATING_SYSTEM.Caption not like "%Microsoft Windows Server 2003 R2%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Server 2003"
    $Collection_Comment         = "A collection of all devices running Windows Server 2003. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows Server 2003%'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Microsoft Windows Server 2003%" and SMS_G_System_OPERATING_SYSTEM.Caption not like "%Microsoft Windows Server 2003 R2%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows Server 2003%' and v_GS_OPERATING_SYSTEM.Caption0 not like '%Microsoft Windows Server 2003 R2%'
```

## Operating System - Windows Server 2003 R2

A collection of all devices running Windows Server 2003 R2.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Server 2003 R2                                           |
| Comment                       | A collection of all devices running Windows Server 2003 R2.                               |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows Server 2003 R2%                                           |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Microsoft Windows Server 2003 R2%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Server 2003 R2"
    $Collection_Comment         = "A collection of all devices running Windows Server 2003 R2. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows Server 2003 R2%'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Microsoft Windows Server 2003 R2%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows Server 2003 R2%'
```

## Operating System - Windows Server 2008

A collection of all devices running Windows Server 2008.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Server 2008                                              |
| Comment                       | A collection of all devices running Windows Server 2008.                                  |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows Server 2008%                                              |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Microsoft Windows Server 2008%" and SMS_G_System_OPERATING_SYSTEM.Caption not like "%Microsoft Windows Server 2008 R2%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Server 2008"
    $Collection_Comment         = "A collection of all devices running Windows Server 2008. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows Server 2008%'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Microsoft Windows Server 2008%" and SMS_G_System_OPERATING_SYSTEM.Caption not like "%Microsoft Windows Server 2008 R2%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows Server 2008%' and v_GS_OPERATING_SYSTEM.Caption0 not like '%Microsoft Windows Server 2008 R2%'
```

## Operating System - Windows Server 2008 R2

A collection of all devices running Windows Server 2008 R2.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Server 2008 R2                                           |
| Comment                       | A collection of all devices running Windows Server 2008 R2.                               |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows Server 2008 R2%                                           |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Microsoft Windows Server 2008 R2%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Server 2008 R2"
    $Collection_Comment         = "A collection of all devices running Windows Server 2008 R2. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows Server 2008 R2%'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Microsoft Windows Server 2008 R2%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows Server 2008 R2%'
```

## Operating System - Windows Server 2012

A collection of all devices running Windows Server 2012.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Server 2012                                              |
| Comment                       | A collection of all devices running Windows Server 2012.                                  |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows Server 2012%                                              |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Microsoft Windows Server 2012%" and SMS_G_System_OPERATING_SYSTEM.Caption not like "%Microsoft Windows Server 2012 R2%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Server 2012"
    $Collection_Comment         = "A collection of all devices running Windows Server 2012. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows Server 2012%'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Microsoft Windows Server 2012%" and SMS_G_System_OPERATING_SYSTEM.Caption not like "%Microsoft Windows Server 2012 R2%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows Server 2012%' and v_GS_OPERATING_SYSTEM.Caption0 not like '%Microsoft Windows Server 2012 R2%'
```

## Operating System - Windows Server 2012 R2

A collection of all devices running Windows Server 2012 R2.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Server 2012 R2                                           |
| Comment                       | A collection of all devices running Windows Server 2012 R2.                               |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows Server 2012 R2%                                           |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Microsoft Windows Server 2012 R2%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Server 2012 R2"
    $Collection_Comment         = "A collection of all devices running Windows Server 2012 R2. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows Server 2012 R2%'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Microsoft Windows Server 2012 R2%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows Server 2012 R2%'
```

## Operating System - Windows Server 2016

A collection of all devices running Windows Server 2016.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Server 2016                                              |
| Comment                       | A collection of all devices running Windows Server 2016.                                  |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows Server 2016%                                              |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Microsoft Windows Server 2016%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Server 2016"
    $Collection_Comment         = "A collection of all devices running Windows Server 2016. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows Server 2016%'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Microsoft Windows Server 2016%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows Server 2016%'
```

## Operating System - Windows Server 2019

A collection of all devices running Windows Server 2019.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Server 2019                                              |
| Comment                       | A collection of all devices running Windows Server 2019.                                  |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows Server 2019%                                              |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Microsoft Windows Server 2019%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Server 2019"
    $Collection_Comment         = "A collection of all devices running Windows Server 2019. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows Server 2019%'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Microsoft Windows Server 2019%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows Server 2019%'
```

## Operating System - Windows Server 2022

A collection of all devices running Windows Server 2022.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Server 2022                                              |
| Comment                       | A collection of all devices running Windows Server 2022.                                  |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "Microsoft Windows Server 2022%                                              |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Microsoft Windows Server 2022%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Server 2022"
    $Collection_Comment         = "A collection of all devices running Windows Server 2022. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "Microsoft Windows Server 2022%'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Microsoft Windows Server 2022%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Microsoft Windows Server 2022%'
```

## Operating System - Windows Edition - Pro

A collection of all devices running Windows Edition - Pro.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Edition - Pro                                            |
| Comment                       | A collection of all devices running Windows Edition - Pro.                                |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "%Pro%"                                                                      |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Pro%" and SMS_G_System_OPERATING_SYSTEM.Caption not like "%Pro for Workstations%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Edition - Pro"
    $Collection_Comment         = "A collection of all devices running Windows Edition - Pro. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "%Pro%"'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Pro%" and SMS_G_System_OPERATING_SYSTEM.Caption not like "%Pro for Workstations%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Pro%' and v_GS_OPERATING_SYSTEM.Caption0 not like '%Pro for Workstations%'
```

## Operating System - Windows Edition - Pro for Workstations

A collection of all devices running Windows Edition - Pro for Workstations.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Edition - Pro for Workstations                           |
| Comment                       | A collection of all devices running Windows Edition - Pro for Workstations.               |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "%Pro for Workstations%"                                                     |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Pro for Workstations%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Edition - Pro for Workstations"
    $Collection_Comment         = "A collection of all devices running Windows Edition - Pro for Workstations. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "%Pro for Workstations%"'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Pro for Workstations%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Pro for Workstations%'
```

## Operating System - Windows Edition - Enterprise

A collection of all devices running Windows Edition - Enterprise.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Edition - Enterprise                                     |
| Comment                       | A collection of all devices running Windows Edition - Enterprise.                         |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "%Enterprise%"                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Enterprise%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Edition - Enterprise"
    $Collection_Comment         = "A collection of all devices running Windows Edition - Enterprise. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "%Enterprise%"'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Enterprise%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Enterprise%'
```

## Operating System - Windows Edition - Education

A collection of all devices running Windows Edition - Education.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Edition - Education                                     |
| Comment                       | A collection of all devices running Windows Edition - Education.                         |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "%Education%"                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Education%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Edition - Education"
    $Collection_Comment         = "A collection of all devices running Windows Edition - Education. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "%Education%"'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Education%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Education%'
```

## Operating System - Windows Edition - Server Essentials

A collection of all devices running Windows Edition - Server Essentials.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Edition - Server Essentials                              |
| Comment                       | A collection of all devices running Windows Edition - Server Essentials.                  |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "%Server%Essentials%"                                                        |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Server%Essentials%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Edition - Server Essentials"
    $Collection_Comment         = "A collection of all devices running Windows Edition - Server Essentials. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "%Server%Essentials%"'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Server%Essentials%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Server%Essentials%'
```

## Operating System - Windows Edition - Server Standard

A collection of all devices running Windows Edition - Server Standard.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Edition - Server Standard                                |
| Comment                       | A collection of all devices running Windows Edition - Server Standard.                    |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "%Server%Standard%" and not like "%Azure Edition%"                           |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Server%Standard%" and SMS_G_System_OPERATING_SYSTEM.Caption not like "%Azure Edition%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Edition - Server Standard"
    $Collection_Comment         = "A collection of all devices running Windows Edition - Server Standard. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "%Server%Standard%" and not like "%Azure Edition%"'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Server%Standard%" and SMS_G_System_OPERATING_SYSTEM.Caption not like "%Azure Edition%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Server%Standard%' and v_GS_OPERATING_SYSTEM.Caption0 not like '%Azure Edition%'
```

## Operating System - Windows Edition - Server Standard Azure Edition

A collection of all devices running Windows Edition - Server Standard Azure Edition.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Edition - Server Standard Azure Edition                 |
| Comment                       | A collection of all devices running Windows Edition - Server Standard Azure Edition.     |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "%Server%Standard Azure Edition%"                                            |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Server%Standard Azure Edition%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Edition - Server Standard Azure Edition"
    $Collection_Comment         = "A collection of all devices running Windows Edition - Server Standard Azure Edition. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "%Server%Standard Azure Edition%"'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Server%Standard Azure Edition%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Server%Standard Azure Edition%'
```

## Operating System - Windows Edition - Server Datacenter

A collection of all devices running Windows Edition - Server Datacenter.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Edition - Server Datacenter                              |
| Comment                       | A collection of all devices running Windows Edition - Server Datacenter.                  |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "%Server%Datacenter%" and not like "%Azure Edition%"                         |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Server%Datacenter%" and SMS_G_System_OPERATING_SYSTEM.Caption not like "%Azure Edition%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Edition - Server Datacenter"
    $Collection_Comment         = "A collection of all devices running Windows Edition - Server Datacenter. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "%Server%Datacenter%" and not like "%Azure Edition%"'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Server%Datacenter%" and SMS_G_System_OPERATING_SYSTEM.Caption not like "%Azure Edition%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Server%Datacenter%' and v_GS_OPERATING_SYSTEM.Caption0 not like '%Azure Edition%'
```

## Operating System - Windows Edition - Server Datacenter Azure Edition

A collection of all devices running Windows Edition - Server Datacenter Azure Edition.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Edition - Server Datacenter Azure Edition                |
| Comment                       | A collection of all devices running Windows Edition - Server Datacenter Azure Edition.    |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "%Server%Datacenter Azure Edition%"                                          |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Server%Datacenter Azure Edition%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Edition - Server Datacenter Azure Edition"
    $Collection_Comment         = "A collection of all devices running Windows Edition - Server Datacenter Azure Edition. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "%Server%Datacenter Azure Edition%"'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%Server%Datacenter Azure Edition%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like '%Server%Datacenter Azure Edition%'
```

## Operating System - Windows Servicing Channel - General Availability

A collection of all devices running Windows Servicing Channel - General Availability.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Servicing Channel - General Availability                 |
| Comment                       | A collection of all devices running Windows Servicing Channel - General Availability.     |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption not like "%LTSB%" or "%LTSC%" or "%Insider%"                                      |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption not like "%LTSB%" and SMS_G_System_OPERATING_SYSTEM.Caption not like "%LTSC%" and SMS_G_System_OPERATING_SYSTEM.Caption not like "%Insider%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Servicing Channel - General Availability"
    $Collection_Comment         = "A collection of all devices running Windows Servicing Channel - General Availability. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption not like "%LTSB%" or "%LTSC%" or "%Insider%"'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption not like "%LTSB%" and SMS_G_System_OPERATING_SYSTEM.Caption not like "%LTSC%" and SMS_G_System_OPERATING_SYSTEM.Caption not like "%Insider%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 not like '%LTSB%' and v_GS_OPERATING_SYSTEM.Caption0 not like '%LTSC%' and v_GS_OPERATING_SYSTEM.Caption0 not like '%Insider%'
```

## Operating System - Windows Servicing Channel - Long-Term Servicing Channel

A collection of all devices running Windows Servicing Channel - Long-Term Servicing Channel.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Servicing Channel - Long-Term Servicing Channel          |
| Comment                       | A collection of all devices running Windows Servicing Channel - Long-Term Servicing Channel. |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Name                          | Caption like "%LTSB%" or "%LTSC%"                                                         |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%LTSB%" or SMS_G_System_OPERATING_SYSTEM.Caption like "%LTSC%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Servicing Channel - Long-Term Servicing Channel"
    $Collection_Comment         = "A collection of all devices running Windows Servicing Channel - Long-Term Servicing Channel. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "26" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Caption like "%LTSB%" or "%LTSC%"'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceID where SMS_G_System_OPERATING_SYSTEM.Caption like "%LTSB%" or SMS_G_System_OPERATING_SYSTEM.Caption like "%LTSC%"'

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
select * from v_R_System inner join v_GS_OPERATING_SYSTEM on v_GS_OPERATING_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_OPERATING_SYSTEM.Caption0 like "%LTSB%" or v_GS_OPERATING_SYSTEM.Caption like "%LTSC%"
```

## [To Do] Operating System - Windows Servicing Channel - Windows Insider

A collection of all devices running Windows Servicing Channel - Windows Insider.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - Windows Servicing Channel - Windows Insider                      |
| Comment                       | A collection of all devices running Windows Servicing Channel - Windows Insider.          |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Snippet                       | [QueryRule] |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - Windows Servicing Channel - Windows Insider"
    $Collection_Comment         = "A collection of all devices running Windows Servicing Channel - Windows Insider. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
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

## Operating System - [CollectionName]

[BriefDescription]

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Operating System - [CollectionName]                                                 |
| Comment                       | [BriefDescription]                                                                        |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Operating System          |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:26                                              |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Operating System"
    $Collection_Name            = "LIE - Operating System - [CollectionName]"
    $Collection_Comment         = "[BriefDescription] `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
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
