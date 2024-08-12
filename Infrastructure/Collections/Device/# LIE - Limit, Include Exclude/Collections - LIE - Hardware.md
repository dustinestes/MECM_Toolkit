# MECM Toolkit - Collections - LIE - Hardware

| Property     | Value                                                                                                                                                                                                              |
|--------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Path         | \\Assets and Compliance\\Overview\\Device Collections\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                                                                                                        |
| Category     | LIE                                                                                                                                                                                                                |
| Description  | All LIE collections should be used to Limit, Include, and Exclude objects on all other collections.                                                                                                                |
| Type         | Hardware                                                                                                                                                                                                           |
| Description  | This is a set of collections that can be used as to identify devices based on installed hardware, hardware configurations, or hardware types.                                                                      |

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

- [MECM - Collections - LIE - Hardware](#mecm---collections---lie---hardware)
  - [About](#about)
  - [Prerequisites](#prerequisites)
  - [List of Collections](#list-of-collections)
  - [Hardware - Processor - 32-bit](#hardware---processor---32-bit)
    - [General](#general)
    - [Membership Rules](#membership-rules)
    - [Update Schedule](#update-schedule)
    - [PowerShell](#powershell)
    - [SQL Query](#sql-query)
  - [Hardware - Processor - 64-bit](#hardware---processor---64-bit)
    - [General](#general-1)
    - [Membership Rules](#membership-rules-1)
    - [Update Schedule](#update-schedule-1)
    - [PowerShell](#powershell-1)
    - [SQL Query](#sql-query-1)
  - [Hardware - Device Type - Desktop](#hardware---device-type---desktop)
    - [General](#general-2)
    - [Membership Rules](#membership-rules-2)
    - [Update Schedule](#update-schedule-2)
    - [PowerShell](#powershell-2)
    - [SQL Query](#sql-query-2)
  - [Hardware - Device Type - Laptop](#hardware---device-type---laptop)
    - [General](#general-3)
    - [Membership Rules](#membership-rules-3)
    - [Update Schedule](#update-schedule-3)
    - [PowerShell](#powershell-3)
    - [SQL Query](#sql-query-3)
  - [Hardware - Device Type - Server](#hardware---device-type---server)
    - [General](#general-4)
    - [Membership Rules](#membership-rules-4)
    - [Update Schedule](#update-schedule-4)
    - [PowerShell](#powershell-4)
    - [SQL Query](#sql-query-4)
  - [Hardware - Device Type - Other](#hardware---device-type---other)
    - [General](#general-5)
    - [Membership Rules](#membership-rules-5)
    - [Update Schedule](#update-schedule-5)
    - [PowerShell](#powershell-5)
    - [SQL Query](#sql-query-5)
  - [Hardware - Device Type - Virtual Machine](#hardware---device-type---virtual-machine)
    - [General](#general-6)
    - [Membership Rules](#membership-rules-6)
    - [Update Schedule](#update-schedule-6)
    - [PowerShell](#powershell-6)
    - [SQL Query](#sql-query-6)
  - [Hardware - Manufacturer - Alienware](#hardware---manufacturer---alienware)
    - [General](#general-7)
    - [Membership Rules](#membership-rules-7)
    - [Update Schedule](#update-schedule-7)
    - [PowerShell](#powershell-7)
    - [SQL Query](#sql-query-7)
  - [Hardware - Manufacturer - Amazon](#hardware---manufacturer---amazon)
    - [General](#general-8)
    - [Membership Rules](#membership-rules-8)
    - [Update Schedule](#update-schedule-8)
    - [PowerShell](#powershell-8)
    - [SQL Query](#sql-query-8)
  - [Hardware - Manufacturer - Dell](#hardware---manufacturer---dell)
    - [General](#general-9)
    - [Membership Rules](#membership-rules-9)
    - [Update Schedule](#update-schedule-9)
    - [PowerShell](#powershell-9)
    - [SQL Query](#sql-query-9)
  - [Hardware - Manufacturer - Gateway](#hardware---manufacturer---gateway)
    - [General](#general-10)
    - [Membership Rules](#membership-rules-10)
    - [Update Schedule](#update-schedule-10)
    - [PowerShell](#powershell-10)
    - [SQL Query](#sql-query-10)
  - [Hardware - Manufacturer - Gigabyte](#hardware---manufacturer---gigabyte)
    - [General](#general-11)
    - [Membership Rules](#membership-rules-11)
    - [Update Schedule](#update-schedule-11)
    - [PowerShell](#powershell-11)
    - [SQL Query](#sql-query-11)
  - [Hardware - Manufacturer - HP](#hardware---manufacturer---hp)
    - [General](#general-12)
    - [Membership Rules](#membership-rules-12)
    - [Update Schedule](#update-schedule-12)
    - [PowerShell](#powershell-12)
    - [SQL Query](#sql-query-12)
  - [Hardware - Manufacturer - IBM](#hardware---manufacturer---ibm)
    - [General](#general-13)
    - [Membership Rules](#membership-rules-13)
    - [Update Schedule](#update-schedule-13)
    - [PowerShell](#powershell-13)
    - [SQL Query](#sql-query-13)
  - [Hardware - Manufacturer - Intel](#hardware---manufacturer---intel)
    - [General](#general-14)
    - [Membership Rules](#membership-rules-14)
    - [Update Schedule](#update-schedule-14)
    - [PowerShell](#powershell-14)
    - [SQL Query](#sql-query-14)
  - [Hardware - Manufacturer - Lenovo](#hardware---manufacturer---lenovo)
    - [General](#general-15)
    - [Membership Rules](#membership-rules-15)
    - [Update Schedule](#update-schedule-15)
    - [PowerShell](#powershell-15)
    - [SQL Query](#sql-query-15)
  - [Hardware - Manufacturer - M\&A Technology](#hardware---manufacturer---ma-technology)
    - [General](#general-16)
    - [Membership Rules](#membership-rules-16)
    - [Update Schedule](#update-schedule-16)
    - [PowerShell](#powershell-16)
    - [SQL Query](#sql-query-16)
  - [Hardware - Manufacturer - Matsushita Electric Industrial Co](#hardware---manufacturer---matsushita-electric-industrial-co)
    - [General](#general-17)
    - [Membership Rules](#membership-rules-17)
    - [Update Schedule](#update-schedule-17)
    - [PowerShell](#powershell-17)
    - [SQL Query](#sql-query-17)
  - [Hardware - Manufacturer - Microsoft](#hardware---manufacturer---microsoft)
    - [General](#general-18)
    - [Membership Rules](#membership-rules-18)
    - [Update Schedule](#update-schedule-18)
    - [PowerShell](#powershell-18)
    - [SQL Query](#sql-query-18)
  - [Hardware - Manufacturer - Panasonic](#hardware---manufacturer---panasonic)
    - [General](#general-19)
    - [Membership Rules](#membership-rules-19)
    - [Update Schedule](#update-schedule-19)
    - [PowerShell](#powershell-19)
    - [SQL Query](#sql-query-19)
  - [Hardware - Manufacturer - Puget Systems](#hardware---manufacturer---puget-systems)
    - [General](#general-20)
    - [Membership Rules](#membership-rules-20)
    - [Update Schedule](#update-schedule-20)
    - [PowerShell](#powershell-20)
    - [SQL Query](#sql-query-20)
  - [Hardware - Manufacturer - Supermicro](#hardware---manufacturer---supermicro)
    - [General](#general-21)
    - [Membership Rules](#membership-rules-21)
    - [Update Schedule](#update-schedule-21)
    - [PowerShell](#powershell-21)
    - [SQL Query](#sql-query-21)
  - [Hardware - Manufacturer - To Be Filled By O.E.M.](#hardware---manufacturer---to-be-filled-by-oem)
    - [General](#general-22)
    - [Membership Rules](#membership-rules-22)
    - [Update Schedule](#update-schedule-22)
    - [PowerShell](#powershell-22)
    - [SQL Query](#sql-query-22)
  - [Hardware - Manufacturer - VMware](#hardware---manufacturer---vmware)
    - [General](#general-23)
    - [Membership Rules](#membership-rules-23)
    - [Update Schedule](#update-schedule-23)
    - [PowerShell](#powershell-23)
    - [SQL Query](#sql-query-23)
  - [Hardware - Manufacturer - Xen](#hardware---manufacturer---xen)
    - [General](#general-24)
    - [Membership Rules](#membership-rules-24)
    - [Update Schedule](#update-schedule-24)
    - [PowerShell](#powershell-24)
    - [SQL Query](#sql-query-24)
  - [Hardware - Model - \[All Models\]](#hardware---model---all-models)
    - [General](#general-25)
    - [Membership Rules](#membership-rules-25)
    - [Update Schedule](#update-schedule-25)
    - [PowerShell](#powershell-25)
    - [SQL Query](#sql-query-25)
- [Apdx A: Install All Collections](#apdx-a-install-all-collections)
- [Apdx B: Collection Template](#apdx-b-collection-template)
  - [Hardware - \[CollectionName\]](#hardware---collectionname)
    - [General](#general-26)
    - [Membership Rules](#membership-rules-26)
    - [Update Schedule](#update-schedule-26)
    - [PowerShell](#powershell-26)
    - [SQL Query](#sql-query-26)

&nbsp;

## Hardware - Processor - 32-bit

A collection of devices that have 32-bit Processors.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Processor - 32-bit                                                       |
| Comment                       | A collection of devices that have 32-bit Processors.                                      |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | AddressWidth = 32                                                                         |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_PROCESSOR on SMS_G_System_PROCESSOR.ResourceID = SMS_R_System.ResourceID where SMS_G_System_PROCESSOR.AddressWidth = "32" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Processor - 32-bit"
    $Collection_Comment         = "A collection of devices that have 32-bit Processors. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'AddressWidth = 32'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_PROCESSOR on SMS_G_System_PROCESSOR.ResourceID = SMS_R_System.ResourceID where SMS_G_System_PROCESSOR.AddressWidth = "32"'

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
select * from v_R_System inner join v_GS_PROCESSOR on v_GS_PROCESSOR.ResourceID = v_R_System.ResourceID where v_GS_PROCESSOR.AddressWidth0 = '32'
```

## Hardware - Processor - 64-bit

A collection of devices that have 64-bit Processors.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Processor - 64-bit                                                       |
| Comment                       | A collection of devices that have 64-bit Processors.                                      |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | AddressWidth = 64                                                                         |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_PROCESSOR on SMS_G_System_PROCESSOR.ResourceID = SMS_R_System.ResourceID where SMS_G_System_PROCESSOR.AddressWidth = "64" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Processor - 64-bit"
    $Collection_Comment         = "A collection of devices that have 64-bit Processors. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'AddressWidth = 64'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_PROCESSOR on SMS_G_System_PROCESSOR.ResourceID = SMS_R_System.ResourceID where SMS_G_System_PROCESSOR.AddressWidth = "64"'

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
select * from v_R_System inner join v_GS_PROCESSOR on v_GS_PROCESSOR.ResourceID = v_R_System.ResourceID where v_GS_PROCESSOR.AddressWidth0 = '64'
```

## Hardware - Device Type - Desktop

A collection of devices that match the device type of Desktop. ChassisTypes in (3, 4, 5, 6, 7, 13, 15, 16, 35, 36) and IsVirtualMachine = 0.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Device Type - Desktop                                                    |
| Comment                       | A collection of devices that match the device type of Desktop. ChassisTypes in (3, 4, 5, 6, 7, 13, 15, 16, 35, 36) and IsVirtualMachine = 0. |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | ChassisTypes in (3, 4, 5, 6, 7, 13, 15, 16, 35, 36) and IsVirtualMachine = 0              |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_SYSTEM_ENCLOSURE on SMS_G_System_SYSTEM_ENCLOSURE.ResourceID = SMS_R_System.ResourceId where SMS_G_System_SYSTEM_ENCLOSURE.ChassisTypes in (3, 4, 5, 6, 7, 13, 15, 16, 35, 36) and SMS_R_System.IsVirtualMachine = 0 |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Device Type - Desktop"
    $Collection_Comment         = "A collection of devices that match the device type of Desktop. ChassisTypes in (3, 4, 5, 6, 7, 13, 15, 16, 35, 36) and IsVirtualMachine = 0. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'ChassisTypes in (3, 4, 5, 6, 7, 13, 15, 16, 35, 36) and IsVirtualMachine = 0'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_SYSTEM_ENCLOSURE on SMS_G_System_SYSTEM_ENCLOSURE.ResourceID = SMS_R_System.ResourceId where SMS_G_System_SYSTEM_ENCLOSURE.ChassisTypes in (3, 4, 5, 6, 7, 13, 15, 16, 35, 36) and SMS_R_System.IsVirtualMachine = 0'

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
select * from v_R_System inner join v_GS_SYSTEM_ENCLOSURE on v_GS_SYSTEM_ENCLOSURE.ResourceID = v_R_System.ResourceID where v_GS_SYSTEM_ENCLOSURE.ChassisTypes0 in (3, 4, 5, 6, 7, 13, 15, 16, 35, 36) and v_R_System.Is_Virtual_Machine0 = 0
```

## Hardware - Device Type - Laptop

A collection of devices that match the device type of Laptop. ChassisTypes in (8, 9, 10, 11, 12, 14, 18, 21, 30, 31, 32) and IsVirtualMachine = 0.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Device Type - Laptop                                                     |
| Comment                       | A collection of devices that match the device type of Laptop. ChassisTypes in (8, 9, 10, 11, 12, 14, 18, 21, 30, 31, 32) and IsVirtualMachine = 0. |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | ChassisTypes in (8, 9, 10, 11, 12, 14, 18, 21, 30, 31, 32) and IsVirtualMachine = 0       |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_SYSTEM_ENCLOSURE on SMS_G_System_SYSTEM_ENCLOSURE.ResourceID = SMS_R_System.ResourceId where SMS_G_System_SYSTEM_ENCLOSURE.ChassisTypes in (8, 9, 10, 11, 12, 14, 18, 21, 30, 31, 32) and SMS_R_System.IsVirtualMachine = 0 |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Device Type - Laptop"
    $Collection_Comment         = "A collection of devices that match the device type of Laptop. ChassisTypes in (8, 9, 10, 11, 12, 14, 18, 21, 30, 31, 32) and IsVirtualMachine = 0. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'ChassisTypes in (8, 9, 10, 11, 12, 14, 18, 21, 30, 31, 32) and IsVirtualMachine = 0'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_SYSTEM_ENCLOSURE on SMS_G_System_SYSTEM_ENCLOSURE.ResourceID = SMS_R_System.ResourceId where SMS_G_System_SYSTEM_ENCLOSURE.ChassisTypes in (8, 9, 10, 11, 12, 14, 18, 21, 30, 31, 32) and SMS_R_System.IsVirtualMachine = 0'

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
select * from v_R_System inner join v_GS_SYSTEM_ENCLOSURE on v_GS_SYSTEM_ENCLOSURE.ResourceID = v_R_System.ResourceID where v_GS_SYSTEM_ENCLOSURE.ChassisTypes0 in (8, 9, 10, 11, 12, 14, 18, 21, 30, 31, 32) and v_R_System.Is_Virtual_Machine0 = 0
```

## Hardware - Device Type - Server

A collection of devices that match the device type of Server. ChassisTypes in (23, 28) and IsVirtualMachine = 0.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Device Type - Server                                                     |
| Comment                       | A collection of devices that match the device type of Server. ChassisTypes in (23, 28) and IsVirtualMachine = 0. |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | ChassisTypes in (23, 28) and IsVirtualMachine = 0                                         |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_SYSTEM_ENCLOSURE on SMS_G_System_SYSTEM_ENCLOSURE.ResourceID = SMS_R_System.ResourceId where SMS_G_System_SYSTEM_ENCLOSURE.ChassisTypes in (23, 28) and SMS_R_System.IsVirtualMachine = 0 |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Device Type - Server"
    $Collection_Comment         = "A collection of devices that match the device type of Server. ChassisTypes in (23, 28) and IsVirtualMachine = 0. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'ChassisTypes in (23, 28) and IsVirtualMachine = 0'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_SYSTEM_ENCLOSURE on SMS_G_System_SYSTEM_ENCLOSURE.ResourceID = SMS_R_System.ResourceId where SMS_G_System_SYSTEM_ENCLOSURE.ChassisTypes in (23, 28) and SMS_R_System.IsVirtualMachine = 0'

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
select * from v_R_System inner join v_GS_SYSTEM_ENCLOSURE on v_GS_SYSTEM_ENCLOSURE.ResourceID = v_R_System.ResourceID where v_GS_SYSTEM_ENCLOSURE.ChassisTypes0 in (23, 28) and v_R_System.Is_Virtual_Machine0 = 0
```

## Hardware - Device Type - Other

A collection of devices that match the device type of Other. ChassisTypes in (1, 2) and IsVirtualMachine = 0.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Device Type - Other                                                      |
| Comment                       | A collection of devices that match the device type of Other. ChassisTypes in (1, 2) and IsVirtualMachine = 0. |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | ChassisTypes in (1, 2) and IsVirtualMachine = 0                                           |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_SYSTEM_ENCLOSURE on SMS_G_System_SYSTEM_ENCLOSURE.ResourceID = SMS_R_System.ResourceId where SMS_G_System_SYSTEM_ENCLOSURE.ChassisTypes in (1, 2) and SMS_R_System.IsVirtualMachine = 0 |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Device Type - Other"
    $Collection_Comment         = "A collection of devices that match the device type of Other. ChassisTypes in (1, 2) and IsVirtualMachine = 0. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'ChassisTypes in (1, 2) and IsVirtualMachine = 0'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_SYSTEM_ENCLOSURE on SMS_G_System_SYSTEM_ENCLOSURE.ResourceID = SMS_R_System.ResourceId where SMS_G_System_SYSTEM_ENCLOSURE.ChassisTypes in (1, 2) and SMS_R_System.IsVirtualMachine = 0'

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
select * from v_R_System inner join v_GS_SYSTEM_ENCLOSURE on v_GS_SYSTEM_ENCLOSURE.ResourceID = v_R_System.ResourceID where v_GS_SYSTEM_ENCLOSURE.ChassisTypes0 in (1, 2) and v_R_System.Is_Virtual_Machine0 = 0
```

## Hardware - Device Type - Virtual Machine

A collection of devices that match the device type of Virtual Machine.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Device Type - Virtual Machine                                            |
| Comment                       | A collection of devices that match the device type of Virtual Machine.                    |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | IsVirtualMachine = 1                                                                      |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System where SMS_R_System.IsVirtualMachine = 1                        |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Device Type - Virtual Machine"
    $Collection_Comment         = "A collection of devices that match the device type of Virtual Machine. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'IsVirtualMachine = 1'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System where SMS_R_System.IsVirtualMachine = 1'

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
select * from v_R_System where Is_Virtual_Machine0 = '1'
```

## Hardware - Manufacturer - Alienware

A collection of devices with a Manufacturer like "%Alienware%".

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Manufacturer - Alienware                                                 |
| Comment                       | A collection of devices with a Manufacturer like "%Alienware%".                           |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | Manufacturer like "%Alienware%"                                                           |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Alienware%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Manufacturer - Alienware"
    $Collection_Comment         = "A collection of devices with a Manufacturer like `"%Alienware%`". `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Manufacturer like "%Alienware%"'
    $MembershipRule_QueryLogic  = 'select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Alienware%"'

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
select * from v_R_System inner join v_GS_COMPUTER_SYSTEM on v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_COMPUTER_SYSTEM.Manufacturer0 like '%Alienware%'
```

## Hardware - Manufacturer - Amazon

A collection of devices with a Manufacturer like "%Amazon%".

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Manufacturer - Amazon                                                    |
| Comment                       | A collection of devices with a Manufacturer like "%Amazon%".                              |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | Manufacturer like "%Amazon%"                                                              |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Amazon%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Manufacturer - Amazon"
    $Collection_Comment         = "A collection of devices with a Manufacturer like `"%Amazon%`". `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Manufacturer like "%Amazon%"'
    $MembershipRule_QueryLogic  = 'select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Amazon%"'

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
select * from v_R_System inner join v_GS_COMPUTER_SYSTEM on v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_COMPUTER_SYSTEM.Manufacturer0 like '%Amazon%'
```

## Hardware - Manufacturer - Dell

A collection of devices with a Manufacturer like "%Dell%".

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Manufacturer - Dell                                                      |
| Comment                       | A collection of devices with a Manufacturer like "%Dell%".                                |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | Manufacturer like "%Dell%"                                                                |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Dell%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Manufacturer - Dell"
    $Collection_Comment         = "A collection of devices with a Manufacturer like `"%Dell%`". `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Manufacturer like "%Dell%"'
    $MembershipRule_QueryLogic  = 'select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Dell%"'

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
select * from v_R_System inner join v_GS_COMPUTER_SYSTEM on v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_COMPUTER_SYSTEM.Manufacturer0 like '%Dell%'
```

## Hardware - Manufacturer - Gateway

A collection of devices with a Manufacturer like "%Gateway%".

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Manufacturer - Gateway                                                   |
| Comment                       | A collection of devices with a Manufacturer like "%Gateway%".                             |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | Manufacturer like "%Gateway%"                                                             |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Gateway%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Manufacturer - Gateway"
    $Collection_Comment         = "A collection of devices with a Manufacturer like `"%Gateway%`". `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Manufacturer like "%Gateway%"'
    $MembershipRule_QueryLogic  = 'select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Gateway%"'

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
select * from v_R_System inner join v_GS_COMPUTER_SYSTEM on v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_COMPUTER_SYSTEM.Manufacturer0 like '%Gateway%'
```

## Hardware - Manufacturer - Gigabyte

A collection of devices with a Manufacturer like "%Gigabyte%".

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Manufacturer - Gigabyte                                                  |
| Comment                       | A collection of devices with a Manufacturer like "%Gigabyte%".                            |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | Manufacturer like "%Gigabyte%"                                                            |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Gigabyte%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Manufacturer - Gigabyte"
    $Collection_Comment         = "A collection of devices with a Manufacturer like `"%Gigabyte%`". `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Manufacturer like "%Gigabyte%"'
    $MembershipRule_QueryLogic  = 'select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Gigabyte%"'

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
select * from v_R_System inner join v_GS_COMPUTER_SYSTEM on v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_COMPUTER_SYSTEM.Manufacturer0 like '%Gigabyte%'
```

## Hardware - Manufacturer - HP

A collection of devices with a Manufacturer like "%HP%" or "%Hewlett-Packard%".

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Manufacturer - HP                                                        |
| Comment                       | A collection of devices with a Manufacturer like "%HP%" or "%Hewlett-Packard%".           |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | Manufacturer like "%HP%" or "%Hewlett-Packard%"                                           |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%HP%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Manufacturer - HP"
    $Collection_Comment         = "A collection of devices with a Manufacturer like `"%HP%`" or `"%Hewlett-Packard%`". `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Manufacturer like "%HP%" or "%Hewlett-Packard%"'
    $MembershipRule_QueryLogic  = 'select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%HP%" or SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Hewlett-Packard%"'

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
select * from v_R_System inner join v_GS_COMPUTER_SYSTEM on v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_COMPUTER_SYSTEM.Manufacturer0 like '%HP%' or v_GS_COMPUTER_SYSTEM.Manufacturer0 like '%Hewlett-Packard%'
```

## Hardware - Manufacturer - IBM

A collection of devices with a Manufacturer like "%IBM%".

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Manufacturer - IBM                                                       |
| Comment                       | A collection of devices with a Manufacturer like "%IBM%".                                 |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | Manufacturer like "%IBM%"                                                                 |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%IBM%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Manufacturer - IBM"
    $Collection_Comment         = "A collection of devices with a Manufacturer like `"%IBM%`". `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Manufacturer like "%IBM%"'
    $MembershipRule_QueryLogic  = 'select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%IBM%"'

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
select * from v_R_System inner join v_GS_COMPUTER_SYSTEM on v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_COMPUTER_SYSTEM.Manufacturer0 like '%IBM%'
```

## Hardware - Manufacturer - Intel

A collection of devices with a Manufacturer like "%Intel%".

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Manufacturer - Intel                                                     |
| Comment                       | A collection of devices with a Manufacturer like "%Intel%".                               |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | Manufacturer like "%Intel%"                                                               |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Intel%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Manufacturer - Intel"
    $Collection_Comment         = "A collection of devices with a Manufacturer like `"%Intel%`". `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Manufacturer like "%Intel%"'
    $MembershipRule_QueryLogic  = 'select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Intel%"'

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
select * from v_R_System inner join v_GS_COMPUTER_SYSTEM on v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_COMPUTER_SYSTEM.Manufacturer0 like '%Intel%'
```

## Hardware - Manufacturer - Lenovo

A collection of devices with a Manufacturer like "%Lenovo%".

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Manufacturer - Lenovo                                                    |
| Comment                       | A collection of devices with a Manufacturer like "%Lenovo%".                              |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | Manufacturer like "%Lenovo%"                                                              |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Lenovo%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Manufacturer - Lenovo"
    $Collection_Comment         = "A collection of devices with a Manufacturer like `"%Lenovo%`". `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Manufacturer like "%Lenovo%"'
    $MembershipRule_QueryLogic  = 'select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Lenovo%"'

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
select * from v_R_System inner join v_GS_COMPUTER_SYSTEM on v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_COMPUTER_SYSTEM.Manufacturer0 like '%Lenovo%'
```

## Hardware - Manufacturer - M&A Technology

A collection of devices with a Manufacturer like "%M&A Technology%".

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Manufacturer - M&A Technology                                            |
| Comment                       | A collection of devices with a Manufacturer like "%M&A Technology%".                      |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | Manufacturer like "%M&A Technology%"                                                      |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%M&A Technology%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Manufacturer - M&A Technology"
    $Collection_Comment         = "A collection of devices with a Manufacturer like `"%M&A Technology%`". `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Manufacturer like "%M&A Technology%"'
    $MembershipRule_QueryLogic  = 'select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%M&A Technology%"'

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
select * from v_R_System inner join v_GS_COMPUTER_SYSTEM on v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_COMPUTER_SYSTEM.Manufacturer0 like '%M&A Technology%'
```

## Hardware - Manufacturer - Matsushita Electric Industrial Co

A collection of devices with a Manufacturer like "%Matsushita Electric Industrial Co%".

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Manufacturer - Matsushita Electric Industrial Co                         |
| Comment                       | A collection of devices with a Manufacturer like "%Matsushita Electric Industrial Co%".   |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | Manufacturer like "%Matsushita Electric Industrial Co%"                                   |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Matsushita Electric Industrial Co%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Manufacturer - Matsushita Electric Industrial Co"
    $Collection_Comment         = "A collection of devices with a Manufacturer like `"%Matsushita Electric Industrial Co%`". `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Manufacturer like "%Matsushita Electric Industrial Co%"'
    $MembershipRule_QueryLogic  = 'select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Matsushita Electric Industrial Co%"'

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
select * from v_R_System inner join v_GS_COMPUTER_SYSTEM on v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_COMPUTER_SYSTEM.Manufacturer0 like '%Matsushita Electric Industrial Co%'
```

## Hardware - Manufacturer - Microsoft

A collection of devices with a Manufacturer like "%Microsoft%".

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Manufacturer - Microsoft                                                 |
| Comment                       | A collection of devices with a Manufacturer like "%Microsoft%".                           |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | Manufacturer like "%Microsoft%"                                                           |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Microsoft%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Manufacturer - Microsoft"
    $Collection_Comment         = "A collection of devices with a Manufacturer like `"%Microsoft%`". `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Manufacturer like "%Microsoft%"'
    $MembershipRule_QueryLogic  = 'select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Microsoft%"'

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
select * from v_R_System inner join v_GS_COMPUTER_SYSTEM on v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_COMPUTER_SYSTEM.Manufacturer0 like '%Microsoft%'
```

## Hardware - Manufacturer - Panasonic

A collection of devices with a Manufacturer like "%Panasonic%".

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Manufacturer - Panasonic                                                 |
| Comment                       | A collection of devices with a Manufacturer like "%Panasonic%".                           |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | Manufacturer like "%Panasonic%"                                                           |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Panasonic%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Manufacturer - Panasonic"
    $Collection_Comment         = "A collection of devices with a Manufacturer like `"%Panasonic%`". `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Manufacturer like "%Panasonic%"'
    $MembershipRule_QueryLogic  = 'select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Panasonic%"'

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
select * from v_R_System inner join v_GS_COMPUTER_SYSTEM on v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_COMPUTER_SYSTEM.Manufacturer0 like '%Panasonic%'
```

## Hardware - Manufacturer - Puget Systems

A collection of devices with a Manufacturer like "%Puget Systems%".

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Manufacturer - Puget Systems                                             |
| Comment                       | A collection of devices with a Manufacturer like "%Puget Systems%".                       |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | Manufacturer like "%Puget Systems%"                                                       |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Puget Systems%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Manufacturer - Puget Systems"
    $Collection_Comment         = "A collection of devices with a Manufacturer like `"%Puget Systems%`". `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Manufacturer like "%Puget Systems%"'
    $MembershipRule_QueryLogic  = 'select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Puget Systems%"'

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
select * from v_R_System inner join v_GS_COMPUTER_SYSTEM on v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_COMPUTER_SYSTEM.Manufacturer0 like '%Puget Systems%'
```

## Hardware - Manufacturer - Supermicro

A collection of devices with a Manufacturer like "%Supermicro%".

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Manufacturer - Supermicro                                                |
| Comment                       | A collection of devices with a Manufacturer like "%Supermicro%".                          |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | Manufacturer like "%Supermicro%"                                                          |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Supermicro%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Manufacturer - Supermicro"
    $Collection_Comment         = "A collection of devices with a Manufacturer like `"%Supermicro%`". `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Manufacturer like "%Supermicro%"'
    $MembershipRule_QueryLogic  = 'select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Supermicro%"'

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
select * from v_R_System inner join v_GS_COMPUTER_SYSTEM on v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_COMPUTER_SYSTEM.Manufacturer0 like '%Supermicro%'
```

## Hardware - Manufacturer - To Be Filled By O.E.M.

A collection of devices with a Manufacturer like "%To Be Filled By O.E.M.%".

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Manufacturer - To Be Filled By O.E.M.                                    |
| Comment                       | A collection of devices with a Manufacturer like "%To Be Filled By O.E.M.%".              |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | Manufacturer like "%To Be Filled By O.E.M.%"                                              |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%To Be Filled By O.E.M.%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Manufacturer - To Be Filled By O.E.M."
    $Collection_Comment         = "A collection of devices with a Manufacturer like `"%To Be Filled By O.E.M.%`". `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Manufacturer like "%To Be Filled By O.E.M.%"'
    $MembershipRule_QueryLogic  = 'select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%To Be Filled By O.E.M.%"'

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
select * from v_R_System inner join v_GS_COMPUTER_SYSTEM on v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_COMPUTER_SYSTEM.Manufacturer0 like '%To Be Filled By O.E.M.%'
```

## Hardware - Manufacturer - VMware

A collection of devices with a Manufacturer like "%VMware%".

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Manufacturer - VMware                                                    |
| Comment                       | A collection of devices with a Manufacturer like "%VMware%".                              |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | Manufacturer like "%VMware%"                                                              |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%VMware%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Manufacturer - VMware"
    $Collection_Comment         = "A collection of devices with a Manufacturer like `"%VMware%`". `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Manufacturer like "%VMware%"'
    $MembershipRule_QueryLogic  = 'select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%VMware%"'

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
select * from v_R_System inner join v_GS_COMPUTER_SYSTEM on v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_COMPUTER_SYSTEM.Manufacturer0 like '%VMware%'
```

## Hardware - Manufacturer - Xen

A collection of devices with a Manufacturer like "%Xen%".

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Manufacturer - Xen                                                       |
| Comment                       | A collection of devices with a Manufacturer like "%Xen%".                                 |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | Manufacturer like "%Xen%"                                                                 |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Xen%" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
    $Collection_Name            = "LIE - Hardware - Manufacturer - Xen"
    $Collection_Comment         = "A collection of devices with a Manufacturer like `"%Xen%`". `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Manufacturer like "%Xen%"'
    $MembershipRule_QueryLogic  = 'select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Manufacturer like "%Xen%"'

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
select * from v_R_System inner join v_GS_COMPUTER_SYSTEM on v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID where v_GS_COMPUTER_SYSTEM.Manufacturer0 like '%Xen%'
```

## Hardware - Model - [All Models]

This is a dynamic script that will query the MECM database for all the Models that have been returned by client managed devices during inventory.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - Model - [All Models]                                                     |
| Comment                       | A collection of devices with a Model equal to `"$($Item.Model)`".                         |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Name                          | Model = "%$($Item.Model)%"                                                                |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Model = `"$($Item.Model)`" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Datasets
    $MECM_Hardware_Models = Get-WmiObject -Namespace "root\sms\site_[SiteCode]" -Class SMS_G_System_COMPUTER_SYSTEM | Select-Object -Property Model -Unique

# Iterate Through Datasets
    foreach ($Item in $MECM_Hardware_Models) {
        Write-Host "Model:"$Item.Model

        if (Get-CMCollection -CollectionType Device -Name "LIE - Hardware - Model - $($Item.Model)") {
            Write-Host "    - Already Exists"
        }
        else {
            # Variables
                $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Hardware"
                $Collection_Name            = "LIE - Hardware - Model - $($Item.Model)"
                $Collection_Comment         = "A collection of devices with a Model equal to `"$($Item.Model)`". `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
                $Collection_Limiting        = "LIE - # Primary - All - Windows"
                $Collection_Type            = "Device"
                $Collection_RefreshType     = "Both"
                $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
                $MembershipRule_Name        = 'Model = "%$($Item.Model)%"'
                $MembershipRule_QueryLogic  = "select *  from  SMS_R_System inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_G_System_COMPUTER_SYSTEM.Model = `"$($Item.Model)`""

            # Create Collection
                $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType -RefreshSchedule $Schedule_FullUpdate

            # Move to Folder
                Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

            # Set Membership Rules
                Add-CMDeviceCollectionQueryMembershipRule -InputObject $Object_Collection -RuleName $MembershipRule_Name -QueryExpression $MembershipRule_QueryLogic

            # Output
                Write-Host "    - Created"
        }

        Write-Host ""
    }
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
select distinct Model0 from v_GS_COMPUTER_SYSTEM
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

## Hardware - [CollectionName]

[BriefDescription]

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Hardware - [CollectionName]                                                         |
| Comment                       | [BriefDescription]                                                                        |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Hardware                  |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:20 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\[FolderName]"
    $Collection_Name            = "LIE - Hardware - [CollectionName]"
    $Collection_Comment         = "[BriefDescription] `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "20" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
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





