#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
#   [string]$SiteCode,                  # 'ABC'
#   [string]$SMSProvider,               # '[ServerFQDN]'
  [string]$RemoveExisting                  # 'True'
)

#--------------------------------------------------------------------------------------------
# Start-Transcript -Path "C:\VividRock\MECM Toolkit\Logs\Task Sequences\Core - Create Directory Structure.log" -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

  Write-Host "------------------------------------------------------------------------------"
  Write-Host "  MECM Toolkit - Task Sequences - Core - Create Directory Structure"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host "    Author:     Dustin Estes"
  Write-Host "    Company:    VividRock"
  Write-Host "    Date:       2024-08-27"
  Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
  Write-Host "    Purpose:    Creates all of the directory folders defined in the MECM Toolkit"
	Write-Host "   							Initialize Variables script. These folders are used for all"
	Write-Host "								logging, caching, and other operations performed by the toolkit."
  Write-Host "    Links:      None"
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
    $Param_RemoveExisting        = $RemoveExisting

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
    $Names_TSVariable_Prefix = "vr_Directory_*"

  # Paths

  # Files

  # Hashtables

  # Arrays

  # Registry

  # WMI

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

	# Write-Host "  Validation"

	# # Sub Directories
	# 	Write-Host "    - Sub Directories"

	# 	try {
	# 		foreach ($Item in (Get-Variable -Name "Path_Local_*")) {
	# 			Write-Host "        Path: $($Item.Value)"
	# 			if (Test-Path -Path $Item.Value) {
	# 				Write-Host "            Status: Exists"
	# 			}
	# 			else {
	# 				New-Item -Path $Item.Value -ItemType Directory -Force | Out-Null
	# 				Write-Host "            Status: Created"
	# 			}
	# 		}
	# 	}
	# 	catch {
	# 		Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
	# 	}

	# Write-Host "    - Complete"
	# Write-Host ""

#EndRegion Validation
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Data Gather
#   Error Range: 1600 - 1699
#--------------------------------------------------------------------------------------------
#Region Data Gather

	Write-Host "  Data Gather"

	# Get Variables
		Write-Host "    - Get Variables"

		try {
      $Dataset_TaskSequence_Variables = $Object_MECM_TSEnvironment.GetVariables() | Where-Object { $_ -like $Names_TSVariable_Prefix | Sort-Object }
      Write-Host "        Count: $(($Dataset_TaskSequence_Variables | Measure-Object).Count)"
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

	# Create Main Directories
    Write-Host "    - Create Main Directories"

    try {
      # Root Directory
        Write-Host "        Variable: vr_Directory_RootDir"
        $Temp_Variable_Value = $Object_MECM_TSEnvironment.Value("vr_Directory_RootDir")
        Write-Host "            Path: $($Temp_Variable_Value)"

        if (Test-Path -Path $Temp_Variable_Value) {
          if ($Param_RemoveExisting -in "True",$true) {
            Write-Host "            Status: Exists, Removing because RemoveExisting argument supplied"
            Remove-Item -Path $Temp_Variable_Value -Recurse -Force | Out-Null
          }
          else {
            Write-Host "            Status: Exists, Skipping removal because RemoveExisting argument not supplied"
          }
        }
        else {
          New-Item -Path $Temp_Variable_Value -ItemType Directory -Force | Out-Null
          Write-Host "            Status: Created"
        }

      # MECM Directory
        Write-Host "        Variable: vr_Directory_MECM"
        $Temp_Variable_Value = $Object_MECM_TSEnvironment.Value("vr_Directory_MECM")
        Write-Host "            Path: $($Temp_Variable_Value)"

        if (Test-Path -Path $Temp_Variable_Value) {
          Write-Host "            Status: Exists"
        }
        else {
          New-Item -Path $Temp_Variable_Value -ItemType Directory -Force | Out-Null
          Write-Host "            Status: Created"
        }
    }
    catch {
      Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
    }

	# Create Sub Directories
		Write-Host "    - Create Sub Directories"

		foreach ($Item in $Dataset_TaskSequence_Variables) {
			Write-Host "    - $($Item)"

			try {
        Write-Host "        Variable: $($Item)"
        $Temp_Variable_Value = $Object_MECM_TSEnvironment.Value($Item)
        Write-Host "            Path: $($Temp_Variable_Value)"

        if (Test-Path -Path $Temp_Variable_Value) {
          Write-Host "            Status: Exists"
        }
        else {
          New-Item -Path $Temp_Variable_Value -ItemType Directory -Force | Out-Null
          Write-Host "            Status: Created"
        }
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

	# Write-Host "  Cleanup"

	# # Confirm Cleanup
	# 	Write-Host "    - Confirm Cleanup"

	# 	do {
	# 		$Temp_Cleanup_UserInput = Read-Host -Prompt "        Do you want to automatically clean up the unecessary content from this script? [Y]es or [N]o"
	# 	} until (
	# 		$Temp_Cleanup_UserInput -in "Y","Yes","N","No"
	# 	)

	# # [StepName]
	# 	Write-Host "    - [StepName]"

	# 	try {
	# 		if ($Temp_Cleanup_UserInput -in "Y", "Yes") {

	# 			Write-Host "        Status: Success"
	# 		}
	# 		else {
	# 			Write-Host "            Status: Skipped"
	# 		}
	# 	}
	# 	catch {
	# 		Write-vr_ErrorCode -Code 1901 -Exit $true -Object $PSItem
	# 	}

	# Write-Host "    - Complete"
	# Write-Host ""

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