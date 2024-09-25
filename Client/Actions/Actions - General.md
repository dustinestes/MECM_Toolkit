# MECM Toolkit - Client - Actions - General

&nbsp;

## References

The following items are referenced in the code within this document. Familiarize yourself with them before moving on.

| Name                  | Type                        | Description                                                                                                       | Link |
|-----------------------|-----------------------------|-------------------------------------------------------------------------------------------------------------------|------|
| Message IDs           | Documentation               | Provides a list of Message IDs used to trigger the various actions.                                               | [Microsoft Learn](https://learn.microsoft.com/en-us/mem/configmgr/osd/understand/provisioning-mode) |
| Send Schedule Tool    | Documentation               | Provides details on using the tool for client management.                                                         | [Microsoft Learn](https://learn.microsoft.com/en-us/mem/configmgr/core/support/send-schedule-tool)  |
| SMS_Client            | WMI Class                   | Represents the client and facilitates manipulation and retrieval of client information.                           | [Microsoft Learn](https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/core/clients/client-classes/sms_client-client-wmi-class) |

&nbsp;

## Table of Contents

- [MECM Toolkit - Client - Actions - General](#mecm-toolkit---client---actions---general)
  - [References](#references)
  - [Table of Contents](#table-of-contents)
- [Basic Snippets](#basic-snippets)
  - [Trigger Client Actions](#trigger-client-actions)
    - [Snippets](#snippets)
    - [Send Schedule Tool (SendSchedule.exe)](#send-schedule-tool-sendscheduleexe)
    - [Output](#output)
  - [\[SnippetTitle\]](#snippettitle)
    - [Example](#example)
    - [Snippets](#snippets-1)
    - [Output](#output-1)
- [Advanced Functions](#advanced-functions)
  - [\[Title\]](#title)
- [Appendices](#appendices)
  - [Apdx A: Message IDs](#apdx-a-message-ids)
    - [Message ID to Client Action Mapping](#message-id-to-client-action-mapping)
    - [All Message IDs](#all-message-ids)

&nbsp;

# Basic Snippets

These are quick, simple snippets of code to reference for a basic understanding and inclusion within larger scripts or codebases. When a more fully developed function or operation is created using these, that block of code can be added to the Advanced Function section below.

> Note: These snippets tend to focus simply on the basic function at hand and should not incorporate other Basic Snippets or Advanced Functions. That is what the Advanced Functions section is for.

## Trigger Client Actions

This snippet uses the TriggerSchedule method to run the specified schdules.

### Snippets

PowerShell

```powershell
# Local Device
  # Using WmiMethod
    $Trigger = "{00000000-0000-0000-0000-000000000021}"
    Invoke-WmiMethod -Namespace 'root\ccm' -Class SMS_Client -Name TriggerSchedule $Trigger

  # Using CimMethod
    $Trigger = "{00000000-0000-0000-0000-000000000021}"
    Invoke-CimMethod -Namespace 'root\CCM' -ClassName SMS_Client -MethodName TriggerSchedule -Arguments @{sScheduleID=$Trigger}

# Remote Device

```

Command Prompt

```bat
REM Local Device
  WMIC /namespace:\\root\CCM path SMS_Client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000021}" /NOINTERACTIVE

REM Remote Device
  REM Not Supported
```

### Send Schedule Tool (SendSchedule.exe)

PowerShell

```powershell
# Local Device

# Remote Device

```

Command Prompt

```bat
REM Run On Local Device
  SendSchedule.exe {00000000-0000-0000-0000-000000000001}

REM Run On Remote Device
  SendSchedule.exe {00000000-0000-0000-0000-000000000001} MyPC

REM Trigger a Specific Configuration Baseline Evaluation
  SendSchedule.exe ScopeId_611E8382-C064-4B62-B0DE-EFFB52AE8994/Baseline_36722778-69dd-4423-9632-b61148b2b67e
```

### Output

```powershell
# Add Code Here
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

## Apdx A: Message IDs

### Message ID to Client Action Mapping

This table provides a simple mapping so you know which Message IDs correspond to the Actions you would normally run from within the Configuration Manager Client GUI.

| Display Name                                      | Action Name                                          | Message ID                             |
|---------------------------------------------------|------------------------------------------------------|----------------------------------------|
| Application manager policy action                 | Application Deployment Evaluation Cycle              | {00000000-0000-0000-0000-000000000121} |
| Data Discovery Record                             | Discovery Data Collection Cycle                      | {00000000-0000-0000-0000-000000000003} |
| File Collection                                   | File Collection Cycle                                | {00000000-0000-0000-0000-000000000010} |
| Hardware Inventory                                | Hardware Inventory Cycle                             | {00000000-0000-0000-0000-000000000001} |
| Machine Policy Assignments Request                | Machine Policy Retrieval & Evaluation Cycle (Part 1) | {00000000-0000-0000-0000-000000000021} |
| Machine Policy Evaluation                         | Machine Policy Retrieval & Evaluation Cycle (Part 2) | {00000000-0000-0000-0000-000000000022} |
| Software Inventory                                | Software Inventory Cycle                             | {00000000-0000-0000-0000-000000000002} |
| Software Metering Generating Usage Report         | Software Metering Usage Report Cycle                 | {00000000-0000-0000-0000-000000000031} |
| Software Updates Assignments Evaluation Cycle     | Software Updates Deployment Evaluation Cycle         | {00000000-0000-0000-0000-000000000108} |
| Scan by Update Source                             | Software Updates Scan Cycle                          | {00000000-0000-0000-0000-000000000113} |
| Policy Agent Request Assignment (User)            | User Policy Retrieval & Evaluation Cycle (Part 1)    | {00000000-0000-0000-0000-000000000026} |
| Policy Agent Evaluate Assignment (User)           | User Policy Retrieval & Evaluation Cycle (Part 2)    | {00000000-0000-0000-0000-000000000027} |
| Source Update Message                             | Windows Installer Source List Update Cycle           | {00000000-0000-0000-0000-000000000032} |

### All Message IDs

This is a table of all documented Message IDs you can send to the MECM client.
| Message ID                             | Display Name                                                                 |
|----------------------------------------|------------------------------------------------------------------------------|
| {00000000-0000-0000-0000-000000000001} | Hardware Inventory                                                           |
| {00000000-0000-0000-0000-000000000002} | Software Inventory                                                           |
| {00000000-0000-0000-0000-000000000003} | Discovery Inventory                                                          |
| {00000000-0000-0000-0000-000000000010} | File Collection                                                              |
| {00000000-0000-0000-0000-000000000011} | IDMIF Collection                                                             |
| {00000000-0000-0000-0000-000000000021} | Request Machine Assignments                                                  |
| {00000000-0000-0000-0000-000000000022} | Evaluate Machine Policies                                                    |
| {00000000-0000-0000-0000-000000000023} | Refresh Default MP Task                                                      |
| {00000000-0000-0000-0000-000000000024} | LS (Location Service) Refresh Locations Task                                 |
| {00000000-0000-0000-0000-000000000025} | LS Timeout Refresh Task                                                      |
| {00000000-0000-0000-0000-000000000026} | Policy Agent Request Assignment (User)                                       |
| {00000000-0000-0000-0000-000000000027} | Policy Agent Evaluate Assignment (User)                                      |
| {00000000-0000-0000-0000-000000000031} | Software Metering Generating Usage Report                                    |
| {00000000-0000-0000-0000-000000000032} | Source Update Message                                                        |
| {00000000-0000-0000-0000-000000000037} | Clearing proxy settings cache                                                |
| {00000000-0000-0000-0000-000000000040} | Machine Policy Agent Cleanup                                                 |
| {00000000-0000-0000-0000-000000000041} | User Policy Agent Cleanup                                                    |
| {00000000-0000-0000-0000-000000000042} | Policy Agent Validate Machine Policy / Assignment                            |
| {00000000-0000-0000-0000-000000000043} | Policy Agent Validate User Policy / Assignment                               |
| {00000000-0000-0000-0000-000000000051} | Retrying/Refreshing certificates in AD on MP                                 |
| {00000000-0000-0000-0000-000000000061} | Peer DP Status reporting                                                     |
| {00000000-0000-0000-0000-000000000062} | Peer DP Pending package check schedule                                       |
| {00000000-0000-0000-0000-000000000063} | SUM Updates install schedule                                                 |
| {00000000-0000-0000-0000-000000000101} | Hardware Inventory Collection Cycle                                          |
| {00000000-0000-0000-0000-000000000102} | Software Inventory Collection Cycle                                          |
| {00000000-0000-0000-0000-000000000103} | Discovery Data Collection Cycle                                              |
| {00000000-0000-0000-0000-000000000104} | File Collection Cycle                                                        |
| {00000000-0000-0000-0000-000000000105} | IDMIF Collection Cycle                                                       |
| {00000000-0000-0000-0000-000000000106} | Software Metering Usage Report Cycle                                         |
| {00000000-0000-0000-0000-000000000107} | Windows Installer Source List Update Cycle                                   |
| {00000000-0000-0000-0000-000000000108} | Software Updates Policy Action Software Updates Assignments Evaluation Cycle |
| {00000000-0000-0000-0000-000000000109} | PDP Maintenance Policy Branch Distribution Point Maintenance Task            |
| {00000000-0000-0000-0000-000000000110} | DCM policy                                                                   |
| {00000000-0000-0000-0000-000000000111} | Send Unsent State Message                                                    |
| {00000000-0000-0000-0000-000000000112} | State System policy cache cleanout                                           |
| {00000000-0000-0000-0000-000000000113} | Update source policy                                                         |
| {00000000-0000-0000-0000-000000000114} | Update Store Policy                                                          |
| {00000000-0000-0000-0000-000000000115} | State system policy bulk send high                                           |
| {00000000-0000-0000-0000-000000000116} | State system policy bulk send low                                            |
| {00000000-0000-0000-0000-000000000121} | Application manager policy action                                            |
| {00000000-0000-0000-0000-000000000122} | Application manager user policy action                                       |
| {00000000-0000-0000-0000-000000000123} | Application manager global evaluation action                                 |
| {00000000-0000-0000-0000-000000000131} | Power management start summarizer                                            |
| {00000000-0000-0000-0000-000000000221} | Endpoint deployment reevaluate                                               |
| {00000000-0000-0000-0000-000000000222} | Endpoint AM policy reevaluate                                                |
| {00000000-0000-0000-0000-000000000223} | External event detection                                                     |