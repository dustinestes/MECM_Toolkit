# MECM Toolkit - Client - Logging - Configure Verbosity

&nbsp;

## References

The following items are referenced in the code within this document. Familiarize yourself with them before moving on.

| Name       | Type       | Description                                                    | Link |
|------------|------------|----------------------------------------------------------------|------|
| Logging    | Component  |  | [Microsoft Learn](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/about-log-files#configure-logging-options-by-using-the-windows-registry)

&nbsp;

## Table of Contents

- [MECM Toolkit - Client - Logging - Configure Verbosity](#mecm-toolkit---client---logging---configure-verbosity)
  - [References](#references)
  - [Table of Contents](#table-of-contents)
- [Basic Snippets](#basic-snippets)
  - [\[SnippetTitle\]](#snippettitle)
    - [Example](#example)
    - [Snippets](#snippets)
- [Advanced Functions](#advanced-functions)
  - [\[Title\]](#title)
- [Appendices](#appendices)
  - [Apdx A: \[Name\]](#apdx-a-name)
- [To Organize](#to-organize)

&nbsp;

# Basic Snippets

These are quick, simple snippets of code to reference for a basic understanding and inclusion within larger scripts or codebases. When a more fully developed function or operation is created using these, that block of code can be added to the Advanced Function section below.

> Note: These snippets tend to focus simply on the basic function at hand and should not incorporate other Basic Snippets or Advanced Functions. That is what the Advanced Functions section is for.

## [SnippetTitle]

[Text]

### Example

[Text]

### Snippets

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




# To Organize

To enable Verbose + Debug Logging on the Management Point or Configuration Manager Client:

| Component       | Registry Key                                     | Property      | Type   | Value   | Default   |
|-----------------|--------------------------------------------------|---------------|--------|---------|-----------|
| Verbose Logging | HKLM\Software\Microsoft\CCM\Logging\@GLOBAL      | LogLevel      | DWORD  | 0       | 1         |
| Debug Logging   | HKLM\Software\Microsoft\CCM\Logging\DebugLogging | Enabled       | String | True    | Not Exist |
| Log Size        | HKLM\Software\Microsoft\CCM\Logging\@GLOBAL      | LogMaxSize    | DWORD  | 5000000 | 250000    |
| Historical Logs | HKLM\Software\Microsoft\CCM\Logging\@GLOBAL      | LogMaxHistory | DWORD  | 5       | 1         |

```powershell
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\CCM\Logging\@Global" -Name "LogLevel" -Value "0" -Type DWord -ErrorAction Stop
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\CCM\Logging\@Global" -Name "LogMaxSize" -Value "5000000" -Type DWord -ErrorAction Stop
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\CCM\Logging\@Global" -Name "LogMaxHistory" -Value "5" -Type DWord -ErrorAction Stop

New-Item -Path "HKLM:\SOFTWARE\Microsoft\CCM\Logging\DebugLogging" -ErrorAction Stop
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\CCM\Logging\DebugLogging" -Name "Enabled" -Value "True" -Type String -Force -ErrorAction Stop
```


On Primary Servers, a number of logs can be made verbose by making an adjustment in the registry:

If you check components in subkeys under HKLM\Software\Microsoft\SMS\Components, you will find some that already have a Verbose Logs key, that you can switch the value from 0 to 1. Not all components offer the verbose option by default, but you can add it manually by creating the Verbose Logs DWORD key and by changing the Verbose Logs value to 1.

sms_regkey

You don’t need to restart any service for this to have an effect. To turn off verbose for the component, set the Verbose Logs value back to 0.

Advertisement

You can also turn on verbose on more logging by making an adjustment in the subkeys of HKLM\Software\Microsoft\SMS\Tracing.

For example, to turn verbose logging on a primary when there is a Remote DP, make the following adjustment:

HKLM\SOFTWARE\Microsoft\SMS\Tracing\SMS_PACKAGE_TRANSFER_MANAGER\

Set DebugLogging = 1
Set LoggingLevel = 0


To enable verbose SCCM Console logging:

From an administrator command prompt, open the following with Notepad: “C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\Microsoft.ConfigurationManagement.exe.config”
Search for switchValue=”Error”, and change to switchValue=”Verbose” (as shown below), and save changes.
Restart the admin console for debug logging to take effect.
console_verbose



Turn on verbose logging for Windows Update logs:

To turn on verbose logging for the WindowsUpdate.log, follow these steps:

HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Trace
Add a new DWORD key named Flags with a value of 7
Add a new DWORD key named Level with a value of 4
Then perform a NET STOP and NET START wuauserv
To enable verbose CBS logging, follow these steps:

NET STOP TRUSTEDINSTALLER
Add the following system environment variable: WINDOWS_TRACING_FLAGS with a value of 10000. *NOTE: This does not require a reboot to take effect.
NET START TRUSTEDINSTALLER


To enable verbose WSUS logging, follow these steps:

HKLM\SOFTWARE\Microsoft\Update Services\Server\Setup
Add a new DWORD key named LogLevel, with a value of 5
Restart IIS
Restart the WSUS Service