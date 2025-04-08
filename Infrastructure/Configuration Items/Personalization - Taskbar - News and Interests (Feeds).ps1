#--------------------------------------------------------------------------------------------
# Notes
#--------------------------------------------------------------------------------------------
#Region Notes

# Supported: Windows 10
# RunAs: System

# Computer Configuration\Administrative Templates\Windows Components\News and interests
#     Setting: Enable news and interests on the taskbar
#     Description: Hides the newspaper icon on the rightside of the taskbar and disables the Settings fields for configuring this item.
#     Requires User Shell Refresh: True
#     Options: Not Configured (Null), Enabled (1), Disabled (0)
#     URL: https://gpsearch.azurewebsites.net:/Default.aspx?PolicyID=15666
#     ADMX: Feeds.admx
# HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds
#     Name: EnableFeeds
#     Type: DWORD
#     Value: 0

#EndRegion Notes
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input

  # MECM Settings
    $Name_ConfigurationItem = "CI - Personalization - Taskbar - News and Interests"
    $Operation_Type         = "Discovery" # "Discovery","Remediation"
    $Path_Log_Directory     = "$($env:vr_Directory_Logs)\ConfigurationBaselines\$($Operation_Type)"

  # Registry
    $Registry_01 = @{
      "Path"          = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds"
      "Name"          = "EnableFeeds"
      "PropertyType"  = "DWORD"
      "Value"         = 0
    }

  # Refresh User Shell
    $Shell_User_Refresh = $true

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

  # Registry
  Out-File -InputObject "Registry" -FilePath $Path_Log_File -Append

  foreach ($Item in (Get-Variable -Name "Registry_*")) {
    try {
      Out-File -InputObject "  - $($Item.Name)" -FilePath $Path_Log_File -Append
      Out-File -InputObject "      Path: $($Item.Value.Path)" -FilePath $Path_Log_File -Append
      Out-File -InputObject "      Name: $($Item.Value.Name)" -FilePath $Path_Log_File -Append
      Out-File -InputObject "      Type: $($Item.Value.PropertyType)" -FilePath $Path_Log_File -Append
      Out-File -InputObject "      Desired Value: $($Item.Value.Value)" -FilePath $Path_Log_File -Append

      # Get Current State
        $Temp_Registry_Current = Get-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -ErrorAction SilentlyContinue
        Out-File -InputObject "      Actual Value: $($Temp_Registry_Current.$($Item.Value.Name))" -FilePath $Path_Log_File -Append

      if ($Operation_Type -eq "Discovery") {
        # Process Based on Current State
          if ($Temp_Registry_Current -in "",$null) {
            $Meta_Result_Failures ++
            Out-File -InputObject "      Result: Failure, Object Not Found" -FilePath $Path_Log_File -Append
          }
          elseif ($Temp_Registry_Current.$($Item.Value.Name) -eq $Item.Value.Value) {
            $Meta_Result_Successes ++
            Out-File -InputObject "      Result: Skipped, Value Already Matches" -FilePath $Path_Log_File -Append
          }
          else {
            $Meta_Result_Failures ++
            Out-File -InputObject "      Result: Failure, Value Mismatch" -FilePath $Path_Log_File -Append
          }
      }
      elseif ($Operation_Type -eq "Remediation") {
        # Process Based on Current State
          if ($Temp_Registry_Current -in "",$null) {
            # Create Path if Not Exist
              if ((Test-Path -Path $Item.Value.Path) -in "",$false) {
                $Temp_PathRecurse = $null

                foreach ($Item_2 in ($Item.Value.Path -split "\\")) {
                  $Temp_PathRecurse += $Item_2 + "\"
                  if (Test-Path -Path $Temp_PathRecurse) {
                  }
                  else {
                    New-Item -Path $Temp_PathRecurse | Out-Null
                    Out-File -InputObject "      Created Path: $($Temp_PathRecurse)" -FilePath $Path_Log_File -Append
                  }
                }
              }

            # Create Registry Item
              New-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -PropertyType $Item.Value.PropertyType -Value $Item.Value.Value | Out-Null

            $Meta_Result_Successes ++
            Out-File -InputObject "      Result: Success, Created Property/Value Pair" -FilePath $Path_Log_File -Append
          }
          elseif ($Temp_Registry_Current.$($Item.Value.Name) -eq $Item.Value.Value) {
            $Meta_Result_Successes ++
            Out-File -InputObject "      Result: Skipped, Value Already Matches" -FilePath $Path_Log_File -Append
          }
          else {
            Set-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -Type $Item.Value.PropertyType -Value $Item.Value.Value | Out-Null
            $Meta_Result_Successes ++
            Out-File -InputObject "      Result: Success, Updated Property/Value Pair" -FilePath $Path_Log_File -Append
          }
      }
    }
    catch {
      # Increment Failure Count
        $Meta_Result_Failures ++
        Out-File -InputObject "      Result: Failure, Unknown Error" -FilePath $Path_Log_File -Append
    }
  }

  # Refresh User Shell
    if ($Shell_User_Refresh -eq $true) {
      Out-File -InputObject "Registry" -FilePath $Path_Log_File -Append
      $code = @'
using System.Runtime.InteropServices;
public class Wallpaper {
  [DllImport("user32.dll", CharSet=CharSet.Auto)]
  public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
'@
      Add-Type $code
      $Temp_Result = [Wallpaper]::SystemParametersInfo(0x0014, 0, $File_01.Path, 0x01 -bor 0x02)
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
