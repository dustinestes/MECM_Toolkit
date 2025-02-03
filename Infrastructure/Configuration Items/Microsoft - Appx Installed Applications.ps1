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
    $Name_ConfigurationItem = "CI - Microsoft - Appx Installed Applications"
    $Operation_Type         = "Discovery" # "Discovery","Remediation"
    $Path_Log_Directory     = "$($env:vr_Directory_Logs)\ConfigurationBaselines\$($Operation_Type)"

  # Appx Packages
    $Appx_Packages = @(
      # Recommended to Remove
      "Microsoft.ZuneMusic"                           # Groove Music
      "Microsoft.ZuneVideo"                           # Movies & TV
      "Microsoft.YourPhone"                           # Your Phone
      "Microsoft.WindowsFeedbackHub"                  # Feedback Hub
      "Microsoft.GetHelp"                             # Get Help
      "Microsoft.Getstarted"                          # Microsoft Tips
      "Microsoft.OneConnect"                          # Mobile Plans
      "Package name:Microsoft.Messaging"              # Microsoft Messaging
      "Microsoft.Wallet"                              # Microsoft Pay
      "Microsoft.MicrosoftSolitaireCollection"        # Microsoft Solitaire Collection
      "Microsoft.BingNews"                            # News
      "Microsoft.BingWeather"                         # Weather

      # Replaced by Business Apps
      "Microsoft.windowscommunicationsapps"           # Mail and Calendar
      "Microsoft.SkypeApp"                            # Skype
      "Microsoft.People"                              # Microsoft People
      "Microsoft.Office.OneNote"                      # OneNote for Windows 10
      "Microsoft.OutlookForWindows"                   # Outlook (New)
      "Microsoft.MicrosoftOfficeHub"                  # Office

      # Xbox Applications
      "Microsoft.Xbox.TCUI"                           # Xbox Live in-game experience
      "Microsoft.XboxApp"                             # Xbox Console Companion
      "Microsoft.XboxGameOverlay"                     # Xbox Game Bar Plugin
      "Microsoft.XboxGamingOverlay"                   # Xbox Game Bar
      "Microsoft.XboxIdentityProvider"                # Xbox Identity Provider
      "Microsoft.XboxSpeechToTextOverlay"             # No Name

      # 3D Tools
      "Microsoft.3DBuilder"                           # 3D Builder
      "Microsoft.Microsoft3DViewer"                   # Microsoft 3D Viewer
      "Microsoft.MSPaint"                             # Paint 3D
      "Microsoft.Print3D"                             # Print 3D
      "Microsoft.MixedReality.Portal"                 # Mixed Reality Portal

      # Productivity Apps
      # "Microsoft.BingWeather"                         # Bing Weather
      # "Microsoft.WindowsMaps"                         # Windows Maps
      # "Microsoft.WindowsSoundRecorder"                # Windows Voice Recorder
      # "Microsoft.WindowsCalculator"                   # Windows Calculator
      # "Microsoft.WindowsCamera"                       # Windows Camera
      # "Microsoft.Windows.Photos"                      # Microsoft Photos
      # "Microsoft.WindowsAlarms"                       # Windows Alarms & Clock
      # "Microsoft.ScreenSketch"                        # Snip & Sketch
      # "Microsoft.MicrosoftStickyNotes"                # Microsoft Sticky Notes

      # Should Not Remove
      # "Microsoft.WindowsStore"                        # Microsoft Store
      # "Microsoft.DesktopAppInstaller"                 # Desktop App Installer
      # "Microsoft.HEIFImageExtension"                  # HEIF Image Extensions
      # "Microsoft.HEVCVideoExtension"                  # HEVC Video Extensions
      # "Microsoft.WebMediaExtensions"                  # Web Media Extensions
      # "Microsoft.WebpImageExtension"                  # Webp Image Extension
      # "Microsoft.VP9VideoExtensions"                  # No Name
      # "Microsoft.Outlook.DesktopIntegrationServices"  # No Name
    )

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

  # Appx Packages
    Out-File -InputObject "Appx Packages" -FilePath $Path_Log_File -Append

    # Loop Through Each Package
    foreach ($Item in $Appx_Packages) {
      try {
        Out-File -InputObject "  - $($Item)" -FilePath $Path_Log_File -Append

        # Get Current State
          $Temp_Package = Get-AppxPackage -Name $Item
          $Temp_ProvisionedPackage = Get-AppxProvisionedPackage -Online | Where-Object -Property DisplayName -eq $Item

        # Process Based on Operation Type
        if ($Operation_Type -eq "Discovery") {
          if (($Temp_Package -in "",$false,$null) -and ($Temp_ProvisionedPackage -in "",$false,$null)) {
            $Meta_Result_Successes ++
            Out-File -InputObject "      Result: Success, Not Installed" -FilePath $Path_Log_File -Append
          }
          else {
            $Meta_Result_Failures ++
            Out-File -InputObject "      Result: Failure, Installed" -FilePath $Path_Log_File -Append
          }
        }
        elseif ($Operation_Type -eq "Remediation") {
          if (($Temp_Package -in "",$false,$null) -and ($Temp_ProvisionedPackage -in "",$false,$null)) {
            $Meta_Result_Successes ++
            Out-File -InputObject "      Result: Success, Not Installed" -FilePath $Path_Log_File -Append
          }
          else {
            if ($Temp_Package -notin "",$false,$null) {
              Remove-AppxPackage -Package $Temp_Package.PackageFullName | Out-Null
              Out-File -InputObject "      Package: Uninstalled" -FilePath $Path_Log_File -Append
            }
            if ($Temp_ProvisionedPackage -notin "",$false,$null) {
              Remove-AppxProvisionedPackage -Online -PackageName $Temp_ProvisionedPackage.PackageName -AllUsers | Out-Null
              Out-File -InputObject "      Provisioned Package: Uninstalled" -FilePath $Path_Log_File -Append
            }

            $Meta_Result_Successes ++
            Out-File -InputObject "      Result: Success, Uninstalled" -FilePath $Path_Log_File -Append
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
