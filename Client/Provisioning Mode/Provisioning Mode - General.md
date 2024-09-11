# MECM Toolkit - Client - Provisioning Mode - General

&nbsp;

## References

The following items are referenced in the code within this document. Familiarize yourself with them before moving on.

| Name                  | Type                        | Description                                                                                                       | Link |
|-----------------------|-----------------------------|-------------------------------------------------------------------------------------------------------------------|------|
| Provisioning Mode     | Documentation               | Provides information about this client state.                                                                     | [Microsoft Learn](https://learn.microsoft.com/en-us/mem/configmgr/osd/understand/provisioning-mode) |

&nbsp;

## Table of Contents

- [MECM Toolkit - Client - Provisioning Mode - General](#mecm-toolkit---client---provisioning-mode---general)
  - [References](#references)
  - [Table of Contents](#table-of-contents)
- [Basic Snippets](#basic-snippets)
  - [Get Provisioning Mode State](#get-provisioning-mode-state)
    - [Snippets](#snippets)
  - [Enable Provisioning Mode](#enable-provisioning-mode)
    - [Snippets](#snippets-1)
  - [Disable Provisioning Mode](#disable-provisioning-mode)
    - [Snippets](#snippets-2)
  - [Set Provisioning Mode Timeout](#set-provisioning-mode-timeout)
    - [Snippets](#snippets-3)
- [Advanced Functions](#advanced-functions)
  - [\[Title\]](#title)
- [Appendices](#appendices)
  - [Apdx A: Settings](#apdx-a-settings)
    - [Registry](#registry)
    - [WMI](#wmi)

&nbsp;

# Basic Snippets

These are quick, simple snippets of code to reference for a basic understanding and inclusion within larger scripts or codebases. When a more fully developed function or operation is created using these, that block of code can be added to the Advanced Function section below.

> Note: These snippets tend to focus simply on the basic function at hand and should not incorporate other Basic Snippets or Advanced Functions. That is what the Advanced Functions section is for.

## Get Provisioning Mode State

This will get the current state of the Client Provisioning Mode.

### Snippets

```powershell
# Local Device
  $Check_Reg_ClientProvisioningMode = Get-ItemPropertyValue -Path "HKLM:\Software\Microsoft\CCM\CcmExec" -Name ProvisioningMode -ErrorAction SilentlyContinue

  if ($Check_Reg_ClientProvisioningMode -in "",$null,$false) {
    Write-Host "    Client Provisioning Mode: Not Found"
  }
  else {
    Write-Host "    Client Provisioning Mode: $($Check_Reg_ClientProvisioningMode)"
  }
```

&nbsp;

## Enable Provisioning Mode

This will enable the Client Provisioning Mode so that the Client does not process Policy from the site.

### Snippets

```powershell
# Using WmiMethod
  Invoke-WmiMethod -Namespace root\CCM -Class SMS_Client -Name SetClientProvisioningMode -ArgumentList $true

# Using CimMethod
  Invoke-CimMethod -Namespace 'root\CCM' -ClassName SMS_Client -MethodName SetClientProvisioningMode -Arguments @{bEnable=$true}
```

&nbsp;

## Disable Provisioning Mode

This will disable the Client Provisioning Mode so that the Client does process Policy from the site.

### Snippets

```powershell
# Using WmiMethod
  Invoke-WmiMethod -Namespace root\CCM -Class SMS_Client -Name SetClientProvisioningMode -ArgumentList $false

# Using CimMethod
  Invoke-CimMethod -Namespace 'root\CCM' -ClassName SMS_Client -MethodName SetClientProvisioningMode -Arguments @{bEnable=$false}
```

&nbsp;

## Set Provisioning Mode Timeout

You can set the following settings in the Registry to configure the Client's Provisioning Mode behavior.

> Note: The client does not immediately see changes to these settings. To force it to query them and recognize the new values, you need to restart the client (ccmrestart.exe) or run the evaluation (ccmeval.exe).

| Setting Name           | Property Type | Description                                                                    | Location                            |
|------------------------|---------------|--------------------------------------------------------------------------------|-------------------------------------|
| ProvisioningMaxMinutes | DWORD         | Sets the maximum number of minutes the client can remain in Provisioning Mode. | HKLM\SOFTWARE\Microsoft\CCM\CcmExec |

### Snippets

```powershell
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\CcmExec" -Name "ProvisioningMaxMinutes" -PropertyType DWORD -Value [int32]
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

## Apdx A: Settings

### Registry

The following Properties relating to Client Provisioning Mode can be found within the Registry

| Setting Name            | Property Type | Description                                                                    | Location                            |
|-------------------------|---------------|--------------------------------------------------------------------------------|-------------------------------------|
| ProvisioningMaxMinutes  | DWORD         | Sets the maximum number of minutes the client can remain in Provisioning Mode. | HKLM\SOFTWARE\Microsoft\CCM\CcmExec |
| ProvisioningEnabledTime | QWORD         | Shows the last time a Client entered Provisioning Mode. [Epoch time]           | HKLM\SOFTWARE\Microsoft\CCM\CcmExec |

### WMI

[Unknon]