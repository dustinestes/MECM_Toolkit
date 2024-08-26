# MECM Toolkit - Infrastructure - Task Sequences - General

&nbsp;

## References

The following items are referenced in the code within this document. Familiarize yourself with them before moving on.

| Name                  | Type                        | Description                                                                                                       | Link |
|-----------------------|-----------------------------|-------------------------------------------------------------------------------------------------------------------|------|
| None | | | |

&nbsp;

## Table of Contents

- [MECM Toolkit - Infrastructure - Task Sequences - General](#mecm-toolkit---infrastructure---task-sequences---general)
  - [References](#references)
  - [Table of Contents](#table-of-contents)
- [Basic Snippets](#basic-snippets)
  - [Get All Steps in a Task Sequence](#get-all-steps-in-a-task-sequence)
  - [Export Task Sequence (Backup)](#export-task-sequence-backup)
    - [Non-Recursively](#non-recursively)
    - [Recursively](#recursively)
- [Advanced Functions](#advanced-functions)
  - [\[Title\]](#title)
- [Appendices](#appendices)
  - [Apdx A: \[Name\]](#apdx-a-name)

&nbsp;

# Basic Snippets

These are quick, simple snippets of code to reference for a basic understanding and inclusion within larger scripts or codebases. When a more fully developed function or operation is created using these, that block of code can be added to the Advanced Function section below.

> Note: These snippets tend to focus simply on the basic function at hand and should not incorporate other Basic Snippets or Advanced Functions. That is what the Advanced Functions section is for.

## Get All Steps in a Task Sequence

This will generate a custom object with some basic information about each step. It can be expanded upon by adding more information to the object for output.

```powershell
# Set Variables
  $Temp_Object = $null
  $Object_Steps = @()

  $TaskSequence_Name = "DEV - Windows 10 - v1.4.06"
  $TaskSequence_Object = $null
  $TaskSequence_Steps = $null

# Suppress Warning Message
  $CMPSSuppressFastNotUsedCheck = $true

# Get Data
  $TaskSequence_Object = Get-CMTaskSequence -Name $TaskSequence_Name
  $TaskSequence_Steps = $TaskSequence_Object | Get-CMTaskSequenceStep

#$TaskSequence_StepConditions = $TaskSequence_Steps | Get-CMTaskSequenceStepCondition


# Iterate Through Steps
foreach ($Item in $TaskSequence_Steps) {
  # Construct Object
    $Temp_Object = [PSCustomObject]@{
      "Name"            = $Item.Name
      "Description"     = $Item.Description
      "Enabled"         = $Item.Enabled
      "ContinueOnError" = $Item.ContinueOnError
      "Object Class"    = $Item.ObjectClass
    }

    # Add Object to Parent HashTable with the Cleaned Up User Name as the Name
      $Object_Steps += $Temp_Object
}

# Output to File
  $Object_Steps | ConvertTo-Csv -Delimiter "," | Out-File -FilePath "$($PSScriptRoot)\Output_TaskSequence_Steps.csv"
```

&nbsp;

## Export Task Sequence (Backup)

This will export a specified Task Sequence to the desired directory.

### Non-Recursively

```powershell
# Set Variables
  $TaskSequence_Name = "DEV - Windows 10 - v1.4.06"
  $TaskSequence_BackupDir = "[PathToBackupDir]"

# Operation
  $Temp_FileName = $TaskSequence_BackupDir + "\" + $TaskSequence_Name + ".zip"

  Export-CMTaskSequence -ExportFilePath $Temp_FileName -Name $TaskSequence_Name -WithContent $False -WithDependence $False

```

### Recursively

[TODO]

```powershell

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