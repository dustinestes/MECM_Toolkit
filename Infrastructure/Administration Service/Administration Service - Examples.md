# MECM Toolkit - Infrastructure - Administration Service - General

&nbsp;

## Table of Contents

- [MECM Toolkit - Infrastructure - Administration Service - General](#mecm-toolkit---infrastructure---administration-service---general)
  - [Table of Contents](#table-of-contents)
- [Content Management](#content-management)
  - [Content Distribution Status](#content-distribution-status)
    - [Get Failed Distributions](#get-failed-distributions)
      - [Output](#output)
    - [Get Packages with No Distributions](#get-packages-with-no-distributions)
      - [Output](#output-1)
    - [Cancel Pending Distributions](#cancel-pending-distributions)
      - [Output](#output-2)
- [\[Category\]](#category)
  - [\[SubCategory\]](#subcategory)
    - [\[Function\]](#function)
      - [Output](#output-3)
  - [\[SnippetTitle\]](#snippettitle)
    - [Example](#example)
    - [Snippets](#snippets)
    - [Output](#output-4)

&nbsp;

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
  $Name_WMI_Class = "SMS_PackageStatus"
  $Odata_Filter_Expression = "?`$filter=Status eq 5"
  $Output = (Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $Name_WMI_Class + $Odata_Filter_Expression)" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value
```

#### Output

```json
{
  "@odata.etag": "VR100003;0;ServerFQDN.DOMAIN.COM;VR1;3;1",
  "__LAZYPROPERTIES": [
      "__QUALIFIER_SECURITYVERBS"
  ],
  "__QUALIFIER_SECURITYVERBS": null,
  "Location": "",
  "PackageID": "VR100003",
  "Personality": 0,
  "PkgServer": "ServerFQDN.DOMAIN.COM",
  "ShareName": "",
  "SiteCode": "VR1",
  "Status": 5,
  "Type": 1,
  "UpdateTime": "2024-08-30T20:55:06Z",
  "__GENUS": 2,
  "__CLASS": "SMS_PackageStatus",
  "__SUPERCLASS": "SMS_BaseClass",
  "__DYNASTY": "SMS_BaseClass",
  "__RELPATH": "SMS_PackageStatus.PackageID=\"VR100003\",Personality=0,PkgServer=\"ServerFQDN.DOMAIN.COM\",SiteCode=\"VR1\",Status=3,Type=1",
  "__PROPERTY_COUNT": 9,
  "__DERIVATION": [
      "SMS_BaseClass"
  ],
  "__SERVER": "V0002WS0127",
  "__NAMESPACE": "root\\sms\\site_VR1",
  "__PATH": "\\\\V0002WS0127\\root\\sms\\site_VR1:SMS_PackageStatus.PackageID=\"VR100003\",Personality=0,PkgServer=\"ServerFQDN.DOMAIN.COM\",SiteCode=\"VR1\",Status=3,Type=1"
}
```

<br>

### Get Packages with No Distributions

This example shows how to identify packages that have no content distributed to any distribution point.

```powershell
# Variables
  $Path_AdminService_WMIRoute = "https://[SMSProviderFQDN]/AdminService/wmi/"
  $Name_WMI_Class = "SMS_PackageStatus"

# Get all package status information and content info
  $PackageStatus = (Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute)$Name_WMI_Class" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value
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
  $Name_WMI_Class = "SMS_PackageStatus"
  $Odata_Filter_Expression = "?`$filter=Status eq 0 or Status eq 1"
  $URI_Method_Cancel = "$Path_AdminService_WMIRoute/SMS_DistributionPoint/AdminService.CancelDistribution"

# Get Pending Distributions
  $Distributions_Pending = (Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $Name_WMI_Class + $Odata_Filter_Expression)" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value
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






## [SnippetTitle]

[Text]

### Example

[Text]

### Snippets

```powershell
# Web Browser

# PowerShell

```

### Output

```powershell
# Add Code Here
```