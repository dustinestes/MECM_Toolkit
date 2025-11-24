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
  - [Appendix A: Activation IDs](#appendix-a-activation-ids)

<br>

## Details

### Supported Environment

#### Operating Systems

| Operating System  | Supported | Notes                     |
|-------------------|-----------|---------------------------|
| Windows 7         | True      |                           |
| Windows 8/8.1     | ?         |                           |
| Windows 10        | True      |                           |
| Windows 11        | True      |                           |

#### PowerShell

| Versions      | Supported | Notes                         |
|---------------|-----------|-------------------------------|
| 1.0           | ?         |                               |
| 2.0           | ?         |                               |
| 3.0           | ?         |                               |
| 4.0           | ?         |                               |
| 5.0           | ?         |                               |
| 5.1           | True      |                               |
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
#--------------------------------------------------------------------------------------------
# Notes
#--------------------------------------------------------------------------------------------
#Region Notes

# RunAs: System

#EndRegion Notes
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input

  # MECM Settings
  $Name_ConfigurationItem = "CI - Windows - License Activation (Windows X)"
  $Operation_Type         = "Discovery" # "Discovery","Remediation"
  $Path_Log_Directory     = "$($env:VR_Directory_Logs)\ConfigurationBaselines\$($Operation_Type)"

# Windows Licensing
  $License_Key            = ""
  $License_ActivationID   = ""

#EndRegion Input
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Builtin (Do Not Edit)
#--------------------------------------------------------------------------------------------
#Region Builtin

# Metadata
  $Meta_Script_Execution_Context  = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $Meta_Script_Start_DateTime     = Get-Date
  $Meta_Script_Complete_DateTime  = $null
  $Meta_Script_Complete_TimeSpan  = $null
  $Meta_Result                    = $null
  $Meta_Result_Successes          = 0
  $Meta_Result_Failures           = 0

# Preferences
  $ErrorActionPreference          = "Stop"

# Logging
  if ($Meta_Script_Execution_Context.Name -eq "NT AUTHORITY\SYSTEM") {
    $Path_Log_File      = $Path_Log_Directory + "\" + $Name_ConfigurationItem + ".log"
  }
  else {
    $Path_Log_File      = $Path_Log_Directory + "\" + $Name_ConfigurationItem + "_" + $(($Meta_Script_Execution_Context.Name -split "\\")[1]) + ".log"
  }

#EndRegion Builtin
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

Out-File -InputObject "-----------------------------------------------------------------------------------" -FilePath $Path_Log_File
Out-File -InputObject "  $($Name_ConfigurationItem)" -FilePath $Path_Log_File -Append
Out-File -InputObject "-----------------------------------------------------------------------------------" -FilePath $Path_Log_File -Append
Out-File -InputObject "  Author:      Dustin Estes" -FilePath $Path_Log_File -Append
Out-File -InputObject "  Company:     VividRock" -FilePath $Path_Log_File -Append
Out-File -InputObject "  Date:        November 17, 2025" -FilePath $Path_Log_File -Append
Out-File -InputObject "  Copyright:   VividRock LLC - All Rights Reserved" -FilePath $Path_Log_File -Append
Out-File -InputObject "  Purpose:     Perform operations of a Configuration Item and return boolean results." -FilePath $Path_Log_File -Append
Out-File -InputObject "-----------------------------------------------------------------------------------" -FilePath $Path_Log_File -Append
Out-File -InputObject "  Script Name: $($MyInvocation.MyCommand.Name)" -FilePath $Path_Log_File -Append
Out-File -InputObject "  Script Path: $($PSScriptRoot)" -FilePath $Path_Log_File -Append
Out-File -InputObject "  Execution Context: $($Meta_Script_Execution_Context.Name)" -FilePath $Path_Log_File -Append
Out-File -InputObject "-----------------------------------------------------------------------------------" -FilePath $Path_Log_File -Append

#EndRegion Header
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Functions
#   Error Range: 1100 - 1199
#--------------------------------------------------------------------------------------------
#Region Functions

# Get-WindowsLicensing
function Get-WindowsLicensing {
  <#
  .SYNOPSIS
    Gets licensing information from the slmgr.vbs script and returns an object.
  .DESCRIPTION
    Gets licensing information from the slmgr.vbs script and returns an object.
  .PARAMETER Name
    Specifies the object(s) name(s), expressed as a regular expression, to filter the results to the desired dataset. Provide an array of names to filter by multiple criteria.
  .PARAMETER ActivationID
    Specifies the object(s) activation id, expressed as a string, to filter the results to the desired dataset.
  .EXAMPLE
    Get-WindowsLicensing
    This example illustrates the basic usage of the function that will return all objects.
  .EXAMPLE
    Get-WindowsLicensing -Name "ESU-Year1","ESU-Year3"
    This example illustrates usage of the Name parameter to filter on an array of strings to filter the return objects to the desired dataset.
  .NOTES
    Copyright: VividRock LLC
    Author: Dustin Estes
    Date: 2025-10-03
    Version: 1.0
  #>
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $false,
    ValueFromPipeline = $true,
    HelpMessage = "Specify the object(s) name(s) to filter the results.",
    ParameterSetName = "Name")]
    [string[]]$Name,
    [Parameter(Mandatory = $false,
    ValueFromPipeline = $true,
    HelpMessage = "Specify the object(s) activation id(s) to filter the results.",
    ParameterSetName = "ActivationID")]
    [string]$ActivationID
  )

  begin {
    Write-Verbose "New-AdvancedFunction: Begin"
    # Add any one-time setup code here
  }

  process {
    Write-Verbose "New-AdvancedFunction: Process"

    # Process Parameters
    $Pattern_Name = @()
    foreach ($Item in $Name) {
      $Pattern_Name += [regex]::Escape($Item)
    }
    $Pattern_Name = $Pattern_Name -join "|"
    Write-Verbose "  Name RegEx Pattern: $($Pattern_Name)"

    # Get Data
    $Dataset_Source = cscript.exe "C:\Windows\System32\slmgr.vbs" /dlv

    # Clean Data
    $Pattern_Headers = (@("Microsoft (R) Windows Script Host Version","Copyright (C) Microsoft Corporation. All rights reserved.","Software licensing service version: ") | ForEach-Object { [regex]::Escape($_) }) -join "|"
    $Dataset_Cleaned = $Dataset_Source | Where-Object { $_ -notmatch $Pattern_Headers }

    # Group Data
    $Groups = @()
    $Temp_Group = @()

    foreach ($Line in $Dataset_Cleaned) {
      if ([string]::IsNullOrWhiteSpace($Line)) {
        # Empty line encountered, add the current group to $Groups if it's not empty
        if ($Temp_Group.Count -gt 0) {
          $Groups += ,$Temp_Group # The comma creates an array of arrays
        }
        $Temp_Group = @()
      } else {
        $Temp_Group += $Line
      }
    }

    # Add the group if it's not empty after the loop finishes
    if ($Temp_Group.Count -gt 0) {
      $Groups += ,$Temp_Group
    }

    # Parse Data to Objects
    $Dataset_Parsed = @()

    # Iterate through each block of strings
    foreach ($Block in $Groups) {
      # Skip empty blocks
      if (-not $Block.Trim()) { continue }

      # Create a hashtable to store key-value pairs
      $properties = @{}

      # Split the block into lines
      $Lines = $Block -split "`r?`n"

      # Iterate through each line and extract key-value pairs
      foreach ($Line in $Lines) {
        if ($Line -match "^(.*?):\s*(.*)$") {
          $Key = $matches[1].Trim()
          $Value = $matches[2].Trim()
          $Properties[$Key] = $Value
        }
      }

      # Create a custom object from the hashtable
      $Temp_Object = New-Object PSObject -Property $Properties

      # Add the object to the array
      $Dataset_Parsed += $Temp_Object
    }
  }
        
  end {
    Write-Verbose "New-AdvancedFunction: End"

    if ($Name) {
      $Dataset_Parsed = $Dataset_Parsed | Where-Object -Property Name -match $Pattern_Name
    }
    elseif ($ActivationID) {
      $Dataset_Parsed = $Dataset_Parsed | Where-Object -Property "Activation ID" -match $ActivationID
    }
      
    Return $Dataset_Parsed

    Write-Verbose "New-AdvancedFunction: Complete"
  }
}

#EndRegion Functions
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Execution

# Windows Licensing
Out-File -InputObject "Windows Licensing" -FilePath $Path_Log_File -Append
Out-File -InputObject "  - License Key: $($License_Key)" -FilePath $Path_Log_File -Append
Out-File -InputObject "  - License Activation ID: $($License_ActivationID)" -FilePath $Path_Log_File -Append
# Process Operation Types
if ($Operation_Type -eq "Discovery") {
  try {
    # Validate License Key
    $License_Status = (Get-WindowsLicensing -ActivationID $License_ActivationID)."License Status"
    if ($License_Status -eq "Licensed") {
      $Meta_Result_Successes ++
      Out-File -InputObject "  - Result: Success, License Activated" -FilePath $Path_Log_File -Append
    }
    else {
      $Meta_Result_Failures ++
      Out-File -InputObject "  - Result: Failure, License Status = $($License_Status)" -FilePath $Path_Log_File -Append
    }
  }
  catch {
    $Meta_Result_Failures ++
    Out-File -InputObject "      Status: Failure, $($PSItem.Exception.Message)" -FilePath $Path_Log_File -Append
    Out-File -InputObject " " -FilePath $Path_Log_File -Append
  }
}
elseif ($Operation_Type -eq "Remediation") {
  try {
    # Install License Key
    $Path_SLMgr = $env:windir + "\system32\slmgr.vbs"
    $Result_LicenseInstall    = cscript.exe $Path_SLMgr /ipk $License_Key
    if ($Result_LicenseInstall -match "Installed product key $($License_Key) successfully") {
      Out-File -InputObject "  - Install License Key: Success" -FilePath $Path_Log_File -Append
    }
    else {
      Throw "  - Install License Key: Error, $($Result_LicenseInstall)"
    }

    # Activate License Key
    $Result_LicenseActivation = cscript.exe $Path_SLMgr /ato $License_ActivationID
    if ($Result_LicenseActivation -match "Product activated successfully") {
      Out-File -InputObject "  - Activate License Key: Success" -FilePath $Path_Log_File -Append
    }
    else {
      Throw "  - Activate License Key: Error, $($Result_LicenseActivation)"
    }

    # Validate License Key
    $License_Status = (Get-WindowsLicensing -ActivationID $License_ActivationID)."License Status"
    if ($License_Status -eq "Licensed") {
      $Meta_Result_Successes ++
      Out-File -InputObject "  - Result: Success, License Activated" -FilePath $Path_Log_File -Append
    }
    else {
      $Meta_Result_Failures ++
      Out-File -InputObject "  - Result: Failure, License Status = $($License_Status)" -FilePath $Path_Log_File -Append
    }
  }
  catch {
    $Meta_Result_Failures ++
    Out-File -InputObject "      Status: Failure, $($PSItem.Exception.Message)" -FilePath $Path_Log_File -Append
    Out-File -InputObject " " -FilePath $Path_Log_File -Append
  }
}

#EndRegion Execution
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Evaluate
#   Error Range: 1300 - 1399
#--------------------------------------------------------------------------------------------
#Region Evaluate

# Determine Script Result
  if (($Meta_Result_Successes -gt 0) -and ($Meta_Result_Failures -eq 0)) {
    $Meta_Result = $true,"Success"
  }
  else {
    $Meta_Result = $false,"Failure"
  }

#EndRegion Evaluate
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Footer
#--------------------------------------------------------------------------------------------
#Region Footer

# Gather Data
  $Meta_Script_Complete_DateTime  = Get-Date
  $Meta_Script_Complete_TimeSpan  = New-TimeSpan -Start $Meta_Script_Start_DateTime -End $Meta_Script_Complete_DateTime

# Output
  Out-File -InputObject "" -FilePath $Path_Log_File -Append
  Out-File -InputObject "------------------------------------------------------------------------------" -FilePath $Path_Log_File -Append
  Out-File -InputObject "  Script Result: $($Meta_Result[1])" -FilePath $Path_Log_File -Append
  Out-File -InputObject "  Script Started: $($Meta_Script_Start_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)" -FilePath $Path_Log_File -Append
  Out-File -InputObject "  Script Completed: $($Meta_Script_Complete_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)" -FilePath $Path_Log_File -Append
  Out-File -InputObject "  Total Time: $($Meta_Script_Complete_TimeSpan.Days) days, $($Meta_Script_Complete_TimeSpan.Hours) hours, $($Meta_Script_Complete_TimeSpan.Minutes) minutes, $($Meta_Script_Complete_TimeSpan.Seconds) seconds, $($Meta_Script_Complete_TimeSpan.Milliseconds) milliseconds" -FilePath $Path_Log_File -Append
  Out-File -InputObject "------------------------------------------------------------------------------" -FilePath $Path_Log_File -Append
  Out-File -InputObject "  End of Script" -FilePath $Path_Log_File -Append
  Out-File -InputObject "------------------------------------------------------------------------------" -FilePath $Path_Log_File -Append

#EndRegion Footer
#--------------------------------------------------------------------------------------------

# Return Value to MECM
Return $Meta_Result[0]
```

<br>

## Scheduled Task

Use this section to configure the code to run as a Scheduled Task.

### Usage

### Parameters

### Code

<br>

## Appendix A: Activation IDs

A list of Activation IDs used by the slmgr tool for activating Windows.

| Product                 | Activation ID                         |
|-------------------------|---------------------------------------|
| Windows 10 ESU: Year 1  | f520e45e-7413-4a34-a497-d2765967d094  |
| Windows 10 ESU: Year 2  | 1043add5-23b1-4afb-9a0f-64343c8f3f8d  |
| Windows 10 ESU: Year 3  | 83d49986-add3-41d7-ba33-87c7bfb5c0fb  |
