# MECM Toolkit - Infrastructure - Boot Images - OSDInjection.xml Usage

&nbsp;

## References

The following items are referenced in the code within this document. Familiarize yourself with them before moving on.

| Name                  | Type                        | Description                                                                                                       | Link |
|-----------------------|-----------------------------|-------------------------------------------------------------------------------------------------------------------|------|
| None | - | - | - |

&nbsp;

## Table of Contents

- [MECM Toolkit - Infrastructure - Boot Images - OSDInjection.xml Usage](#mecm-toolkit---infrastructure---boot-images---osdinjectionxml-usage)
  - [References](#references)
  - [Table of Contents](#table-of-contents)
- [Basic Format](#basic-format)
  - [\[SnippetTitle\]](#snippettitle)
    - [Example](#example)
    - [Snippets](#snippets)
    - [Output](#output)
- [Basic Snippets](#basic-snippets)
  - [\[SnippetTitle\]](#snippettitle-1)
    - [Example](#example-1)
    - [Snippets](#snippets-1)
    - [Output](#output-1)
- [Advanced Functions](#advanced-functions)
  - [\[Title\]](#title)
- [Appendices](#appendices)
  - [Apdx A: Default Content](#apdx-a-default-content)
    - [Version 2403](#version-2403)

&nbsp;

# Basic Format

These are quick, simple snippets of code to reference for a basic understanding and inclusion within larger scripts or codebases. When a more fully developed function or operation is created using these, that block of code can be added to the Advanced Function section below.

> Note: These snippets tend to focus simply on the basic function at hand and should not incorporate other Basic Snippets or Advanced Functions. That is what the Advanced Functions section is for.

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

# Basic Snippets

These are quick, simple snippets of code to reference for a basic understanding and inclusion within larger scripts or codebases. When a more fully developed function or operation is created using these, that block of code can be added to the Advanced Function section below.

> Note: These snippets tend to focus simply on the basic function at hand and should not incorporate other Basic Snippets or Advanced Functions. That is what the Advanced Functions section is for.

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

## Apdx A: Default Content

This provides a look at the default content of this file without any edits or customization. You can use this as a reference or as a way to restore your file should you need to undo any customizations.

> Note: I am not sure if this file changes between MECM versions or how often so each version's content will be provided below for reference.

### Version 2403

```xml
<?xml version="1.0" encoding="utf-8"?>
<InjectionFiles>
  <Architecture imgArch="i386">
    <FileList source="WPE">
      <File name="boot.sdi">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>x86\Media\Boot</Source>
        <Destination>sms\boot</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="bootfix.bin">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>x86\Media\Boot</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
    </FileList>
    <FileList source="WDT">
      <File name="bootsect.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>x86\BCDBoot</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="bcdboot.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>x86\BCDBoot</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="etfsboot.com">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>x86\Oscdimg</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="efisys.bin">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>x86\Oscdimg</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="oscdimg.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>x86\Oscdimg</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="wimgapi.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>x86\DISM</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="wimgapi.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>amd64\DISM</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="*">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>x86\DISM</Source>
        <Destination>Windows\Pkgmgr</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
    </FileList>
    <FileList source="SCCM">
      <File name="ccmcore.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="CcmUtilLib.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdApplyOs.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="BCD-EFI-32">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdCaptureCd.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdCaptureSystemImage.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdCore.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdDiskPart.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OSDDownloadContent.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OSDDriverClient.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdGina.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdGina.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdNetSettings.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OSDOfflineBitlocker.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OSDPrestartCheck.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OSDRunPowerShellScript.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OSDSetDynamicVariables.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdSetupWindows.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdSetupHook.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdSetupHook.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdWinSettings.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdSmpClient.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdMigrateUserState.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="smsboot.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="SmsCore.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="smsnetuse.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="smsswd.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="SmsTftp.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="CMTrace.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsBootShell.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsCore.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="CommonUtils.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsEnv.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsManager.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="McsClient.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TSD.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsmBootstrap.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsMessaging.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsProgressUI.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsProgressUI.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsPxe.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsRes.dll">
        <LocaleNeeded>true</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsRes.dll">
        <LocaleNeeded>true</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="tsresnlc.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="tsresnlc.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="smswdstc.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="CcmGenCert.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="msvcp140.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="msvcp140d.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>true</DebugBinary>
      </File>
      <File name="msvcp140_1.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="msvcp140_1d.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>true</DebugBinary>
      </File>
      <File name="msvcp140_2.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
       <File name="msvcp140_2d.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>true</DebugBinary>
      </File>
      <File name="vcruntime140.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="vcruntime140d.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>true</DebugBinary>
      </File>
      <File name="ucrtbased.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>true</DebugBinary>
      </File>
    </FileList>
  </Architecture>
  <Architecture imgArch="x64">
    <FileList source="WPE">
      <File name="boot.sdi">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>amd64\Media\Boot</Source>
        <Destination>sms\boot</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="bootfix.bin">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>amd64\Media\Boot</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
    </FileList>
    <FileList source="WDT">
      <File name="bootsect.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>amd64\BCDBoot</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="bootsect.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>x86\BCDBoot</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="bcdboot.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>amd64\BCDBoot</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="bcdboot.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>x86\BCDBoot</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="etfsboot.com">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>amd64\Oscdimg</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="efisys.bin">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>amd64\Oscdimg</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="oscdimg.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>x86\Oscdimg</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="oscdimg.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>amd64\Oscdimg</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="wimgapi.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>amd64\DISM</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="wimgapi.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>x86\DISM</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="*">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>amd64\DISM</Source>
        <Destination>Windows\Pkgmgr</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
    </FileList>
    <FileList source="SCCM">
      <File name="ccmcore.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="CcmUtilLib.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdApplyOs.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="BCD-EFI-64">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdCaptureCd.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdCaptureSystemImage.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdCore.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdDiskPart.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OSDDownloadContent.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OSDDriverClient.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdGina.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdNetSettings.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OSDOfflineBitlocker.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OSDPrestartCheck.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OSDRunPowerShellScript.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OSDSetDynamicVariables.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdSetupWindows.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdSetupHook.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdWinSettings.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdSmpClient.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdMigrateUserState.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="smsboot.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="SmsCore.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="smsnetuse.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="smsswd.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="SmsTftp.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="CMTrace.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsBootShell.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsCore.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="CommonUtils.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsEnv.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsManager.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="McsClient.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TSD.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsmBootstrap.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsMessaging.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsProgressUI.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsPxe.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsRes.dll">
        <LocaleNeeded>true</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsRes.dll">
        <LocaleNeeded>true</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="tsresnlc.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="smswdstc.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="CcmGenCert.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="msvcp140.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
       <File name="msvcp140d.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>true</DebugBinary>
      </File>
      <File name="msvcp140_1.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="msvcp140_1d.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>true</DebugBinary>
      </File>
      <File name="msvcp140_2.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
       <File name="msvcp140_2d.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>true</DebugBinary>
      </File>
      <File name="vcruntime140.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="vcruntime140d.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>true</DebugBinary>
      </File>
      <File name="vcruntime140_1.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="vcruntime140_1d.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>true</DebugBinary>
      </File>
      <File name="ucrtbased.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>true</DebugBinary>
      </File>
    </FileList>
  </Architecture>
  <Architecture imgArch="arm64">
    <FileList source="WPE">
      <File name="boot.sdi">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>arm64\Media\Boot</Source>
        <Destination>sms\boot</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
    </FileList>
    <FileList source="WDT">
      <File name="bootsect.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>arm64\BCDBoot</Source>
        <Destination>sms\bin\arm64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="bcdboot.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>arm64\BCDBoot</Source>
        <Destination>sms\bin\arm64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="efisys.bin">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>arm64\Oscdimg</Source>
        <Destination>sms\bin\arm64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="oscdimg.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>x86\Oscdimg</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="oscdimg.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>arm64\Oscdimg</Source>
        <Destination>sms\bin\arm64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="wimgapi.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>x86\DISM</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="wimgapi.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>amd64\DISM</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="wimgapi.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>arm64\DISM</Source>
        <Destination>sms\bin\arm64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="*">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>arm64\DISM</Source>
        <Destination>Windows\Pkgmgr</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
    </FileList>
    <FileList source="SCCM">
      <File name="ccmcore.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="CcmUtilLib.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdApplyOs.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="BCD-EFI-64">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdCaptureCd.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdCaptureSystemImage.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdCore.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdDiskPart.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OSDDownloadContent.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OSDDriverClient.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdGina.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdNetSettings.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OSDOfflineBitlocker.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OSDPrestartCheck.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OSDRunPowerShellScript.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OSDSetDynamicVariables.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdSetupWindows.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdSetupHook.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdWinSettings.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdSmpClient.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="OsdMigrateUserState.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="smsboot.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="SmsCore.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="smsnetuse.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="smsswd.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="SmsTftp.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="CMTrace.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsBootShell.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsCore.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="CommonUtils.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsEnv.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsManager.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="McsClient.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TSD.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsmBootstrap.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsMessaging.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsProgressUI.exe">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsPxe.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsRes.dll">
        <LocaleNeeded>true</LocaleNeeded>
        <Source>bin\i386</Source>
        <Destination>sms\bin\i386</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="TsRes.dll">
        <LocaleNeeded>true</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="tsresnlc.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="smswdstc.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="CcmGenCert.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="msvcp140.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
       <File name="msvcp140d.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>true</DebugBinary>
      </File>
      <File name="msvcp140_1.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="msvcp140_1d.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>true</DebugBinary>
      </File>
      <File name="msvcp140_2.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
       <File name="msvcp140_2d.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>true</DebugBinary>
      </File>
      <File name="vcruntime140.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="vcruntime140d.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>true</DebugBinary>
      </File>
      <File name="vcruntime140_1.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>false</DebugBinary>
      </File>
      <File name="vcruntime140_1d.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>true</DebugBinary>
      </File>
      <File name="ucrtbased.dll">
        <LocaleNeeded>false</LocaleNeeded>
        <Source>bin\x64</Source>
        <Destination>sms\bin\x64</Destination>
        <DebugBinary>true</DebugBinary>
      </File>
    </FileList>
  </Architecture>
</InjectionFiles>
```