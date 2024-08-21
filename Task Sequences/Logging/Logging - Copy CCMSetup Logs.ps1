#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
	[string]$Source,                    # 'C:\Windows\CCMSetup\Logs'
	[string]$Destination                # '%vr_Directory_TS_CCMSetup%'
)

#--------------------------------------------------------------------------------------------
Start-Transcript -Path "C:\VividRock\MECM Toolkit\Logs\Task Sequences\Logging - Copy CCMSetup Logs.log" -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

	Write-Host "------------------------------------------------------------------------------"
	Write-Host "  VividRock - MECM Toolkit - Task Sequences - Logging - Copy CCMSetup Logs"
	Write-Host "------------------------------------------------------------------------------"
	Write-Host "    Author:     Dustin Estes"
	Write-Host "    Company:    VividRock"
	Write-Host "    Date:       [Date]"
	Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
	Write-Host "    Purpose:   This script will copy the specified CCMSetup logs from their"
	Write-Host "               original location into the local Log Repository for"
	Write-Host "               point-in-time analysis."
	Write-Host "    Links:      [Links to Helpful Source Material]"
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
		$Param_Source       = $Source
		$Param_Destination	= $Destination

	# Metadata
		$Meta_Script_Start_DateTime     = Get-Date
		$Meta_Script_Complete_DateTime  = $null
		$Meta_Script_Complete_TimeSpan  = $null
		$Meta_Script_Execution_User     = [System.Security.Principal.WindowsIdentity]::GetCurrent()
		$Meta_Script_Result = $false,"Failure"

	# Names

	# Paths

	# Files

	# Hashtables

	# Arrays
		$Array_CCMSetupLogNames = @(
			'ccmsetup*';              				# Records ccmsetup tasks for client setup, client upgrade, and client removal. Can be used to troubleshoot client installation problems.
			'Client*';              					# Unknown, log located on client device but not defined within Microsoft Docs Log Reference
			'MicrosoftPolicyPlatformSetup*'		# Log for this prerequisite item
		)

	# Registry

	# WMI

	# Datasets

	# Temporary

	# Output to Log
		Write-Host "    - Parameters"
		foreach ($Item in (Get-Variable -Name "Param_*")) {
			Write-Host "        $(($Item.Name) -replace 'Param_',''): $($Item.Value)"
		}
		Write-Host "    - Logs to Copy"
    foreach ($Item in $Array_CCMSetupLogNames) {
      Write-Host "        $($Item)"
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
	# 		$Object_MECM_Client = New-Object -ComObject Microsoft.SMS.Client -ErrorAction Stop
	# 		Write-Host "        Status: Success"
	# 	}
	# 	catch {
	# 		Write-vr_ErrorCode -Code 1401 -Exit $true -Object $PSItem
	# 	}

	# # Create TSEnvironment COM Object
	# 	Write-Host "    - Create TSEnvironment COM Object"

	# 	try {
	# 		$Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
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

	# 				if((Get-Module ConfigurationManager -ErrorAction Stop) -in $null,"") {
	# 					Import-Module -Name "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" -ErrorAction Stop
	# 					Write-Host "            Status: Success"
	# 				}
	# 				else {
	# 					Write-Host "            Status: Already Imported"
	# 				}

	# 			# Create the Site Drive
	# 				Write-Host "        Create the Site Drive"

	# 				if((Get-PSDrive -Name $Param_SiteCode -PSProvider CMSite -ErrorAction Stop) -in $null,"") {
	# 					New-PSDrive -Name $Param_SiteCode -PSProvider CMSite -Root $Param_SMSProvider -ErrorAction Stop
	# 					Write-Host "            Status: Success"
	# 				}
	# 				else {
	# 					Write-Host "            Status: Already Exists"
	# 				}

	# 			# Set the Location
	# 				Write-Host "        Set the Location"

	# 				if ((Get-Location -ErrorAction Stop).Path -ne "$($Param_SiteCode):\") {
	# 					Set-Location "$($Param_SiteCode):\" -ErrorAction Stop
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

	# Source Directory Exists
		Write-Host "    - Source Directory Exists"

		try {
			Write-Host "        Path: $($Param_Source)"
			if (Test-Path -Path $Param_Source) {
				Write-Host "            Status: Exists"
			}
			else {
				Write-Host "            Status: Not Exists"
				Throw "Error: source directory not exists"
			}
		}
		catch {
			Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
		}

	# Destination Directory Exists
		Write-Host "    - Destination Directory Exists"

		try {
			Write-Host "        Path: $($Param_Destination)"
			if (Test-Path -Path $Param_Destination) {
				Write-Host "            Status: Exists"
			}
			else {
				New-Item -Path $Param_Destination -ItemType Directory -Force -ErrorAction Stop | Out-Null
				Write-Host "            Status: Created"
			}
		}
		catch {
			Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
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

	# Get Log Files
		Write-Host "    - Get Log Files"

		try {
			$Dataset_LogFiles = Get-ChildItem -Path $Param_Source -Recurse
			Write-Host "        Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
		}

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

	# Copy Logs
		Write-Host "    - Copy Logs"

		try {
			foreach($LogName in $Array_CCMSetupLogNames){
				Write-Host "        $($LogName)"
        $Count = 0

				foreach($LogFile in $Dataset_LogFiles){
					if($LogFile -like $LogName){
						try{
              Write-Host "          File Path: $($LogFile.FullName)"
							Copy-Item -Path $LogFile.FullName -Destination $Param_Destination -Force -Recurse -ErrorAction Stop
							Write-Host "          Status: Copied File"
              $Count ++
						}
						catch{
							Write-Host "          Status: Error Copying File"
						}
					}
				}
				if ($Count -eq 0){
					Write-Host "          Status: No Matches Found"
				}
			}
		}
		catch {
			Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
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
	# 		$Temp_Cleanup_UserInput = Read-Host -Prompt "        Do you want to automatically clean up the unecessary content from this script? [Y]es or [N]o" -ErrorAction Stop
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

Stop-Transcript
Return $Meta_Script_Result[1]