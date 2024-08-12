# MECM Toolkit - Collections - LIE - Security

| Property     | Value                                                                                                                                                                                                              |
|--------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Path         | \\Assets and Compliance\\Overview\\Device Collections\\VividRock\\# LIE - Limit, Include, Exclude\\Security                                                                                                    |
| Category     | LIE                                                                                                                                                                                                                |
| Description  | All LIE collections should be used to Limit, Include, and Exclude objects on all other collections.                                                                                                                |
| Type         | Security                                                                                                                                                                                                       |
| Description  | This is a set of collections that can be used as to identify devices that have a specific Security state.                                                                                                                              |

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

- [MECM - Collections - LIE - Security](#mecm---collections---lie---security)
  - [About](#about)
  - [Prerequisites](#prerequisites)
  - [List of Collections](#list-of-collections)
  - [Security - BitLocker Management Enabled](#security---bitlocker-management-enabled)
    - [General](#general)
    - [Membership Rules](#membership-rules)
    - [Update Schedule](#update-schedule)
    - [PowerShell](#powershell)
    - [SQL Query](#sql-query)
- [Apdx A: Install All Collections](#apdx-a-install-all-collections)
- [Apdx B: Collection Template](#apdx-b-collection-template)
  - [Security - \[CollectionName\]](#security---collectionname)
    - [General](#general-1)
    - [Membership Rules](#membership-rules-1)
    - [Update Schedule](#update-schedule-1)
    - [PowerShell](#powershell-1)
    - [SQL Query](#sql-query-1)

&nbsp;

## Security - BitLocker Management Enabled

A collection of devices that have the MECM BitLocker Management MDOP MBAM software installed.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Security - BitLocker Management Enabled                                                     |
| Comment                       | A collection of devices that have the MECM BitLocker Management MDOP MBAM software installed. |
| Limiting Collection           | LIE - # Primary - All - Windows                                                                  |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Security                  |

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
| Name                          | Installed Applications (64).DisplayName = MDOP MBAM                                       |
| Resource Class                | System Resource                                                                           |
| Snippet                       | select * from  SMS_R_System inner join SMS_G_System_ADD_REMOVE_PROGRAMS_64 on SMS_G_System_ADD_REMOVE_PROGRAMS_64.ResourceId = SMS_R_System.ResourceId where SMS_G_System_ADD_REMOVE_PROGRAMS_64.DisplayName = "MDOP MBAM" |

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
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:28 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Security"
    $Collection_Name            = "LIE - Security - BitLocker Management Enabled"
    $Collection_Comment         = "A collection of devices that have the MECM BitLocker Management MDOP MBAM software installed. `n    Include: False `n    Exclude: False `n    Direct:  False `n    Query:   True"
    $Collection_Limiting        = "LIE - # Primary - All - Windows"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "28" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
    $MembershipRule_Name        = 'Installed Applications (64).DisplayName = MDOP MBAM'
    $MembershipRule_QueryLogic  = 'select * from  SMS_R_System inner join SMS_G_System_ADD_REMOVE_PROGRAMS_64 on SMS_G_System_ADD_REMOVE_PROGRAMS_64.ResourceId = SMS_R_System.ResourceId where SMS_G_System_ADD_REMOVE_PROGRAMS_64.DisplayName = "MDOP MBAM"'

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
select * from v_R_System inner join v_GS_ADD_REMOVE_PROGRAMS_64 on v_GS_ADD_REMOVE_PROGRAMS_64.ResourceID = v_R_System.ResourceID where v_GS_ADD_REMOVE_PROGRAMS_64.DisplayName0 = 'MDOP MBAM'
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

## Security - [CollectionName]

[BriefDescription]

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | LIE - Security - [CollectionName]                                                     |
| Comment                       | [BriefDescription]                                                                        |
| Limiting Collection           | [LimitingCollectionName]                                                                  |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\# LIE - Limit, Include, Exclude\\Security                  |

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
| Collection Name(s)            | [Name]                                                                                    |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | [True/False]                                                                              |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Enabled                                                                                   |
| Full Updates                  | Occurs every 1 days effective 1/01/2020 7:28 PM                                           |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\# LIE - Limit, Include, Exclude\Security"
    $Collection_Name            = "LIE - Security - [CollectionName]"
    $Collection_Comment         = "[BriefDescription] `n    Include: [True/False] `n    Exclude: [True/False] `n    Direct:  [True/False] `n    Query:   [True/False]"
    $Collection_Limiting        = "[LimitingCollectionName]"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Both"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "28" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
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
