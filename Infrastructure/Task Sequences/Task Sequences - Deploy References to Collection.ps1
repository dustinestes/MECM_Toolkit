
#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
  [string]$TaskSequence,              # 'SUB - Build Type - MECM Development - 1.1.1'
  [string]$Collection,                # 'AM - Build Type - MECM Development'
  [string]$SiteCode,                  # 'ABC'
  [string]$SMSProvider                # '[ServerFQDN]'
)

#--------------------------------------------------------------------------------------------
Start-Transcript -Path "C:\VividRock\MECM Toolkit\Logs\Task Sequences\Deploy References to Collection.log" -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

  Write-Host "------------------------------------------------------------------------------"
  Write-Host "  MECM Toolkit - Task Sequences - Deploy References to Collection"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host "    Author:     Dustin Estes"
  Write-Host "    Company:    VividRock"
  Write-Host "    Date:       2024-08-26"
  Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
  Write-Host "    Purpose:    Deploys all of the packages and applications associated with a"
  Write-Host "                Task Sequence to the specified collection."
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
    $Param_SiteCode         = $SiteCode
    $Param_SMSProvider      = $SMSProvider
    $Param_TaskSequence     = $TaskSequence
    $Param_Collection       = $Collection

  # Metadata
    $Meta_Script_Start_DateTime     = Get-Date
    $Meta_Script_Complete_DateTime  = $null
    $Meta_Script_Complete_TimeSpan  = $null
    $Meta_Script_Execution_User     = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $Meta_Script_Result = $false,"Failure"

	# Preferences
		$ErrorActionPreference = "Stop"
		$CMPSSuppressFastNotUsedCheck = $true

  # Names

  # Paths
    $Path_AdminService_ODataRoute = "https://$($Param_SMSProvider)/AdminService/v1.0/"
    $Path_AdminService_WMIRoute   = "https://$($Param_SMSProvider)/AdminService/wmi/"

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
    Write-Host "    - Paths"
    foreach ($Item in (Get-Variable -Name "Path_*")) {
      Write-Host "        $(($Item.Name) -replace 'Path_',''): $($Item.Value)"
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

	# # Create TSEnvironment COM Object
	# 	Write-Host "    - Create TSEnvironment COM Object"

	# 	try {
	# 		$Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment
	# 		Write-Host "        Status: Success"
	# 	}
	# 	catch {
	# 		Write-vr_ErrorCode -Code 1402 -Exit $true -Object $PSItem
	# 	}

	# Connect to MECM Infrastructure
		Write-Host "    - Connect to MECM Infrastructure"

		try {
			if (Test-Connection -ComputerName $Param_SMSProvider -Count 2 -Quiet) {
				# Import the PowerShell Module
					Write-Host "        Import the PowerShell Module"

					if((Get-Module ConfigurationManager) -in $null,"") {
						Import-Module -Name "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"
						Write-Host "            Status: Success"
					}
					else {
						Write-Host "            Status: Already Imported"
					}

				# Create the Site Drive
					Write-Host "        Create the Site Drive"

					if((Get-PSDrive -Name $Param_SiteCode -PSProvider CMSite) -in $null,"") {
						New-PSDrive -Name $Param_SiteCode -PSProvider CMSite -Root $Param_SMSProvider
						Write-Host "            Status: Success"
					}
					else {
						Write-Host "            Status: Already Exists"
					}

				# Set the Location
					Write-Host "        Set the Location"

					if ((Get-Location).Path -ne "$($Param_SiteCode):\") {
						Set-Location "$($Param_SiteCode):\"
						Write-Host "            Status: Success"
					}
					else {
						Write-Host "            Status: Already Set"
					}
			}
			else {
				Write-Host "        Status: MECM Server Unreachable"
				Throw "Status: MECM Server Unreachable"
			}
		}
		catch {
			Write-vr_ErrorCode -Code 1403 -Exit $true -Object $PSItem
		}

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

	# API Routes
		Write-Host "    - API Routes"

		try {
			foreach ($Item in (Get-Variable -Name "Path_AdminService_*")) {
				Write-Host "        Route: $($Item.Value)"

				$Temp_API_Result = Invoke-RestMethod -Uri $Item.Value -Method Get -ContentType "Application/Json" -UseDefaultCredentials
				if ($Temp_API_Result) {
					Write-Host "            Status: Success"
				}
				else {
					Write-Host "            Status: Error"
					Throw
				}
			}
		}
		catch {
			Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
		}

	# Task Sequence Exists
		Write-Host "    - Task Sequence Exists"

		try {
			if (Get-CMTaskSequence -Name $Param_TaskSequence -Fast) {
					Write-Host "        Status: Success"
			}
			else {
					Write-Host "        Status: Error"
					Throw
			}
		}
		catch {
			Write-vr_ErrorCode -Code 1502 -Exit $true -Object $PSItem
		}

	# Collection Exists
		Write-Host "    - Collection Exists"

		try {
			if (Get-CMCollection -Name $Param_Collection) {
					Write-Host "        Status: Success"
			}
			else {
					Write-Host "        Status: Error"
					Throw
			}
		}
		catch {
			Write-vr_ErrorCode -Code 1503 -Exit $true -Object $PSItem
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

	# Task Sequence References
		Write-Host "    - Task Sequence References"

		try {
			$Dataset_TaskSequence_References = (Get-CMTaskSequence -Name $Param_TaskSequence).References
			Write-Host "        Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
		}

	# Collection
		Write-Host "    - Collection"

		try {
			$Object_Collection = Get-CMCollection -Name $Param_Collection
			Write-Host "        Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 1602 -Exit $true -Object $PSItem
		}

	# Applications
		Write-Host "    - Applications"

		try {
			$Dataset_Applications = (Invoke-RestMethod -Uri "$($Path_AdminService_ODataRoute)Application" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value
			Write-Host "        Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 1603 -Exit $true -Object $PSItem
		}

	# Packages
		Write-Host "    - Packages"

		try {
			$Dataset_Packages = (Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute)SMS_Package" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value
			Write-Host "        Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 1604 -Exit $true -Object $PSItem
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

	# Create Deployments
		foreach ($Item in $Dataset_TaskSequence_References) {
			Write-Host "    - $($Item.Package)"

			try {
				switch ($Item.Type) {
					'0' {
						Write-Host "      Type: Package"
						$Temp_Reference = $Dataset_Packages | Where-Object -Property PackageID -eq $Item.Package
						Write-Host "      Name: $($Temp_Reference.Name)"

						if ($Item.Program -in "",$null,"*") {
							Write-Host "      Status: Skipped,  No Program Defined"
						}
						else {
							$Params= $null
							$Params = @{
								'PackageId'         = $Item.Package
								'ProgramName'       = $Item.Program
								'Collection'        = $Object_Collection
								'StandardProgram'   = $true
								'DeployPurpose'     = "Available"
								# 'RunFromSoftwareCenter' = $true
								'ErrorAction'       = "Stop"
							}

							New-CMPackageDeployment @Params | Out-Null

							Write-Host "      Status: Success"
						}

					}
					'1' {
						Write-Host "      Type: Application"
						$Temp_Reference = $Dataset_Applications | Where-Object -Property ModelName -eq $Item.Package
						Write-Host "      Name: $($Temp_Reference.DisplayName)"

						$Params = @{
							'Name'              = $Temp_Reference.DisplayName
							'Collection'        = $Object_Collection
							'DeployAction'      = "Install"
							'DeployPurpose'     = "Available"
							'AllowRepairApp'    = $true
							'ApprovalRequired'  = $false
							'UserNotification'  = "DisplaySoftwareCenterOnly"
							'ErrorAction'       = "Stop"
						}

						try {
							New-CMApplicationDeployment @Params | Out-Null
							Write-Host "      Status: Success"
						}
						catch [System.InvalidOperationException] {
							Write-Host "      Status: Already Deployed"
						}
						catch {
							Write-Host "      Status: Failed"
						}
					}
					Default {Write-Host "      Type: Unknown"}
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

Stop-Transcript
Return $Meta_Script_Result[1]