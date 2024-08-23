#--------------------------------------------------------------------------------------------
# Write Output Header Info to SMSTS.log
#--------------------------------------------------------------------------------------------
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - Task Sequences - Remove Provisioned Apps (Appx)"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:    Dustin Estes"
    Write-Host "    Company:   VividRock"
    Write-Host "    Date:      February 10, 2018"
    Write-Host "    Copyright: VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:   Removes all of the identified appx applications from Windows."
    Write-Host "    Reference: https://learn.microsoft.com/en-us/windows/application-management/provisioned-apps-windows-client-os"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""
#--------------------------------------------------------------------------------------------

<# ---------------------------------------------------------------------------------------------
    Define Variables
------------------------------------------------------------------------------------------------
    Define the variables used within the script
------------------------------------------------------------------------------------------------ #>
#Region

    Write-Host "  Define Variables"

    # List of Applications to Remove (Comment out any you wish to keep)
    #   - Pulled from link above
        $Array_ApplicationsToRemove = @(
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

            # Replaced by Business Apps
                "Microsoft.windowscommunicationsapps"           # Mail and Calendar
                "Microsoft.SkypeApp"                            # Skype
                "Microsoft.People"                              # Microsoft People
                "Microsoft.Office.OneNote"                      # OneNote for Windows 10
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

            # Should Note Remove
                # "Microsoft.WindowsStore"                        # Microsoft Store
                # "Microsoft.DesktopAppInstaller"                 # Desktop App Installer
                # "Microsoft.HEIFImageExtension"                  # HEIF Image Extensions
                # "Microsoft.HEVCVideoExtension"                  # HEVC Video Extensions
                # "Microsoft.WebMediaExtensions"                  # Web Media Extensions
                # "Microsoft.WebpImageExtension"                  # Webp Image Extension
                # "Microsoft.VP9VideoExtensions"                  # No Name
                # "Microsoft.Outlook.DesktopIntegrationServices"  # No Name
        )

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Define Variables


<# ---------------------------------------------------------------------------------------------
    Remove Applications (Appx)
------------------------------------------------------------------------------------------------
    Remove the application packages that were identified above
------------------------------------------------------------------------------------------------ #>
#Region

    Write-Host "  Remove Applications (Appx)"

    # Process Application List
        foreach ($Item in $Array_ApplicationsToRemove) {
            Write-Host "    - "$Item

            # Get Objects, States, and Remove if Applicable
                $Object_ApplicationPackage = Get-AppxPackage -Name $Item
                if ($Object_ApplicationPackage -in "",$false,$null) {
                    # Output Log Information
                        Write-Host "          Package State: Not Installed" -ForegroundColor DarkGray
                }
                else {
                    # Output Log Information
                        Write-Host "          Package State: Installed"
                        Write-Host "          Package Full Name: "$Object_ApplicationPackage.PackageFullName
                        Write-Host "          NonRemovable: "$Object_ApplicationPackage.NonRemovable

                    # Remove Application
                        Write-Host "          Remove Appx Package: " -NoNewline
                        try {
                            Remove-AppxPackage -Package $Object_ApplicationPackage.PackageFullName -ErrorAction Stop
                            Write-Host " Success" -ForegroundColor Green
                        }
                        catch {
                            Write-Host " Failed" -ForegroundColor Red
                        }
                }

                Write-Host ""

                $Object_ApplicationProvisionedPackage = Get-AppxProvisionedPackage -Online | Where-Object -Property DisplayName -eq $Item
                if ($Object_ApplicationProvisionedPackage -in "",$false,$null) {
                    # Output Log Information
                        Write-Host "          Prov. Package State: Not Installed" -ForegroundColor DarkGray
                }
                else {
                    # Output Log Information
                        Write-Host "          Prov. Package State: Installed"
                        Write-Host "          Provisioned Package Name: "$Object_ApplicationProvisionedPackage.PackageName

                    # Remove Application
                        Write-Host "          Remove Appx Provisioned Package: " -NoNewline
                        try {
                            $Result = Remove-AppxProvisionedPackage -Online -PackageName $Object_ApplicationProvisionedPackage.PackageName -ErrorAction Stop -AllUsers
                            Write-Host " Success" -ForegroundColor Green
                            Write-Host "          Restart Required: "$Result.RestartNeeded
                        }
                        catch {
                            Write-Host " Failed" -ForegroundColor Red
                        }
                }

                Write-Host ""
        }

    Write-Host "    - Complete"
    Write-Host ""
#EndRegion Remove Applications (Appx)
