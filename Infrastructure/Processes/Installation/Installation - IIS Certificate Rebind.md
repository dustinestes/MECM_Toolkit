# MECM Toolkit - Infrastructure - Installation - IIS Certificate Rebind

&nbsp;

## References

The following items are referenced in the code within this document. Familiarize yourself with them before moving on.

| Name                                | Type       | Description                                                             | Link |
|-------------------------------------|------------|-------------------------------------------------------------------------|------|
| Certificate Rebind in IIS 8.5       | Link       | Automatically rebind a renewed certificate by using Certificate Rebind. | [Microsoft Learn](https://learn.microsoft.com/en-us/iis/get-started/whats-new-in-iis-85/certificate-rebind-in-iis85)

&nbsp;

## Table of Contents

- [MECM Toolkit - Infrastructure - Installation - IIS Certificate Rebind](#mecm-toolkit---infrastructure---installation---iis-certificate-rebind)
  - [References](#references)
  - [Table of Contents](#table-of-contents)
- [Basic Snippets](#basic-snippets)
  - [Enable Certificate Rebind in IIS](#enable-certificate-rebind-in-iis)
    - [Example](#example)
    - [Snippets](#snippets)
  - [\[SnippetTitle\]](#snippettitle)
    - [Example](#example-1)
    - [Snippets](#snippets-1)
- [Advanced Functions](#advanced-functions)
  - [\[Title\]](#title)
- [Appendices](#appendices)
  - [Apdx A: Scheduled Task XML](#apdx-a-scheduled-task-xml)

&nbsp;

# Basic Snippets

These are quick, simple snippets of code to reference for a basic understanding and inclusion within larger scripts or codebases. When a more fully developed function or operation is created using these, that block of code can be added to the Advanced Function section below.

> Note: These snippets tend to focus simply on the basic function at hand and should not incorporate other Basic Snippets or Advanced Functions. That is what the Advanced Functions section is for.

## Enable Certificate Rebind in IIS

To enable the certificate rebind feature in IIS 8.5 and above, you need to create the scheduled job that would otherwise be created by clicking the link in the IIS Manager console. The extracted XML content in the below snippet was pulled from a default creation of the Scheduled Task by IIS Manager on a Windows Server 2019 VM.

See Also: the Configuration Item and Configuration Baseline items in this toolkit for leveraging MECM for configuration management and remediation.

### Example

You need to enable the Certificate Rebind feature in IIS so that all renewed certificates will automatically be binded to the websites in IIS.

### Snippets

```powershell
[string]$XML_Task_CertificateRebind = @'
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <URI>\Microsoft\Windows\CertificateServicesClient\IIS-AutoCertRebind</URI>
  </RegistrationInfo>
  <Triggers>
    <EventTrigger>
      <Enabled>true</Enabled>
      <Subscription>&lt;QueryList&gt;&lt;Query Id='0'&gt;&lt;Select Path='Microsoft-Windows-CertificateServicesClient-Lifecycle-System/Operational'&gt;*[System[EventID=1001]]&lt;/Select&gt;&lt;/Query&gt;&lt;/QueryList&gt;</Subscription>
      <ValueQueries>
        <Value name="NewCertHash">Event/UserData/CertNotificationData/NewCertificateDetails/@Thumbprint</Value>
        <Value name="OldCertHash">Event/UserData/CertNotificationData/OldCertificateDetails/@Thumbprint</Value>
      </ValueQueries>
    </EventTrigger>
  </Triggers>
  <Principals>
    <Principal id="System">
      <UserId>S-1-5-18</UserId>
      <RunLevel>HighestAvailable</RunLevel>
      <LogonType>InteractiveToken</LogonType>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>Queue</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>false</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT1H</ExecutionTimeLimit>
    <Priority>7</Priority>
    <RestartOnFailure>
      <Interval>PT10M</Interval>
      <Count>3</Count>
    </RestartOnFailure>
  </Settings>
  <Actions Context="System">
    <Exec>
      <Command>%SystemRoot%\System32\inetsrv\appcmd.exe</Command>
      <Arguments>renew binding /oldcert:$(OldCertHash) /newcert:$(NewCertHash)</Arguments>
    </Exec>
  </Actions>
</Task>
'@

Register-ScheduledTask -TaskName "IIS-AutoCertRebind" -TaskPath "\Microsoft\Windows\CertificateServicesClient" -Xml $XML_Task_CertificateRebind
```

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

## Apdx A: Scheduled Task XML

Below is an extract of the XML content from the local file on Windows Server 2019.

```xml
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <URI>\Microsoft\Windows\CertificateServicesClient\IIS-AutoCertRebind</URI>
  </RegistrationInfo>
  <Triggers>
    <EventTrigger>
      <Enabled>true</Enabled>
      <Subscription>&lt;QueryList&gt;&lt;Query Id='0'&gt;&lt;Select Path='Microsoft-Windows-CertificateServicesClient-Lifecycle-System/Operational'&gt;*[System[EventID=1001]]&lt;/Select&gt;&lt;/Query&gt;&lt;/QueryList&gt;</Subscription>
      <ValueQueries>
        <Value name="NewCertHash">Event/UserData/CertNotificationData/NewCertificateDetails/@Thumbprint</Value>
        <Value name="OldCertHash">Event/UserData/CertNotificationData/OldCertificateDetails/@Thumbprint</Value>
      </ValueQueries>
    </EventTrigger>
  </Triggers>
  <Principals>
    <Principal id="System">
      <UserId>S-1-5-18</UserId>
      <RunLevel>HighestAvailable</RunLevel>
      <LogonType>InteractiveToken</LogonType>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>Queue</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>false</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT1H</ExecutionTimeLimit>
    <Priority>7</Priority>
    <RestartOnFailure>
      <Interval>PT10M</Interval>
      <Count>3</Count>
    </RestartOnFailure>
  </Settings>
  <Actions Context="System">
    <Exec>
      <Command>%SystemRoot%\System32\inetsrv\appcmd.exe</Command>
      <Arguments>renew binding /oldcert:$(OldCertHash) /newcert:$(NewCertHash)</Arguments>
    </Exec>
  </Actions>
</Task>
```