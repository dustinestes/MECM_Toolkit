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