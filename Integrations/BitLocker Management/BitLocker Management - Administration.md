# MECM Toolkit - Integrations - BitLocker Management - Administration

&nbsp;

## References

The following items are referenced in the code within this document. Familiarize yourself with them before moving on.

| Name                  | Type                        | Description                                                                                                       | Link |
|-----------------------|-----------------------------|-------------------------------------------------------------------------------------------------------------------|------|
| None | | | |

&nbsp;

## Table of Contents

- [MECM Toolkit - Integrations - BitLocker Management - Administration](#mecm-toolkit---integrations---bitlocker-management---administration)
  - [References](#references)
  - [Table of Contents](#table-of-contents)
- [Basic Snippets](#basic-snippets)
  - [Get Recovery Keys Stored in a SQL Database](#get-recovery-keys-stored-in-a-sql-database)
    - [Snippets](#snippets)
    - [Output](#output)
  - [Get Devices with Disclosed Keys](#get-devices-with-disclosed-keys)
    - [Snippets](#snippets-1)
    - [Output](#output-1)
- [Advanced Functions](#advanced-functions)
  - [\[Title\]](#title)
- [Appendices](#appendices)
  - [Apdx A: \[Name\]](#apdx-a-name)

&nbsp;

# Basic Snippets

These are quick, simple snippets of code to reference for a basic understanding and inclusion within larger scripts or codebases. When a more fully developed function or operation is created using these, that block of code can be added to the Advanced Function section below.

> Note: These snippets tend to focus simply on the basic function at hand and should not incorporate other Basic Snippets or Advanced Functions. That is what the Advanced Functions section is for.

## Get Recovery Keys Stored in a SQL Database

This query will output a table with recovery keys that were found within the database.

### Snippets

```SQL
/* Get Specific Device Keys */
  select
    Machines.Name,
    Volumes.VolumeId,
    Keys.RecoveryKeyId,
    Keys.LastUpdateTime,
    RecoveryAndHardwareCore.DecryptString(Keys.RecoveryKey, DEFAULT) AS RecoveryKey
  from dbo.RecoveryAndHardwareCore_Machines Machines
  inner join dbo.RecoveryAndHardwareCore_Machines_Volumes Volumes
    ON Machines.Id = Volumes.MachineId
  inner join dbo.RecoveryAndHardwareCore_Keys Keys
    ON Volumes.VolumeId = Keys.VolumeId

  where Machines.Name = '[DeviceName]'

/* Get All Device Keys */
  select
    Machines.Name,
    Volumes.VolumeId,
    Keys.RecoveryKeyId,
    Keys.LastUpdateTime,
    RecoveryAndHardwareCore.DecryptString(Keys.RecoveryKey, DEFAULT) AS RecoveryKey
  from dbo.RecoveryAndHardwareCore_Machines Machines
  inner join dbo.RecoveryAndHardwareCore_Machines_Volumes Volumes
    ON Machines.Id = Volumes.MachineId
  inner join dbo.RecoveryAndHardwareCore_Keys Keys
    ON Volumes.VolumeId = Keys.VolumeId
```

### Output

```
Name          VolumeId    RecoveryKeyId  LastUpdateTime           RecoveryKey
------------- ----------- -------------- ------------------------ ------------
VR-SERVER-01  [redacted]  [redacted]     2024-08-13 04:05:15.000  [redacted]
VR-SERVER-02  [redacted]  [redacted]     2024-08-13 04:05:15.000  [redacted]
VR-SERVER-03  [redacted]  [redacted]     2024-08-13 04:05:15.000  [redacted]
VR-SERVER-04  [redacted]  [redacted]     2024-08-13 04:05:15.000  [redacted]
```

&nbsp;

## Get Devices with Disclosed Keys

This query will output all the devices currently marked as having disclosed keys and are awaiting key refresh.

> Note: It has been observed that a device with multiple volumes will have two identical timestamp records in the database with different RecoveryKeyIDs. Fixed Drives will not show as having a disclosed key even when the OS drive does. This can cause issues filtering on "latest record with disclosed key" logic because ordering by date on this column when there are two identical timestamps will give you varied results: sometimes giving one drive row number one or another.

### Snippets

```SQL
/* Get Specific Device Keys */

```

### Output

```
Id          Name          VolumeId    RecoveryKeyId  LastUpdateTime           RecoveryKey
----------- ------------- ----------- -------------- ------------------------ ------------
[redacted]  VR-SERVER-01  [redacted]  [redacted]     2024-08-13 04:05:15.000  [redacted]
[redacted]  VR-SERVER-02  [redacted]  [redacted]     2024-08-13 04:05:15.000  [redacted]
[redacted]  VR-SERVER-03  [redacted]  [redacted]     2024-08-13 04:05:15.000  [redacted]
[redacted]  VR-SERVER-04  [redacted]  [redacted]     2024-08-13 04:05:15.000  [redacted]
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