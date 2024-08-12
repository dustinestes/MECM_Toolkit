# MECM Toolkit - Collections - LIE - Storage

| Property     | Value                                                                                                                                                                                                              |
|--------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Path         | \\Assets and Compliance\\Overview\\Device Collections\\VividRock\\# LIE - Limit, Include, Exclude\\Storage                                                                                                         |
| Category     | LIE                                                                                                                                                                                                                |
| Description  | All LIE collections should be used to Limit, Include, and Exclude objects on all other collections.                                                                                                                |
| Type         | Storage                                                                                                                                                                                                            |
| Description  | This is a set of collections that can be used as to identify devices that have various issues, configurations, etc. with their local storage.                                                                      |

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

- [MECM - Collections - LIE - Storage](#mecm---collections---lie---storage)
  - [About](#about)
  - [Prerequisites](#prerequisites)
  - [List of Collections](#list-of-collections)
  - [LIE - Storage - C: \< 30 GB](#lie---storage---c--30-gb)
    - [General](#general)
    - [Membership Rules](#membership-rules)
    - [Update Schedule](#update-schedule)
    - [PowerShell](#powershell)
    - [SQL Query](#sql-query)
  - [LIE - Storage - C: \< 20 GB](#lie---storage---c--20-gb)
    - [General](#general-1)
    - [Membership Rules](#membership-rules-1)
    - [Update Schedule](#update-schedule-1)
    - [PowerShell](#powershell-1)
    - [SQL Query](#sql-query-1)
  - [LIE - Storage - C: \< 10 GB](#lie---storage---c--10-gb)
    - [General](#general-2)
    - [Membership Rules](#membership-rules-2)
    - [Update Schedule](#update-schedule-2)
    - [PowerShell](#powershell-2)
    - [SQL Query](#sql-query-2)
  - [LIE - Storage - C: \< 05 GB](#lie---storage---c--05-gb)
    - [General](#general-3)
    - [Membership Rules](#membership-rules-3)
    - [Update Schedule](#update-schedule-3)
    - [PowerShell](#powershell-3)
    - [SQL Query](#sql-query-3)
  - [LIE - Storage - C: \< 01 GB](#lie---storage---c--01-gb)
    - [General](#general-4)
    - [Membership Rules](#membership-rules-4)
    - [Update Schedule](#update-schedule-4)
    - [PowerShell](#powershell-4)
    - [SQL Query](#sql-query-4)
- [Apdx A: Install All Collections](#apdx-a-install-all-collections)
- [Apdx B: Collection Template](#apdx-b-collection-template)
  - [LIE - Storage - \[CollectionName\]](#lie---storage---collectionname)
    - [General](#general-5)
    - [Membership Rules](#membership-rules-5)
    - [Update Schedule](#update-schedule-5)
    - [PowerShell](#powershell-5)
    - [SQL Query](#sql-query-5)

&nbsp;

## LIE - Storage - C: < 30 GB

A collection of devices with less than 30 GB of freespace on the C: drive.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Storage - C: < 30 GB                                                                |
| Comment                       | A collection of devices with less than 30 GB of freespace on the C: drive.                |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Storage                   |

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
| Name                          | FreeSpace < 30720                                                                         |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_LOGICAL_DISK on SMS_G_System_LOGICAL_DISK.ResourceID = SMS_R_System.ResourceId where SMS_G_System_LOGICAL_DISK.Name = "C:" and SMS_G_System_LOGICAL_DISK.FreeSpace < 30720 |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:32 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Storage"
    $Collection_Name            = "LIE - Storage - C: < 30 GB"
    $Collection_Comment         = "A collection of devices with less than 30 GB of freespace on the C: drive. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "32" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'FreeSpace < 30720'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_LOGICAL_DISK on SMS_G_System_LOGICAL_DISK.ResourceID = SMS_R_System.ResourceId where SMS_G_System_LOGICAL_DISK.Name = "C:" and SMS_G_System_LOGICAL_DISK.FreeSpace < 30720'

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
select * from v_R_System INNER JOIN v_GS_LOGICAL_DISK ON v_GS_LOGICAL_DISK.ResourceID = v_R_System.ResourceID where (v_GS_LOGICAL_DISK.Name0 = 'C:' AND v_GS_LOGICAL_DISK.FreeSpace0 < 30720)
```

## LIE - Storage - C: < 20 GB

A collection of devices with less than 20 GB of freespace on the C: drive.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Storage - C: < 20 GB                                                                |
| Comment                       | A collection of devices with less than 20 GB of freespace on the C: drive.                |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Storage                   |

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
| Name                          | FreeSpace < 20480                                                                         |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_LOGICAL_DISK on SMS_G_System_LOGICAL_DISK.ResourceID = SMS_R_System.ResourceId where SMS_G_System_LOGICAL_DISK.Name = "C:" and SMS_G_System_LOGICAL_DISK.FreeSpace < 20480 |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:32 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Storage"
    $Collection_Name            = "LIE - Storage - C: < 20 GB"
    $Collection_Comment         = "A collection of devices with less than 20 GB of freespace on the C: drive. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "32" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'FreeSpace < 20480'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_LOGICAL_DISK on SMS_G_System_LOGICAL_DISK.ResourceID = SMS_R_System.ResourceId where SMS_G_System_LOGICAL_DISK.Name = "C:" and SMS_G_System_LOGICAL_DISK.FreeSpace < 20480'

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
select * from v_R_System INNER JOIN v_GS_LOGICAL_DISK ON v_GS_LOGICAL_DISK.ResourceID = v_R_System.ResourceID where (v_GS_LOGICAL_DISK.Name0 = 'C:' AND v_GS_LOGICAL_DISK.FreeSpace0 < 20480)
```

## LIE - Storage - C: < 10 GB

A collection of devices with less than 10 GB of freespace on the C: drive.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Storage - C: < 10 GB                                                                |
| Comment                       | A collection of devices with less than 10 GB of freespace on the C: drive.                |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Storage                   |

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
| Name                          | FreeSpace < 10240                                                                         |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_LOGICAL_DISK on SMS_G_System_LOGICAL_DISK.ResourceID = SMS_R_System.ResourceId where SMS_G_System_LOGICAL_DISK.Name = "C:" and SMS_G_System_LOGICAL_DISK.FreeSpace < 10240 |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:32 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Storage"
    $Collection_Name            = "LIE - Storage - C: < 10 GB"
    $Collection_Comment         = "A collection of devices with less than 10 GB of freespace on the C: drive. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "32" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'FreeSpace < 10240'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_LOGICAL_DISK on SMS_G_System_LOGICAL_DISK.ResourceID = SMS_R_System.ResourceId where SMS_G_System_LOGICAL_DISK.Name = "C:" and SMS_G_System_LOGICAL_DISK.FreeSpace < 10240'

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
select * from v_R_System INNER JOIN v_GS_LOGICAL_DISK ON v_GS_LOGICAL_DISK.ResourceID = v_R_System.ResourceID where (v_GS_LOGICAL_DISK.Name0 = 'C:' AND v_GS_LOGICAL_DISK.FreeSpace0 < 10240)
```

## LIE - Storage - C: < 05 GB

A collection of devices with less than 05 GB of freespace on the C: drive.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Storage - C: < 05 GB                                                                |
| Comment                       | A collection of devices with less than 05 GB of freespace on the C: drive.                |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Storage                   |

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
| Name                          | FreeSpace < 5120                                                                         |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_LOGICAL_DISK on SMS_G_System_LOGICAL_DISK.ResourceID = SMS_R_System.ResourceId where SMS_G_System_LOGICAL_DISK.Name = "C:" and SMS_G_System_LOGICAL_DISK.FreeSpace < 5120 |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:32 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Storage"
    $Collection_Name            = "LIE - Storage - C: < 05 GB"
    $Collection_Comment         = "A collection of devices with less than 05 GB of freespace on the C: drive. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "32" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'FreeSpace < 5120'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_LOGICAL_DISK on SMS_G_System_LOGICAL_DISK.ResourceID = SMS_R_System.ResourceId where SMS_G_System_LOGICAL_DISK.Name = "C:" and SMS_G_System_LOGICAL_DISK.FreeSpace < 5120'

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
select * from v_R_System INNER JOIN v_GS_LOGICAL_DISK ON v_GS_LOGICAL_DISK.ResourceID = v_R_System.ResourceID where (v_GS_LOGICAL_DISK.Name0 = 'C:' AND v_GS_LOGICAL_DISK.FreeSpace0 < 5120)
```

## LIE - Storage - C: < 01 GB

A collection of devices with less than 01 GB of freespace on the C: drive.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Storage - C: < 01 GB                                                                |
| Comment                       | A collection of devices with less than 01 GB of freespace on the C: drive.                |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Storage                   |

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
| Name                          | FreeSpace < 1024                                                                         |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from SMS_R_System inner join SMS_G_System_LOGICAL_DISK on SMS_G_System_LOGICAL_DISK.ResourceID = SMS_R_System.ResourceId where SMS_G_System_LOGICAL_DISK.Name = "C:" and SMS_G_System_LOGICAL_DISK.FreeSpace < 1024 |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:32 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Storage"
    $Collection_Name            = "LIE - Storage - C: < 01 GB"
    $Collection_Comment         = "A collection of devices with less than 01 GB of freespace on the C: drive. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "32" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'FreeSpace < 1024'
    $MembershipRule_QueryLogic  = 'select * from SMS_R_System inner join SMS_G_System_LOGICAL_DISK on SMS_G_System_LOGICAL_DISK.ResourceID = SMS_R_System.ResourceId where SMS_G_System_LOGICAL_DISK.Name = "C:" and SMS_G_System_LOGICAL_DISK.FreeSpace < 1024'

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
select * from v_R_System INNER JOIN v_GS_LOGICAL_DISK ON v_GS_LOGICAL_DISK.ResourceID = v_R_System.ResourceID where (v_GS_LOGICAL_DISK.Name0 = 'C:' AND v_GS_LOGICAL_DISK.FreeSpace0 < 1024)
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

## LIE - Storage - [CollectionName]

[BriefDescription]

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Storage - [CollectionName]                                                          |
| Comment                       | [BriefDescription]                                                                        |
| Limiting Collection           | LIE - # Primary - All - Windows                                                           |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Storage                   |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:32 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Storage"
    $Collection_Name            = "LIE - Storage - [CollectionName]"
    $Collection_Comment         = "[BriefDescription] `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "32" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
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
