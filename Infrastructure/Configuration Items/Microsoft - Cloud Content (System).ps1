#--------------------------------------------------------------------------------------------
# Notes
#--------------------------------------------------------------------------------------------
#Region Notes

# RunAs: System

# Computer Configuration\Administrative Templates\Windows Components\Cloud Content
#   Setting: Do not show Windows tips
#   Description: Prevents Windows tips from being show to users. Also known as the "Show suggestions occasionally in Start" option in Settings
#   Options
#     State: Not Configured (null), Enabled (1), Disabled (0)
#   URL:  https://gpsearch.azurewebsites.net:/Default.aspx?PolicyID=13330
#   ADMX: CloudContent.admx
# HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent
#   Name: DisableSoftLanding
#     Type:   Dword
#     Value:  1

# Computer Configuration\Administrative Templates\Windows Components\Cloud Content
#   Setting: Turn off cloud consumer account state content
#   Description: Turn off cloud consumer account state content in all Windows experiences
#   Options
#     State: Not Configured (null), Enabled (1), Disabled (0)
#   URL:  https://gpsearch.azurewebsites.net:/Default.aspx?PolicyID=15912
#   ADMX: CloudContent.admx
# HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent
#   Name: DisableConsumerAccountStateContent
#     Type:   Dword
#     Value:  1

# Computer Configuration\Administrative Templates\Windows Components\Cloud Content
#   Setting: Turn off cloud optimized content
#   Description: Turn off cloud optimized content in all Windows experiences
#   Options
#     State: Not Configured (null), Enabled (1), Disabled (0)
#   URL:  https://gpsearch.azurewebsites.net:/Default.aspx?PolicyID=15350
#   ADMX: CloudContent.admx
# HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent
#   Name: DisableCloudOptimizedContent
#     Type:   Dword
#     Value:  1

# Computer Configuration\Administrative Templates\Windows Components\Cloud Content
#   Setting: Turn off Microsoft consumer experiences
#   Description: Turn off experiences that help consumers make the most of their devices and Microsoft account
#   Options
#     State: Not Configured (null), Enabled (1), Disabled (0)
#   URL:  https://gpsearch.azurewebsites.net:/Default.aspx?PolicyID=13329
#   ADMX: CloudContent.admx
# HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent
#   Name: DisableWindowsConsumerFeatures
#     Type:   Dword
#     Value:  1

#EndRegion Notes
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input

  # MECM Settings
    $Name_ConfigurationItem = "CI - Microsoft - Cloud Content (System)"
    $Operation_Type         = "Discovery" # "Discovery","Remediation"
    $Path_Log_Directory     = "$($env:vr_Directory_Logs)\ConfigurationBaselines\$($Operation_Type)"

  # Registry - System / Current User
    $Registry_Online_01 = @{
      "Path"          = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
      "Name"          = "DisableSoftLanding"
      "PropertyType"  = "Dword"
      "Value"         = 1
    }
    $Registry_Online_02 = @{
      "Path"          = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
      "Name"          = "DisableConsumerAccountStateContent"
      "PropertyType"  = "Dword"
      "Value"         = 1
    }
    $Registry_Online_03 = @{
      "Path"          = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
      "Name"          = "DisableCloudOptimizedContent"
      "PropertyType"  = "Dword"
      "Value"         = 1
    }
    $Registry_Online_04 = @{
      "Path"          = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
      "Name"          = "DisableWindowsConsumerFeatures"
      "PropertyType"  = "Dword"
      "Value"         = 1
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

  # Registry - System / Current User
    Out-File -InputObject "Registry - System / Current User" -FilePath $Path_Log_File -Append

    foreach ($Item in (Get-Variable -Name "Registry_Online_*")) {
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
