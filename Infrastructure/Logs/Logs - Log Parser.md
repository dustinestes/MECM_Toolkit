# MECM Toolkit - Task Sequences - Logs - Log Parser

This is a log parser for reading the MECM formatted log files and extracting the usable data out into objects within MECM. This uses a modular approach so that you need only one main script to execute the majority of the operations. The Filter Sets are the modular snippets for parsing the specified log files using the supplied patterns.

&nbsp;

## References

The following items are referenced in the code within this document. Familiarize yourself with them before moving on.

| Name                  | Type                        | Description                                                                                                       | Link |
|-----------------------|-----------------------------|-------------------------------------------------------------------------------------------------------------------|------|
| MECM Log Files        | Reference                   | A log used to store all activity from the Task Sequence execution process                                         | [Microsoft Learn](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/log-files#BKMK_OSDLog) |

&nbsp;

## Table of Contents

- [MECM Toolkit - Task Sequences - Logs - Log Parser](#mecm-toolkit---task-sequences---logs---log-parser)
  - [References](#references)
  - [Table of Contents](#table-of-contents)
- [Main Script](#main-script)
  - [How To Use](#how-to-use)
    - [Snippets](#snippets)
    - [Output](#output)
- [Filter Sets](#filter-sets)
  - [Application Management Logs](#application-management-logs)
    - [Application Enforcement Auditing](#application-enforcement-auditing)
    - [Snippets](#snippets-1)
    - [Output](#output-1)
  - [SMSTS Logs](#smsts-logs)
    - [General Task Sequence Operations](#general-task-sequence-operations)
    - [Snippets](#snippets-2)
    - [Output](#output-2)
- [Appendices](#appendices)
  - [Apdx A: \[Name\]](#apdx-a-name)

&nbsp;

# Main Script

This snippet will gather the content from all files specified in the Filter Set and then create an object from the gathered log data.

## How To Use

1. Replace the placeholder text below with the desired Filter Set snippet
2. Run the snippet
3. Output the $Result object to view the object or use other cmdlets to further filter or select less columns

### Snippets

```powershell
# Define Variables
  $Dataset_Raw = $null
  $Dataset_Filtered = @()
  $Result = @()
  $Index = 0

# Get SMSTS Log Files to Parse
  $Files = Get-ChildItem -Path "C:\Windows\CCM\Logs\" -Recurse

# ------------------------------------------------------------------------------------------
# <placeholder>
#   Add Filter Set Here
# <placeholder>
# ------------------------------------------------------------------------------------------

  foreach ($Item in $Dataset_Raw) {
    foreach ($Pattern in $Patterns_Filter) {
      if ($Item -like $Pattern) {
          $Dataset_Filtered += $Item
      }
    }
  }

# Convert Log Lines to Object
  $Patterns_Extract = @(
    '<!\[LOG\[(.*?)\]LOG\]!>'
    'time="(.*?)"'
    'date="(.*?)"'
    'component="(.*?)"'
    'context="(.*?)"'
    'type="(.*?)"'
    'thread="(.*?)"'
    'file="(.*?)"'
  )

  foreach ($Item in $Dataset_Filtered) {
    # Output Progress
      Write-Progress -Activity "Log File Parser" -Status "Processing Item: $($Index + 1)/$($Dataset_Filtered.Count)" -PercentComplete ($Index / $Dataset_Filtered.Count*100)

    # Find Log Lines Broken Across Two Lines and Concatenate
      if ($Item -eq "<![LOG[") {
        $NextLine = $Index + 1
        $Item = $Item + $Dataset_Filtered[$NextLine]
      }

    # Skip the Lines That Were Concatenated Above to Prevent Duplicates With Empty Messages
      if ($Item.StartsWith("<![LOG") -ne $true) {
        # Skip Line Because it is Already Concatenated Above
      }
      else {
        $Object = [PSCustomObject]@{
          Message     = ([regex]::Match($Item, $Patterns_Extract[0])).Groups[1]
          Time        = ([regex]::Match($Item, $Patterns_Extract[1])).Groups[1]
          Date        = ([regex]::Match($Item, $Patterns_Extract[2])).Groups[1]
          Component   = ([regex]::Match($Item, $Patterns_Extract[3])).Groups[1]
          Context     = ([regex]::Match($Item, $Patterns_Extract[4])).Groups[1]
          Type        = ([regex]::Match($Item, $Patterns_Extract[5])).Groups[1]
          Thread      = ([regex]::Match($Item, $Patterns_Extract[6])).Groups[1]
          File        = ([regex]::Match($Item, $Patterns_Extract[7])).Groups[1]
        }

        $Result += $Object
      }

    $Index ++
  }

  Write-Progress -Activity "Log File Parser" -Completed
```

### Output

```powershell
# Custom Object
```

&nbsp;

# Filter Sets

These snippets must be used in the script above to customize the output to meet the criteria. Each filter set should be designed to grab helpful information from the logs based on an operation or type of data to make auditing and troubleshooting easier.

In order to use these, just replace the placeholder text in the script above with one of these snippets.

## Application Management Logs

### Application Enforcement Auditing

This is used to gather the log output associated with the Application Deployment process. This can provide a high-level overview of what actions were performed, skipped, succeeded, and failed.

Entries Include
- Start of operation
- Discovery results
- Exit code
- Successes and Failures

### Snippets

```powershell
  # Get File Content in Correct Order to Preserve Transcription
    # Older Timestamped Files in Ascending Order
      $Dataset_Raw = $Files | Where-Object -Property Name -like "AppEnforce-*" | Sort-Object -Property Name | Get-Content
    # Final Log File Without Timestamp
      $Dataset_Raw += $Files | Where-Object -Property Name -like "AppEnforce.log" | Get-Content

  # Filter Dataset
    $Patterns_Filter = @(
      "*Starting Install enforcement*"
      "*Application * discovered*"
      "*Discovered application*"
      "*Matched exit code*"
      "*App enforcement completed*"
    )
```

### Output

```powershell
  Message
-------
+++ Starting Install enforcement for App DT "Microsoft Corporation - Microsoft SQL Server Management Studio - 19.1 - 19.1.56.0 (Silent x86)" ApplicationDeliveryType - ScopeId_99ED2923-6EDE-4D65-AC0E-21876AE0D204/DeploymentType_49071da0-75da-4921-bae6-61dc677517cc, Revision - 2, ContentPath - C:\WINDOWS\ccmcache\2, Execution Context - S...
+++ Application not discovered with script detection. [AppDT Id: ScopeId_99ED2923-6EDE-4D65-AC0E-21876AE0D204/DeploymentType_49071da0-75da-4921-bae6-61dc677517cc, Revision: 2]
    Process 9476 terminated with exitcode: 0
    Matched exit code 0 to a Success entry in exit codes table.
+++ Discovered application [AppDT Id: ScopeId_99ED2923-6EDE-4D65-AC0E-21876AE0D204/DeploymentType_49071da0-75da-4921-bae6-61dc677517cc, Revision: 2]
++++++ App enforcement completed (170 seconds) for App DT "Microsoft Corporation - Microsoft SQL Server Management Studio - 19.1 - 19.1.56.0 (Silent x86)" [ScopeId_99ED2923-6EDE-4D65-AC0E-21876AE0D204/DeploymentType_49071da0-75da-4921-bae6-61dc677517cc], Revision: 2, User SID: S-1-5-21-2770504749-1329334717-2188162814-333270] ++++++

```

## SMSTS Logs

### General Task Sequence Operations

This is used to gather the log output associated with the general Task Sequence Operations. The output looks similar to what you would see within the Task Sequence View/Editor in the MECM console. This can provide a high-level overview of what actions were performed, skipped, succeeded, and failed.

Entries Include
- Group start/stop entries
- Step start/stop entries
- Successes and Failures

### Snippets

```powershell
# Get File Content in Correct Order to Preserve Transcription
  # Older Timestamped Files in Ascending Order
    $Dataset_Raw = $Files | Where-Object -Property Name -like "smsts-*" | Sort-Object -Property Name | Get-Content
  # Final Log File Without Timestamp
    $Dataset_Raw += $Files | Where-Object -Property Name -like "smsts.log" | Get-Content

# Filter Dataset
  $Patterns_Filter = @(
    "*Start executing an instruction*"
    "*The group (*) has been*"
    "*Let the parent group*"
    "*The group (*) ignored *"
    "*completed the action*"
    "*Failed to run the action*"
  )
```

### Output

```powershell
Message                                                                                                                                                                               Time             Date       Component Context Type Thread File
-------                                                                                                                                                                               ----             ----       --------- ------- ---- ------ ----
Start executing an instruction. Instruction name: 'Install Windows'.  Pointer: 0. Type: ''. Disabled: 0                                                                               14:31:39.566+300 08-15-2024 TSManager         1    1208   engine.cxx:914
The group (Install Windows) has been successfully started                                                                                                                             14:31:39.623+300 08-15-2024 TSManager         1    1208   instruction.cxx:159
Start executing an instruction. Instruction name: 'Initialize'.  Pointer: 1. Type: ''. Disabled: 0                                                                                    14:31:40.925+300 08-15-2024 TSManager         1    1208   engine.cxx:914
The group (Initialize) has been successfully started                                                                                                                                  14:31:40.930+300 08-15-2024 TSManager         1    1208   instruction.cxx:159
Start executing an instruction. Instruction name: 'Format Unformatted Disk'.  Pointer: 2. Type: ''. Disabled: 0                                                                       14:31:42.239+300 08-15-2024 TSManager         1    1208   engine.cxx:914
The group (Format Unformatted Disk) has been successfully started                                                                                                                     14:31:42.249+300 08-15-2024 TSManager         1    1208   instruction.cxx:159
```

&nbsp;

# Appendices

A collection of sections that provide detailed explanation or understanding to the above topic but are not necessary within the main body of the topic.

## Apdx A: [Name]

[Text]