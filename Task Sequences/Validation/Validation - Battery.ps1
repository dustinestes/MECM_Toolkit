<#--------------------------------------------------------------------------------------------------------------------
    PowerShell: Message Box
----------------------------------------------------------------------------------------------------------------------
    Author:  Dustin Estes
    Date:    September 16th, 2020

    This script will present a message box to the user and provide them with some information. It will then have an OK
    so that they can confirm the receipt of that message.

    Link to Microsoft Support Document that was used to populate the list of log files below:
        https://support.microsoft.com/en-us/help/928901/log-files-that-are-created-when-you-upgrade-to-a-new-version-of-window

----------------------------------------------------------------------------------------------------------------------#>
Function MessageBox() {
  $MsgBox_Title = "MECM - Windows 10 Upgrade - Prerequisite Checker"
  $MsgBox_Body = "Warning!

  Your device is currently running on BATTERY and is not plugged in. A power failure or disruption to power during this process could result in your device becoming unresponsive.

  Please perform the following:
      - Confirm your power cord is securely plugged into the wall
      - Plug your power cord into the device
      - Confirm your device registers as plugged in by looking at the power icon in the system tray (bottom right)
      - Click OK"

  $MsgBox_ButtonType = [System.Windows.MessageBoxButton]::OK
  $MsgBox_Icon = [System.Windows.MessageBoxImage]::Warning

  # Add in required GUI assemblies for message box
      Add-Type -AssemblyName PresentationCore, PresentationFramework

  # Present Message Box to user
      $Result=[System.Windows.MessageBox]::Show($MsgBox_Body, $MsgBox_Title, $MsgBox_ButtonType, $MsgBox_Icon)

  # Check for AC Power after user clicks OK
      CheckIfACPower

  }

  Function CheckIfACPower(){

  # Check WMI using Microsoft supported query
      $WMIBatteryStatus = Get-WmiObject -Class Win32_Battery -Property BatteryStatus

      If ($WMIBatteryStatus.BatteryStatus -ne 2) {
          # Display the message box again because the power has not been connected
              MessageBox
      }
      Else {
          Exit 0
      }

  }


  # Run Initial Function(s)

      #Hide the progress dialog
          $TSProgressUI = new-object -comobject Microsoft.SMS.TSProgressUI
          $TSProgressUI.CloseProgressDialog()

      CheckIfACPower