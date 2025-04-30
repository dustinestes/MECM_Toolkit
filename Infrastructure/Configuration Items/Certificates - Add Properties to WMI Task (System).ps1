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
    $Name_ConfigurationItem = "CI - Certificates - Add Properties to WMI Task"
    $Operation_Type         = "Discovery" # "Discovery","Remediation"
    $Path_Log_Directory     = "$($env:vr_Directory_Logs)\ConfigurationBaselines\$($Operation_Type)"

  # Localized PowerShell Script
    $LocalizedScript_01 = @{
      Name      = ""
      Path      = ""
    }

  # Scheduled Task
    $ScheduledTask_01 = @{
      Name        = "Certificates - [Name]"
      Path        = "\VividRock\MECM\Certificates\"
      Author      = "VividRock"
      Description = "A task that runs a PowerShell script [Description]."
      Command     = "powershell.exe"
      Arguments   = '-NoProfile -NoLogo -WindowStyle Hidden -ExecutionPolicy Bypass -File "$($env:vr_Directory_Cache_Scripts)\Cache\Scripts\Certificates\Maintenance Task - Certificates - [Name].ps1" -RetentionDays "30" -Criteria "CreationTimeUtc" -OutputDir $env:vr_Directory_Logs_Scripts -OutputName "Maintenance Task - Certificates - [Name]"'
    }

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

# << Copy Module Execution Code Here >>

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
