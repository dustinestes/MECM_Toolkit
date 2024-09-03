#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
  # [string]$SiteCode,                  # 'ABC'
  # [string]$SMSProvider,               # '[ServerFQDN]'
  [string]$Drive,                       # '%OSDTargetSystemDrive%'
  [string]$InWinPE,                     # '%_SMSTSInWinPE%'
  [string]$Enabled                      # 'True' or 'False'
)

#--------------------------------------------------------------------------------------------
Start-Transcript -Path "C:\VividRock\MECM Toolkit\Logs\Task Sequences\Windows - Configure Mouse Suppression.log" -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

  Write-Host "------------------------------------------------------------------------------"
  Write-Host "  MECM Toolkit - Task Sequences - Windows - Configure Mouse Suppression"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host "    Author:     Dustin Estes"
  Write-Host "    Company:    VividRock"
  Write-Host "    Date:       2024-0-29"
  Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
  Write-Host "    Purpose:    Enable or disable the Mouse Suppression configuration."
  Write-Host "    Links:      https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/os-deployment/no-mouse-cursor-during-osd-task-sequence"
  Write-Host "    Template:   1.1"
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
    # $Param_SiteCode         = $SiteCode
    # $Param_SMSProvider      = $SMSProvider
    $Param_Drive            = $Drive
    $Param_InWinPe          = $InWinPe
    $Param_Enabled          = $Enabled

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

  # Paths

  # Files

  # Hashtables
    $Hashtable_Offline = @{
      "FilePath"      = "$($Param_Drive)Windows\System32\config\Software"
      "LoadPath"      = "HKLM\Offline"
    }

  # Arrays

  # Registry
    $Registry_Enable  = @{
      "Path"          = ""
      "PathWin"       = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
      "PathWinPE"     = "HKLM:\Offline\Microsoft\Windows\CurrentVersion\Policies\System"
      "Name"          = "EnableCursorSuppression"
      "Value"         = "1"
      "PropertyType"  = "DWORD"
    }

    $Registry_Disable = @{
      "Path"          = ""
      "PathWin"       = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
      "PathWinPE"     = "HKLM:\Offline\Microsoft\Windows\CurrentVersion\Policies\System"
      "Name"          = "EnableCursorSuppression"
      "Value"         = "0"
      "PropertyType"  = "DWORD"
    }

  # WMI

  # Datasets

  # Temporary

  # Output to Log
    Write-Host "    - Parameters"
    foreach ($Item in (Get-Variable -Name "Param_*")) {
      Write-Host "        $(($Item.Name) -replace 'Param_',''): $($Item.Value)"
    }
    Write-Host "    - Offline Settings"
    foreach ($Item in (Get-Variable -Name "Hashtable_*")) {
      foreach ($SubItem in $Item.Value.GetEnumerator()) {
        Write-Host "        $($SubItem.Key): $($SubItem.Value)"
      }
    }
    Write-Host "    - Registry"
    foreach ($Item in (Get-Variable -Name "Registry_*")) {
      Write-Host "        $(($Item.Name) -replace 'Registry_','')"
      foreach ($SubItem in $Item.Value.GetEnumerator()) {
        Write-Host "            $($SubItem.Key): $($SubItem.Value)"
      }
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

	# Write-Host "  Environment"

	# # Create Client COM Object
	# 	Write-Host "    - Create Client COM Object"

	# 	try {
	# 		$Object_MECM_Client = New-Object -ComObject Microsoft.SMS.Client
	# 		Write-Host "        Status: Success"
	# 	}
	# 	catch {
	# 		Write-vr_ErrorCode -Code 1401 -Exit $true -Object $PSItem
	# 	}

	# # Create TSEnvironment COM Object
	# 	Write-Host "    - Create TSEnvironment COM Object"

	# 	try {
	# 		$Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment
	# 		Write-Host "        Status: Success"
	# 	}
	# 	catch {
	# 		Write-vr_ErrorCode -Code 1402 -Exit $true -Object $PSItem
	# 	}

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

	# Write-Host "    - Complete"
	# Write-Host ""

#EndRegion Environment
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validation
#   Error Range: 1500 - 1599
#--------------------------------------------------------------------------------------------
#Region Validation

	Write-Host "  Validation"

  # # Registry Keys
  #   Write-Host "    - Registry Keys"

  #   try {
  #     foreach ($Item in (Get-Variable -Name "Registry_*")) {
  #       Write-Host "        Path: $($Item.Value.Path)"

  #       if (Test-Path -Path $Item.Value.Path) {
  #         Write-Host "            Status: Exists"
  #       }
  #       else {
  #         New-Item -Path $Item.Value.Path -ItemType Directory -Force | Out-Null
  #         Write-Host "            Status: Created"
  #       }
  #     }
  #   }
  #   catch {
  #     Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
  #   }

  # Offline Hive Exists
    Write-Host "    - Offline Hive Exists"

    try {
      if ($Param_InWinPE -eq "True") {
        if (Test-Path -Path $Hashtable_Offline.FilePath) {
          Write-Host "            Status: Exists"
        }
        else {
          Write-Host "            Status: Not Exists"
          Throw "The offline registry hive could not be found"
        }
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

	# Write-Host "  Data Gather"

	# # [StepName]
	# 	Write-Host "    - [StepName]"

	# 	try {

	# 		Write-Host "        Status: Success"
	# 	}
	# 	catch {
	# 		Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
	# 	}

	# # [StepName]
	# 	foreach ($Item in (Get-Variable -Name "Path_*")) {
	# 		Write-Host "    - $($Item.Name)"

	# 		try {

	# 			Write-Host "        Status: Success"
	# 		}
	# 		catch {
	# 			Write-vr_ErrorCode -Code 1602 -Exit $true -Object $PSItem
	# 		}
	# 	}

	# Write-Host "    - Complete"
	# Write-Host ""

#EndRegion Data Gather
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1700 - 1799
#--------------------------------------------------------------------------------------------
#Region Execution

	Write-Host "  Execution"

  # Load Offline Registry Hive
    Write-Host "    - Load Offline Registry Hive"

    try {
      if ($Param_InWinPe -eq "True") {
        Write-Host "        WinPE: $($Param_InWinPe)"

        $Temp_Expression = "reg load $($Hashtable_Offline.LoadPath) $($Hashtable_Offline.FilePath)"

        $Registry_Enable.Path = $Registry_Enable.PathWinPE
        $Registry_Disable.Path = $Registry_Disable.PathWinPE

        $Result = Invoke-Expression -Command $Temp_Expression
        if ($LASTEXITCODE -eq 0) {
          Write-Host "        Status: Success"
        } else {
          throw "        Status: Failed. Exit code: $($LASTEXITCODE)"
        }
      }
      else {
        $Registry_Enable.Path = $Registry_Enable.PathWin
        $Registry_Disable.Path = $Registry_Disable.PathWin
        Write-Host "        Status: Skipped"
      }
    }
    catch {
      Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
    }

	# Disable Mouse Suppression
    if ($Param_Enabled -eq "False") {
      try {
		    Write-Host "    - Disable Mouse Suppression"

        if (Test-Path -Path $Registry_Disable.Path) {
          Set-ItemProperty -Path $Registry_Disable.Path -Name $Registry_Disable.Name -Value $Registry_Disable.Value
          Write-Host "        Status: Updated"
        }
        else {
          New-ItemProperty -Path $Registry_Disable.Path -Name $Registry_Disable.Name -Value $Registry_Disable.Value -PropertyType $Registry_Disable.PropertyType
          Write-Host "        Status: Created"
        }
			}
			catch {
				Write-vr_ErrorCode -Code 1702 -Exit $true -Object $PSItem
			}
    }

	# Enable Mouse Suppression
    if ($Param_Enabled -eq "True") {
      try {
		    Write-Host "    - Enable Mouse Suppression"

        if (Test-Path -Path $Registry_Enable.Path) {
          Set-ItemProperty -Path $Registry_Enable.Path -Name $Registry_Enable.Name -Value $Registry_Enable.Value
          Write-Host "        Status: Updated"
        }
        else {
          New-ItemProperty -Path $Registry_Enable.Path -Name $Registry_Enable.Name -Value $Registry_Enable.Value -PropertyType $Registry_Enable.PropertyType
          Write-Host "        Status: Created"
        }
			}
			catch {
				Write-vr_ErrorCode -Code 1703 -Exit $true -Object $PSItem
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

	# Write-Host "  Output"

	# # [StepName]
	# 	Write-Host "    - [StepName]"

	# 	try {

	# 		Write-Host "        Status: Success"
	# 	}
	# 	catch {
	# 		Write-vr_ErrorCode -Code 1801 -Exit $true -Object $PSItem
	# 	}

	# Write-Host "    - Complete"
	# Write-Host ""

#EndRegion Output
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Cleanup
#   Error Range: 1900 - 1999
#--------------------------------------------------------------------------------------------
#Region Cleanup

	Write-Host "  Cleanup"

	# # Confirm Cleanup
	# 	Write-Host "    - Confirm Cleanup"

	# 	do {
	# 		$Temp_Cleanup_UserInput = Read-Host -Prompt "        Do you want to automatically clean up the unecessary content from this script? [Y]es or [N]o"
	# 	} until (
	# 		$Temp_Cleanup_UserInput -in "Y","Yes","N","No"
	# 	)

  # Run Garbage Collector
		Write-Host "    - Run Garbage Collector"

		try {
      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
      Start-Sleep -Seconds 5
      Write-Host "        Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 1901 -Exit $true -Object $PSItem
		}

	# Unload Offline Registry Hive
		Write-Host "    - Unload Offline Registry Hive"

		try {
      if ($Param_InWinPe -eq "True") {
        $Temp_Expression = "reg unload $($Hashtable_Offline.LoadPath)"
        $Result = Invoke-Expression -Command $Temp_Expression
        if ($LASTEXITCODE -eq 0) {
            Write-Host "        Status: Success"
        } else {
            throw "        Status: Failed. Exit code: $($LASTEXITCODE)"
        }
      }
      else {
          Write-Host "        Status: Skipped"
      }
		}
		catch {
			Write-vr_ErrorCode -Code 1902 -Exit $true -Object $PSItem
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

Stop-Transcript
Return $Meta_Script_Result[1]