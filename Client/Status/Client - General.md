# MECM Toolkit - Client - Status

&nbsp;

## References

The following items are referenced in the code within this document. Familiarize yourself with them before moving on.

| Name                  | Type                        | Description                                                                                                       | Link |
|-----------------------|-----------------------------|-------------------------------------------------------------------------------------------------------------------|------|
| None | | | |

&nbsp;

## Table of Contents

- [MECM Toolkit - Client - Status](#mecm-toolkit---client---status)
  - [References](#references)
  - [Table of Contents](#table-of-contents)
- [Basic Snippets](#basic-snippets)
  - [Check for Client Installation Service](#check-for-client-installation-service)
    - [Snippets](#snippets)
    - [Output](#output)
  - [Check for Task Sequence Process](#check-for-task-sequence-process)
    - [Snippets](#snippets-1)
    - [Output](#output-1)
  - [\[SnippetTitle\]](#snippettitle)
    - [Example](#example)
    - [Snippets](#snippets-2)
    - [Output](#output-2)
- [Advanced Functions](#advanced-functions)
  - [\[Title\]](#title)
- [Appendices](#appendices)
  - [Apdx A: \[Name\]](#apdx-a-name)

&nbsp;

# Basic Snippets

These are quick, simple snippets of code to reference for a basic understanding and inclusion within larger scripts or codebases. When a more fully developed function or operation is created using these, that block of code can be added to the Advanced Function section below.

> Note: These snippets tend to focus simply on the basic function at hand and should not incorporate other Basic Snippets or Advanced Functions. That is what the Advanced Functions section is for.

## Check for Client Installation Service

Check to see if the Client Installation Service is running or not.

### Snippets

```powershell
# Local Device
  $Check_Service_CcmSetup = Get-Service -Name "ccmsetup"

  if ($Check_Service_CcmSetup -in "",$null) {
    Write-Host "    Client Installation: Not Found"
  }
  else {
    Write-Host "    Client Installation: $($Check_Service_CcmSetup.Status)"
  }

# Remote Device
  $Check_Service_CcmSetup = Get-Service -Name "ccmsetup" -ComputerName "[DeviceFQDN]"

  if ($Check_Service_CcmSetup -in "",$null) {
    Write-Host "    Client Installation: Not Found"
  }
  else {
    Write-Host "    Client Installation: $($Check_Service_CcmSetup.Status)"
  }
```

### Output

```powershell
# Simple write-host output
```

## Check for Task Sequence Process

Check to see if the process associated with a running Task Sequence exists.

### Snippets

```powershell
# Local Device
  $Check_Process_TSRunning = Get-Process |  Where-Object -Property Name -in "TsBootShell","TsManager","TsmBootStrap","TsProgressUI"

  if ($Check_Process_TSRunning -in "",$null) {
    Write-Host "    Client TS Processes: Not Found"
  }
  else {
    Write-Host "    Client TS Processes: $($Check_Process_TSRunning.Name)"
  }

# Remote Device
  $Check_Process_TSRunning = Get-Process -ComputerName "[DeviceFQDN]" |  Where-Object -Property Name -in "TsBootShell","TsManager","TsmBootStrap","TsProgressUI"

  if ($Check_Process_TSRunning -in "",$null) {
    Write-Host "    Client TS Processes: Not Found"
  }
  else {
    Write-Host "    Client TS Processes: $($Check_Process_TSRunning.Name)"
  }
```

### Output

```powershell
# Simple write-host output
```

## [SnippetTitle]

[Text]

### Example

[Text]

### Snippets

```powershell
# Local Device

# Remote Device

```

### Output

```powershell
# Add Code Here
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