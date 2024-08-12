# MECM Toolkit -oolkit - Collections - OS - Operating System

| Property     | Value                                                                                                                                                                                                              |
|--------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Path         | \\Assets and Compliance\\Overview\\Device Collections\\VividRock\\OS - Operating System                                                                                                                            |
| Category     | Production                                                                                                                                                                                                         |
| Description  | All production collections are where you target deployments and implement change. These collections should utilize the Limit, Include, and Exclude collections for membership to ensure consistency.               |
| Type         | Operating System                                                                                                                                                                                                   |
| Description  | This is a set of collections used to deploy Operating System Task Sequences to devices.                                                                                                                            |

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

- [MECM - Collections - OS - Operating System](#mecm---collections---os---operating-system)
  - [About](#about)
  - [Prerequisites](#prerequisites)
  - [List of Collections](#list-of-collections)
  - [OS - Windows 7 - Install - Development](#os---windows-7---install---development)
    - [General](#general)
    - [Membership Rules](#membership-rules)
    - [Update Schedule](#update-schedule)
    - [PowerShell](#powershell)
    - [SQL Query](#sql-query)
  - [OS - Windows 7 - Install - Testing](#os---windows-7---install---testing)
    - [General](#general-1)
    - [Membership Rules](#membership-rules-1)
    - [Update Schedule](#update-schedule-1)
    - [PowerShell](#powershell-1)
    - [SQL Query](#sql-query-1)
  - [OS - Windows 7 - Install - Production](#os---windows-7---install---production)
    - [General](#general-2)
    - [Membership Rules](#membership-rules-2)
    - [Update Schedule](#update-schedule-2)
    - [PowerShell](#powershell-2)
    - [SQL Query](#sql-query-2)
  - [OS - Windows 10 - Install - Development](#os---windows-10---install---development)
    - [General](#general-3)
    - [Membership Rules](#membership-rules-3)
    - [Update Schedule](#update-schedule-3)
    - [PowerShell](#powershell-3)
    - [SQL Query](#sql-query-3)
  - [OS - Windows 10 - Install - Testing](#os---windows-10---install---testing)
    - [General](#general-4)
    - [Membership Rules](#membership-rules-4)
    - [Update Schedule](#update-schedule-4)
    - [PowerShell](#powershell-4)
    - [SQL Query](#sql-query-4)
  - [OS - Windows 10 - Install - Production](#os---windows-10---install---production)
    - [General](#general-5)
    - [Membership Rules](#membership-rules-5)
    - [Update Schedule](#update-schedule-5)
    - [PowerShell](#powershell-5)
    - [SQL Query](#sql-query-5)
  - [OS - Windows 11 - Install - Development](#os---windows-11---install---development)
    - [General](#general-6)
    - [Membership Rules](#membership-rules-6)
    - [Update Schedule](#update-schedule-6)
    - [PowerShell](#powershell-6)
    - [SQL Query](#sql-query-6)
  - [OS - Windows 11 - Install - Testing](#os---windows-11---install---testing)
    - [General](#general-7)
    - [Membership Rules](#membership-rules-7)
    - [Update Schedule](#update-schedule-7)
    - [PowerShell](#powershell-7)
    - [SQL Query](#sql-query-7)
  - [OS - Windows 11 - Install - Production](#os---windows-11---install---production)
    - [General](#general-8)
    - [Membership Rules](#membership-rules-8)
    - [Update Schedule](#update-schedule-8)
    - [PowerShell](#powershell-8)
    - [SQL Query](#sql-query-8)
- [Apdx A: Install All Collections](#apdx-a-install-all-collections)
- [Apdx B: Collection Template](#apdx-b-collection-template)
  - [OS - \[CollectionName\]](#os---collectionname)
    - [General](#general-9)
    - [Membership Rules](#membership-rules-9)
    - [Update Schedule](#update-schedule-9)
    - [PowerShell](#powershell-9)
    - [SQL Query](#sql-query-9)

&nbsp;

## OS - Windows 7 - Install - Development

A collection of all Windows 7 devices that should have the development version of the Install Task Sequences targeted to them.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | OS - Windows 7 - Install - Development                                                   |
| Comment                       | A collection of all Windows 7 devices that should have the development version of the Install Task Sequences targeted to them. |
| Limiting Collection           | All Systems                                                                               |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\OS - Operating System                                      |

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
| Collection Name(s)            | LIE - Department - IT - MECM Engineering - Development Devices                            |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disable                                                                                   |
| Full Updates                  | None                                                                                      |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\OS - Operating System"
    $Collection_Name            = "OS - Windows 7 - Install - Development"
    $Collection_Comment         = "A collection of all Windows 7 devices that should have the development version of the Install Task Sequences targeted to them. `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "All Systems"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Manual"
    $MembershipRule_Include     = "LIE - Department - IT - MECM Engineering - Development Devices"


# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- None
```

## OS - Windows 7 - Install - Testing

A collection of all Windows 7 devices that should have the Testing version of the Install Task Sequences targeted to them.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | OS - Windows 7 - Install - Testing                                                       |
| Comment                       | A collection of all Windows 7 devices that should have the Testing version of the Install Task Sequences targeted to them. |
| Limiting Collection           | All Systems                                                                               |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\OS - Operating System                                      |

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
| Collection Name(s)            | LIE - Department - IT - MECM Engineering - Testing Devices                                |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disable                                                                                   |
| Full Updates                  | None                                                                                      |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\OS - Operating System"
    $Collection_Name            = "OS - Windows 7 - Install - Testing"
    $Collection_Comment         = "A collection of all Windows 7 devices that should have the Testing version of the Install Task Sequences targeted to them. `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "All Systems"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Manual"
    $MembershipRule_Include     = "LIE - Department - IT - MECM Engineering - Testing Devices"


# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- None
```

## OS - Windows 7 - Install - Production

A collection of all Windows 7 devices that should have the Production version of the Install Task Sequences targeted to them.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | OS - Windows 7 - Install - Production                                                    |
| Comment                       | A collection of all Windows 7 devices that should have the Production version of the Install Task Sequences targeted to them. |
| Limiting Collection           | All Systems                                                                               |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\OS - Operating System                                      |

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
| Collection Name(s)            | All Unknown Computers                                                                     |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disable                                                                                   |
| Full Updates                  | None                                                                                      |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\OS - Operating System"
    $Collection_Name            = "OS - Windows 7 - Install - Production"
    $Collection_Comment         = "A collection of all Windows 7 devices that should have the Production version of the Install Task Sequences targeted to them. `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "All Systems"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Manual"
    $MembershipRule_Include     = "All Unknown Computers"


# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- None
```

## OS - Windows 10 - Install - Development

A collection of all Windows 10 devices that should have the development version of the Install Task Sequences targeted to them.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | OS - Windows 10 - Install - Development                                                   |
| Comment                       | A collection of all Windows 10 devices that should have the development version of the Install Task Sequences targeted to them. |
| Limiting Collection           | All Systems                                                                               |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\OS - Operating System                                      |

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
| Collection Name(s)            | LIE - Department - IT - MECM Engineering - Development Devices                            |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disable                                                                                   |
| Full Updates                  | None                                                                                      |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\OS - Operating System"
    $Collection_Name            = "OS - Windows 10 - Install - Development"
    $Collection_Comment         = "A collection of all Windows 10 devices that should have the development version of the Install Task Sequences targeted to them. `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "All Systems"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Manual"
    $MembershipRule_Include     = "LIE - Department - IT - MECM Engineering - Development Devices"


# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- None
```

## OS - Windows 10 - Install - Testing

A collection of all Windows 10 devices that should have the Testing version of the Install Task Sequences targeted to them.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | OS - Windows 10 - Install - Testing                                                       |
| Comment                       | A collection of all Windows 10 devices that should have the Testing version of the Install Task Sequences targeted to them. |
| Limiting Collection           | All Systems                                                                               |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\OS - Operating System                                      |

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
| Collection Name(s)            | LIE - Department - IT - MECM Engineering - Testing Devices                                |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disable                                                                                   |
| Full Updates                  | None                                                                                      |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\OS - Operating System"
    $Collection_Name            = "OS - Windows 10 - Install - Testing"
    $Collection_Comment         = "A collection of all Windows 10 devices that should have the Testing version of the Install Task Sequences targeted to them. `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "All Systems"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Manual"
    $MembershipRule_Include     = "LIE - Department - IT - MECM Engineering - Testing Devices"


# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- None
```

## OS - Windows 10 - Install - Production

A collection of all Windows 10 devices that should have the Production version of the Install Task Sequences targeted to them.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | OS - Windows 10 - Install - Production                                                    |
| Comment                       | A collection of all Windows 10 devices that should have the Production version of the Install Task Sequences targeted to them. |
| Limiting Collection           | All Systems                                                                               |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\OS - Operating System                                      |

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
| Collection Name(s)            | All Unknown Computers                                                                     |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disable                                                                                   |
| Full Updates                  | None                                                                                      |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\OS - Operating System"
    $Collection_Name            = "OS - Windows 10 - Install - Production"
    $Collection_Comment         = "A collection of all Windows 10 devices that should have the Production version of the Install Task Sequences targeted to them. `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "All Systems"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Manual"
    $MembershipRule_Include     = "All Unknown Computers"


# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- None
```

## OS - Windows 11 - Install - Development

A collection of all Windows 11 devices that should have the development version of the Install Task Sequences targeted to them.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | OS - Windows 11 - Install - Development                                                   |
| Comment                       | A collection of all Windows 11 devices that should have the development version of the Install Task Sequences targeted to them. |
| Limiting Collection           | All Systems                                                                               |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\OS - Operating System                                      |

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
| Collection Name(s)            | LIE - Department - IT - MECM Engineering - Development Devices                            |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disable                                                                                   |
| Full Updates                  | None                                                                                      |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\OS - Operating System"
    $Collection_Name            = "OS - Windows 11 - Install - Development"
    $Collection_Comment         = "A collection of all Windows 11 devices that should have the development version of the Install Task Sequences targeted to them. `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "All Systems"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Manual"
    $MembershipRule_Include     = "LIE - Department - IT - MECM Engineering - Development Devices"


# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- None
```

## OS - Windows 11 - Install - Testing

A collection of all Windows 11 devices that should have the Testing version of the Install Task Sequences targeted to them.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | OS - Windows 11 - Install - Testing                                                       |
| Comment                       | A collection of all Windows 11 devices that should have the Testing version of the Install Task Sequences targeted to them. |
| Limiting Collection           | All Systems                                                                               |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\OS - Operating System                                      |

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
| Collection Name(s)            | LIE - Department - IT - MECM Engineering - Testing Devices                                |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disable                                                                                   |
| Full Updates                  | None                                                                                      |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\OS - Operating System"
    $Collection_Name            = "OS - Windows 11 - Install - Testing"
    $Collection_Comment         = "A collection of all Windows 11 devices that should have the Testing version of the Install Task Sequences targeted to them. `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "All Systems"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Manual"
    $MembershipRule_Include     = "LIE - Department - IT - MECM Engineering - Testing Devices"


# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- None
```

## OS - Windows 11 - Install - Production

A collection of all Windows 11 devices that should have the Production version of the Install Task Sequences targeted to them.

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | OS - Windows 11 - Install - Production                                                    |
| Comment                       | A collection of all Windows 11 devices that should have the Production version of the Install Task Sequences targeted to them. |
| Limiting Collection           | All Systems                                                                               |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\OS - Operating System                                      |

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
| Collection Name(s)            | All Unknown Computers                                                                     |

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Enabled                       | False                                                                                     |
| Type                          | Exclude                                                                                   |
| Collection Name(s)            | [Name]                                                                                    |

### Update Schedule

| Type                          | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Incremental Updates           | Disable                                                                                   |
| Full Updates                  | None                                                                                      |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\OS - Operating System"
    $Collection_Name            = "OS - Windows 11 - Install - Production"
    $Collection_Comment         = "A collection of all Windows 11 devices that should have the Production version of the Install Task Sequences targeted to them. `n    Include: True `n    Exclude: False `n    Direct:  False `n    Query:   False"
    $Collection_Limiting        = "All Systems"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "Manual"
    $MembershipRule_Include     = "All Unknown Computers"


# Create Collection
    $Object_Collection = New-CMCollection -Name $Collection_Name -Comment $Collection_Comment -LimitingCollectionName $Collection_Limiting -CollectionType $Collection_Type -RefreshType $Collection_RefreshType

# Move to Folder
    Move-CMObject -InputObject $Object_Collection -FolderPath $MECM_FolderPath

# Set Membership Rules
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName $Collection_Name -IncludeCollectionName $MembershipRule_Include
```

### SQL Query

The below snippet can be used from the SQL Server Management Studio (or your tool of choice) to query the same information that the Collection is pulling.

```sql
-- None
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

## OS - [CollectionName]

[BriefDescription]

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Name                          | OS - [CollectionName]                                                                     |
| Comment                       | [BriefDescription]                                                                        |
| Limiting Collection           | [LimitingCollectionName]                                                                  |
| Type                          | Device                                                                                    |
| Folder Path                   | \\DeviceCollection\\VividRock\\OS - Operating System                                      |

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
| Incremental Updates           | [Enabled/Disabled]                                                                        |
| Full Updates                  | [Schedule]                                                                                |

### PowerShell

This snippet will create the collection with all of the identified settings above. If you wish to customize it, you can do so in the script or later in the GUI.

> Note: You must run this in a PowerShell instance that is already connected to an MECM PS Drive.

```powershell
# Variables
    $MECM_FolderPath            = "\DeviceCollection\VividRock\OS - Operating System"
    $Collection_Name            = "OS - [CollectionName]"
    $Collection_Comment         = "[BriefDescription] `n    Include: [True/False] `n    Exclude: [True/False] `n    Direct:  [True/False] `n    Query:   [True/False]"
    $Collection_Limiting        = "[LimitingCollectionName]"
    $Collection_Type            = "Device"
    $Collection_RefreshType     = "[Manual/Periodic/Continuous/Both]"
    $Schedule_FullUpdate        = New-CMSchedule -Start (Get-Date -Date "01/01/2020" -Hour "19" -Minute "54" -Second "00" -Format o) -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 1
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
