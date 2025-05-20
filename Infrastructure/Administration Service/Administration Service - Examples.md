# MECM Toolkit - Infrastructure - Administration Service - Examples

<br>

## Table of Contents

- [MECM Toolkit - Infrastructure - Administration Service - Examples](#mecm-toolkit---infrastructure---administration-service---examples)
  - [Table of Contents](#table-of-contents)
- [Collections](#collections)
  - [Queries](#queries)
    - [Get All Collections where Name Contains a String (No Wildcard)](#get-all-collections-where-name-contains-a-string-no-wildcard)
      - [Web URI](#web-uri)
      - [PowerShell](#powershell)
  - [Creation](#creation)
    - [Create Collection](#create-collection)
      - [Web URI](#web-uri-1)
      - [PowerShell](#powershell-1)
  - [Deletion](#deletion)
    - [Delete Collection](#delete-collection)
      - [Web URI](#web-uri-2)
      - [PowerShell](#powershell-2)
  - [Organization](#organization)
    - [Move Collection to Folder (From Root Folder)](#move-collection-to-folder-from-root-folder)
      - [Web URI](#web-uri-3)
      - [PowerShell](#powershell-3)
    - [Move Collection to Folder (From Sub Folder)](#move-collection-to-folder-from-sub-folder)
      - [Web URI](#web-uri-4)
      - [PowerShell](#powershell-4)
  - [Membership](#membership)
    - [TODO: Add Collection Membership Rule](#todo-add-collection-membership-rule)
- [Applications](#applications)
  - [Queries](#queries-1)
  - [Creation](#creation-1)
    - [Create Application](#create-application)
      - [Web URI](#web-uri-5)
      - [PowerShell](#powershell-5)
  - [Deletion](#deletion-1)
    - [Delete Application](#delete-application)
      - [Web URI](#web-uri-6)
      - [PowerShell](#powershell-6)
    - [Delete Application Revisions](#delete-application-revisions)
  - [Organization](#organization-1)
  - [Deployment](#deployment)
    - [Create an Application Deployment (Available)](#create-an-application-deployment-available)
      - [Web URI](#web-uri-7)
      - [PowerShell](#powershell-7)
    - [Create an Application Deployment (Required)](#create-an-application-deployment-required)
      - [Web URI](#web-uri-8)
      - [PowerShell](#powershell-8)
- [Content Management](#content-management)
  - [Content Distribution Status](#content-distribution-status)
    - [Get Failed Distributions](#get-failed-distributions)
      - [Web URI](#web-uri-9)
      - [PowerShell](#powershell-9)
    - [Get Packages with No Distributions](#get-packages-with-no-distributions)
      - [PowerShell](#powershell-10)
    - [Cancel Pending Distributions](#cancel-pending-distributions)
      - [PowerShell](#powershell-11)
- [Administrative Categories](#administrative-categories)
  - [Queries](#queries-2)
  - [Creation](#creation-2)
    - [\[Function\]](#function)
      - [Web URI](#web-uri-10)
      - [PowerShell](#powershell-12)
  - [Deletion](#deletion-2)
    - [\[Function\]](#function-1)
      - [Web URI](#web-uri-11)
      - [PowerShell](#powershell-13)
- [\[Category\]](#category)
  - [\[SubCategory\]](#subcategory)
    - [\[Function\]](#function-2)
      - [Web URI](#web-uri-12)
      - [PowerShell](#powershell-14)
- [Appendices](#appendices)
  - [Apdx A: \[Name\]](#apdx-a-name)
  - [Template](#template)
    - [\[StepName\]](#stepname)
      - [Snippet](#snippet)
      - [Output](#output)

<br>

# Collections

## Queries

### Get All Collections where Name Contains a String (No Wildcard)

You can use this snippet to return all the Collections where the name contains the specified string.

>Note: No wildcards are required when using the *Contains* query function as long as you dont have wildcards within your characters.

#### Web URI

```https://[SMSProvider]/AdminService/wmi/SMS_Collection/?$filter=contains(Name,'AM - User')```

#### PowerShell

Snippet

```powershell
$Odata_ServiceRootURI = "https://[SMSProvider]/AdminService/wmi/"
$Odata_Resource = "SMS_Collection"
$Odata_Query = "?`$filter=contains(Name,'AM - User')"
Invoke-RestMethod -Uri "$($Odata_ServiceRootURI + $Odata_Resource + $Odata_Query)" -Method Get -ContentType "application/json" -UseDefaultCredentials
```

Output

```powershell
# This returns all Entites that match the filter pattern
# Results omitted for brevity
```

<br>

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

#### Web URI

```Not Applicable```

#### PowerShell

Snippet

```powershell
$Odata_ServiceRootURI = "https://[SMSProvider]/AdminService/wmi/"
$Odata_Resource = "SMS_Collection"
$Odata_Body = @{
  Name                = "AM - Users - Microsoft Corporation - Microsoft Endpoint Configuration Manager Console"
  LimitToCollectionID = "SMS00004"
  Comment             = "Collection created using the REST API."
  CollectionType      = 1
} | ConvertTo-Json
Invoke-RestMethod -Uri "$($Odata_ServiceRootURI + $Odata_Resource)" -Method Post -Body $Odata_Body -ContentType "application/json" -UseDefaultCredentials
```

Output

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

#### Web URI

```Not Applicable```

#### PowerShell

Snippet

```powershell
$Odata_ServiceRootURI = "https://[SMSProvider]/AdminService/wmi/"
$Odata_Resource = "SMS_Collection"
$CollectionID = "ABC00200"
Invoke-RestMethod -Uri "$($Odata_ServiceRootURI + $Odata_Resource)/$($CollectionID)" -Method Delete -ContentType "application/json" -UseDefaultCredentials
```

Output

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

#### Web URI

```Not Applicable```

#### PowerShell

Snippet

```powershell
$Odata_ServiceRootURI = "https://[SMSProvider]/AdminService/wmi/"
$Odata_Resource = "SMS_ObjectContainerItem"
$Odata_Body = @{
  InstanceKey     = "ABC00200"
  ContainerNodeID = 16777201
  ObjectType      = 5001
} | ConvertTo-Json

Invoke-RestMethod -Uri "$($Odata_ServiceRootURI + $Odata_Resource)" -Method Post -Body $Odata_Body -ContentType "application/json" -UseDefaultCredentials
```

Output

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

#### Web URI

```Not Applicable```

#### PowerShell

Snippet

```powershell
$Odata_ServiceRootURI = "https://[SMSProvider]/AdminService/wmi/"
$Odata_Resource = "SMS_ObjectContainerItem.MoveMembers"
$Odata_Body = @{
  InstanceKeys          = @("ABC00200")
  ContainerNodeID       = 16777201
  TargetContainerNodeID = 16777202
  ObjectType            = 5001
} | ConvertTo-Json

$Result = Invoke-RestMethod -Uri "$($Odata_ServiceRootURI + $Odata_Resource)" -Method Post -Body $Odata_Body -ContentType "application/json" -UseDefaultCredentials
```

Output

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

# Applications

## Queries

TODO: Queries

Potential Queries

- All Applications without A Deployment

| Query Name | Description | URI |
|-|-|-|
| All Applications without A Deployment | - | - |
| All Applications from a Specific Publisher | - | - |
| All Applications that Match a String | Returns all Applications that match the string in the fields: Manufacturer, LocalizedDisplayName, SoftwareVersion. | - |
| All Applications that are Superseded | - | - |
| All Applications that are Expired | - | - |

<br>

## Creation

### Create Application

TODO: Create Application

You can use this snippet to create a new Application in MECM.

| Property | Type | Required | Description |
|-|-|-|-|
|
|
|
|
|

#### Web URI

```Not Applicable```

#### PowerShell

Snippet

```powershell
$Odata_ServiceRootURI = "https://[SMSProvider]/AdminService/wmi/"
$Odata_Resource = "SMS_Application"
$Odata_Body = @{

} | ConvertTo-Json
Invoke-RestMethod -Uri "$($Odata_ServiceRootURI + $Odata_Resource)" -Method Post -Body $Odata_Body -ContentType "application/json" -UseDefaultCredentials
```

Output

```powershell

```

<br>

## Deletion

### Delete Application

You can use this snippet to delete an existing Application in MECM.

- Class [SMS_Application](https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/apps/sms_application-server-wmi-class) : [SMS_ConfigurationItemLatestBaseClass](https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/compliance/sms_configurationitemlatestbaseclass-server-wmi-class)

| Property | Type | Required | Related Field(s) | Description |
|-|-|-|-|-|
| CI_ID | UInt32 | True | None | The unique ID of the configuration item. This ID is unique only for the site. |

#### Web URI

```Not Applicable```

#### PowerShell

Snippet

```powershell
$Odata_ServiceRootURI = "https://[SMSProvider]/AdminService/wmi/"
$Odata_Resource = "SMS_Application/[CI_ID]"
$Odata_Body = @{
} | ConvertTo-Json

Invoke-RestMethod -Uri "$($Odata_ServiceRootURI + $Odata_Resource)" -Method Post -Body $Odata_Body -ContentType "application/json" -UseDefaultCredentials
```

Output

```powershell
# Empty string returned when successful
```

<br>

### Delete Application Revisions

You can use this snippet to remove the revisions that are associated with an application. These are identified by looking for entities within the SMS_Application Resource where the Property *IsLatest = False*. This helps to free up space in the database and remove old, unused records that don't need to be retained once the Application packaging has produced a stable, production-ready package.

```
Use the above code for deleting an application to delete revisions of an application as these are all just configuration items within the MECM database.
```

<br>

## Organization

TODO: Application Organization

<br>

## Deployment

### Create an Application Deployment (Available)

You can use this snippet to create an Available Application Deployment in MECM.

- Class [SMS_ApplicationAssignment](https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/apps/sms_applicationassignment-server-wmi-class) : [SMS_CIAssignmentBaseClass](https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/compliance/sms_ciassignmentbaseclass-server-wmi-class)

> Note: You can view the SMS_ApplicationAssignment Resource in the web browser and look at Deployments you already have to mirror the desired settings you want in new Deployments.

| Property | Type | Required | Related Field(s) | Description |
|-|-|-|-|-|
| AssignedCIs | SInt32 Array | True | SMS_Application.CI_ID | CI ID of the Application to deploy. |
| AssignmentAction | SInt32 | True | None | Action associated with the Deployment. See link for accepted values. |
| AssignmentDescription | String | True | None | The description of the Deployment. |
| AssignmentName | String | True | [SMS_Application.LocalizedDisplayName]_[SMS_Collection.TargetCollectionName]_[AssignmentAction] | A unique name given to the assignment at creation time that, by default, takes the form in the Related Fields column. |
| AssignmentType | SInt32 | True | None | The type of the assignment based on the CI being deployed. See link for accepted values. |
| CollectionName | String | True | SMS_Collection.Name | The name of the Collection targeted by the Application Deployment. |
| DesiredConfigType | SInt32 | True | None | Sets the Purpose/Action of the Deployment. 1 = Install, 2 = Uninstall |
| DisableMomAlerts | Boolean | True | None | True if the client is configured to raise MOM alerts when a configuration item is applied. The default is false. |
| Enabled | Boolean | True | None | True if the configuration item is enabled. |
| NotifyUser | Boolean | True | None | True to notify the user when a configuration item is available. |
| OfferFlags | UInt32 | True | None | This does not look like it is used on Application Deployments. |
| OfferTypeID | SInt32 | True | None | Sets the deployment type to either Required (0) or Available (2) |
| OverrideServiceWindows | Boolean | True | None | True if the client ignores maintenance windows when a configuration item is applied. |
| PersistOnWriteFilterDevices | Boolean | True | None | True if write filters on devices should be persisted. The default value is false. |
| RaiseMomAlertsOnFailure | Boolean | True | None | True if the client raises MOM alerts if it fails to apply a configuration item. The default is false. |
| RebootOutsideOfServiceWindows | Boolean | True | None | True if the client reboots outside a maintenance window if a reboot is pending after applying a configuration item targeted by the assignment. |
| RequireApproval | Boolean | True | None | True if the request for this user-available assignment requires approval from the administrator. |
| StartTime | DateTime | True | None | The date and time when the Deployment is initially offered (Available). |
| SuppressReboot | UInt32 | True | None | Determines whether to perform a reboot after the Deployment if there is a reboot pending. 0 = False, 1 = True |
| TargetCollectionID | String | True | SMS_Collection.CollectionID | The ID of the Collection to which the Application is deployed. |
| UseGMTTimes | Bool | True | None | True if the times and schedules are in Universal Coordinated Time (UTC). |
| UserUIExperience | Boolean | True | None | True if user notification is displayed, otherwise false. |
| WoLEnabled | Boolean | True | None | true to send a Wake On Lan (WoL) transmission to the client when the deadline is reached for the assignment. |

#### Web URI

```Not Applicable```

#### PowerShell

Snippet

```powershell
$Odata_ServiceRootURI = "https://[SMSProvider]/AdminService/wmi/"
$Odata_Resource = "SMS_ApplicationAssignment"
$Odata_Body = @{
  AssignedCIs                     = @(16853331)  # SMS_Application.CI_ID
  AssignmentAction                = 2
  AssignmentDescription           = ""
  AssignmentName                  = "Google Chrome - 80.0.3987.149_AM - User - Insight - Test & Validation Users_Install"  # [SMS_Application.LocalizedDisplayName]_[SMS_Collection.TargetCollectionName]_[Action]
  AssignmentType                  = 2
  CollectionName                  = "AM - User - Insight - Test & Validation Users"   # SMS_Collection.Name
  DesiredConfigType               = 1
  DisableMomAlerts                = $false
  Enabled                         = $true
  NotifyUser                      = $false
  OfferFlags                      = 0             # Not Defined
  OfferTypeID                     = 2
  OverrideServiceWindows          = $false
  PersistOnWriteFilterDevices     = $true
  RaiseMomAlertsOnFailure         = $false
  RebootOutsideOfServiceWindows   = $false
  RequireApproval                 = $false
  StartTime                       = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
  SuppressReboot                  = 1
  TargetCollectionID              = "FSI00173"    # SMS_Collection.CollectionID
  UseGMTTimes                     = $true
  UserUIExperience                = $true
  WoLEnabled                      = $false
} | ConvertTo-Json

$Result = Invoke-RestMethod -Uri "$($Odata_ServiceRootURI + $Odata_Resource)" -Method Post -Body $Odata_Body -ContentType "application/json" -UseDefaultCredentials

```

Output

```powershell
PS C:\Users\VividRock> $Result.GetType(); $Result

  IsPublic IsSerial Name                                     BaseType
  -------- -------- ----                                     --------
  True     False    PSCustomObject                           System.Object

  @odata.context                  : https://[SMSProvider]/AdminService/wmi/$metadata#SMS_ApplicationAssignment/$entity
  @odata.etag                     : 16778597
  __LAZYPROPERTIES                : {__QUALIFIER_SECURITYVERBS, PolicyBinding}
  __QUALIFIER_SECURITYVERBS       : -1
  AdditionalProperties            :
  ApplicationName                 : Google Chrome - 109.0.5414.120
  ApplyToSubTargets               : False
  AppModelID                      : 16846056
  AssignedCI_UniqueID             : ScopeId_99ED2923-6EDE-4D65-AC0E-21876AE0D204/Application_23628f33-7a22-493a-8a29-aa009b40024b/8
  AssignedCIs                     : {16853331}
  AssignmentAction                : 2
  AssignmentDescription           :
  AssignmentID                    : 16778597
  AssignmentName                  : Google Chrome - 80.0.3987.149_AM - User - Insight - Test & Validation Users_Install
  AssignmentType                  : 2
  AssignmentUniqueID              : {3B6F829B-772B-4AB7-83C4-AE00F47BA40F}
  CollectionName                  : AM - User - Insight - Test & Validation Users
  ContainsExpiredUpdates          : False
  CreationTime                    : 2025-02-20T01:00:10Z
  DesiredConfigType               : 1
  DisableMomAlerts                : False
  DPLocality                      : 80
  Enabled                         : True
  EnforcementDeadline             :
  EvaluationSchedule              :
  ExpirationTime                  :
  LastModificationTime            : 2025-02-20T01:00:10Z
  LastModifiedBy                  : DOMAIN\Username
  LocaleID                        : 1033
  LogComplianceToWinEvent         : False
  NonComplianceCriticality        :
  NotifyUser                      : False
  OfferFlags                      : 0
  OfferTypeID                     : 2
  OverrideServiceWindows          : False
  PersistOnWriteFilterDevices     : True
  Priority                        : 1
  RaiseMomAlertsOnFailure         : False
  RebootOutsideOfServiceWindows   : False
  RequireApproval                 : False
  SendDetailedNonComplianceStatus : False
  SoftDeadlineEnabled             : False
  SourceSite                      : ABC
  StartTime                       : 2025-02-20T12:00:00Z
  StateMessagePriority            : 5
  SuppressReboot                  : 1
  TargetCollectionID              : ABC00173
  UpdateDeadline                  :
  UpdateSupersedence              : False
  UseGMTTimes                     : True
  UserUIExperience                : True
  WoLEnabled                      : False
  __GENUS                         : 2
  __CLASS                         : SMS_ApplicationAssignment
  __SUPERCLASS                    : SMS_CIAssignmentBaseClass
  __DYNASTY                       : SMS_BaseClass
  __RELPATH                       : SMS_ApplicationAssignment.AssignmentID=16778597
  __PROPERTY_COUNT                : 49
  __DERIVATION                    : {SMS_CIAssignmentBaseClass, SMS_BaseClass}
  __SERVER                        : [SMSProvider]
  __NAMESPACE                     : root\sms\site_ABC
  __PATH                          : \\[SMSProvider]\root\sms\site_ABC:SMS_ApplicationAssignment.AssignmentID=16778597
  PolicyBinding                   : {}
```

<br>

### Create an Application Deployment (Required)

You can use this snippet to create an Required Application Deployment in MECM.

| Property | Type | Required | Description |
|-|-|-|-|
|
|
|
|
|

#### Web URI

```Not Applicable```

#### PowerShell

Snippet

```powershell
$Odata_ServiceRootURI = "https://[SMSProvider]/AdminService/wmi/"
$Odata_Resource = "SMS_Application"
$Odata_Body = @{

} | ConvertTo-Json
Invoke-RestMethod -Uri "$($Odata_ServiceRootURI + $Odata_Resource)" -Method Post -Body $Odata_Body -ContentType "application/json" -UseDefaultCredentials
```

Output

```powershell

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

#### Web URI

```https://[SMSProvider]/AdminService/wmi/SMS_PackageStatus?$filter=Status eq 5```

#### PowerShell

Snippet

```powershell
$Odata_ServiceRootURI = "https://[SMSProviderFQDN]/AdminService/wmi/"
$Odata_Resource = "SMS_PackageStatus"
$Odata_Query = "?`$filter=Status eq 5"
$Output = (Invoke-RestMethod -Uri "$($Odata_ServiceRootURI + $Odata_Resource + $Odata_Query)" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value
```

Output

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

#### PowerShell

Snippet

```powershell
# Variables
  $Odata_ServiceRootURI = "https://[SMSProviderFQDN]/AdminService/wmi/"
  $Odata_Resource = "SMS_PackageStatus"

# Get all package status information and content info
  $PackageStatus = (Invoke-RestMethod -Uri "$($Odata_ServiceRootURI)$Odata_Resource" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value
  $Package_ContentInfo = (Invoke-RestMethod -Uri "$($Odata_ServiceRootURI)SMS_ObjectContentInfo" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value

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

Output

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

#### PowerShell

Snippet

```powershell
# Variables
  $Odata_ServiceRootURI = "https://[SMSProviderFQDN]/AdminService/wmi/"
  $Odata_Resource = "SMS_PackageStatus"
  $Odata_Query = "?`$filter=Status eq 0 or Status eq 1"
  $URI_Method_Cancel = "$Odata_ServiceRootURI/SMS_DistributionPoint/AdminService.CancelDistribution"

# Get Pending Distributions
  $Distributions_Pending = (Invoke-RestMethod -Uri "$($Odata_ServiceRootURI + $Odata_Resource + $Odata_Query)" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value
  $Package_ContentInfo = (Invoke-RestMethod -Uri "$($Odata_ServiceRootURI)SMS_ObjectContentInfo" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value

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

Output

```
Content Distribution - Cancelled Packages
  - [PackageName]
      PackageID: [PackageID]
      Target: [ServerFQDN]
      Status: [Status]
```
<br>

# Administrative Categories

## Queries

| Description | URI |
|-|-|
| All Applications with An Admin Category that Matches a String | https://[ServerFQDN]/AdminService/wmi/SMS_Application?$filter=LocalizedCategoryInstanceNames/any(item: item eq 'Intune Sync') |

<br>

## Creation

[Text]

### [Function]

[Text]

#### Web URI

```https://[SMSProvider]/AdminService/wmi/[Resource]/[QueryOptions]```

#### PowerShell

Snippet

```powershell

```

Output

```powershell

```

<br>

## Deletion

[Text]

### [Function]

[Text]

#### Web URI

```https://[SMSProvider]/AdminService/wmi/[Resource]/[QueryOptions]```

#### PowerShell

Snippet

```powershell

```

Output

```powershell

```

<br>

# [Category]

## [SubCategory]

[Text]

### [Function]

[Text]

#### Web URI

```https://[SMSProvider]/AdminService/wmi/[Resource]/[QueryOptions]```

#### PowerShell

Snippet

```powershell

```

Output

```powershell

```





<br>

# Appendices

A collection of sections that provide detailed explanation or understanding to the above topic but are not necessary within the main body of the topic.

## Apdx A: [Name]

[Text]








## Template

### [StepName]

[Description]

- Class [ClassName](https://#) : [ParentClassName](https://#)

| Property | Type | Required | Description |
|-|-|-|-|

#### Snippet

```powershell
$Odata_ServiceRootURI   = "https://[SMSProvider]/AdminService/wmi/"
```

#### Output

```powershell

```