# MECM Toolkit - SMS Provider - WMI Classes and Properties

This document provides a detailed look at the WMI classes, properties, and methods associated with the SMS Provider.

This data is helpful when building collections, quieries, and other WQL-based code for MECM

## About

[Text]

&nbsp;

## Prerequisites

The following prerequisites are needed before running any of the code snippets within this document.

1. You must run all PowerShell scripts as an administrator from a site system that has the SMS Provider installed on it.

&nbsp;

## Table of Contents

- [MECM - SMS Provider - WMI Classes and Properties](#mecm---sms-provider---wmi-classes-and-properties)
  - [About](#about)
  - [Prerequisites](#prerequisites)
  - [Table of Contents](#table-of-contents)
  - [Code](#code)
  - [Output](#output)

&nbsp;

## Code

This code snippet is what is used to gather and output the data from an MECM SMS Provider.

```powershell
# Variables
    $MECM_SiteCode  = "VR1"

    $Temp_Object = $null
    $Temp_HashTable = @{}
    $Temp_HashTable_Methods = @{}
    $Temp_HashTable_Properties = @{}

# Get Data
    $MECM_WMIObject = Get-WmiObject -Namespace "root\sms\site_$($MECM_SiteCode)" -List | Where-Object -FilterScript { $_.Name -notlike "__*" } | Select-Object -Property Name, Methods, Properties | Sort-Object -Property Name -Descending

# Iterate Through Objects
    foreach ($Item in $MECM_WMIObject) {
        # Create Object
            $Temp_Object = [PSCustomObject]@{
                "Methods" = $Item.Methods
                "Properties" = $Item.Properties
            }

        # Add Object to Hashtable
            $Temp_HashTable.$($Item.Name) = $Temp_Object
    }

# Output Data
    $Temp_HashTable | ConvertTo-Json -Depth 4 | Out-File -FilePath "$($env:USERPROFILE)\Downloads\MECM - WMI Object Data.json"
```

## Output

MECM Version:
Generated: 2023-09-05

```json

```
