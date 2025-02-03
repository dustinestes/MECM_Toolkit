#--------------------------------------------------------------------------------------------
# Notes
#--------------------------------------------------------------------------------------------
#Region Notes

# RunAs: System

# User Configuration\Administrative Templates\Windows Components\Cloud Content
#   Setting: Configure Windows Spotlight on Lock Screen
#   Description: Configure the windows spotlight on the lock screen.
#   Options
#     State: Not Configured (null), Enabled (1), Disabled (2)
#     Include content from Enterprise spotlight: True (1), False (0)
#   URL:  https://gpsearch.azurewebsites.net:/Default.aspx?PolicyID=13362
#   ADMX: CloudContent.admx
# HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent
#   Name: ConfigureWindowsSpotlight
#     Type:   Dword
#     Value:  2
#   Name: IncludeEnterpriseSpotlight
#     Type:   Dword
#     Value:  0

# User Configuration\Administrative Templates\Windows Components\Cloud Content
#   Setting: Do not suggest third-party content in Windows spotlight
#   Description: Configure features like lock screen spotlight, suggest apps in Start menu, or windows tips for third-party apps and content. Does not prevent content from Microsoft.
#   Options
#     State: Not Configured (null), Enabled (1), Disabled (0)
#   URL:  https://gpsearch.azurewebsites.net:/Default.aspx?PolicyID=13364
#   ADMX: CloudContent.admx
# HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent
#   Name: DisableThirdPartySuggestions
#     Type:   Dword
#     Value:  1

# User Configuration\Administrative Templates\Windows Components\Cloud Content
#   Setting: Do not use diagnostic data for tailored experiences
#   Description: Lets you prevent Windows from using diagnostic data to provide tailored experiences to the user.
#   Options
#     State: Not Configured (null), Enabled (1), Disabled (0)
#   URL:  https://gpsearch.azurewebsites.net:/Default.aspx?PolicyID=13573
#   ADMX: CloudContent.admx
# HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent
#   Name: DisableTailoredExperiencesWithDiagnosticData
#     Type:   Dword
#     Value:  1

# User Configuration\Administrative Templates\Windows Components\Cloud Content
#   Setting: Enable Organizational Messages
#   Description: Organizational messages allow Administrators to deliver messages to their end users on selected Windows 11 experiences via services like Microsoft Endpoint Manager.
#   Options
#     State: Not Configured (null), Enabled (1), Disabled (0)
#   URL:  https://gpsearch.azurewebsites.net:/Default.aspx?PolicyID=16588
#   ADMX: CloudContent.admx
# HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent
#   Name: EnableOrganizationalMessages
#     Type:   Dword
#     Value:  1

# User Configuration\Administrative Templates\Windows Components\Cloud Content
#   Setting: Turn off all Windows spotlight features
#   Description: Lets you turn off all Windows spotlight features at once.
#   Options
#     State: Not Configured (null), Enabled (1), Disabled (0)
#   URL:  https://gpsearch.azurewebsites.net:/Default.aspx?PolicyID=13363
#   ADMX: CloudContent.admx
# HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent
#   Name: DisableWindowsSpotlightFeatures
#     Type:   Dword
#     Value:  1

# User Configuration\Administrative Templates\Windows Components\Cloud Content
#   Setting: Turn off Spotlight collection on Desktop
#   Description: Removes the Spotlight collection setting in Personalization, rendering the user unable to select and subsequently download daily images from Microsoft to desktop
#   Options
#     State: Not Configured (null), Enabled (1), Disabled (0)
#   URL:  https://gpsearch.azurewebsites.net:/Default.aspx?PolicyID=15911
#   ADMX: CloudContent.admx
# HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent
#   Name: DisableSpotlightCollectionOnDesktop
#     Type:   Dword
#     Value:  1

# User Configuration\Administrative Templates\Windows Components\Cloud Content
#   Setting: Turn off the Windows Welcome Experience
#   Description: Lets you turn off the Windows Spotlight Windows Welcome experience that helps onboard users to Windows. For instance, launching Microsoft Edge with a web page highlighting new features.
#   Options
#     State: Not Configured (null), Enabled (1), Disabled (0)
#   URL:  https://gpsearch.azurewebsites.net:/Default.aspx?PolicyID=13575
#   ADMX: CloudContent.admx
# HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent
#   Name: DisableWindowsSpotlightWindowsWelcomeExperience
#     Type:   Dword
#     Value:  1

# User Configuration\Administrative Templates\Windows Components\Cloud Content
#   Setting: Turn off Windows Spotlight on Action Center
#   Description: Determines whether Windows Spotlight notifications will be shown on the Action Center. These notifications will suggest apps or features to help users be more productive on Windows.
#   Options
#     State: Not Configured (null), Enabled (1), Disabled (0)
#   URL:  https://gpsearch.azurewebsites.net:/Default.aspx?PolicyID=13574
#   ADMX: CloudContent.admx
# HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent
#   Name: DisableWindowsSpotlightOnActionCenter
#     Type:   Dword
#     Value:  1

# User Configuration\Administrative Templates\Windows Components\Cloud Content
#   Setting: Turn off Windows Spotlight on Settings
#   Description: Configures whether Windows Spotlight suggestions will be shown in the Settings app.
#   Options
#     State: Not Configured (null), Enabled (1), Disabled (0)
#   URL:  https://gpsearch.azurewebsites.net:/Default.aspx?PolicyID=13762
#   ADMX: CloudContent.admx
# HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent
#   Name: DisableWindowsSpotlightOnSettings
#     Type:   Dword
#     Value:  1

#EndRegion Notes
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input

  # MECM Settings
    $Name_ConfigurationItem = "CI - Microsoft - Cloud Content (All Users)"
    $Operation_Type         = "Discovery" # "Discovery","Remediation"
    $Path_Log_Directory     = "$($env:vr_Directory_Logs)\ConfigurationBaselines\$($Operation_Type)"

  # Registry - All Users
    $Registry_Offline_01a = @{
      "Path"          = "SOFTWARE\Policies\Microsoft\Windows\CloudContent"
      "Name"          = "ConfigureWindowsSpotlight"
      "PropertyType"  = "Dword"
      "Value"         = 2
    }
    $Registry_Offline_01b = @{
      "Path"          = "SOFTWARE\Policies\Microsoft\Windows\CloudContent"
      "Name"          = "IncludeEnterpriseSpotlight"
      "PropertyType"  = "Dword"
      "Value"         = 0
    }
    $Registry_Offline_02 = @{
      "Path"          = "SOFTWARE\Policies\Microsoft\Windows\CloudContent"
      "Name"          = "DisableThirdPartySuggestions"
      "PropertyType"  = "Dword"
      "Value"         = 1
    }
    $Registry_Offline_03 = @{
      "Path"          = "SOFTWARE\Policies\Microsoft\Windows\CloudContent"
      "Name"          = "DisableTailoredExperiencesWithDiagnosticData"
      "PropertyType"  = "Dword"
      "Value"         = 1
    }
    $Registry_Offline_04 = @{
      "Path"          = "SOFTWARE\Policies\Microsoft\Windows\CloudContent"
      "Name"          = "EnableOrganizationalMessages"
      "PropertyType"  = "Dword"
      "Value"         = 1
    }
    $Registry_Offline_05 = @{
      "Path"          = "SOFTWARE\Policies\Microsoft\Windows\CloudContent"
      "Name"          = "DisableWindowsSpotlightFeatures"
      "PropertyType"  = "Dword"
      "Value"         = 1
    }
    $Registry_Offline_06 = @{
      "Path"          = "SOFTWARE\Policies\Microsoft\Windows\CloudContent"
      "Name"          = "DisableSpotlightCollectionOnDesktop"
      "PropertyType"  = "Dword"
      "Value"         = 1
    }
    $Registry_Offline_07 = @{
      "Path"          = "SOFTWARE\Policies\Microsoft\Windows\CloudContent"
      "Name"          = "DisableWindowsSpotlightWindowsWelcomeExperience"
      "PropertyType"  = "Dword"
      "Value"         = 1
    }
    $Registry_Offline_08 = @{
      "Path"          = "SOFTWARE\Policies\Microsoft\Windows\CloudContent"
      "Name"          = "DisableWindowsSpotlightOnActionCenter"
      "PropertyType"  = "Dword"
      "Value"         = 1
    }
    $Registry_Offline_09 = @{
      "Path"          = "SOFTWARE\Policies\Microsoft\Windows\CloudContent"
      "Name"          = "DisableWindowsSpotlightOnSettings"
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
        Out-File -InputObject "  - SID: $($Profile.SID)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      Hive: $($Profile.Hive)" -FilePath $Path_Log_File -Append

        # Load if Not Already Loaded
          if ((Test-Path -Path "Registry::HKEY_USERS\$($Profile.SID)") -eq $false) {
            Start-Process -FilePath "cmd.exe" -ArgumentList "/c reg.exe load HKU\$($Profile.SID) $($Profile.Hive)" -Wait -WindowStyle Hidden
          }

        foreach ($Item in (Get-Variable -Name "Registry_Offline_*")) {
          try {
            # Construct the Registry Path
              $Item.Value.Path = "Registry::HKEY_Users\$($Profile.SID)\$($Item.Value.Path)"

            Out-File -InputObject "      $($Item.Name)" -FilePath $Path_Log_File -Append
            Out-File -InputObject "        Path: $($Item.Value.Path)" -FilePath $Path_Log_File -Append
            Out-File -InputObject "        Name: $($Item.Value.Name)" -FilePath $Path_Log_File -Append
            Out-File -InputObject "        Type: $($Item.Value.PropertyType)" -FilePath $Path_Log_File -Append
            Out-File -InputObject "        Desired Value: $($Item.Value.Value)" -FilePath $Path_Log_File -Append

            # Get Current State
              $Temp_Registry_Current = Get-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -ErrorAction SilentlyContinue
              Out-File -InputObject "        Actual Value: $($Temp_Registry_Current.$($Item.Value.Name))" -FilePath $Path_Log_File -Append

            if ($Operation_Type -eq "Discovery") {
              # Process Based on Current State
                if ($Temp_Registry_Current -in "",$null) {
                  $Meta_Result_Failures ++
                  Out-File -InputObject "        Result: Failure, Object Not Found" -FilePath $Path_Log_File -Append
                }
                elseif ($Temp_Registry_Current.$($Item.Value.Name) -eq $Item.Value.Value) {
                  $Meta_Result_Successes ++
                  Out-File -InputObject "        Result: Skipped, Value Already Matches" -FilePath $Path_Log_File -Append
                }
                else {
                  $Meta_Result_Failures ++
                  Out-File -InputObject "        Result: Failure, Value Mismatch" -FilePath $Path_Log_File -Append
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
                          Out-File -InputObject "        Created Path: $($Temp_PathRecurse)" -FilePath $Path_Log_File -Append
                        }
                      }
                    }

                  # Create Registry Item
                    New-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -PropertyType $Item.Value.PropertyType -Value $Item.Value.Value | Out-Null

                  $Meta_Result_Successes ++
                  Out-File -InputObject "        Result: Success, Created Property/Value Pair" -FilePath $Path_Log_File -Append
                }
                elseif ($Temp_Registry_Current.$($Item.Value.Name) -eq $Item.Value.Value) {
                  $Meta_Result_Successes ++
                  Out-File -InputObject "        Result: Skipped, Value Already Matches" -FilePath $Path_Log_File -Append
                }
                else {
                  Set-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -Type $Item.Value.PropertyType -Value $Item.Value.Value | Out-Null
                  $Meta_Result_Successes ++
                  Out-File -InputObject "        Result: Success, Updated Property/Value Pair" -FilePath $Path_Log_File -Append
                }
              }

            # Clean the Registry Path
              $Temp_CleanupString = [regex]::Escape("Registry::HKEY_Users\$($Profile.SID)\")
              $Item.Value.Path = $Item.Value.Path -replace $Temp_CleanupString,""
          }
          catch {
            # Increment Failure Count
              $Meta_Result_Failures ++
              Out-File -InputObject "        Result: Failure, Unknown Error" -FilePath $Path_Log_File -Append
          }
        }

        # Run Garbage Collector
          [gc]::Collect()
          Start-Sleep -Seconds 2

        # Unload Hive
          Start-Process -FilePath "cmd.exe" -ArgumentList "/c reg.exe unload HKU\$($Profile.SID)" -Wait -WindowStyle Hidden | Out-Null
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
