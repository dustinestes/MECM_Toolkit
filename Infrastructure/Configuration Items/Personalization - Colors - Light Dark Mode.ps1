#--------------------------------------------------------------------------------------------
# Notes
#--------------------------------------------------------------------------------------------
#Region Notes

# Supported: Windows 10, 11
# RunAs: User

# User Configuration\Administrative Templates\Control Panel\Personalization
#   Setting: Force a specific default lock screen and logon image
#   Description: Allows you to force a specific image by entering the path to image file. The same image will be used for both elements. Only applies to Enterprise, Education, and Server SKUs
#   Scope: Machine
#   Options:
#     State: Not Configured (null), Enabled (1), Disabled ()
#       Name: No Registry Entry Found
#     Path to lock screen image: [LocalOrUNCPath]
#       Name: LockScreenImage
#         Path:   HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization
#         Type:   String
#         Value:  C:\Path\file.jpg
#     Turn off fun facts, tips, tricks and more on lock screen: Checkbox
#       Name: LockScreenOverlaysDisabled
#         Path:   HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization
#         Type:   DWORD
#         Value:  1
#   URL: https://gpsearch.azurewebsites.net:/Default.aspx?PolicyID=8225
#   ADMX: ControlPanelDisplay.admx

#EndRegion Notes
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input

  # MECM Settings
    $Name_ConfigurationItem = "CI - Personalization - Colors - Light Dark Mode"
    $Operation_Type         = "Discovery" # "Discovery","Remediation"
    $Path_Log_Directory     = "$($env:vr_Directory_Logs)\ConfigurationBaselines\$($Operation_Type)"

  # Registry - All Users
    $Registry_Offline_01 = @{
      "Path"          = "SOFTWARE\Microsoft\Windows\CurrentVersion\THemes\Personalize"
      "Name"          = "SystemUsesLightTheme"
      "PropertyType"  = "Dword"
      "Value"         = 0
    }
    $Registry_Offline_02 = @{
      "Path"          = "SOFTWARE\Microsoft\Windows\CurrentVersion\THemes\Personalize"
      "Name"          = "AppsUseLightTheme"
      "PropertyType"  = "Dword"
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

  # Registry - All Users
    Out-File -InputObject "Registry - All Users" -FilePath $Path_Log_File -Append

    # Get Each User Profile SID and Path to the Profile
      $User_Profiles = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*" | Where-Object {$_.PSChildName -match "S-1-5-21-(\d+-?){4}$"} | Select-Object @{Name="SID"; Expression={$_.PSChildName}}, @{Name="Hive"; Expression={"$($_.ProfileImagePath)\NTuser.dat"}}

    # Add the .DEFAULT User Profile
      [array]$User_Profiles += [pscustomobject] @{
        SID = "USERTEMPLATE"
        Hive = "C:\Users\Default\NTUSER.dat"
      }

    # Loop Through Each Profile on the Machine
      foreach ($Profile in $User_Profiles) {
        # Load if Not Already Loaded
          if ((Test-Path -Path "Registry::HKEY_USERS\$($Profile.SID)") -eq $false) {
            Start-Process -FilePath "cmd.exe" -ArgumentList "/c reg.exe load HKU\$($Profile.SID) $($Profile.Hive)" -Wait -WindowStyle Hidden
          }

        foreach ($Item in (Get-Variable -Name "Registry_Offline_*")) {
          try {
            # Construct the Registry Path
              $Item.Path = "Registry::HKEY_Users\$($Profile.SID)\$($Item.Path)"

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

        # Run Garbage Collector
          [gc]::Collect()
          Start-Sleep -Seconds 5

        # Unload Hive
          Start-Process -FilePath "cmd.exe" -ArgumentList "/c reg.exe unload HKU\$($Profile.SID)" -Wait -WindowStyle Hidden | Out-Null
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
