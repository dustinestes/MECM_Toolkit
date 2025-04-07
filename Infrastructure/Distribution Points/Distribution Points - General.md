# MECM Toolkit - Infrastructure - Distribution Points - General

&nbsp;

## References

The following items are referenced in the code within this document. Familiarize yourself with them before moving on.

| Name       | Type       | Description                                                    | Link |
|------------|------------|----------------------------------------------------------------|------|
| None | | | |

&nbsp;

## Table of Contents

- [MECM Toolkit - Infrastructure - Distribution Points - General](#mecm-toolkit---infrastructure---distribution-points---general)
  - [References](#references)
  - [Table of Contents](#table-of-contents)
- [Basic Snippets](#basic-snippets)
  - [Reinstall the Distribution Point Role](#reinstall-the-distribution-point-role)
    - [Process](#process)
    - [Snippets](#snippets)
  - [Distribute OSD Certificate to All Distribution Points](#distribute-osd-certificate-to-all-distribution-points)
    - [Process](#process-1)
      - [Request the MECM DP OSD Certificate](#request-the-mecm-dp-osd-certificate)
      - [Renew the MECM DP OSD Certificate](#renew-the-mecm-dp-osd-certificate)
      - [Export the Certificate](#export-the-certificate)
      - [Distribute the Certificate to All Distribution Points](#distribute-the-certificate-to-all-distribution-points)
        - [Snippets](#snippets-1)
      - [(Optional) Create a New ISO with the New Certificate](#optional-create-a-new-iso-with-the-new-certificate)
      - [Get Certificate Path of All Distribution Points](#get-certificate-path-of-all-distribution-points)
  - [PXE](#pxe)
    - [Enable](#enable)
    - [Disable](#disable)
  - [Content Validation](#content-validation)
    - [Enable](#enable-1)
    - [Disable](#disable-1)
- [Advanced Functions](#advanced-functions)
  - [\[Title\]](#title)
- [Appendices](#appendices)
  - [Apdx A: \[Name\]](#apdx-a-name)

&nbsp;

# Basic Snippets

These are quick, simple snippets of code to reference for a basic understanding and inclusion within larger scripts or codebases. When a more fully developed function or operation is created using these, that block of code can be added to the Advanced Function section below.

> Note: These snippets tend to focus simply on the basic function at hand and should not incorporate other Basic Snippets or Advanced Functions. That is what the Advanced Functions section is for.

## Reinstall the Distribution Point Role

This bit of SQL code will set the flags for both the State and IsPullDPInstalled state to 0 (or False) within the database. This tells MEC that the device is a Distribution Point, but it has not been provisiioned. MECM will then perform the installation of the Distribution Role as well as the PullDP software (if configured for it).

### Process

1. Open SQL Server Management Studio
2. Connect to the SQL Server
3. Run the 1st snippet to check the value of the server
4. Run the 2nd snippet to reset the installation of the server
5. Run the 1st snippet again to check the value of the server has now been updated
6. Restart the SMS_Distribution_Manager component from the Configuration Manager Service Manager

### Snippets

```sql
/** Get Install State of Distribution Point **/
SELECT DPID, IsPullDPInstalled, State, ServerName
FROM DistributionPoints
WHERE ServerName = '[ServerFQDN]'

/** Reset Install State of Distribution Point **/
UPDATE DistributionPoints
SET IsPullDPInstalled = '0', State = '0'
WHERE ServerName = '[ServerFQDN]'
```

&nbsp;

## Distribute OSD Certificate to All Distribution Points

This snippet is used for both the initial push of the certificate to all DPs as well as each subsequent push when the certificate has to be renewed.

### Process

#### Request the MECM DP OSD Certificate
Use this process if the Certificate already exists within the Certificate Store

1. Logon to the Primary Site Server
2. Open Manage Computer Certificates from the start menu
3. Expand the Personal store
4. Right Click Certificates container
5. Mouse over All Tasks
6. Click Request New Certificate...
7. Click Next
8. Click Next
9. Check the box next to MECM DP OSD Certificate
10. Click Enroll
11. Click Finish

#### Renew the MECM DP OSD Certificate
Use this process if the Certificate already exists within the Certificate Store

1. Logon to the Primary Site Server
2. Open Manage Computer Certificates from the start menu
3. Expand the Personal store
4. Click Certificates container
5. Right Click the Certificate issued from the MECM DP OSD Certificate template
6. Mouse over All Tasks
7. Click Request Certificate with New Key...
8. Click Next
9. Click Enroll
10. Click Finish

#### Export the Certificate
The certificate needs to be exported with its Private Key so this Certificate can be used to install supported certificates in Windows PE sessions created from PXE and ISO imaging.

1. Right Click the Certificate issued from the MECM DP OSD Certificate template
2. Mouse over All Tasks
3. Click Export...
4. Click Next
5. Select Yes, export the private key radio button
6. Click Next
7. Use these Options
   1. Type: Personal Information Exchange – PKCS #12 (.PFX)
   2. Enable: Include all certificates in the certificate path if possible
   3. Enable: Enable certificate privacy
8. Click Next
9.  Protect the Private Key using the following:
   1. Password: Choose a strong password and save it somewhere safe
   2. Encryption: TripleDES-SHA1
10. Click Next
11. Save the Certificate Export File in the Repo
    1.  Path: \\[ShareAddress]\Repo\Backups\Certificates\MECM DP OSD Certificate_[ExpiryDate_YYYY-MM-DD].pfx
12. Click Next
13. Click Finish

#### Distribute the Certificate to All Distribution Points
The certificate now needs to be distributed to all DPs so it can be included with all PXE deployments

1. Open the MECM Console
2. Click the Blue Arrow dropdown in the top left corner
3. Click Connect via Windows PowerShell ISE
4. Run the Connection Script that opens
   1. You can just highlight all and use the F8 run selection to avoid Execution Policy restrictions or having to change them
5. Run one of the following snippets for single or multiple servers
  ```powershell
  # Single Server
    $DistributionPoint = Get-CMDistributionPoint -SiteSystemServerName "[ServerName]"

    $Params = @{
        InputObject = $DistributionPoint
        CertificatePath = "[PathToCertFile]"
        CertificatePassword = $(ConvertTo-SecureString -String "[CertificatePassword]" -AsPlainText -Force)
        Force = $true
    }

  Set-CMDistributionPoint @Params

  # Multiple Servers
    $DistributionPoints = Get-CMDistributionPoint | Where-Object { $_.NALType -ne "Windows Azure" }

    foreach ($DistributionPoint in $DistributionPoints) {
      $Params = @{
        InputObject = $DistributionPoint
        CertificatePath = "[PathToCertFile]"
        CertificatePassword = $(ConvertTo-SecureString -String "[CertificatePassword]" -AsPlainText -Force)
        Force = $true
      }

      Set-CMDistributionPoint @Params

      Write-Host "  - $($DistributionPoint.EmbeddedProperties."Server Remote Name".Value1): Certificate Added Successfully"
    }
  ```
6. Validate Output shows all DPs Successful
7. Done

##### Snippets


#### (Optional) Create a New ISO with the New Certificate
If you are using ISOs for imaging, you will have to generate a new ISO with this certificate injected into it.

> [This process will be done after updating the ADK as part of the High Availability scale up]

#### Get Certificate Path of All Distribution Points

1. Open the MECM Console
2. Click the Blue Arrow dropdown in the top left corner
3. Click Connect via Windows PowerShell ISE
4. Run the Connection Script that opens
   1. You can just highlight all and use the F8 run selection to avoid Execution Policy restrictions or having to change them
5. Run the following snippet
  ```powershell
  $DistributionPoints = Get-CMDistributionPoint | Where-Object {$_.NALType -ne "Windows Azure"}

  foreach ($DP in $DistributionPoints) {
    Write-Host "$($DP.NetworkOSPath)"
    foreach ($Property in $DP.Props) {
      if ($Property.PropertyName -eq "CertificateFile") {
          Write-Host "    FilePath: $($Property.Value1)"
      }
    }
  }
  ```
6. Analyze the output
7. Done

&nbsp;

## PXE

The snippets below provide a method for configuring the PXE role on a single server or an entire hierarchy of servers.

### Enable

> Note: Both snippets include Where-Object clauses to ensure that devices with PXE already enabled are not included and neither are CMG servers.

```powershell
# Single Server
  $DistributionPoint = Get-CMDistributionPoint -SiteSystemServerName "[SERVERFQDN]" | Where-Object {($_.EmbeddedProperties.IsPXE.Value -eq 0) -and ($_.NALType -ne "Windows Azure")}

  $Params = @{
  InputObject = $DistributionPoint
  EnablePXE = $true
  AllowPxeResponse = $true
  EnableUnknownComputerSupport = $true
  EnableNonWdsPxe = $true
  PxePassword = $(ConvertTo-SecureString -String "[Password]" -AsPlainText -Force)
  ClearMacAddressForRespondingPxeRequest = $true
  UserDeviceAffinity = "AllowWithAutomaticApproval"
  }

  Set-CMDistributionPoint @Params

# Multiple Servers
  $DistributionPoints = Get-CMDistributionPoint -SiteSystemServerName "*" | Where-Object {($_.EmbeddedProperties.IsPXE.Value -eq 0) -and ($_.NALType -ne "Windows Azure")}

  foreach ($DistributionPoint in $DistributionPoints) {
    $Params = @{
      InputObject = $DistributionPoint
      EnablePXE = $true
      AllowPxeResponse = $true
      EnableUnknownComputerSupport = $true
      EnableNonWdsPxe = $true
      PxePassword = $(ConvertTo-SecureString -String "[Password]" -AsPlainText -Force)
      ClearMacAddressForRespondingPxeRequest = $true
      UserDeviceAffinity = "AllowWithAutomaticApproval"
    }

    Set-CMDistributionPoint @Params

    Write-Host "  - $($DistributionPoint.EmbeddedProperties."Server Remote Name".Value1): Completed Successfully"
  }
```

### Disable

> Note: Both snippets include Where-Object clauses to ensure that devices with PXE already disabled are not included and neither are CMG servers.

```powershell
# Single Server
	$DistributionPoint = Get-CMDistributionPoint -SiteSystemServerName "[SERVERFQDN]" | Where-Object {($_.EmbeddedProperties.IsPXE.Value -eq 1) -and ($_.NALType -ne "Windows Azure")}

	$Params = @{
	InputObject = $DistributionPoint
	EnablePXE = $false
	KeepWds = $true
	}

	Set-CMDistributionPoint @Params

# Multiple Servers
  $DistributionPoints = Get-CMDistributionPoint -SiteSystemServerName "*" | Where-Object {($_.EmbeddedProperties.IsPXE.Value -eq 1) -and ($_.NALType -ne "Windows Azure")}

  foreach ($DistributionPoint in $DistributionPoints) {
    $Params = @{
      InputObject = $DistributionPoint
      EnablePXE = $false
      KeepWds = $true
    }

    Set-CMDistributionPoint @Params

    Write-Host "  - $($DistributionPoint.EmbeddedProperties."Server Remote Name".Value1): Completed Successfully"
  }
```

## Content Validation

The snippets below provide a method for configuring the Content Validation settings on a single server or an entire hierarchy of servers.

### Enable

> Note: Both snippets include Where-Object clauses to ensure that devices with Content Validation already enabled are not included and neither are CMG servers.

```powershell
# Single Server
	$DistributionPoint = Get-CMDistributionPoint -SiteSystemServerName "[SERVERFQDN]" | Where-Object {($_.EmbeddedProperties.DPMonEnabled.Value -eq 0) -and ($_.NALType -ne "Windows Azure")}

	$Params = @{
    InputObject = $DistributionPoint
    EnableContentValidation = $true
    ContentValidationSchedule = New-CMSchedule -Start "2024-01-01T00:00:00.0000000" -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 2
    ContentMonitoringPriority = "Lowest"
	}

	Set-CMDistributionPoint @Params

# Multiple Servers
  $DistributionPoints = Get-CMDistributionPoint -SiteSystemServerName "*" | Where-Object {($_.EmbeddedProperties.DPMonEnabled.Value -eq 0) -and ($_.NALType -ne "Windows Azure")}

  foreach ($DistributionPoint in $DistributionPoints) {
    $Params = @{
      InputObject = $DistributionPoint
      EnableContentValidation = $true
      ContentValidationSchedule = New-CMSchedule -Start "2024-01-01T00:00:00.0000000" -DurationInterval Days -DurationCount 0 -RecurInterval Days -RecurCount 2
      ContentMonitoringPriority = "Lowest"
    }

    Set-CMDistributionPoint @Params

    Write-Host "  - $($DistributionPoint.EmbeddedProperties."Server Remote Name".Value1): Completed Successfully"
  }
```

### Disable

> Note: Both snippets include Where-Object clauses to ensure that devices with Content Validation already disabled are not included and neither are CMG servers.

```powershell
# Single Server
	$DistributionPoint = Get-CMDistributionPoint -SiteSystemServerName "[SERVERFQDN]" | Where-Object {($_.EmbeddedProperties.DPMonEnabled.Value -eq 1) -and ($_.NALType -ne "Windows Azure")}

	$Params = @{
    InputObject = $DistributionPoint
    EnableContentValidation = $false
	}

	Set-CMDistributionPoint @Params

# Multiple Servers
  $DistributionPoints = Get-CMDistributionPoint -SiteSystemServerName "*" | Where-Object {($_.EmbeddedProperties.DPMonEnabled.Value -eq 0) -and ($_.NALType -ne "Windows Azure")}

  foreach ($DistributionPoint in $DistributionPoints) {
    $Params = @{
      InputObject = $DistributionPoint
      EnableContentValidation = $false
    }

    Set-CMDistributionPoint @Params

    Write-Host "  - $($DistributionPoint.EmbeddedProperties."Server Remote Name".Value1): Completed Successfully"
  }
```

&nbsp;

# Advanced Functions

These are more advanced snippets and usages of the basic snippets above that provide even more functionality and capabilities. These might also incorporate other Basic Snippets or Advanced functions from other Collections and Topics.

## [Title]

[Text]

> Example:
>
> [Text]

```powershell
# Add Code Here
```

&nbsp;

# Appendices

A collection of sections that provide detailed explanation or understanding to the above topic but are not necessary within the main body of the topic.

## Apdx A: [Name]

[Text]