# MECM Toolkit - Infrastructure - Administration Service

<br>

## References

The following items are referenced in the code within this document. Familiarize yourself with them before moving on.

| Name                              | Type                        | Description                                                                                                       | Link |
|-----------------------------------|-----------------------------|-------------------------------------------------------------------------------------------------------------------|------|
| What is the Administation Service | Documentation               | An overview of the service and general information.                                                               | [Microsoft Learn](https://learn.microsoft.com/en-us/mem/configmgr/develop/adminservice/overview) |
| How to use the Admin Service      | Documentation               | Example queries and information on using PowerShell, PowerBI, and the web for getting data.                       | [Microsoft Learn](https://learn.microsoft.com/en-us/mem/configmgr/develop/adminservice/usage) |
| MECM API Reference                | Documentation               | A full API reference for the various WMI routes and methods provided by the MECM solution.                        | [Microsoft Learn](https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/configuration-manager-reference) |
| Examples                          | Code                        | Code samples and use cases for performing the various REST methods and operations with the MECM Web API           | [MECM Toolkit Repo](https://github.com/dustinestes/MECM_Toolkit/blob/main/Infrastructure/Administration%20Service/Administration%20Service%20-%20Examples.md) |

<br>

## Table of Contents

- [MECM Toolkit - Infrastructure - Administration Service](#mecm-toolkit---infrastructure---administration-service)
  - [References](#references)
  - [Table of Contents](#table-of-contents)
  - [About](#about)
    - [Benefits](#benefits)
    - [Things to Know](#things-to-know)
  - [Accessing the API Information](#accessing-the-api-information)
    - [Find Entities and Methods](#find-entities-and-methods)
      - [Example: SMS\_Collection](#example-sms_collection)
  - [Interacting with the API](#interacting-with-the-api)
    - [Web Browser](#web-browser)
    - [PowerShell](#powershell)
    - [PowerBI](#powerbi)
    - [3rd Party Tools](#3rd-party-tools)
  - [Methods](#methods)
  - [Service Operations](#service-operations)
  - [Query Options](#query-options)
  - [Query Functions](#query-functions)
  - [Operators](#operators)
    - [Comparison Operators](#comparison-operators)
    - [Logical Operators](#logical-operators)
    - [Arithmetic Operators](#arithmetic-operators)
    - [Grouping Operators](#grouping-operators)
  - [Characters](#characters)
    - [URL encode special characters](#url-encode-special-characters)
    - [Wildcard Characters](#wildcard-characters)
- [Appendices](#appendices)
  - [Apdx A: Troubleshooting](#apdx-a-troubleshooting)
    - [Invoke-RestMethod : The remote server returned an error: (401) Unauthorized](#invoke-restmethod--the-remote-server-returned-an-error-401-unauthorized)
      - [Message](#message)
      - [Reason](#reason)
      - [Resolution](#resolution)

<br>

## About

Microsoft Endpoint Configuration Manager's Administration Service is used for accessing a Site's data via a REST API. With it, you can perform actions within the Site, extend automation and maintenance, and so on.

### Benefits

One of the main benefits of using the Web API is that it is accessible without the use of more complicated tools such as the PowerShell cmdlets that require you to import the module, create a provider-based drive, and then run the cmdlets provided. With the REST API, you can simply perform basic REST methods against the API's web address and retrieve data right in your browser. It's security requirements are also far less complicated. You don't have to change PowerShell execution policies, grant user's administrative permissions, etc. You simply need an account within the MECM application with the appropriate rights to perform the operations.

- Works without using additional tools such as cmdlets from the MECM PowerShell Module
- Can be run from any browser that has access to the REST API
- Allows server-side filtering and selects which is faster than filtering in PowerShell after retrieving the full dataset
- Simplified, minimal access control using only MECM's builtin RBAC solution
- Can be utilized over the CMG connection

### Things to Know

It is important to know a couple of things before using the Administration Service:

- It requiers HTTPS communication (supports Enhanced HTTP mode in MECM)
- Based on the [OData v4](https://www.odata.org/documentation/) protocol
- To use with a CMG, you need a synchronized account in Azure AD (Hybrid-Identity)

## Accessing the API Information

### Find Entities and Methods

In order to discover all of the Entities, Datatypes, and Methods that are supported by the Administration Service, you can always use the API documentation link in the references section above. Or, you can use the WEB API itself to pull the list.

1) Open your browser
2) Navigate to the path: ```https://www.[ServerFQDN]/AdminService/wmi/$metadata```

Here, you will find a list of all the entities, their property names, and those property's data types. Along with this information, you can find the associated methods that the entity supports.

#### Example: SMS_Collection

API Reference: ```https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/core/clients/collections/sms_collection-server-wmi-class```

API Metadata:

```xml
<EntityType Name="SMS_Collection">
  <Key>
    <PropertyRef Name="CollectionID" />
  </Key>
  <Property Name="__GENUS" Type="Edm.Int32" />
  <Property Name="__CLASS" Type="Edm.String" />
  <Property Name="__SUPERCLASS" Type="Edm.String" />
  <Property Name="__DYNASTY" Type="Edm.String" />
  <Property Name="__RELPATH" Type="Edm.String" />
  <Property Name="__PROPERTY_COUNT" Type="Edm.Int32" />
  <Property Name="__DERIVATION" Type="Collection(Edm.String)" />
  <Property Name="__SERVER" Type="Edm.String" />
  <Property Name="__NAMESPACE" Type="Edm.String" />
  <Property Name="__PATH" Type="Edm.String" />
  <Property Name="__LAZYPROPERTIES" Type="Collection(Edm.String)" />
  <Property Name="__QUALIFIER_SECURITYVERBS" Type="Edm.Int32" />
  <Property Name="CloudSyncCount" Type="Edm.Int32" />
  <Property Name="CollectionID" Type="Edm.String" />
  <Property Name="CollectionRules" Type="Collection(AdminService.SMS_CollectionRule)" />
  <Property Name="CollectionType" Type="Edm.Int64" />
  <Property Name="CollectionVariablesCount" Type="Edm.Int32" />
  <Property Name="Comment" Type="Edm.String" />
  <Property Name="CurrentStatus" Type="Edm.Int64" />
  <Property Name="FullEvaluationLastRefreshTime" Type="Edm.DateTimeOffset" />
  <Property Name="FullEvaluationMemberChanges" Type="Edm.Int64" />
  <Property Name="FullEvaluationMemberChangeTime" Type="Edm.DateTimeOffset" />
  <Property Name="FullEvaluationNextRefreshTime" Type="Edm.DateTimeOffset" />
  <Property Name="FullEvaluationRunTime" Type="Edm.Int64" />
  <Property Name="HasProvisionedMember" Type="Edm.Boolean" />
  <Property Name="IncludeExcludeCollectionsCount" Type="Edm.Int32" />
  <Property Name="IncrementalEvaluationLastRefreshTime" Type="Edm.DateTimeOffset" />
  <Property Name="IncrementalEvaluationMemberChanges" Type="Edm.Int64" />
  <Property Name="IncrementalEvaluationMemberChangeTime" Type="Edm.DateTimeOffset" />
  <Property Name="IncrementalEvaluationRunTime" Type="Edm.Int64" />
  <Property Name="IsBuiltIn" Type="Edm.Boolean" />
  <Property Name="IsReferenceCollection" Type="Edm.Boolean" />
  <Property Name="ISVData" Type="Edm.Binary" />
  <Property Name="ISVDataSize" Type="Edm.Int64" />
  <Property Name="ISVString" Type="Edm.String" />
  <Property Name="LastChangeTime" Type="Edm.DateTimeOffset" />
  <Property Name="LastMemberChangeTime" Type="Edm.DateTimeOffset" />
  <Property Name="LastRefreshTime" Type="Edm.DateTimeOffset" />
  <Property Name="LimitToCollectionID" Type="Edm.String" />
  <Property Name="LimitToCollectionName" Type="Edm.String" />
  <Property Name="LocalMemberCount" Type="Edm.Int32" />
  <Property Name="MemberClassName" Type="Edm.String" />
  <Property Name="MemberCount" Type="Edm.Int32" />
  <Property Name="MonitoringFlags" Type="Edm.Int64" />
  <Property Name="Name" Type="Edm.String" Nullable="false" />
  <Property Name="ObjectPath" Type="Edm.String" />
  <Property Name="OwnedByThisSite" Type="Edm.Boolean" />
  <Property Name="PowerConfigsCount" Type="Edm.Int32" />
  <Property Name="RefreshSchedule" Type="Collection(AdminService.SMS_ScheduleToken)" />
  <Property Name="RefreshType" Type="Edm.Int64" />
  <Property Name="ReplicateToSubSites" Type="Edm.Boolean" />
  <Property Name="ServicePartners" Type="Edm.Int32" />
  <Property Name="ServiceWindowsCount" Type="Edm.Int32" />
  <Property Name="UseCluster" Type="Edm.Boolean" />
  <NavigationProperty Name="SMS_R_System" Type="Collection(AdminService.SMS_R_System)">
    <ReferentialConstraint Property="CollectionID" ReferencedProperty="ResourceId" />
  </NavigationProperty>
  <NavigationProperty Name="SMS_R_User" Type="Collection(AdminService.SMS_R_User)">
    <ReferentialConstraint Property="CollectionID" ReferencedProperty="ResourceId" />
  </NavigationProperty>
  <NavigationProperty Name="SMS_R_UserGroup" Type="Collection(AdminService.SMS_R_UserGroup)">
    <ReferentialConstraint Property="CollectionID" ReferencedProperty="ResourceId" />
  </NavigationProperty>
  <NavigationProperty Name="SMS_R_UnknownSystem" Type="Collection(AdminService.SMS_R_UnknownSystem)">
    <ReferentialConstraint Property="CollectionID" ReferencedProperty="ResourceId" />
  </NavigationProperty>
</EntityType>
```

```xml
<Action Name="AddMembershipRule" IsBound="true">
  <Parameter Name="bindingParameter" Type="AdminService.SMS_Collection" />
  <Parameter Name="collectionRule" Type="AdminService.SMS_CollectionRule" />
  <ReturnType Type="Edm.Int32" />
</Action>
```

```xml
<ActionImport Name="SMS_Collection.VerifyNoCircularDependencies" Action="AdminService.SMS_Collection.VerifyNoCircularDependencies" />
<ActionImport Name="SMS_Collection.GetNumResults" Action="AdminService.SMS_Collection.GetNumResults" />
<ActionImport Name="SMS_Collection.GetTotalNumResults" Action="AdminService.SMS_Collection.GetTotalNumResults" />
<ActionImport Name="SMS_Collection.GetNextID" Action="AdminService.SMS_Collection.GetNextID" />
<ActionImport Name="SMS_Collection.SetNextID" Action="AdminService.SMS_Collection.SetNextID" />
<ActionImport Name="SMS_Collection.FindMachineSite" Action="AdminService.SMS_Collection.FindMachineSite" />
<ActionImport Name="SMS_Collection.CreateCCR" Action="AdminService.SMS_Collection.CreateCCR" />
<ActionImport Name="SMS_Collection.GenerateCCRByName" Action="AdminService.SMS_Collection.GenerateCCRByName" />
<ActionImport Name="SMS_Collection.ApproveClients" Action="AdminService.SMS_Collection.ApproveClients" />
<ActionImport Name="SMS_Collection.BlockClients" Action="AdminService.SMS_Collection.BlockClients" />
<ActionImport Name="SMS_Collection.ChangeOwnership" Action="AdminService.SMS_Collection.ChangeOwnership" />
<ActionImport Name="SMS_Collection.ClientEditions" Action="AdminService.SMS_Collection.ClientEditions" />
<ActionImport Name="SMS_Collection.ReassignClientsToSite" Action="AdminService.SMS_Collection.ReassignClientsToSite" />
<ActionImport Name="SMS_Collection.SetDeviceCategory" Action="AdminService.SMS_Collection.SetDeviceCategory" />
<ActionImport Name="SMS_Collection.ClearDeviceCategory" Action="AdminService.SMS_Collection.ClearDeviceCategory" />
<ActionImport Name="SMS_Collection.ClearLastNBSAdvForMachines" Action="AdminService.SMS_Collection.ClearLastNBSAdvForMachines" />
<ActionImport Name="SMS_Collection.SetMemberOrder" Action="AdminService.SMS_Collection.SetMemberOrder" />
<ActionImport Name="SMS_Collection.AMTOperateForMachines" Action="AdminService.SMS_Collection.AMTOperateForMachines" />
<ActionImport Name="SMS_Collection.GetServicePartners" Action="AdminService.SMS_Collection.GetServicePartners" />
<ActionImport Name="SMS_Collection.ModifyServicePartners" Action="AdminService.SMS_Collection.ModifyServicePartners" />
<EntitySet Name="SMS_Collection" EntityType="AdminService.SMS_Collection">
```

<br>

## Interacting with the API

This document focuses on using the PowerShell environment for interacting with the API. However, most of what you see here can be helpful when using other toolsets as well.

- The Administration Service class names are case-sensitive

> Important: As of the time of writing this document, Postman is not supported.

### Web Browser

You can use any browser to query the API. All returns are in JSON format. All of the script snippets in the PowerShell section will have a variable called *OData_Query* which will contain the same formatted query string you would use in the browser so they are not repeated here.

> Note: When using the OData_Query items from the PowerShell section, you will need to remove the escape key(s) within those strings. The escape key is the ` (grave accent).

1. Construct your URI with your query methods
   - Format: ```https://www.[ServerFQDN]/AdminService/wmi/[OData_WMIClass][OData_Query]```
   - Example: ```https://www.[ServerFQDN]/AdminService/wmi/SMS_Application?$filter=Manufacturer eq 'Microsoft Corporation' and IsLatest eq true &$select=Manufacturer,LocalizedDisplayName,SoftwareVersion```
2. Open your browser
3. Navigate to the constructed URI
4. Done

### PowerShell

This tool is the main focus of this document as it is also the main focus of the entire MECM toolkit.

- All snippets will utilize the modern *Invoke-RestMethod* cmdlet, not the *Invoke-WebRequest* cmdlet
- You must include the *-UseDefaultCredentials* parameter when using the *Invoke-RestMethod* cmdlet

1. Open PowerShell
2. Construct your snippet
   ```PowerShell
   ### GET Method
    $Path_AdminService_WMIRoute   = "https://$($SMSProvider)/AdminService/wmi/"
    $Odata_WMIClass       = "SMS_Collection"
    $OData_Query         = "?`$filter=IsBuiltIn eq false &`$select=CollectionID,Name,ObjectPath"
    $Temp_SMS_Collection = (Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $Odata_WMIClass + $OData_Query)" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value

   ### POST Method
    $Path_AdminService_WMIRoute   = "https://$($SMSProvider)/AdminService/wmi/"
    $WebAPI_WMIClass       = "SMS_Collection"
    $WebAPI_Body = @{
      Name                = "AM - Users - Microsoft Corporation - Microsoft Endpoint Configuration Manager Console"
      LimitToCollectionID = "SMS00004"
      Comment             = "Collection created using the REST API."
      CollectionType      = 1
    } | ConvertTo-Json
    Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $WebAPI_WMIClass)" -Method Post -Body $WebAPI_Body -ContentType "application/json" -UseDefaultCredentials
   ```
3. Execute
4. Done

### PowerBI

You can use powerful business intelligency and analytics tools such as PowerBI in order to query data and generate valuable reports for greater visibility.

- Greatly simplifies the access to data by not requiring SQL database rights (datareader) or direct access to DB servers or clusters
- A CNAME Alias and load balancing techniques can future-proof your reporting access while improving speed and reliability

1. Open PowerBI
2. Select Get Data
3. Select OData feed
4. Enter the URI: ```https://$($SMSProvider)/AdminService/wmi/```
5. Choose Windows Authentication
6. In the Navigator, select the WMI Class(es) you want to include in your report
7. Done

### 3rd Party Tools

> Note: This section is left intentionally blank as the scope of this document cannot possibly include the breadth of available tools.

<br>

## Methods

Because the Admin Service is based on the OData (Open Data Protocol), it supports the standard HTTP methods for CRUD operations: GET, POST, PUT/PATCH, DELETE

| Operation | Method | Description |
|-|-|-|
| Create | POST | Used to create a new resource. |
| Retrieve (Read) | GET | Used to request data from a specific resource or a collection of resources. |
| Update | PUT | Replaces the entire resource with the data in the request body. |
| Update | PATCH | Applies partial updates to the resource. |
| Delete | DELETE | Used to delete a specific resource. |

<br>

## Service Operations

OData allows servers to expose custom operations (also known as service operations) that can be invoked through GET or POST.

> Note: It is not known at this time if any service operations exist for the MECM Administration Service. This section is added here to identify that this is the current state and provide a location for documentation should that state change.

<br>

## Query Options

OData provides query optoins that allow clients to refine their requests, such as selecting specific properties, expanding related resources, sorting results, or filtering data.

| Option | Description | Example |
|-|-|-|
| [Filter](https://www.odata.org/documentation/odata-version-2-0/uri-conventions/#:~:text=4.5.%20Filter%20System%20Query%20Option%20(%24filter)) | Identifies a subset of the Entries from the Collection of Entries identified by the Resource Path section of the URI. The subset is determined by selecting only the Entries that satisfy the predicate expression specified by the query option. | ```https://$($SMSProvider)/AdminService/wmi/SMS_Collection?$filter=Name eq 'All Users'``` |
| [Select](https://www.odata.org/documentation/odata-version-2-0/uri-conventions/#:~:text=4.8.%20Select%20System%20Query%20Option%20(%24select)) | Identifies the same set of Entries as a URI without a $select query option; however, the value of $select specifies that a response from an OData service should return a subset of the Properties which would have been returned had the URI not included a $select query option. | ```https://$($SMSProvider)/AdminService/wmi/SMS_Collection?$select=CollectionID,Name,LimitToCollectionName,MemberCount``` |
| [Order By](https://www.odata.org/documentation/odata-version-2-0/uri-conventions/#:~:text=4.2.%20Orderby%20System%20Query%20Option%20(%24orderby)) | Specifies an expression for determining what values are used to order the collection of Entries identified by the Resource Path section of the URI. This query option is only supported when the resource path identifies a Collection of Entries. | ```https://$($SMSProvider)/AdminService/wmi/SMS_Collection?$orderby=MemberCount``` |
| [Top](https://www.odata.org/documentation/odata-version-2-0/uri-conventions/#:~:text=4.3.%20Top%20System%20Query%20Option%20(%24top)) | Identifies a subset of the Entries in the Collection of Entries identified by the Resource Path section of the URI. This subset is formed by selecting only the first N items of the set, where N is an integer greater than or equal to zero specified by this query option. | ```https://$($SMSProvider)/AdminService/wmi/SMS_Collection?$top=5``` |
| [Skip](https://www.odata.org/documentation/odata-version-2-0/uri-conventions/#:~:text=4.4.%20Skip%20System%20Query%20Option%20(%24skip)) | Identifies a subset of the Entries in the Collection of Entries identified by the Resource Path section of the URI. That subset is defined by seeking N Entries into the Collection and selecting only the remaining Entries (starting with Entry N+1). | ```https://$($SMSProvider)/AdminService/wmi/SMS_Collection?$skip=5``` |
| Count | Returns the number of records in a collection or, if the collection has a filter, the number of records matching the filter. | ```https://$($SMSProvider)/AdminService/wmi/SMS_Collection/$count``` |
| [Inline Count](https://www.odata.org/documentation/odata-version-2-0/uri-conventions/#:~:text=4.9.%20Inlinecount%20System%20Query%20Option%20(%24inlinecount)) | Specifies that the response to the request includes a count of the number of Entries in the Collection of Entries identified by the Resource Path section of the URI. The count must be calculated after applying any $filter System Query Options present in the URI. | This does not appear to be supported with the API |
| [Expand](https://www.odata.org/documentation/odata-version-2-0/uri-conventions/#:~:text=4.6.%20Expand%20System%20Query%20Option%20(%24expand)) | Indicates that Entries associated with the Entry or Collection of Entries identified by the Resource Path section of the URI must be represented inline (i.e. eagerly loaded). For example, if you want to identify a category and its products, you could use two URIs (and execute two requests), one for /Categories(1) and one for /Categories(1)/Products. The '$expand' option allows you to identify related Entries with a single URI such that a graph of Entries could be retrieved with a single HTTP request. | TODO |
| Search
| [Format](https://www.odata.org/documentation/odata-version-2-0/uri-conventions/#:~:text=4.7.%20Format%20System%20Query%20Option%20(%24format)) | Specifies that a response to the request MUST use the media type specified by the query option. If the $format query option is present in a request URI it takes precedence over the value(s) specified in the Accept request header. | TODO |

<br>

## Query Functions

The following table describes the OData query functions you can use to filter on string values:

| Function    | Description                                                                           | Example                                           |
|-------------|---------------------------------------------------------------------------------------|---------------------------------------------------|
| contains    |                                                                                       | $filter=contains(name,'(sample)')                 |
| endswith    |                                                                                       | $filter=endswith(name,'Inc.')                     |
| startswith  |                                                                                       | $filter=startswith(name,'a')                      |
| any         | Search for a single string within an array type property                              | $filter=PropertyName/any(item: item eq 'String')  |

<br>

## Operators

### Comparison Operators

| Operator             | Description           | Example                                            |
|----------------------|-----------------------|----------------------------------------------------|
| Eq                   | Equal                 | /Suppliers?$filter=Address/City eq 'Redmond'       |
| Ne                   | Not equal             | /Suppliers?$filter=Address/City ne 'London'        |
| Gt                   | Greater than          | /Products?$filter=Price gt 20                      |
| Ge                   | Greater than or equal | /Products?$filter=Price ge 10                      |
| Lt                   | Less than             | /Products?$filter=Price lt 20                      |
| Le                   | Less than or equal    | /Products?$filter=Price le 100                     |
| Like**               | Like the pattern      | /Products?$filter=contains(Name,'milk')            |

** This operator is not supported. However, you can achieve this type of comparison by using the query function *contains(property,value)*

### Logical Operators



| Operator             | Description           | Example                                            |
|----------------------|-----------------------|----------------------------------------------------|
| And                  | Logical and           | /Products?$filter=Price le 200 and Price gt 3.5    |
| Or                   | Logical or            | /Products?$filter=Price le 3.5 or Price gt 200     |
| Not                  | Logical negation      | /Products?$filter=not endswith(Description,'milk') |

### Arithmetic Operators

| Operator             | Description           | Example                                            |
|----------------------|-----------------------|----------------------------------------------------|
| Add                  | Addition              | /Products?$filter=Price add 5 gt 10                |
| Sub                  | Subtraction           | /Products?$filter=Price sub 5 gt 10                |
| Mul                  | Multiplication        | /Products?$filter=Price mul 2 gt 2000              |
| Div                  | Division              | /Products?$filter=Price div 2 gt 4                 |
| Mod                  | Modulo                | /Products?$filter=Price mod 2 eq 0                 |

### Grouping Operators

| Operator             | Description           | Example                                            |
|----------------------|-----------------------|----------------------------------------------------|
| ( )                  | Precedence grouping   | /Products?$filter=(Price sub 5) gt 10              |

<br>

## Characters

### URL encode special characters

If the string you are using as a value in a filter function includes a special character, you need to URL encode it. For example, if you use this function: contains(name,'+123'), it will not work because + is a character that can't be included in a URL. If you URL encode the string, it will become contains(name,'%2B123') and you will get results where the column value contains +123.

The following table shows the URL encoded values for common special characters.

| Special Character    | URL Encoded Character    |
|----------------------|--------------------------|
| $                    | %24                      |
| &                    | %26                      |
| +                    | %2B                      |
| ,                    | %2C                      |
| /                    | %2F                      |
| :                    | %3A                      |
| ;                    | %3B                      |
| =                    | %3D                      |
| ?                    | %3F                      |
| @                    | %40                      |

### Wildcard Characters

When composing filters using strings, you can apply the following wildcard characters:

> Note: If attempting to filter for entities in a "like" or wildcard search scenario, use the query function *contains(property,value)*.

| Characters | Description                                                                                                                 | T-SQL documentation and examples                                                                                                                                                                   |
|------------|-----------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| %          | Matches any string of zero or more characters. This wildcard character can be used as either a prefix or a suffix.          | [Percent character (Wildcard - Character(s) to Match) (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/percent-character-wildcard-character-s-to-match-transact-sql)  |
| _          | Use the underscore character to match any single character in a string comparison operation that involves pattern matching. | [_ (Wildcard - Match One Character) (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/wildcard-match-one-character-transact-sql)                                       |
| []         | Matches any single character within the specified range or set that is specified between brackets.                          | [[ ] (Wildcard - Character(s) to Match) (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/wildcard-character-s-to-match-transact-sql)                                  |
| [^]        | Matches any single character that isn't within the range or set specified between the square brackets.                      | [[^] (Wildcard - Character(s) Not to Match) (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/wildcard-character-s-not-to-match-transact-sql)                          |

<br>

# Appendices

A collection of sections that provide detailed explanation or understanding to the above topic but are not necessary within the main body of the topic.

## Apdx A: Troubleshooting

### Invoke-RestMethod : The remote server returned an error: (401) Unauthorized

#### Message

PowerShell will throw an error message that looks like the following:

```powershell
Invoke-RestMethod : The remote server returned an error: (401) Unauthorized.
At line:1 char:1
+ Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $Odata_WMICla ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidOperation: (System.Net.HttpWebRequest:HttpWebRequest) [Invoke-RestMethod], WebException
    + FullyQualifiedErrorId : WebCmdletWebResponseException,Microsoft.PowerShell.Commands.InvokeRestMethodCommand
```

#### Reason

This can happen for any of the following reasons:

- You did not include the *-UseDefaultCredentials* parameter when executing the *Invoke-RestMethod* cmdlet

#### Resolution

Add the *-UseDefaultCredentials* parameter to the line where you are executing the *Invoke-RestMethod* cmdlet

<br>