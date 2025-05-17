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
  - [Reset Client Policy Using (TriggerSchedule Method)](#reset-client-policy-using-triggerschedule-method)
    - [Snippets](#snippets-1)
    - [Output](#output-1)
  - [Reset Client Policy (ResetPolicy Method)](#reset-client-policy-resetpolicy-method)
    - [Snippets](#snippets-2)
    - [Output](#output-2)
- [Advanced Functions](#advanced-functions)
  - [\[Title\]](#title)
- [Appendices](#appendices)
  - [Apdx A: Message IDs](#apdx-a-message-ids)
    - [Message ID to Client Action Mapping](#message-id-to-client-action-mapping)
    - [All Message IDs](#all-message-ids)
  - [Apdx B: SendSchedule Tool](#apdx-b-sendschedule-tool)
    - [Files](#files)
    - [Prerequisites](#prerequisites)
    - [Help Output](#help-output)
    - [SendScheduleMessages.xml Content](#sendschedulemessagesxml-content)

&nbsp;

# Basic Snippets

These are quick, simple snippets of code to reference for a basic understanding and inclusion within larger scripts or codebases. When a more fully developed function or operation is created using these, that block of code can be added to the Advanced Function section below.

> Note: These snippets tend to focus simply on the basic function at hand and should not incorporate other Basic Snippets or Advanced Functions. That is what the Advanced Functions section is for.

## Trigger Client Actions

This snippet uses the TriggerSchedule method to run the specified schedules.

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

The SendSchedule.exe file is located on the Site share located at the following URI format:

- \\[PrimarySiteServerFQDN]\SMS_[SiteCode]\tools\ClientTools

PowerShell

```powershell
# Local Device
  # TODO
# Remote Device
  # TODO
```

Command Prompt

```bat
REM Run On Local Device
  SendSchedule.exe {00000000-0000-0000-0000-000000000001}

REM Run On Remote Device
  SendSchedule.exe {00000000-0000-0000-0000-000000000001} [DeviceFQDN]

REM Trigger a Specific Configuration Baseline Evaluation
  SendSchedule.exe ScopeId_611E8382-C064-4B62-B0DE-EFFB52AE8994/Baseline_36722778-69dd-4423-9632-b61148b2b67e
```

### Output

```powershell
# Add Code Here
```

&nbsp;

## Reset Client Policy Using (TriggerSchedule Method)

These snippets utilize the TriggerSchedule method to reset the devices current policy.

### Snippets

```powershell
# Local Device
  # Using WmiMethod
    $Trigger = "{00000000-0000-0000-0000-000000000021}"
    Invoke-WmiMethod -Namespace 'root\ccm' -Class SMS_Client -Name TriggerSchedule $Trigger

  # Using CimMethod
    $Trigger = "{00000000-0000-0000-0000-000000000021}"
    Invoke-CimMethod -Namespace 'root\CCM' -ClassName SMS_Client -MethodName TriggerSchedule -Arguments @{sScheduleID=$Trigger}

# Remote Device
  # Using WmiMethod
  $Computers = "ComputerName1","ComputerName2"
  $Trigger = "{00000000-0000-0000-0000-000000000021}"

  foreach ($Computer in $Computers) {
    Invoke-WmiMethod -ComputerName $Computer -Namespace 'root\ccm' -Class SMS_Client -Name TriggerSchedule $Trigger
  }
  
  # Using CIMMethod
  # TODO
```

### Output

```powershell
# TODO
```

&nbsp;

## Reset Client Policy (ResetPolicy Method)

These snippets utilize the ResetPolicy method to reset the devices current policy.

### Snippets

```powershell
# Local Device
  # Using WmiMethod
  $Flag = "0"
  $Return = Invoke-WmiMethod -ComputerName $Computer -Namespace root\ccm -Class SMS_Client -Name ResetPolicy -ArgumentList @($Flag)
  if ($Return.ReturnValue -eq 0) {
    Write-Host "Status: Success"
  }
  else {
    Write-Host "Status: Error"
  }

  # Using CIMMethod
  # TODO

# Remote Device
  # Using WmiMethod
  $Computers = "ComputerName1","ComputerName2"
  $Flag = "0"

  foreach ($Computer in $Computers) {
    $Return = Invoke-WmiMethod -ComputerName $Computer -Namespace root\ccm -Class SMS_Client -Name ResetPolicy -ArgumentList @($Flag)
    if ($Return.ReturnValue -eq 0) {
      Write-Host "$($Computer): Success"
    }
    else {
      Write-Host "$($Computer): Error"
    }
  }

  # Using CIMMethod
  # TODO
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


## Apdx B: SendSchedule Tool

### Files

The following files must reside in the same directory in order to execute the tool.

- sendschedule.exe
- sendschedulemessages.xml
- microsoft.diagnostics.tracing.eventsource.dll

### Prerequisites

- Remote WMI Access

### Help Output

This is the command line help output seen when typing in the command's help parameter.

```bat
c:\>sendschedule /?
************************************************************
System Center 2012 Configuration Manager Send Schedule Tool

Usage:
   SendSchedule /L [Machine Name]
   SendSchedule "<Message GUID | DCM UID>" [Machine Name]

Options:
   /L - List all Message GUID or DCM UID available for sending.
        Displays the meaningful name of messages in the data table for each one.
        If machine name is absent, the local machine will be used.

   If the message is specified without machine name then
   the message is sent to the local machine.

Example:
   SendSchedule /L MyPC
   SendSchedule {00000000-0000-0000-0000-000000000001} MyPC
   SendSchedule ScopeId_611E8382-C064-4B62-B0DE-EFFB52AE8994/Baseline_36722778-69dd-4423-9632-b61148b2b67e MyPC
   SendSchedule /L
   SendSchedule {00000000-0000-0000-0000-000000000001}
************************************************************
```

### SendScheduleMessages.xml Content

Along with the EXE file, there is also an XML file that sits in the same ClientTools folder. The content of this file is provided below for reference.

```xml
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<!--Send Schedule Message List-->
<Messages>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000001}">
      <OriginalName>HARDWARE_INV_ACTION_ID</OriginalName>
      <DisplayName>Hardware Inventory</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000002}">
      <OriginalName>SOFTWARE_INV_ACTION_ID</OriginalName>
      <DisplayName>Software Inventory</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000003}">
      <OriginalName>DISCOVERY_INV_ACTION_ID</OriginalName>
      <DisplayName>Discovery Inventory</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000010}">
      <OriginalName>FILE_COLLECTION_ACTION_ID</OriginalName>
      <DisplayName>File Collection</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000011}">
      <OriginalName>IDMIF_COLLECTION_ACTION_ID</OriginalName>
      <DisplayName>IDMIF Collection</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000012}">
      <OriginalName>CLIENT_MACHINE_AUTH_ACTION_ID</OriginalName>
      <DisplayName>Client Machine Authentication</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000021}">
      <OriginalName>POLICYAGENT_REQUEST_MACHINE_ASSIGNMENTS_ID</OriginalName>
      <DisplayName>Request Machine Assignments</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000022}">
      <OriginalName>POLICYAGENT_EVALUATE_MACHINE_POLICIES_ID</OriginalName>
      <DisplayName>Evaluate Machine Policies</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000023}">
      <OriginalName>LS_SCHEDULEDCLEANUP_REFRESH_DEFAULT_MP_TASK_ID</OriginalName>
      <DisplayName>Refresh Default MP Task</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000024}">
      <OriginalName>LS_SCHEDULEDCLEANUP_REFRESH_LOCATIONS_TASK_ID</OriginalName>
      <DisplayName>LS (Location Service) Refresh Locations Task</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000025}">
      <OriginalName>LS_SCHEDULEDCLEANUP_TIMEOUT_REFRESH_TASK_ID</OriginalName>
      <DisplayName>LS (Location Service) Timeout Refresh Task</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000026}">
      <OriginalName>POLICYAGENT_REQUEST_USER_ASSIGNMENTS_ID</OriginalName>
      <DisplayName>Policy Agent Request Assignment (User)</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000027}">
      <OriginalName>POLICYAGENT_EVALUATE_USER_POLICIES_ID</OriginalName>
      <DisplayName>Policy Agent Evaluate Assignment (User)</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000031}">
      <OriginalName>SWMTR_USER_REPORT_GENERATION_ID</OriginalName>
      <DisplayName>Software Metering Generating Usage Report</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000032}">
      <OriginalName>SOURCE_UPDATE_MESSAGE_ID</OriginalName>
      <DisplayName>Source Update Message</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000037}">
      <OriginalName>Schedule for clearing proxy settings cache</OriginalName>
      <DisplayName>Clearing proxy settings cache</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000040}">
      <OriginalName>[Machine Policy schedules] PolicyAgent_Cleanup</OriginalName>
      <DisplayName>Machine Policy Agent Cleanup</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000041}">
      <OriginalName>[User Policy schedules] PolicyAgent_Cleanup</OriginalName>
      <DisplayName>User Policy Agent Cleanup</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000042}">
      <OriginalName>[Machine Policy schedules] PolicyAgent_RequestAssignments</OriginalName>
      <DisplayName>Policy Agent Validate Machine Policy / Assignment</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000043}">
      <OriginalName>[User Policy schedules] PolicyAgent_RequestAssignments</OriginalName>
      <DisplayName>Policy Agent Validate User Policy / Assignment</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000051}">
      <OriginalName>Schedule for retrying/refreshing certificates in AD on MP</OriginalName>
      <DisplayName>Retrying/Refreshing certificates in AD on MP</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000061}">
      <OriginalName>PDP_STATUS_REPORTING_SCHEDULE_ID</OriginalName>
      <DisplayName>Peer DP Status reporting</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000062}">
      <OriginalName>PDP_PENDING_PACKAGE_CHECK_SCHEDULE_ID</OriginalName>
      <DisplayName>Peer DP Pending package check schedule</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000063}">
      <OriginalName>SUM_UPDATES_INSTALL_SCHEDULE_ID</OriginalName>
      <DisplayName>SUM Updates install schedule</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000071}">
      <OriginalName>NAP_ACTION_ID</OriginalName>
      <DisplayName>NAP action</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000101}">
      <OriginalName>HARDWARE_INV_POLICY_ACTION_ID</OriginalName>
      <DisplayName>Hardware Inventory Collection Cycle</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000102}">
      <OriginalName>SOFTWARE_INV_POLICY_ACTION_ID</OriginalName>
      <DisplayName>Software Inventory Collection Cycle</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000103}">
      <OriginalName>DISCOVERY_INV_POLICY_ACTION_ID</OriginalName>
      <DisplayName>Discovery Data Collection Cycle</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000104}">
      <OriginalName>FILE_COLLECTION_POLICY_ACTION_ID</OriginalName>
      <DisplayName>File Collection Cycle</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000105}">
      <OriginalName>IDMIF_COLLECTION_POLICY_ACTION_ID</OriginalName>
      <DisplayName>IDMIF Collection Cycle</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000106}">
      <OriginalName>METRING_POLICY_ACTION_ID</OriginalName>
      <DisplayName>Software Metering Usage Report Cycle</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000107}">
      <OriginalName>SOURCE_UPDATE_POLICY_ACTION_ID</OriginalName>
      <DisplayName>Windows Installer Source List Update Cycle</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000108}">
      <OriginalName>SOFTWARE_UPDATES_POLICY_ACTION_ID</OriginalName>
      <DisplayName>Software Updates Assignments Evaluation Cycle</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000109}">
      <OriginalName>PDP_MAINTENANCE_POLICY_ACTION_ID</OriginalName>
      <DisplayName>Branch Distribution Point Maintenance Task</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000110}">
      <OriginalName>DCM_POLICY_ACTION_ID</OriginalName>
      <DisplayName>DCM policy</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000111}">
      <OriginalName>STATE_SYSTEM_POLICY_BULKSEND_ACTION_ID</OriginalName>
      <DisplayName>Send Unsent State Message</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000112}">
      <OriginalName>STATE_SYSTEM_POLICY_CACHECLEANOUT_ACTION_ID</OriginalName>
      <DisplayName>State System policy cache cleanout</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000113}">
      <OriginalName>UPDATE_SOURCE_POLICY_ACTION_ID</OriginalName>
      <DisplayName>Scan by Update Source</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000114}">
      <OriginalName>UPDATE_STORE_POLICY_ACTION_ID</OriginalName>
      <DisplayName>Update Store Policy</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000115}">
      <OriginalName>STATE_SYSTEM_POLICY_BULKSEND_HIGH_ACTION_ID</OriginalName>
      <DisplayName>State system policy bulk send high</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000116}">
      <OriginalName>STATE_SYSTEM_POLICY_BULKSEND_LOW_ACTION_ID</OriginalName>
      <DisplayName>State system policy bulk send low</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000120}">
      <OriginalName>AMT_STATUS_CHECK_POLICY_ACTION_ID</OriginalName>
      <DisplayName>AMT Status Check Policy</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000121}">
      <OriginalName>APPMAN_POLICY_ACTION_ID</OriginalName>
      <DisplayName>Application manager policy action</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000122}">
      <OriginalName>APPMAN_USER_POLICY_ACTION_ID</OriginalName>
      <DisplayName>Application manager user policy action</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000123}">
      <OriginalName>APPMAN_GLOBAL_EVALUATION_ACTION_ID</OriginalName>
      <DisplayName>Application manager global evaluation action</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000131}">
      <OriginalName>PWRMGMT_START_SUMMARIZER_ID</OriginalName>
      <DisplayName>Power management start summarizer</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000221}">
      <OriginalName>EP_DEPLOYMENT_REEVALUATE_ID</OriginalName>
      <DisplayName>Endpoint deployment reevaluate</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000222}">
      <OriginalName>EP_AMPOLICY_REEVALUATE_ID</OriginalName>
      <DisplayName>Endpoint AM policy reevaluate</DisplayName>
    </GUID>
  </Message>
  <Message>
    <GUID id="{00000000-0000-0000-0000-000000000223}">
      <OriginalName>EXTERNAL_EVENT_DETECTION_ID</OriginalName>
      <DisplayName>External event detection</DisplayName>
    </GUID>
  </Message>
</Messages>
```