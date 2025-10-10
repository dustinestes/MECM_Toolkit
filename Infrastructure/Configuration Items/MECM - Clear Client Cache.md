# MECM Toolkit - Configuration Items - MECM - Clear Client Cache

The client's cache can sometimes become full of stale/old content and cause issues when the client attempts to download new content causing issues. Unfortunately, regular users cannot resolve these issues themselves because it requires administrative priveleges to interact with the resource manager API of the MECM client.

Some cuases include:
- Large content downloads
- Stale/orphaned directories from client site migrations
- Newly imaged devices that downloaded lots of content
- Troublesome client
- and more...

## Table of Contents

- [MECM Toolkit - Configuration Items - MECM - Clear Client Cache](#mecm-toolkit---configuration-items---mecm---clear-client-cache)
  - [Table of Contents](#table-of-contents)
  - [Configuration Item](#configuration-item)
    - [Usage](#usage)
    - [Parameters](#parameters)
    - [Script](#script)
  - [Appendix A: \[Name\]](#appendix-a-name)


## Configuration Item

Use this snippet to perform discovery and remediation as part of a Configuration Item and Baseline to continually manage and cleanup the client cache on an interval.

### Usage

The script is written using the multipurpose template so you only have to change the Operation Type parameter to suit both the Discovery and Remediation scenarios.

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

### Script


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
  $Name_ConfigurationItem = "CI - MECM - Clear Client Cache"
  $Operation_Type         = "Discovery" # "Discovery","Remediation"
  $Path_Log_Directory     = "$($env:vr_Directory_Logs)\ConfigurationBaselines\$($Operation_Type)"

# MECM Client - Cache
  [int]$MECMClient_Cache_OlderThanDays    = 30

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
  Out-File -InputObject "  Date:        February 17, 2024" -FilePath $Path_Log_File -Append
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
# Execution
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Execution

# MECM Client - Cache
Out-File -InputObject "MECM Client - Cache" -FilePath $Path_Log_File -Append

  # Environment
  $Object_MECM_ResourceMgr = New-Object -ComObject "UIResource.UIResourceMgr"

  # Get Cache Elements
  $Cache_Elements = $Object_MECM_ResourceMgr.GetCacheInfo().GetCacheElements()

  # Filter Cache Elements
  $Cache_Elements = $Cache_Elements | Where-Object { $_.LastReferenceTime -lt (Get-Date).AddDays(-$MECMClient_Cache_OlderThanDays) }

  # Process Operation Types
  if ($Operation_Type -eq "Discovery") {
    try {
      if ($Cache_Elements.Count -gt 0) {
        $Meta_Result_Failures ++

        foreach ($Item in $Cache_Elements) {
          Out-File -InputObject "  - $($Item.ContentId)" -FilePath $Path_Log_File -Append
          Out-File -InputObject "      Location: $($Item.Location)" -FilePath $Path_Log_File -Append
          Out-File -InputObject "      Version: $($Item.Version)" -FilePath $Path_Log_File -Append
          Out-File -InputObject "      CacheElementId: $($Item.CacheElementId)" -FilePath $Path_Log_File -Append
          Out-File -InputObject "      ReferenceCount: $($Item.ReferenceCount)" -FilePath $Path_Log_File -Append
          Out-File -InputObject "      LastReferenceTime: $($Item.LastReferenceTime)" -FilePath $Path_Log_File -Append
          Out-File -InputObject "      AgeDays: $(((Get-Date) - $Item.LastReferenceTime).Days)" -FilePath $Path_Log_File -Append
          Out-File -InputObject "      Size (MB): $([math]::Round($Item.ContentSize / 1kb, 2))" -FilePath $Path_Log_File -Append
          Out-File -InputObject " " -FilePath $Path_Log_File -Append
        }

        Out-File -InputObject "  - Result: Failure, $($Cache_Elements.Count) Cache Elements Found" -FilePath $Path_Log_File -Append
      }
      elseif ($Cache_Elements.Count -in "",$null,0) {
        $Meta_Result_Successes ++
        Out-File -InputObject "  - Result: Success, No Cache Elements Found" -FilePath $Path_Log_File -Append
      }
      else {
        $Meta_Result_Failures ++
        Out-File -InputObject "  - Result: Failure, Unknown Error" -FilePath $Path_Log_File -Append
      }
    }
    catch {
      $Meta_Result_Failures ++
      Out-File -InputObject "      Status: Failure, $($PSItem.Exception.Message)" -FilePath $Path_Log_File -Append
      Out-File -InputObject " " -FilePath $Path_Log_File -Append
    }

  }
  elseif ($Operation_Type -eq "Remediation") {
    foreach ($Item in $Cache_Elements) {
      try {
        Out-File -InputObject "  - $($Item.ContentId)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      Location: $($Item.Location)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      Version: $($Item.Version)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      CacheElementId: $($Item.CacheElementId)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      ReferenceCount: $($Item.ReferenceCount)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      LastReferenceTime: $($Item.LastReferenceTime)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      AgeDays: $(((Get-Date) - $Item.LastReferenceTime).Days)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      Size (MB): $([math]::Round($Item.ContentSize / 1kb, 2))" -FilePath $Path_Log_File -Append
        $Object_MECM_ResourceMgr.GetCacheInfo().DeleteCacheElement([string]$($Item.CacheElementID))
        Out-File -InputObject "      Status: Success" -FilePath $Path_Log_File -Append
        Out-File -InputObject " " -FilePath $Path_Log_File -Append

        $Meta_Result_Successes ++
      }
      catch {
        $Meta_Result_Failures ++
        Out-File -InputObject "      Status: Failure, $($PSItem.Exception.Message)" -FilePath $Path_Log_File -Append
        Out-File -InputObject " " -FilePath $Path_Log_File -Append
      }
      
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

## Appendix A: [Name]

[Description]