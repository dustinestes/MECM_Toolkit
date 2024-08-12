# MECM Toolkit - Client - Installation


&nbsp;

## References

The following items are referenced in the code within this document. Familiarize yourself with them before moving on.

| Name                  | Type                        | Description                                                                                                       | Link |
|-----------------------|-----------------------------|-------------------------------------------------------------------------------------------------------------------|------|
| Log Files             | Documentation               | Provides a list of all MECM log files for reference                                                               | [Microsoft Learn](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/log-files) |

&nbsp;

## Table of Contents

- [MECM Toolkit - Client - Installation](#mecm-toolkit---client---installation)
  - [References](#references)
  - [Table of Contents](#table-of-contents)
- [Basic Snippets](#basic-snippets)
  - [Unsecure Environments (HTTP)](#unsecure-environments-http)
    - [PowerShell](#powershell)
    - [Command Prompt](#command-prompt)
  - [Secure Environments (HTTPS)](#secure-environments-https)
    - [PowerShell](#powershell-1)
    - [Command Prompt](#command-prompt-1)
  - [Local Source Content (No Distribution)](#local-source-content-no-distribution)
    - [PowerShell](#powershell-2)
- [Advanced Functions](#advanced-functions)
  - [\[Title\]](#title)
- [Appendices](#appendices)
  - [Apdx A: Logging \& Output](#apdx-a-logging--output)
    - [Log Files](#log-files)
    - [Registry](#registry)
    - [WMI](#wmi)
    - [Event Viewer](#event-viewer)

&nbsp;

# Basic Snippets

These are quick, simple snippets of code to reference for a basic understanding and inclusion within larger scripts or codebases. When a more fully developed function or operation is created using these, that block of code can be added to the Advanced Function section below.

> Note: These snippets tend to focus simply on the basic function at hand and should not incorporate other Basic Snippets or Advanced Functions. That is what the Advanced Functions section is for.

## Unsecure Environments (HTTP)

Use this installation snippet if your MECM site is configured for HTTP or Enhanced HTTP.

### PowerShell

```powershell
# Local Installation
  Start-Process -FilePath "C:\Windows\ccmsetup\ccmsetup.exe" -ArgumentList "SMSSITECODE=[SiteCode]"

# Remote Installation
  Invoke-Command -ComputerName "[ComputerName]" -ScriptBlock { Start-Process -FilePath "C:\Windows\ccmsetup\ccmsetup.exe" -ArgumentList "SMSSITECODE=[SiteCode]" }
```

### Command Prompt

```bat
REM Local Installation
  "C:\Windows\ccmsetup\ccmsetup.exe" SMSSITECODE=[SiteCode]

REM Remote Installation
REM   Not Supported
```

&nbsp;

## Secure Environments (HTTPS)

Use this installation snippet if your MECM site is configured for HTTPS.

### PowerShell

```powershell
# Local Installation
  Start-Process -FilePath "C:\Windows\ccmsetup\ccmsetup.exe" -ArgumentList "SMSSITECODE=[SiteCode]","CCMHTTPSPORT=443","/UsePKICert"

# Remote Installation
  Invoke-Command -ComputerName "[ComputerName]" -ScriptBlock { Start-Process -FilePath "C:\Windows\ccmsetup\ccmsetup.exe" -ArgumentList "SMSSITECODE=[SiteCode]","CCMHTTPSPORT=443","/UsePKICert" }
```

### Command Prompt

```bat
REM Local Installation
  "C:\Windows\ccmsetup\ccmsetup.exe" SMSSITECODE=[SiteCode] CCMHTTPSPORT=443 /UsePKICert

REM Remote Installation
REM   Not Supported
```

&nbsp;

## Local Source Content (No Distribution)

Use this installation snippet if you have a copy of the Client files locally and you do not wish to download them on-demand from a Distribution Point.

### PowerShell

```powershell
# Local Installation (HTTP)
  Start-Process -FilePath "C:\Windows\ccmsetup\ccmsetup.exe" -ArgumentList "SMSSITECODE=[SiteCode]","/source:'[PathToLocalSource]'"

# Remote Installation (HTTP)
  Invoke-Command -ComputerName "[ComputerName]" -ScriptBlock { Start-Process -FilePath "C:\Windows\ccmsetup\ccmsetup.exe" -ArgumentList "SMSSITECODE=[SiteCode]","/source:'[PathToLocalSource]'" }

# Local Installation (HTTPS)
  Start-Process -FilePath "C:\Windows\ccmsetup\ccmsetup.exe" -ArgumentList "SMSSITECODE=[SiteCode]","CCMHTTPSPORT=443","/UsePKICert","/source:'[PathToLocalSource]'"

# Remote Installation (HTTPS)
  Invoke-Command -ComputerName "[ComputerName]" -ScriptBlock { Start-Process -FilePath "C:\Windows\ccmsetup\ccmsetup.exe" -ArgumentList "SMSSITECODE=[SiteCode]","CCMHTTPSPORT=443","/UsePKICert","/source:'[PathToLocalSource]'" }
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

## Apdx A: Logging & Output

The following sections provide information on logging and output provided from the installation of the MECM client.

### Log Files

| Log name             | Description                                                                                                                                |
|----------------------|--------------------------------------------------------------------------------------------------------------------------------------------|
| ccmsetup.log         | Records ccmsetup.exe tasks for client setup, client upgrade, and client removal. Can be used to troubleshoot client installation problems. |
| ccmsetup-ccmeval.log | Records ccmsetup.exe tasks for client status and remediation.                                                                              |
| CcmRepair.log        | Records the repair activities of the client agent.                                                                                         |
| client.msi.log       | Records setup tasks done by client.msi. Can be used to troubleshoot client installation or removal problems.                               |
| ClientServicing.log  | Records information for client deployment state messages during auto-upgrade and client piloting.                                          |

### Registry

[TODO]

### WMI

[TODO]

### Event Viewer

[TODO]