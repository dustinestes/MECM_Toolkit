# MECM Toolkit - Task Sequences - Notifications - Execution Status

&nbsp;

## References

The following items are referenced in the code within this document. Familiarize yourself with them before moving on.

| Name                  | Type                        | Description                                                                                                       | Link |
|-----------------------|-----------------------------|-------------------------------------------------------------------------------------------------------------------|------|
| None | | | |

&nbsp;

## Table of Contents

- [MECM Toolkit - Task Sequences - Notifications - Execution Status](#mecm-toolkit---task-sequences---notifications---execution-status)
  - [References](#references)
  - [Table of Contents](#table-of-contents)
- [Basic Snippets](#basic-snippets)
  - [PowerShell](#powershell)
    - [Output](#output)
  - [Command (cmd.exe)](#command-cmdexe)
    - [Output](#output-1)
- [Advanced Functions](#advanced-functions)
  - [\[Title\]](#title)
- [Appendices](#appendices)
  - [Apdx A: \[Name\]](#apdx-a-name)

&nbsp;

# Basic Snippets

These are quick, simple snippets of code to reference for a basic understanding and inclusion within larger scripts or codebases. When a more fully developed function or operation is created using these, that block of code can be added to the Advanced Function section below.

> Note: These snippets tend to focus simply on the basic function at hand and should not incorporate other Basic Snippets or Advanced Functions. That is what the Advanced Functions section is for.

## PowerShell

This is the powershell method for displaying an execution status notification.

```powershell
#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

  param (
    [string[]]$TSVariables            # '%vr_TS_Status_ActionName%','%vr_TS_Status_ReturnCode%','%vr_TS_Status_Success%','%OSDComputerName%','%vr_Device_SerialNumber%','%vr_Directory_TaskSequences%','%vr_Logging_NetworkRepository%'
  )

#--------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------
# Variables
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Variables

  Write-Host "  - Set Variables"

  $Title    = "VividRock - MECM Toolkit - Notification"
  $Message  = @"
The Task Sequence experienced an error during execution.
  - Step Name:   $($TSVariables[0])
  - Return Code: $($TSVariables[1])
  - Success:     $($TSVariables[2])

Troubleshooting Information
  - Computer Name: $($TSVariables[3])
  - Serial `#: $($TSVariables[4])
  - Local Log Repo: $($TSVariables[5])
  - Network Log Repo: $($TSVariables[6])

Next Steps
  - Analyze output logs and data to determine if the issue is easily identifed and resolved
  - Retry the imaging process on the device
  - If failure persists, notify the MECM team

"@
  $Timeout  = 0
  $Settings = 0 + 64 + 4096

  Write-Host "      Status: Success"

#EndRegion Variables
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Environment
#   Error Range: 1400 - 1499
#--------------------------------------------------------------------------------------------
#Region Environment

  # Close Progress Dialog UI
    Write-Host "  - Close TS ProgressUI"
    try {
      (New-Object -ComObject Microsoft.SMS.TsProgressUI).CloseProgressDialog()
      Write-Host "      Status: Success"
    }
    catch {
      Write-Host "      Status: Error - Unable to close the TS ProgressUI"
    }

#EndRegion Environment
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1700 - 1799
#--------------------------------------------------------------------------------------------
#Region Execution

  # Display Notification
    Write-Host "  - Display Notification"
    try {
      $Return = (New-Object -ComObject Wscript.Shell).Popup($Message,$Timeout,$Title,$Settings)
      Write-Host "      Status: Success"
    }
    catch {
      Write-Host "      Status: Unable to display notification"
      Exit 1701
    }

  # Process Return Input
    Write-Host "  - Process Return Input"
    try {
      switch ($Return) {
        1 { Write-Host "      Input: 1 - OK Button Pressed"; Write-Host "      Exit Code: 0"; Exit 0 }
        Default { Write-Host "      Input: Unknown - Button Not Mapped to switch logic"; Write-Host "      Exit Code: 100"; Exit 100 }
      }
      Write-Host "      Status: Success"
    }
    catch {
      Write-Host "      Status: Unable to process return input"
      Exit 1702
    }

#EndRegion Execution
#--------------------------------------------------------------------------------------------

```

### Output

```powershell
# A dialog window will appear with the content and buttons defined.
```

## Command (cmd.exe)

This is the command line (cmd.exe) method for displaying a message box.

>Note: This requires the use of the ServiceUI executable found within the Microsoft Deployment Toolkit.

```powershell
Bin\ServiceUI_x64.exe -process:TsProgressUI.exe %SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -noexit -command (New-Object -ComObject Microsoft.SMS.TsProgressUI).CloseProgressDialog() ;
Invoke-Command -ScriptBlock { ;
    $Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment ;
    Clear-Host ;
    write-host "----------------------------------------------------------------------------------------------" ;
    write-host "$([char]32)$([char]32)MECM - Task Sequence - Execution Status: Failure" ;
    write-host "----------------------------------------------------------------------------------------------" ;
    write-host "$([char]32)$([char]32)The Task Sequence experienced an error during execution." ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Step Name:   $($Object_MECM_TSEnvironment.Value('vr_TS_Status_ActionName'))" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Return Code: $($Object_MECM_TSEnvironment.Value('vr_TS_Status_ReturnCode'))" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Success:     $($Object_MECM_TSEnvironment.Value('vr_TS_Status_Success'))" ;
    write-host "$([char]32)" ;
    write-host "$([char]32)$([char]32)Troubleshooting Information" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Computer Name: $($Object_MECM_TSEnvironment.Value('OSDComputerName'))" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Serial `#: $($Object_MECM_TSEnvironment.Value('vr_Device_SerialNumber'))" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Local Log Repo: $($Object_MECM_TSEnvironment.Value('vr_Directory_TaskSequences'))" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Network Log Repo: $($Object_MECM_TSEnvironment.Value('vr_Logging_NetworkRepository'))" ;
    write-host "$([char]32)" ;
    write-host "$([char]32)$([char]32)Next Steps" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Analyze output logs and data to determine if the issue is easily identifed and resolved" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Retry the imaging process on the device" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- If failure persists, notify the MECM team" ;
    write-host "$([char]32)" ;
    write-host "----------------------------------------------------------------------------------------------" ;
    write-host "$([char]32)" ;
    $msg = 'Are you ready to quit the Task Sequence? [Y/N]' ;
    do { $response = Read-Host -Prompt $msg ; if ($response -eq 'n') {} ; }
    until ($response -eq 'y') ; write-host "Exiting Task Sequence..." ;

    $Files_Log_SMSTS = Get-ChildItem -Path "C:\Windows\CCM\Logs\smsts*" ;
    Start-Process -FilePath "C:\Windows\CCM\CMTrace.exe" -ArgumentList $Files_Log_SMSTS.FullName ;
    Pause

    Exit 0 }
```

### Output

```powershell
# A command line window will appear with the message content inside of it.
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
