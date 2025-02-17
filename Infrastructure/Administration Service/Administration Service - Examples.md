# MECM Toolkit - Infrastructure - Administration Service - Examples

<br>

## Table of Contents

- [MECM Toolkit - Infrastructure - Administration Service - Examples](#mecm-toolkit---infrastructure---administration-service---examples)
  - [Table of Contents](#table-of-contents)
- [Collections](#collections)
  - [Creation](#creation)
    - [Create Collection](#create-collection)
      - [Snippet](#snippet)
      - [Output](#output)
  - [Deletion](#deletion)
    - [Delete Collection](#delete-collection)
      - [Snippet](#snippet-1)
      - [Output](#output-1)
  - [Organization](#organization)
    - [Move Collection to Folder (From Root Folder)](#move-collection-to-folder-from-root-folder)
      - [Snippet](#snippet-2)
      - [Output](#output-2)
    - [Move Collection to Folder (From Sub Folder)](#move-collection-to-folder-from-sub-folder)
      - [Snippet](#snippet-3)
      - [Output](#output-3)
  - [Membership](#membership)
    - [TODO: Add Collection Membership Rule](#todo-add-collection-membership-rule)
  - [Querying](#querying)
    - [Get All Collections where Name Contains a String (No Wildcard)](#get-all-collections-where-name-contains-a-string-no-wildcard)
      - [Snippet](#snippet-4)
      - [Output](#output-4)
- [Content Management](#content-management)
  - [Content Distribution Status](#content-distribution-status)
    - [Get Failed Distributions](#get-failed-distributions)
      - [Output](#output-5)
    - [Get Packages with No Distributions](#get-packages-with-no-distributions)
      - [Output](#output-6)
    - [Cancel Pending Distributions](#cancel-pending-distributions)
      - [Output](#output-7)
- [\[Category\]](#category)
  - [\[SubCategory\]](#subcategory)
    - [\[Function\]](#function)
      - [Output](#output-8)
- [Appendices](#appendices)
  - [Apdx A: \[Name\]](#apdx-a-name)
  - [Template](#template)
    - [\[StepName\]](#stepname)
      - [Snippet](#snippet-5)
      - [Output](#output-9)

<br>

# Collections

## Creation

### Create Collection

You can use this snippet to create a new Collection in MECM.

> Note: This creates it at the Collection root folder. If you want to store the collection in a different folder, you have to create a ContainerItem for the new object (or there is a method for moving existing items.)

| Property | Type | Required | Description |
|-|-|-|-|
| [Collection Type](https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/core/clients/collections/sms_collection-server-wmi-class#collectiontype) | UInt32 | True | Defines whether the new Collection is a User or Device Collection. |
| [Name](https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/core/clients/collections/sms_collection-server-wmi-class#name) | String | True | The name of the new Collection. |
| [LimitToCollectionID](https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/core/clients/collections/sms_collection-server-wmi-class#limittocollectionid) | String | *True | The Collection ID of an existing Collection that this new Collection will be limited by. <br><br>**Note:** You can use either this ID based one or the below Name based one, not both. |
| [LimitToCollectionName](https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/core/clients/collections/sms_collection-server-wmi-class#limittocollectionname) | String | *True | The Collection Name of an existing Collection that this new Collection will be limited by. <br><br>**Note:** You can use either this Name based one or the above ID based one, not both. |
| [Comment](https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/core/clients/collections/sms_collection-server-wmi-class#comment) | String | False | A comment that provides some context or detail as to the purpose or use of the new Collection. |

#### Snippet

```powershell
# Create Collection
    $Path_AdminService_WMIRoute = "https://[SMSProvider]/AdminService/wmi/"
    $Odata_Class = "SMS_Collection"
    $Odata_Body = @{
      Name                = "AM - Users - Microsoft Corporation - Microsoft Endpoint Configuration Manager Console"
      LimitToCollectionID = "SMS00004"
      Comment             = "Collection created using the REST API."
      CollectionType      = 1
    } | ConvertTo-Json
    Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $Odata_Class)" -Method Post -Body $Odata_Body -ContentType "application/json" -UseDefaultCredentials
```

#### Output

```powershell
@odata.context                        : https://[SMSProvider]/AdminService/wmi/$metadata#SMS_Collection/$entity
@odata.etag                           : ABC00200
__LAZYPROPERTIES                      : {__QUALIFIER_SECURITYVERBS, CollectionRules, ISVData, ISVDataSize...}
__QUALIFIER_SECURITYVERBS             : -1
CloudSyncCount                        : 0
CollectionID                          : ABC00200
CollectionType                        : 1
CollectionVariablesCount              : 0
Comment                               : Collection created using the REST API.
CurrentStatus                         : 5
FullEvaluationLastRefreshTime         : 1970-01-01T00:00:00Z
FullEvaluationMemberChanges           : 0
FullEvaluationMemberChangeTime        : 1970-01-01T00:00:00Z
FullEvaluationNextRefreshTime         : 1970-01-01T00:00:00Z
FullEvaluationRunTime                 : 0
HasProvisionedMember                  : False
IncludeExcludeCollectionsCount        : 0
IncrementalEvaluationLastRefreshTime  : 1970-01-01T00:00:00Z
IncrementalEvaluationMemberChanges    : 0
IncrementalEvaluationMemberChangeTime : 1970-01-01T00:00:00Z
IncrementalEvaluationRunTime          : 0
IsBuiltIn                             : False
IsReferenceCollection                 : False
ISVData                               :
ISVDataSize                           : 0
ISVString                             :
LastChangeTime                        : 2025-02-15T23:13:23Z
LastMemberChangeTime                  : 1980-01-01T06:00:00Z
LastRefreshTime                       : 1980-01-01T12:00:00Z
LimitToCollectionID                   : SMS00004
LimitToCollectionName                 : All Users and User Groups
LocalMemberCount                      : 0
MemberClassName                       : SMS_CM_RES_COLL_ABC00200
MemberCount                           : 0
MonitoringFlags                       : 0
Name                                  : AM - Users - Microsoft Corporation - Microsoft Endpoint Configuration Manager Console
ObjectPath                            :
OwnedByThisSite                       : True
PowerConfigsCount                     : 0
RefreshType                           : 1
ReplicateToSubSites                   : True
ServicePartners                       : 0
ServiceWindowsCount                   : 0
UseCluster                            : False
__GENUS                               : 2
__CLASS                               : SMS_Collection
__SUPERCLASS                          : SMS_BaseClass
__DYNASTY                             : SMS_BaseClass
__RELPATH                             : SMS_Collection.CollectionID="ABC00200"
__PROPERTY_COUNT                      : 42
__DERIVATION                          : {SMS_BaseClass}
__SERVER                              : [SMSProvider]
__NAMESPACE                           : root\sms\site_ABC
__PATH                                : \\[SMSProvider]\root\sms\site_ABC:SMS_Collection.CollectionID="ABC00200"
CollectionRules                       : {}
RefreshSchedule                       : {}

```

<br>

## Deletion

### Delete Collection

You can use this snippet to delete an existing Collection in MECM.

#### Snippet

```powershell
# Create Collection
    $Path_AdminService_WMIRoute = "https://[SMSProvider]/AdminService/wmi/"
    $Odata_Class = "SMS_Collection"
    $CollectionID = "ABC00200"
    Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $Odata_Class)/$($CollectionID)" -Method Delete -ContentType "application/json" -UseDefaultCredentials
```

#### Output

```powershell
# This returns nothing if successful
```

<br>

## Organization

### Move Collection to Folder (From Root Folder)

When working with a net-new Collection, such as a created object from the Create Collection snippet, or one that resides in the Root folder of the Collections node, you have to generate a new SMS_ContinerItem object that associates the new Collection with a Folder's SMS_ContainerNodeID.

> Note: This **DOES NOT** update a Collection that is already in a folder other than the Root folder. That code is in the example: Move Collection to Folder (From Sub Folder).

| Property | Type | Required | Description |
|-|-|-|-|
| [InstanceKey](https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/core/servers/console/sms_objectcontaineritem-server-wmi-class#:~:text=of%20the%20folder.-,InstanceKey,-Data%20type%3A) | String | True | CollectionID of Collection to Move to Folder: SMS_Collection.CollectionID |
| [ContainerNodeID](https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/core/servers/console/sms_objectcontaineritem-server-wmi-class#:~:text=Properties-,ContainerNodeID,-Data%20type%3A) | UInt32 | True | ID of Parent Folder to Contain Collection: SMS_ObjectContainerNode.ContainerNodeID |
| [ObjectType](https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/core/servers/console/sms_objectcontaineritem-server-wmi-class#:~:text=of%20the%20relation.-,ObjectType,-Data%20type%3A) | UInt32 | True | The type identifier for determining if the Collection is a Device or User type. 5000 = Device, 5001 = User: SMS_ObjectContainerItem |

#### Snippet

```powershell
# Comment
  $Path_AdminService_WMIRoute = "https://[SMSProvider]/AdminService/wmi/"
  $Odata_Class = "SMS_ObjectContainerItem"
  $Odata_Body = @{
    InstanceKey     = "ABC00200"
    ContainerNodeID = 16777201
    ObjectType      = 5001
  } | ConvertTo-Json

  Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $Odata_Class)" -Method Post -Body $Odata_Body -ContentType "application/json" -UseDefaultCredentials
```

#### Output

```powershell
@odata.context            : https://[SMSProvider]/AdminService/wmi/$metadata#SMS_ObjectContainerItem/$entity
@odata.etag               : 16779425
__LAZYPROPERTIES          : {__QUALIFIER_SECURITYVERBS}
__QUALIFIER_SECURITYVERBS :
ContainerNodeID           : 16777201
InstanceKey               : ABC00200
MemberGuid                : 490094B8-3EFB-47BE-A836-9C7568E8007F
MemberID                  : 16779425
ObjectType                : 5001
ObjectTypeName            : SMS_Collection_User
SourceSite                : ABC
__GENUS                   : 2
__CLASS                   : SMS_ObjectContainerItem
__SUPERCLASS              : SMS_BaseClass
__DYNASTY                 : SMS_BaseClass
__RELPATH                 : SMS_ObjectContainerItem.MemberID=16779425
__PROPERTY_COUNT          : 7
__DERIVATION              : {SMS_BaseClass}
__SERVER                  : [SMSProvider]
__NAMESPACE               : root\sms\site_ABC
__PATH                    : \\[SMSProvider]\root\sms\site_ABC:SMS_ObjectContainerItem.MemberID=16779425
```

<br>

### Move Collection to Folder (From Sub Folder)

This snippet uses the *[MoveMembers](https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/core/servers/console/movemembers-method-in-class-sms_objectcontaineritem)* method of the *[SMS_ObjectContainerItem](https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/core/servers/console/sms_objectcontaineritem-server-wmi-class)* class to provide the current ContainerNodeID and InstanceKey(s) of the Collection(s) and moves these items to the TargetContainerNodeID.

| Property | Type | Required | Description |
|-|-|-|-|
| [InstanceKeys](https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/core/servers/console/movemembers-method-in-class-sms_objectcontaineritem#:~:text=Parameters-,InstanceKeys,-Data%20type%3A) | String[] | True | An array of strings that contains the CollectionIDs of the Collections you wish to move. |
| [ContainerNodeID](https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/core/servers/console/movemembers-method-in-class-sms_objectcontaineritem#:~:text=items%20to%20move.-,ContainerNodeID,-Data%20type%3A) | UInt32 | True | The ContainerNodeID of the current folder that the Collections reside in. |
| [TargetContainerNodeID](https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/core/servers/console/movemembers-method-in-class-sms_objectcontaineritem#:~:text=copy%20the%20items.-,TargetContainerNodeID,-Data%20type%3A) | UInt32 | True | The ContainerNodeID of the target folder that you want to move the Collections to. |
| [ObjectType](https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/core/servers/console/movemembers-method-in-class-sms_objectcontaineritem#:~:text=move%20the%20items.-,ObjectType,-Data%20type%3A) | UInt32 | True | The type identifier for determining if the Collection is a Device or User type. 5000 = Device, 5001 = User |

#### Snippet

```powershell
# Comment
  $Path_AdminService_WMIRoute = "https://[SMSProvider]/AdminService/wmi/"
  $Odata_Class = "SMS_ObjectContainerItem.MoveMembers"
  $Odata_Body = @{
    InstanceKeys          = @("ABC00200")
    ContainerNodeID       = 16777201
    TargetContainerNodeID = 16777202
    ObjectType            = 5001
  } | ConvertTo-Json

  $Result = Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $Odata_Class)" -Method Post -Body $Odata_Body -ContentType "application/json" -UseDefaultCredentials
```

#### Output

An SInt32 data type that is 0 indicates a success, non-zero indicates failure

```powershell
@odata.context                                                               ReturnValue
--------------                                                               -----------
https://[SMSProvider]/AdminService/wmi/$metadata#__PARAMETERS           0
```

<br>

## Membership

### TODO: Add Collection Membership Rule

<br>

## Querying

### Get All Collections where Name Contains a String (No Wildcard)

You can use this snippet to return all the Collections where the name contains the specified string.

#### Snippet

```powershell
# Create Collection
    $Path_AdminService_WMIRoute = "https://[SMSProvider]/AdminService/wmi/"
    $Odata_Class = "SMS_Collection"
    $Odata_Filter = "?`$filter=contains(Name,'AM - User')"
    Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $Odata_Class + $Odata_Filter)" -Method Get -ContentType "application/json" -UseDefaultCredentials
```

#### Output

```powershell
# This returns all Collections that match the filter pattern
# Results omitted for brevity
```

<br>




# Content Management

## Content Distribution Status

### Get Failed Distributions

This utilizes the SMS_PackageStatus WMI class to gather Content Distribution Status.

| Value | Status         |
|-------|----------------|
| 0     | NONE           |
| 1     | SENT           |
| 2     | RECEIVED       |
| 3     | INSTALLED      |
| 4     | RETRY          |
| 5     | FAILED         |
| 6     | REMOVED        |
| 7     | PENDING_REMOVE |

```
# Web Browser
  https://[SMSProviderFQDN]/AdminService/wmi/SMS_PackageStatus?$filter=Status eq 5
```

```powershell
# PowerShell
  $Path_AdminService_WMIRoute = "https://[SMSProviderFQDN]/AdminService/wmi/"
  $Odata_Class = "SMS_PackageStatus"
  $Odata_Filter = "?`$filter=Status eq 5"
  $Output = (Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $Odata_Class + $Odata_Filter)" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value
```

#### Output

```json
{
  "@odata.etag": "ABC00003;0;ServerFQDN.DOMAIN.COM;ABC;3;1",
  "__LAZYPROPERTIES": [
      "__QUALIFIER_SECURITYVERBS"
  ],
  "__QUALIFIER_SECURITYVERBS": null,
  "Location": "",
  "PackageID": "ABC00003",
  "Personality": 0,
  "PkgServer": "ServerFQDN.DOMAIN.COM",
  "ShareName": "",
  "SiteCode": "ABC",
  "Status": 5,
  "Type": 1,
  "UpdateTime": "2024-08-30T20:55:06Z",
  "__GENUS": 2,
  "__CLASS": "SMS_PackageStatus",
  "__SUPERCLASS": "SMS_BaseClass",
  "__DYNASTY": "SMS_BaseClass",
  "__RELPATH": "SMS_PackageStatus.PackageID=\"ABC00003\",Personality=0,PkgServer=\"ServerFQDN.DOMAIN.COM\",SiteCode=\"ABC\",Status=3,Type=1",
  "__PROPERTY_COUNT": 9,
  "__DERIVATION": [
      "SMS_BaseClass"
  ],
  "__SERVER": "[SMSProvider]",
  "__NAMESPACE": "root\\sms\\site_ABC",
  "__PATH": "\\\\[SMSProvider]\\root\\sms\\site_ABC:SMS_PackageStatus.PackageID=\"ABC00003\",Personality=0,PkgServer=\"ServerFQDN.DOMAIN.COM\",SiteCode=\"ABC\",Status=3,Type=1"
}
```

<br>

### Get Packages with No Distributions

This example shows how to identify packages that have no content distributed to any distribution point.

```powershell
# Variables
  $Path_AdminService_WMIRoute = "https://[SMSProviderFQDN]/AdminService/wmi/"
  $Odata_Class = "SMS_PackageStatus"

# Get all package status information and content info
  $PackageStatus = (Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute)$Odata_Class" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value
  $Package_ContentInfo = (Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute)SMS_ObjectContentInfo" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value

# Find packages with no distribution
  $Packages_NoDistribution = $Package_ContentInfo | Where-Object {
      $PackageID = $_.PackageID
      -not ($PackageStatus | Where-Object { $_.PackageID -eq $PackageID })
  }

# Output results
  Write-Host "Packages with No Distributions:"
  foreach ($Package in $Packages_NoDistribution) {
      Write-Host "  - $($Package.SoftwareName)"
      Write-Host "      PackageID: $($Package.PackageID)"
      Write-Host "      Package Type: $($Package.ObjectType)"
}
```

#### Output

```
Packages with No Distributions:
  - Application Name
      PackageID: APP00001
      Package Type: 7
  - Package Name
      PackageID: PKG00001
      Package Type: 0
```

Note: The ObjectType values represent different types of content:
- 0: Legacy Package
- 3: Driver Package
- 5: Software Update Package
- 7: Application
- 8: Boot Image
- 257: Operating System Image
- 258: Operating System Installer

<br>

### Cancel Pending Distributions

This example demonstrates how to cancel all pending content distributions using the Administration Service.

```powershell
# Variables
  $Path_AdminService_WMIRoute = "https://[SMSProviderFQDN]/AdminService/wmi/"
  $Odata_Class = "SMS_PackageStatus"
  $Odata_Filter = "?`$filter=Status eq 0 or Status eq 1"
  $URI_Method_Cancel = "$Path_AdminService_WMIRoute/SMS_DistributionPoint/AdminService.CancelDistribution"

# Get Pending Distributions
  $Distributions_Pending = (Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $Odata_Class + $Odata_Filter)" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value
  $Package_ContentInfo = (Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute)SMS_ObjectContentInfo" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value

# Cancel each pending distribution
  Write-Host "Content Distribution - Cancelled Packages"

  foreach ($Distribution in $Distributions_Pending) {
    try {
      # Output Data
        $Temp_PackageName = ($Package_ContentInfo | Where-Object { $_.PackageID -eq $Distribution.PackageID }).SoftwareName
        $Temp_ServerName  = [regex]::Match($Distribution.PkgServer, '\["Display=(.*?)"').Groups[1].Value
        Write-Host "  - $($Temp_PackageName)"
        Write-Host "      PackageID: $($Distribution.PackageID)"
        Write-Host "      Target: $($Temp_ServerName)"

      # Construct Body
        $Body = @{
            PackageID = $Distribution.PackageID
            ServerNALPath = $Distribution.PkgServer
        } | ConvertTo-Json

      # Run Method
        Invoke-RestMethod -Uri $URI_Method_Cancel -Method Post -Body $Body -ContentType "Application/Json" -UseDefaultCredentials -ErrorAction Stop

      Write-Host "      Status: Success"
    }
    catch {
      Write-Host "      Status: Error"
    }
  }
```

#### Output

```
Content Distribution - Cancelled Packages
  - [PackageName]
      PackageID: [PackageID]
      Target: [ServerFQDN]
      Status: [Status]
```


# [Category]

## [SubCategory]

[Text]

### [Function]

[Text]

```
# Web Browser

```

```powershell
# PowerShell

```

#### Output

```json
# Add Code Here
```







<br>

# Appendices

A collection of sections that provide detailed explanation or understanding to the above topic but are not necessary within the main body of the topic.

## Apdx A: [Name]

[Text]








## Template

### [StepName]

[Description]

| Property | Type | Required | Description |
|-|-|-|-|

#### Snippet

```powershell
# Comment
  $Path_AdminService_WMIRoute   = "https://[SMSProvider]/AdminService/wmi/"
```

#### Output

```powershell

```