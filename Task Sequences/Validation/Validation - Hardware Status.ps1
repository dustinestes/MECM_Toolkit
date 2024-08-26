#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$Filename,                # 'Validation_Hardware.log'
    [string]$Path                     # '%vr_Directory_TS_Validation%'
)

#--------------------------------------------------------------------------------------------
# Start-Transcript -Path "C:\VividRock\MECM Toolkit\Logs\Task Sequences\Validation - Hardware Status.log" -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

  Write-Host "------------------------------------------------------------------------------"
  Write-Host "  MECM Toolkit - Task Sequences - Validation - Hardware Status"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host "    Author:     Dustin Estes"
  Write-Host "    Company:    VividRock"
	Write-Host "    Date:       December 23, 2019"
	Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
	Write-Host "    Purpose:    This script will scan the hardware on the device and check for"
	Write-Host "                any hardware with an error code != 0. If found, it will prompt"
	Write-Host "                prompt the user with the hardware info and status."
	Write-Host "    Links:      https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-pnpentity?redirectedfrom=MSDN"
	Write-Host "                https://support.microsoft.com/en-us/topic/error-codes-in-device-manager-in-windows-524e9e89-4dee-8883-0afa-6bca0456324e"
	Write-Host "------------------------------------------------------------------------------"
  Write-Host ""

<#
  To Do:
    - Item
    - Item
#>

#EndRegion Header
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Variables
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Variables

  Write-Host "  Variables"

  # Parameters
    $Param_SiteCode         = $SiteCode
    $Param_SMSProvider      = $SMSProvider
    $Param_Filename         = $Filename
		$Param_Path            	= $Path

  # Metadata
    $Meta_Script_Start_DateTime     = Get-Date
    $Meta_Script_Complete_DateTime  = $null
    $Meta_Script_Complete_TimeSpan  = $null
    $Meta_Script_Execution_User     = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $Meta_Script_Result = $false,"Failure"

  # Preferences
    $ErrorActionPreference        = "Stop"
    $CMPSSuppressFastNotUsedCheck = $true

  # Names
		$Name_TSVariable_ValidationStatus    = "vr_Validation_HardwareStatus"
			# Success = No errors found, Failure = 1 or more errors found
		$Name_TSVariable_TotalHardware       = "vr_Validation_HardwareTotal"
		$Name_TSVariable_TotalErrors         = "vr_Validation_HardwareErrors"

  # Paths
		$Path_HardwareInfo_Log    = "$($Object_MECM_TSEnvironment.Value("vr_Directory_TS_Validation"))\$($Filename)"

  # Files

  # Hashtables
		$Hashtable_Win32PnpEntity_ErrorCodes = @{
			"1" = "This device is not configured correctly. (Code 1)"
			"3" = "The driver for this devicemight be corrupted… (Code 3)"
			"9" = "Windows cannot identify this hardware… (Code 9)"
			"10" = "This device cannot start. (Code 10)"
			"12" = "This device cannot find enough free resources that it can use... (Code 12) "
			"14" = "This device cannotwork properly until you restart your computer. (Code 14)"
			"16" = "Windows cannot identify all the resources this device uses. (Code 16)"
			"18" = "Reinstall the drivers for this device. (Code 18)"
			"19" = "Windows cannot start this hardware device… (Code 19)"
			"21" = "Windows is removing this device...(Code 21)"
			"22" = "This device is disabled. (Code 22)"
			"24" = "This device is notpresent, is not working properly… (Code 24)"
			"28" = "The drivers for this device are not installed. (Code 28)"
			"29" = "This device is disabled...(Code 29)"
			"31" = "This device is not working properly...(Code 31)"
			"32" = "A driver (service) for this device has been disabled. (Code 32)"
			"33" = "Windows cannot determinewhich resources are required for this device. (Code 33)"
			"34" = "Windows cannot determine the settings for this device... (Code 34)"
			"35" = "Your computer`'s system firmware does not… (Code 35)"
			"36" = "This device is requesting a PCI interrupt… (Code 36)"
			"37" = "Windows cannot initialize the device driver for this hardware. (Code 37)"
			"38" = "Windows cannot load the device driver… (Code 38)"
			"39" = "Windows cannot load the device driver for this hardware... (Code 39)."
			"40" = "Windows cannot access this hardware… (Code 40)"
			"41" = "Windows successfully loaded the device driver… (Code 41)"
			"42" = "Windows cannot load the device driver…  (Code 42)"
			"43" = "Windows has stopped this device because it has reported problems. (Code 43)"
			"44" = "An application or service has shut down this hardware device. (Code 44)"
			"45" = "Currently, this hardware device is not connected to the computer... (Code 45)"
			"46" = "Windows cannot gain accessto this hardware device… (Code 46)"
			"47" = "Windows cannot use this hardware device… (Code 47)"
			"48" = "The software for this device has been blocked… (Code 48)."
			"49" = "Windows cannot start new hardware devices… (Code 49)."
			"50" = "Windows cannot apply all of the properties for this device... (Code 50)"
			"51" = "This device is currently waiting on another device… (Code 51)."
			"52" = "Windows cannot verify the digital signature for the drivers required for this device. (Code 52)"
			"53" = "This device has been reserved for use by the Windows kernel debugger... (Code 53)"
			"54" = "This device has failed and is undergoing a reset. (Code 54)"
		}

  # Arrays

  # Registry

  # WMI
		$WMI_Path_Namespace      = "root\cimV2"
		$WMI_Name_Class          = "Win32_PnpEntity"

  # Datasets

  # Temporary

  # Output to Log
    Write-Host "    - Parameters"
    foreach ($Item in (Get-Variable -Name "Param_*")) {
      Write-Host "        $(($Item.Name) -replace 'Param_',''): $($Item.Value)"
    }
		Write-Host "    - Names"
    foreach ($Item in (Get-Variable -Name "Name_*")) {
      Write-Host "        $(($Item.Name) -replace 'Name_',''): $($Item.Value)"
    }
		Write-Host "    - Paths"
    foreach ($Item in (Get-Variable -Name "Path_*")) {
      Write-Host "        $(($Item.Name) -replace 'Path_',''): $($Item.Value)"
    }
		Write-Host "    - WMI"
    foreach ($Item in (Get-Variable -Name "WMI_*")) {
      Write-Host "        $(($Item.Name) -replace 'WMI_',''): $($Item.Value)"
    }

  Write-Host "    - Complete"
  Write-Host ""

#EndRegion Variables
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Functions
#   Error Range: 1300 - 1399
#--------------------------------------------------------------------------------------------
#Region Functions

  Write-Host "  Functions"

  # Write Error Codes
    Write-Host "    - Write-vr_ErrorCode"
    function Write-vr_ErrorCode ($Code,$Exit,$Object) {
      # Code: XXXX   4-digit code to identify where in script the operation failed
      # Exit: Boolean option to define if  exits or not
      # Object: The error object created when the script encounters an error ($Error[0], $PSItem, etc.)

      begin {

      }

      process {
        Write-Host "        Error: $($Object.Exception.ErrorId)"
        Write-Host "        Command Name: $($Object.CategoryInfo.Activity)"
        Write-Host "        Message: $($Object.Exception.Message)"
        Write-Host "        Line/Position: $($Object.Exception.Line)/$($Object.Exception.Offset)"
      }

      end {
        switch ($Exit) {
          $true {
            Write-Host "        Exit: $($Code)"
            Stop-Transcript
            Exit $Code
          }
          $false {
            Write-Host "        Continue Processing..."
          }
          Default {
            Write-Host "        Unknown Exit option in Write-vr_ErrorCode parameter"
          }
        }
      }
    }

  Write-Host "    - Complete"
  Write-Host ""

#EndRegion Functions
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Environment
#   Error Range: 1400 - 1499
#--------------------------------------------------------------------------------------------
#Region Environment

	Write-Host "  Environment"

	# # Create Client COM Object
	# 	Write-Host "    - Create Client COM Object"

	# 	try {
	# 		$Object_MECM_Client = New-Object -ComObject Microsoft.SMS.Client
	# 		Write-Host "        Status: Success"
	# 	}
	# 	catch {
	# 		Write-vr_ErrorCode -Code 1401 -Exit $true -Object $PSItem
	# 	}

	# Create TSEnvironment COM Object
		Write-Host "    - Create TSEnvironment COM Object"

		try {
			$Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment
			Write-Host "        Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 1402 -Exit $true -Object $PSItem
		}

	# # Connect to MECM Infrastructure
	# 	Write-Host "    - Connect to MECM Infrastructure"

	# 	try {
	# 		if (Test-Connection -ComputerName $Param_SMSProvider -Count 2 -Quiet) {
	# 			# Import the PowerShell Module
	# 				Write-Host "        Import the PowerShell Module"

	# 				if((Get-Module ConfigurationManager) -in $null,"") {
	# 					Import-Module -Name "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"
	# 					Write-Host "            Status: Success"
	# 				}
	# 				else {
	# 					Write-Host "            Status: Already Imported"
	# 				}

	# 			# Create the Site Drive
	# 				Write-Host "        Create the Site Drive"

	# 				if((Get-PSDrive -Name $Param_SiteCode -PSProvider CMSite) -in $null,"") {
	# 					New-PSDrive -Name $Param_SiteCode -PSProvider CMSite -Root $Param_SMSProvider
	# 					Write-Host "            Status: Success"
	# 				}
	# 				else {
	# 					Write-Host "            Status: Already Exists"
	# 				}

	# 			# Set the Location
	# 				Write-Host "        Set the Location"

	# 				if ((Get-Location).Path -ne "$($Param_SiteCode):\") {
	# 					Set-Location "$($Param_SiteCode):\"
	# 					Write-Host "            Status: Success"
	# 				}
	# 				else {
	# 					Write-Host "            Status: Already Set"
	# 				}
	# 		}
	# 		else {
	# 			Write-Host "        Status: MECM Server Unreachable"
	# 			Throw "Status: MECM Server Unreachable"
	# 		}
	# 	}
	# 	catch {
	# 		Write-vr_ErrorCode -Code 1403 -Exit $true -Object $PSItem
	# 	}

	Write-Host "    - Complete"
	Write-Host ""

#EndRegion Environment
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validation
#   Error Range: 1500 - 1599
#--------------------------------------------------------------------------------------------
#Region Validation

	Write-Host "  Validation"

	# Output Directory
		Write-Host "    - Output Directory"

		try {
			Write-Host "        Path: $($Param_Path)"

			if (Test-Path -Path $Param_Path) {
				Write-Host "            Status: Exists"
			}
			else {
				New-Item -Path $Param_Path -ItemType Directory -Force | Out-Null
				Write-Host "            Status: Created"
			}
		}
		catch {
			Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
		}

	# WMI Path
		Write-Host "    - WMI Path"

		try {
			Write-Host "        Namespace: $($WMI_Path_Namespace)"
			Write-Host "        Class: $($WMI_Name_Class)"

			if (Get-CimInstance -Namespace $WMI_Path_Namespace -ClassName $WMI_Name_Class) {
				Write-Host "            Status: Exists"
			}
		}
		catch {
			Write-vr_ErrorCode -Code 1502 -Exit $true -Object $PSItem
		}

	Write-Host "    - Complete"
	Write-Host ""

#EndRegion Validation
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Data Gather
#   Error Range: 1600 - 1699
#--------------------------------------------------------------------------------------------
#Region Data Gather

	Write-Host "  Data Gather"

	# Hardware Information
		Write-Host "    - Hardware Information"

		try {
			$Dataset_Hardware = Get-CimInstance -Namespace $WMI_Path_Namespace -ClassName $WMI_Name_Class
			Write-Host "        Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
		}

	Write-Host "    - Complete"
	Write-Host ""

#EndRegion Data Gather
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1700 - 1799
#--------------------------------------------------------------------------------------------
#Region Execution

	Write-Host "  Execution"

	# Analyze Hardware
		Write-Host "    - Analyze Hardware"

		try {
			$Temp_Hardware_Errors = $Dataset_Hardware | Where-Object {$_.ConfigManagerErrorCode -gt 0 }

			Write-Host "        Total: $(($Dataset_Hardware | Measure-Object).Count)"
			Write-Host "        Errors: $(($Temp_Hardware_Errors | Measure-Object).Count)"
		}
		catch {
			Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
		}

	# Display Hardware with Errors
		foreach ($Item in $Temp_Hardware_Errors) {

			try {
				Write-Host "    - $($Item.Name)"
				Write-Host "        Error Code: $($Item.ConfigManagerErrorCode)"
				Write-Host "        Error Message: $($Hashtable_Win32PnpEntity_ErrorCodes[[string]$Item.ConfigManagerErrorCode])"
			}
			catch {
				Write-vr_ErrorCode -Code 1702 -Exit $true -Object $PSItem
			}
		}

	# Determine Script Result
		$Meta_Script_Result = $true,"Success"

	Write-Host "    - Complete"
	Write-Host ""

#EndRegion Execution
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Output
#   Error Range: 1800 - 1899
#--------------------------------------------------------------------------------------------
#Region Output

	Write-Host "  Output"

	# Set Task Sequence Variables
		Write-Host "    - Set Task Sequence Variables"

		try {
			if ((($Temp_Hardware_Errors | Measure-Object).Count) -gt 0) {
				$Object_MECM_TSEnvironment.Value("$($Name_TSVariable_ValidationStatus)") = "Errors Found"
			}
			else {
				$Object_MECM_TSEnvironment.Value("$($Name_TSVariable_ValidationStatus)") = "Success"
			}
			$Object_MECM_TSEnvironment.Value("$($Name_TSVariable_TotalHardware)") = ($Dataset_Hardware | Measure-Object).Count
			$Object_MECM_TSEnvironment.Value("$($Name_TSVariable_TotalErrors)")   = ($Temp_Hardware_Errors | Measure-Object).Count

			Write-Host "        $($Name_TSVariable_ValidationStatus): $($Object_MECM_TSEnvironment.Value("$($Name_TSVariable_ValidationStatus)"))"
			Write-Host "        $($Name_TSVariable_TotalHardware): $($Object_MECM_TSEnvironment.Value("$($Name_TSVariable_TotalHardware)"))"
			Write-Host "        $($Name_TSVariable_TotalErrors): $($Object_MECM_TSEnvironment.Value("$($Name_TSVariable_TotalErrors)"))"
			Write-Host "        Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 1801 -Exit $true -Object $PSItem
		}

	# Write Log File
		Write-Host "    - Write Log File"

		try {
			foreach ($Item in $Dataset_Hardware) {
				$Temp_Log_Entry = "Device Name: $($Item.Name)
  Status Code: $($Item.ConfigManagerErrorCode)
  Status Message: $($Hashtable_Win32PnpEntity_ErrorCodes[[string]$Item.ConfigManagerErrorCode])
"

			Out-File -FilePath $Path_HardwareInfo_Log -InputObject $Temp_Log_Entry -Append -ErrorAction Stop
		}
		Write-Host "          Success: Logged Detailed Hardware Information"
			Write-Host "        Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 1801 -Exit $true -Object $PSItem
		}

	Write-Host "    - Complete"
	Write-Host ""

#EndRegion Output
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Cleanup
#   Error Range: 1900 - 1999
#--------------------------------------------------------------------------------------------
#Region Cleanup

	Write-Host "  Cleanup"

	# Confirm Cleanup
		Write-Host "    - Confirm Cleanup"

		do {
			$Temp_Cleanup_UserInput = Read-Host -Prompt "        Do you want to automatically clean up the unecessary content from this script? [Y]es or [N]o"
		} until (
			$Temp_Cleanup_UserInput -in "Y","Yes","N","No"
		)

	# [StepName]
		Write-Host "    - [StepName]"

		try {
			if ($Temp_Cleanup_UserInput -in "Y", "Yes") {

				Write-Host "        Status: Success"
			}
			else {
				Write-Host "            Status: Skipped"
			}
		}
		catch {
			Write-vr_ErrorCode -Code 1901 -Exit $true -Object $PSItem
		}

	Write-Host "    - Complete"
	Write-Host ""

#EndRegion Cleanup
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Footer
#--------------------------------------------------------------------------------------------
#Region Footer

	# Gather Data
		$Meta_Script_Complete_DateTime  = Get-Date
		$Meta_Script_Complete_TimeSpan  = New-TimeSpan -Start $Meta_Script_Start_DateTime -End $Meta_Script_Complete_DateTime

	# Output
		Write-Host ""
		Write-Host "------------------------------------------------------------------------------"
		Write-Host "  Script Result: $($Meta_Script_Result[0])"
		Write-Host "  Script Started: $($Meta_Script_Start_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
		Write-Host "  Script Completed: $($Meta_Script_Complete_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
		Write-Host "  Total Time: $($Meta_Script_Complete_TimeSpan.Days) days, $($Meta_Script_Complete_TimeSpan.Hours) hours, $($Meta_Script_Complete_TimeSpan.Minutes) minutes, $($Meta_Script_Complete_TimeSpan.Seconds) seconds, $($Meta_Script_Complete_TimeSpan.Milliseconds) milliseconds"
		Write-Host "------------------------------------------------------------------------------"
		Write-Host "  End of Script"
		Write-Host "------------------------------------------------------------------------------"

#EndRegion Footer
#--------------------------------------------------------------------------------------------

# Stop-Transcript
Return $Meta_Script_Result[1]