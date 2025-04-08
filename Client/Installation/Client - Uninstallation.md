# MECM Toolkit - Client - Uninstallation


<br>

## References

The following items are referenced in the code within this document. Familiarize yourself with them before moving on.

| Name                  | Type                        | Description                                                                                                       | Link |
|-----------------------|-----------------------------|-------------------------------------------------------------------------------------------------------------------|------|
| Log Files             | Documentation               | Provides a list of all MECM log files for reference                                                               | [Microsoft Learn](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/log-files) |

<br>

## Table of Contents

- [MECM Toolkit - Client - Uninstallation](#mecm-toolkit---client---uninstallation)
  - [References](#references)
  - [Table of Contents](#table-of-contents)
- [Basic Snippets](#basic-snippets)
  - [Clean Uninstall](#clean-uninstall)
    - [PowerShell](#powershell)
    - [Command Prompt](#command-prompt)
- [Advanced Functions](#advanced-functions)
  - [\[Title\]](#title)
- [Appendices](#appendices)
  - [Apdx A: Logging \& Output](#apdx-a-logging--output)
    - [Log Files](#log-files)
    - [Registry](#registry)
    - [WMI](#wmi)
    - [Event Viewer](#event-viewer)

<br>

# Basic Snippets

These are quick, simple snippets of code to reference for a basic understanding and inclusion within larger scripts or codebases. When a more fully developed function or operation is created using these, that block of code can be added to the Advanced Function section below.

> Note: These snippets tend to focus simply on the basic function at hand and should not incorporate other Basic Snippets or Advanced Functions. That is what the Advanced Functions section is for.

## Clean Uninstall

Use this uninstallation snippet if you have tried to perform client reinstallations over an existing failed client and the device still will not communicate successfully. This will ensure all services and files are removed for a completely fresh installation.

### PowerShell

```powershell
# Clear CCMSetup Log
  Clear-Content -Path "C:\Windows\ccmsetup\Logs\ccmsetup.log"

# Uninstall MECM Agent
  Start-Process -FilePath "C:\Windows\ccmsetup\ccmsetup.exe" -ArgumentList "/uninstall"

# Open Log to Monitor
  Copy-Item -Path "C:\Windows\CCM\CMTrace.exe" -Destination $($env:TEMP)
  Start-Process -FilePath "$($env:TEMP)\cmtrace.exe" -ArgumentList "C:\Windows\ccmsetup\Logs\ccmsetup.log"

# Monitor Log File
  do {
    # Get Log File
      $Temp_LogFile = Get-Content -Path "C:\Windows\ccmsetup\Logs\ccmsetup.log"
      Start-Sleep -Seconds 10
  }
  until ($Temp_LogFile -match "CcmSetup is exiting with return code")

# Remove Service
  $Temp_CCMExecService = Get-Service -Name CcmExec -ErrorAction SilentlyContinue

  if ($Temp_CCMExecService.Status -eq "Running") {
    # Stop Dependent Services
      if ($Temp_CCMExecService.DependentServices -notin "",$null) {
        Stop-Service -Name $Temp_CCMExecService.DependentServices -Force -ErrorAction Stop
      }

    # Stop MECM Service
      Stop-Service -Name CcmExec -Force

    # Remove MECM Service
      $Temp_RemoveService = Get-WmiObject -Class Win32_Service -Filter "Name='CcmExec'"
      $Temp_NullOut = $Temp_RemoveService.Delete()

    # Start Dependent Services
      if ($Temp_CCMExecService.DependentServices -notin "",$null) {
        Start-Service -Name $Temp_CCMExecService.DependentServices -Force -ErrorAction Stop
      }
  }

# Remove WMI Namespace
  Get-WmiObject -query "Select * From __Namespace Where Name='CCM'" -Namespace "root" -ComputerName COMPUTERNAME.DOMAIN | Remove-WmiObject

# Set ACL on Files
  Start-Process -FilePath "Takeown" -ArgumentList "/f","C:\windows\CCM\PolicyBackup"
  Start-Process -FilePath "icacls" -ArgumentList "C:\windows\CCM\PolicyBackup","/grant","administrators:F"
  Start-Process -FilePath "Takeown" -ArgumentList "/f","C:\windows\ccmcache"
  Start-Process -FilePath "icacls" -ArgumentList "C:\windows\ccmcache","/grant","administrators:F"

# Remove Files
  Remove-Item -Path "C:\Windows\CCM" -Recurse -Force
  Remove-Item -Path "C:\windows\ccmcache" -Recurse -Force
```

### Command Prompt

```bat
REM Not Exist
```

<br>

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

<br>

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