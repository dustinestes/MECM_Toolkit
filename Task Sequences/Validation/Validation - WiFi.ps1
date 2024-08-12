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

  Your device is currently connected to WiFi. It is recommended that you plug your device into a network cable (ethernet) before continuing.

  This process requires data to be transferred to and from your device. Doing so over WiFi can cause the process to take significantly longer.

  Please click Ok when you are ready to proceed."

  $MsgBox_ButtonType = [System.Windows.MessageBoxButton]::OK
  $MsgBox_Icon = [System.Windows.MessageBoxImage]::Warning

  # Add in required GUI assemblies for message box
      Add-Type -AssemblyName PresentationCore, PresentationFramework

  # Present Message Box to user
      [System.Windows.MessageBox]::Show($MsgBox_Body, $MsgBox_Title, $MsgBox_ButtonType, $MsgBox_Icon)

  # Check for AC Power after user clicks OK
      CheckIfWiFi

  }

  Function CheckIfWiFi(){

  # Check WMI using Microsoft supported query
      $WMIConnectionID = Get-WmiObject -Class Win32_NetworkAdapter -Filter "NetConnectionStatus = 2 and PhysicalAdapter = True" | Select-Object NetConnectionID

      If ($WMIConnectionID -eq 'Wi-Fi') {
          # Display the message box again because the power has not been connected
              MessageBox
      }
      Else {
          Exit 0
      }

  }


  # Run Initial Function(s)

      #Hide the progress dialog
   #       $TSProgressUI = new-object -comobject Microsoft.SMS.TSProgressUI
   #       $TSProgressUI.CloseProgressDialog()

      CheckIfWiFi