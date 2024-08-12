# MECM Toolkit - Collections - Management

The below ToC links you to the various sections and code snippets within this markdown file. These snippets should be used to manage the environment and help maintain standards.

## Table of Contents

- [MECM Toolkit - Collections - Management](#mecm-toolkit---collections---management)
  - [Table of Contents](#table-of-contents)
  - [Collection Auditing](#collection-auditing)
    - [Get - Collection Membership Count](#get---collection-membership-count)
    - [Get - Collection Exclude Rules](#get---collection-exclude-rules)
    - [Get - Collections with Zero Deployments](#get---collections-with-zero-deployments)
  - [Collection Member Management](#collection-member-management)
    - [Add - Exclude Rule to Target Collection(s)](#add---exclude-rule-to-target-collections)
    - [Remove - Exclude Rule from Target Collections](#remove---exclude-rule-from-target-collections)
    - [Add - Multiple Computers to Collection](#add---multiple-computers-to-collection)
    - [Remove - All Direct Memberships](#remove---all-direct-memberships)

&nbsp;

## Collection Auditing

The following snippets are used for auditing collections within MECM.

| Name | Purpose | Description | Link |
| ---- | ------- | ----------- | ---- |
| Get - Collection Membership Count | Collection Auditing | Query Collections and their membership info and return the member counts. | [Link](###-get---collection-membership-count) |
| Get - Collection Exclude Rules | Collection Auditing | Query Collections and return their exclude rules. | [Link](###-get---collection-exclude-rules) |
| Get - Collections with Zero Deployments | Collection Auditing | Query Collections and return the ones that do not have any Deployments targeted to them. | [Link](###-get---collections-with-zero-deployments) |

&nbsp;

### Get - Collection Membership Count

Snippet

```powershell
<# ---------------------------------------------------------------------------------------------
        Get - Collection Membership Count
   ---------------------------------------------------------------------------------------------
        Technology: Microsoft Endpoint Configuration Manager (MECM)
        Category: Assets and Compliance
        Subject: Collection Management
        Author: Dustin Estes
        Description: You can provide a TargetCollectionNamePrefix with a wildcard so that you
                     can target any number of collections to get a count of the membership.
                     This is helpful when you want to audit a group of collections very quickly
                     and easily.
        Modified By:
        Modified Date:
        Change Notes:
   --------------------------------------------------------------------------------------------- #>

# User Defined Variables
  $TargetCollectionNamePrefix = "TST - *"




<# -------------------------------- Do not edit below this line -------------------------------- #>

# Script Defined Variables
  $Results = [System.Collections.ArrayList]@()

# Get Collections by the prefix
  $CollectionsList = Get-CMCollection -CollectionType Device -Name $TargetCollectionNamePrefix

# Loop through Collections
  Foreach($Collection in $CollectionsList){
    # Create object
      $Object1 = New-Object PSobject

    # Add values to properties in object
      Add-Member -InputObject $Object1 -MemberType NoteProperty -Name CollectionName -Value $Collection.Name
      Add-Member -InputObject $Object1 -MemberType NoteProperty -Name LocalMemberCount -Value $Collection.LocalMemberCount
      Add-Member -InputObject $Object1 -MemberType NoteProperty -Name MemberCount -Value $Collection.MemberCount

    # Add object to results list
      $Results.Add($Object1) | Out-Null
  }

# Output results
  $Results | Sort CollectionName
```

&nbsp;

Output

```powershell
CollectionName              LocalMemberCount MemberCount
--------------              ---------------- -----------
TST - Collection 1                         0           0
TST - Collection 1[1]                      0           0
TST - Collection 1[1][1]                   0           0
TST - Collection 1[1][1][1]                0           0
```

&nbsp;

### Get - Collection Exclude Rules

Snippet

```powershell
<# ---------------------------------------------------------------------------------------------
        Get - Collection Exclude Rules
   ---------------------------------------------------------------------------------------------
        Technology: Microsoft Endpoint Configuration Manager (MECM)
        Category: Assets and Compliance
        Subject: Collection Management
        Author: Dustin Estes
        Date: August 14, 2021
        Description: You can provide a TargetCollectionNamePrefix with a wildcard so that you
                     can target any number of collections to get the ExcludeCollection rules.
                     This is helpful when you want to audity a group of collections very quickly
                     and easily.
        Modified By:
        Modified Date:
        Change Notes:
   --------------------------------------------------------------------------------------------- #>

# Declare Variables
    $TargetCollectionNamePrefix = "TST - *"




<# -------------------------------- Do not edit below this line -------------------------------- #>

# Script Defined Variables
  $Results = [System.Collections.ArrayList]@()

# Get Collections by the prefix
    $CollectionsList = Get-CMCollection -CollectionType Device -Name $TargetCollectionNamePrefix

# Loop through Collections
    Foreach($Collection in $CollectionsList){
        # Create object
        $Object1 = New-Object PSobject

        # Get Exclude rules
        $ExcludeInformation = (Get-CMCollectionExcludeMembershipRule -CollectionName $Collection.Name)

        # Add values to properties in object
        Add-Member -InputObject $Object1 -MemberType NoteProperty -Name CollectionName -Value $Collection.Name
        Add-Member -InputObject $Object1 -MemberType NoteProperty -Name ExcludeRules -Value $ExcludeInformation.RuleName

        # Add object to results list
        $Results.Add($Object1) | Out-Null
    }

# Output results
    $Results | Sort CollectionName
```

&nbsp;

Output

```powershell
CollectionName              ExcludeRules
--------------              ------------
TST - Collection 1          {LIE - Global Exclude - All Collections, LIE - Globally Exclude - All Collections - EP - Endpoint Protection}
TST - Collection 1[1]
TST - Collection 1[1][1]
TST - Collection 1[1][1][1]
```

&nbsp;

### Get - Collections with Zero Deployments

Snippet

```powershell
<# ---------------------------------------------------------------------------------------------
        MECM - Get - Collections with Zero Deployments
   ---------------------------------------------------------------------------------------------
        Technology: Microsoft Endpoint Configuration Manager (MECM)
        Category: Assets and Compliance
        Subject: Collection Management
        Author: Dustin Estes
        Date: September 24, 2021
        Description: This script will simply query all the Collections in the MECM environment,
                     locate the ones that are NOT a BuiltIn collection, select specific
                     properties we want to gather, and then determine if the Collection has zero
                     deployments assigned to it. If it does NOT have any deployments to it, the
                     information for the Collection is saved to a custom object and then output
                     to the screen and CSV file.
        Modified By:
        Modified Date:
        Change Notes:
   --------------------------------------------------------------------------------------------- #>


# Declare Variables
    $OutputPath = "C:\VividRock\MECM Toolkit\Output\MECM-Toolkit_CollectionManagement_Get-CollectionsWithZeroDeployments.csv"






<# -------------------------------- Do not edit below this line -------------------------------- #>

# Script Defined Variables
    $Results = [System.Collections.ArrayList]@()
    $CollectionTypes = @{
        1 = 'User'
        2 = 'Computer'
    }

# Get Collections that are not BuiltIn
    $CollectionsList = Get-CmCollection | Where-Object {$_.IsBuiltIn -ne $true} | Select-Object -Property CollectionID,Name,MemberCount,CollectionType,Comment,IsReferenceCollection,LastChangeTime,ObjectPath,PowerConfigsCount

# Loop through Collections
    Foreach ($Collection in $CollectionsList) {
        # Create object
        $Object1 = New-Object PSobject

        # Get Deployments for the initial set of Collections
        $Deployments = Get-CMDeployment | Where-Object {$_.CollectionName -eq $Collection.Name}

        # Determine if Deployments is null
        If ($Deployments -eq $null)
        {
            # Add values to properties in object
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name CollectionID -Value $Collection.CollectionID
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name Name -Value $Collection.Name
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name MemberCount -Value $Collection.MemberCount
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name CollectionType -Value $Collection.CollectionType
                # Transform data to user readable format
                    $CollectionTypeName = $CollectionTypes.[int]$Collection.CollectionType
                    Add-Member -InputObject $Object1 -MemberType NoteProperty -Name CollectionTypeName -Value $CollectionTypeName
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name Comment -Value $Collection.Comment
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name IsReferenceCollection -Value $Collection.IsReferenceCollection
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name LastChangeTime -Value $Collection.LastChangeTime
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name ObjectPath -Value $Collection.ObjectPath
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name PowerConfigsCount -Value $Collection.PowerConfigsCount
        }

        # Add object to results list
        $Results.Add($Object1) | Out-Null
    }


# Output Results
    # To Window
    $Results | Format-Table | Sort Name

    # To CSV
    $Results.GetEnumerator() |
        Select-Object -Property CollectionID,Name,MemberCount,CollectionType,CollectionTypeName,Comment,IsReferenceCollection,LastChangeTime,ObjectPath,PowerConfigsCount |
            Export-Csv -NoTypeInformation -Path $OutputPath

```

&nbsp;

Output

```powershell
CollectionID Name                                                MemberCount CollectionType CollectionTypeName Comment
------------ ----                                                ----------- -------------- ------------------ -------
VR10000D     VR BETA Users                                               389              1 User               None
VR100046     All Healthy Systems                                       16255              2 Computer           Collection of All Systems with the client installed and a Heartbeat within 14 days.
VR100047     Corporate Offfice\Computers\Endpoints                     10417              2 Computer           All devices within Active Directory organizational unit "Corporate Offfice\Computers\Endpoints"
```

&nbsp;

## Collection Member Management

The following snippets are used for managing collections within MECM.

&nbsp;

| Name | Purpose | DeSnippetion | Link |
| ---- | ------- | ----------- | ---- |
| Add - Exclude Rule to Target Collection(s) | Collection Member Management | Add an Exclude rule to a target collection. Used to quickly modify collection's membership and to standardize configurations. | [Link](###-add---exclude-rule-to-target-collections) |
| Remove - Exclude Rule from Target Collection(s) | Collection Member Management | Remove an Exclude rule from a target collection. Used to quickly modify collection's membership and to standardize configurations. | [Link](###-remove---exclude-rule-from-target-collections) |
| Remove - All Direct Memberships | Collection Member Management | Remove all direct memberships references on a collection. | [Link](###-remove---all-direct-memberships) |

&nbsp;

### Add - Exclude Rule to Target Collection(s)

Snippet

```powershell
<# ---------------------------------------------------------------------------------------------
        Add - Exclude Rule to Target Collection(s)
   ---------------------------------------------------------------------------------------------
        Technology: Microsoft Endpoint Configuration Manager (MECM)
        Category: Assets and Compliance
        Subject: Collection Management
        Author: Dustin Estes
        Date: August 14, 2021
        Description: You can provide a TargetCollectionNamePrefix with a wildcard so that you
                     can target any number of collections to apply an ExcludeCollection rule.
                     This is helpful when you want to apply a Global Exclude Collection to a
                     group of collections very quickly and easily.
        Modified By:
        Modified Date:
        Change Notes:
   --------------------------------------------------------------------------------------------- #>

# Declare Variables
    $TargetCollectionNamePrefix = "TST - Collection*"
    $ExcludeCollectionName = "LIE - Global Exclude - All Collections"




<# -------------------------------- Do not edit below this line -------------------------------- #>

# Script Defined Variables
  $Results = [System.Collections.ArrayList]@()

# Get Collections by the prefix
    $CollectionsList = Get-CMCollection -CollectionType Device -Name $TargetCollectionNamePrefix

# Loop through Collections
    Foreach($Collection in $CollectionsList){
        # Create object
        $Object1 = New-Object PSobject

        # Get Exclude rules
        $ExcludeInformation = (Get-CMCollectionExcludeMembershipRule -CollectionName $Collection.Name -ExcludeCollectionName $ExcludeCollectionName)

        # Add values to properties in object
        Add-Member -InputObject $Object1 -MemberType NoteProperty -Name CollectionName -Value $Collection.Name

        # Determine status and add rule if non-existent
        If($ExcludeInformation.RuleName -eq $ExcludeCollectionName){
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name PreviousRules -Value $ExcludeInformation.RuleName
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name IsPresent -Value $true
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name Action -Value "Skip"
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name NewRules -Value "No Change"
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name Status -Value "None"
        }Else{
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name PreviousRules -Value $ExcludeInformation.RuleName
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name IsPresent -Value $false
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name Action -Value "Add"

            # Add rule to collection
            Add-CMDeviceCollectionExcludeMembershipRule -CollectionName $Collection.Name -ExcludeCollectionName $ExcludeCollectionName

            # Get Exclude rules
            $ExcludeInformation = $null
            $ExcludeInformation = (Get-CMCollectionExcludeMembershipRule -CollectionName $Collection.Name -ExcludeCollectionName $ExcludeCollectionName)

            # Add new rules to object
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name NewRules -Value $ExcludeInformation.RuleName


            # Check to ensure Exclude rule was added
            If((Get-CMCollectionExcludeMembershipRule -CollectionName $Collection.Name -ExcludeCollectionName $ExcludeCollectionName).RuleName -eq $ExcludeCollectionName){
                Add-Member -InputObject $Object1 -MemberType NoteProperty -Name Status -Value "Success"
            }Else{
                Add-Member -InputObject $Object1 -MemberType NoteProperty -Name Status -Value "Failure"
            }
        }

    # Add object to results list
    $Results.Add($Object1) | Out-Null
    }

# Output results
    $Results | Format-Table | Sort CollectionName
```

&nbsp;

Output

```powershell
CollectionName              PreviousRules                          IsPresent Action NewRules                               Status
--------------              -------------                          --------- ------ --------                               ------
TST - Collection 1          LIE - Global Exclude - All Collections      True Skip   No Change                              None
TST - Collection 1[1]                                                  False Add    LIE - Global Exclude - All Collections Success
TST - Collection 1[1][1]                                               False Add    LIE - Global Exclude - All Collections Success
TST - Collection 1[1][1][1]                                            False Add    LIE - Global Exclude - All Collections Success

```

### Remove - Exclude Rule from Target Collections

Snippet

```powershell
<# ---------------------------------------------------------------------------------------------
        Remove - Exclude Rule from Target Collection(s)
   ---------------------------------------------------------------------------------------------
        Technology: Microsoft Endpoint Configuration Manager (MECM)
        Category: Assets and Compliance
        Subject: Collection Management
        Author: Dustin Estes
        Date: August 14, 2021
        Description: You can provide a TargetCollectionNamePrefix with a wildcard so that you
                     can target any number of collections to remove an ExcludeCollection rule.
                     This is helpful when you want to remove a Global Exclude Collection from a
                     group of collections very quickly and easily.
        Modified By:
        Modified Date:
        Change Notes:
   --------------------------------------------------------------------------------------------- #>

# Declare Variables
    $TargetCollectionNamePrefix = "TST - Collection*"
    $ExcludeCollectionName = "LIE - Global Exclude - All Collections"




<# -------------------------------- Do not edit below this line -------------------------------- #>

# Script Defined Variables
  $Results = [System.Collections.ArrayList]@()

# Get Collections by the prefix
    $CollectionsList = Get-CMCollection -CollectionType Device -Name $TargetCollectionNamePrefix

# Loop through Collections
    Foreach($Collection in $CollectionsList){
        # Create object
        $Object1 = New-Object PSobject

        # Get Exclude rules
        $ExcludeInformation = (Get-CMCollectionExcludeMembershipRule -CollectionName $Collection.Name -ExcludeCollectionName $ExcludeCollectionName)

        # Add values to properties in object
        Add-Member -InputObject $Object1 -MemberType NoteProperty -Name CollectionName -Value $Collection.Name

        # Determine status and add rule if non-existent
        If($ExcludeInformation.RuleName -eq $ExcludeCollectionName){
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name PreviousRules -Value $ExcludeInformation.RuleName
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name IsPresent -Value $true
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name Action -Value "Remove"

            # Add rule to collection
            Remove-CMDeviceCollectionExcludeMembershipRule -CollectionName $Collection.Name -ExcludeCollectionName $ExcludeCollectionName -Force

            # Get Exclude rules
            $ExcludeInformation = $null
            $ExcludeInformation = (Get-CMCollectionExcludeMembershipRule -CollectionName $Collection.Name -ExcludeCollectionName $ExcludeCollectionName)

            # Add new rules to object
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name NewRules -Value $ExcludeInformation.RuleName


            # Check to ensure Exclude rule was added
            If((Get-CMCollectionExcludeMembershipRule -CollectionName $Collection.Name -ExcludeCollectionName $ExcludeCollectionName).RuleName -eq $ExcludeCollectionName){
                Add-Member -InputObject $Object1 -MemberType NoteProperty -Name Status -Value "Failure"
            }Else{
                Add-Member -InputObject $Object1 -MemberType NoteProperty -Name Status -Value "Success"
            }
        }Else{
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name PreviousRules -Value $ExcludeInformation.RuleName
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name IsPresent -Value $false
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name Action -Value "Skip"
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name NewRules -Value "No Change"
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name Status -Value "None"
        }

    # Add object to results list
    $Results.Add($Object1) | Out-Null
    }

# Output results
    $Results | Format-Table | Sort CollectionName
```

&nbsp;

Output

```powershell
CollectionName              PreviousRules                          IsPresent Action NewRules Status
--------------              -------------                          --------- ------ -------- ------
TST - Collection 1          LIE - Global Exclude - All Collections      True Remove          Success
TST - Collection 1[1]       LIE - Global Exclude - All Collections      True Remove          Success
TST - Collection 1[1][1]    LIE - Global Exclude - All Collections      True Remove          Success
TST - Collection 1[1][1][1] LIE - Global Exclude - All Collections      True Remove          Success
```

&nbsp;

### Add - Multiple Computers to Collection

Snippet

```powershell
# Use File Content
  $Computer_List = Get-Content -Path ""
  $Collection_Name = "[CollectionName]"

# Use Array Content
  $Computer_List = @(
    Computer01
    Computer02
  )

# Process Computer List
  foreach ($item in $Computer_List) {
      Add-CMDeviceCollectionDirectMembershipRule -CollectionName $Collection_Name -ResourceID (Get-CMDevice -Name $item).ResourceID
  }
```

### Remove - All Direct Memberships

Snippet

```powershell
<# ---------------------------------------------------------------------------------------------
        Remove - All Direct Memberships
   ---------------------------------------------------------------------------------------------
        Technology: Microsoft Endpoint Configuration Manager (MECM)
        Category: Assets and Compliance
        Subject: Collection Management
        Author: Dustin Estes
        Date: August 27, 2021
        Description: This script is used to remove all direct memberships that are defined on a
                     collection. It is helpful when trying to cleanup collections as you don't
                     have to manually remove each direct membership 1 by 1.
        Modified By:
        Modified Date:
        Change Notes:
   --------------------------------------------------------------------------------------------- #>

# Declare Variables
    $CollectionName = "TEST - Direct Membership Stuff"




<# -------------------------------- Do not edit below this line -------------------------------- #>

# Script Defined Variables
  $Results = [System.Collections.ArrayList]@()

# Get Members by the prefix
    $DirectMembershipList = Get-CMCollectionDirectMembershipRule -CollectionName $CollectionName

# Loop through Members
    Foreach($Member in $DirectMembershipList){
        # Create object
        $Object1 = New-Object PSobject

        # Add values to properties in object
        Add-Member -InputObject $Object1 -MemberType NoteProperty -Name CollectionName -Value $CollectionName
        Add-Member -InputObject $Object1 -MemberType NoteProperty -Name RuleName -Value $Member.RuleName
        Add-Member -InputObject $Object1 -MemberType NoteProperty -Name ResourceID -Value $Member.ResourceID

        # Remove Member from Collection
        try{
            Remove-CMCollectionDirectMembershipRule -CollectionName $CollectionName -ResourceName $Member.RuleName -Force
        }
        catch{
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name MemberRemoved -Value "Error Removing Member"
        }

        # Validate Removal
        if(Get-CMCollectionDirectMembershipRule -CollectionName $CollectionName | Where-Object {$_.RuleName -like $Member.RuleName}){
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name MemberRemoved -Value "Failure"
        }
        else{
            Add-Member -InputObject $Object1 -MemberType NoteProperty -Name MemberRemoved -Value "Success"
        }

    # Add object to results list
    $Results.Add($Object1) | Out-Null
    }

# Output results
    $Results | Format-Table | Sort CollectionName
```

&nbsp;

Output

```powershell
CollectionName                 RuleName   ResourceID MemberRemoved
--------------                 --------   ---------- -------------
TEST - Direct Membership Stuff DESTES-847   16917857 Success
TEST - Direct Membership Stuff DESTES-VM1   16920390 Success
TEST - Direct Membership Stuff DESTES-VM2   16920409 Success
TEST - Direct Membership Stuff DESTES-VM3   16920939 Success
```
