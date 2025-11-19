# MECM Toolkit - Configuration Items - Windows - License Activation

Microsoft provides a rudimentary method for applying and activating Windows operating system licensing keys. This script provides a more robust method for applying the licensing key(s), activating them, and validating that the activation was successful.

## Table of Contents

- [MECM Toolkit - Configuration Items - Windows - License Activation](#mecm-toolkit---configuration-items---windows---license-activation)
  - [Table of Contents](#table-of-contents)
  - [Details](#details)
    - [Supported Environment](#supported-environment)
      - [Operating Systems](#operating-systems)
      - [PowerShell](#powershell)
  - [Manual Execution](#manual-execution)
    - [Usage](#usage)
    - [Parameters](#parameters)
    - [Code](#code)
  - [Configuration Item](#configuration-item)
    - [Usage](#usage-1)
    - [Parameters](#parameters-1)
    - [Code](#code-1)
  - [Scheduled Task](#scheduled-task)
    - [Usage](#usage-2)
    - [Parameters](#parameters-2)
    - [Code](#code-2)
  - [Appendix A: \[Name\]](#appendix-a-name)

<br>

## Details

### Supported Environment

#### Operating Systems

| Operating System  | Supported | Notes                     |
|-------------------|-----------|---------------------------|
| Windows 7         | ?         |                           |
| Windows 8/8.1     | ?         |                           |
| Windows 10        | ?         |                           |
| Windows 11        | ?         |                           |

#### PowerShell

| Versions      | Supported | Notes                         |
|---------------|-----------|-------------------------------|
| 1.0           | ?         |                               |
| 2.0           | ?         |                               |
| 3.0           | ?         |                               |
| 4.0           | ?         |                               |
| 5.0           | ?         |                               |
| 5.1           | ?         |                               |
| 6.x           | ?         |                               |
| 7.x           | ?         |                               |


<br>

<br>

## Manual Execution

Use this section to perform manual, one-off executions of the code for both local and remote devices to achieve ad-hoc results.

### Usage

### Parameters

### Code

```powershell
# Local
$Path = $env:windir + "\system32\slmgr.vbs"

# Windows 10 ESU: Year 1
  # Install the ESU Key
    cscript.exe $Path /ipk [Key]

  # Active the ESU Key
    cscript.exe $Path /ato f520e45e-7413-4a34-a497-d2765967d094

# Windows 10 ESU: Year 2
  # Install the ESU Key
    cscript.exe $Path /ipk [Key]

  # Active the ESU Key
    cscript.exe $Path /ato 1043add5-23b1-4afb-9a0f-64343c8f3f8d

# Windows 10 ESU: Year 3
  # Install the ESU Key
    cscript.exe $Path /ipk [Key]

  # Active the ESU Key
    cscript.exe $Path /ato 83d49986-add3-41d7-ba33-87c7bfb5c0fb

# Remote
# TODO
```

<br>

## Configuration Item

Use this section when you need to utilize MECM (or another mechanism) to configure multiple devices in an environment to perform Discovery and Remediation on a schedule to persist the configuration.

### Usage

The script is written using a multipurpose template so you only have to change the Operation Type parameter to suit both the Discovery and Remediation scenarios.

1. Copy script to discovery/remediation section of Configuration Item
2. Change the parameter value of $Operation_Type to match the operation being performed
3. Do this for both types of operations
4. Save and test

### Parameters

There are other parameters in the script, but only the ones listed below should be modified to address your use-case.

| Name | Type | Description | Example Value |
|-|-|-|-|
| Operation_Type | String | Tells the script whether its performing discovery operations or remediation operations. | Discovery/Remediation |
| MECMClient_Cache_OlderThanDays | Integer | Used to pass a positive integer representing how old (in number of days) that content is based on when it was downloaded. | 25 |

### Code


```powershell

```

<br>

## Scheduled Task

Use this section to configure the code to run as a Scheduled Task.

### Usage

### Parameters

### Code

<br>

## Appendix A: [Name]

[Description]