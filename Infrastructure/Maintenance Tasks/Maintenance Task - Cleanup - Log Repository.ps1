#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
  # [string]$SiteCode,                  # 'ABC'
  # [string]$SMSProvider,               # '[ServerFQDN]'
  [string]$Path,                        # '\\[ServerFQDN]\[Share]'
  [int]$Depth,                          # '2'
  [int]$RetentionDays,                  # '30'
  [string]$Criteria,                    # 'CreationTime','CreationTimeUtc','LastAccessTime','LastAccessTimeUtc','LastWriteTime','LastWriteTimeUtc'
  [string]$OutputDir,                   # '\\[URI]\Share'
  [string]$OutputName                   # 'Cleanup - Log Repository - Task Sequence Logs'
)

#--------------------------------------------------------------------------------------------
Start-Transcript -Path "$($OutputDir)\$($OutputName).log" -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

  Write-Host "------------------------------------------------------------------------------"
  Write-Host "  MECM Toolkit - Maintenance Tasks - Cleanup - Log Repository"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host "    Author:     Dustin Estes"
  Write-Host "    Company:    VividRock"
  Write-Host "    Date:       2024-09-15"
  Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
  Write-Host "    Purpose:    Removes log directories that are older than the provided days"
  Write-Host "                of retention or are empty."
  Write-Host "    Links:      None"
  Write-Host "    Template:   1.1"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host ""

  <#
    How To Use:
    Note: Perform all of the below steps on the Primary Site Server

    Create Source Content
      1. Save this script to a directory accessible by the Primary Site Server
        i.e. \\[servername]\[share]\VividRock\MECM Toolkit\Maintenance Tasks\Maintenance Task - Cleanup - Log Repository.ps1

    Create Scheduled Task
      1. Create Folder Structure: Task Scheduler Library / [CompanyName] / MECM / Maintenance Tasks
      2. Create Scheduled Task
        General Tab
          Name: Cleanup - Log Repository - [Name of Log Folder To Cleanup]
          Description: This script runs as a Scheduled Task and performs the tasks necessary to cleanup old log directories based on the retention days defined.
          User Account: SYSTEM
          Run Option: Run whether user is logged on or not
        Triggers Tab
          Note: Set this to run on a schedule that meets your organization's needs.
          Recommended: Ever 1 days @ 23:00 Local Time
        Action Tab
          Action: Start a Program
            Program/Script: powershell.exe
            Arguments: -NoProfile -NoLogo -WindowStyle Hidden -ExecutionPolicy Bypass -File "" -Path "" -Depth "" -RetentionDays "" -Criteria "" -OutputDir "" -OutputName ""
            Start In: "\\[pathtofile]"

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
    $Param_Path             = $Path
    $Param_Depth            = $Depth
    $Param_RetentionDays    = $RetentionDays
    $Param_Criteria         = $Criteria
    $Param_OutputDir        = $OutputDir
    $Param_OutputName       = $OutputName

  # Metadata
    $Meta_Script_Start_DateTime     = Get-Date
    $Meta_Script_Complete_DateTime  = $null
    $Meta_Script_Complete_TimeSpan  = $null
    $Meta_Script_Execution_User     = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $Meta_Script_Result             = $false,"Failure"

  # Preferences
    $ErrorActionPreference        = "Stop"
    $CMPSSuppressFastNotUsedCheck = $true

  # Names

  # Paths
    # $Path_AdminService_ODataRoute = "https://$($Param_SMSProvider)/AdminService/v1.0/"
    # $Path_AdminService_WMIRoute   = "https://$($Param_SMSProvider)/AdminService/wmi/"

  # Files

  # Hashtables

  # Arrays
    $Dataset_Logging_Directories_Results = @()

  # Registry

  # WMI

  # Datasets

  # Temporary

  # Output to Log
    Write-Host "    - Parameters"
    foreach ($Item in (Get-Variable -Name "Param_*")) {
      Write-Host "        $(($Item.Name) -replace 'Param_',''): $($Item.Value)"
    }
    Write-Host "    - Temporary"
    foreach ($Item in (Get-Variable -Name "Temp_*")) {
      Write-Host "        $(($Item.Name) -replace 'Temp_',''): $($Item.Value)"
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
            Stop-Transcript -ErrorAction SilentlyContinue
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

  # # API Routes
	# 	Write-Host "    - API Routes"

	# 	try {
	# 		foreach ($Item in (Get-Variable -Name "Path_AdminService_*")) {
	# 			Write-Host "        Route: $($Item.Value)"

	# 			$Temp_API_Result = Invoke-RestMethod -Uri $Item.Value -Method Get -ContentType "Application/Json" -UseDefaultCredentials
	# 			if ($Temp_API_Result) {
	# 				Write-Host "            Status: Success"
	# 			}
	# 			else {
	# 				Write-Host "            Status: Error"
	# 				Throw
	# 			}
	# 		}
	# 	}
	# 	catch {
	# 		Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
	# 	}

  # Directory Path
		Write-Host "    - Directory Path: $($Param_Path)"

		try {
      if (Test-Path -Path "filesystem::$($Param_Path)") {
        Write-Host "        Status: Exists"
      }
      else {
        Throw "The provided directory path was not found"
      }
		}
		catch {
			Write-vr_ErrorCode -Code 1502 -Exit $true -Object $PSItem
		}

  # Output Path
		Write-Host "    - Output Path: $($Param_OutputDir)"

		try {
      if (Test-Path -Path "filesystem::$($Param_OutputDir)") {
        Write-Host "        Status: Exists"
      }
      else {
        New-Item -Path $Param_OutputDir -ItemType Directory -Force | Out-Null
        Write-Host "        Status: Created"
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

	# # [WMIClassName]
  #   Write-Host "    - [WMIClassName]"

  #   try {
  #     $Dataset_[WMIClassName] = (Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute)[WMIClassName]" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value
  #     Write-Host "        Status: Success"
  #   }
  #   catch {
  #     Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
  #   }

	# # [OdataName]
  #   Write-Host "    - [OdataName]"

  #   try {
  #     $Dataset_[OdataName] = (Invoke-RestMethod -Uri "$($Path_AdminService_ODataRoute)[OdataName]" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value
  #     Write-Host "        Status: Success"
  #   }
  #   catch {
  #     Write-vr_ErrorCode -Code 1602 -Exit $true -Object $PSItem
  #   }

  # Calculate Retention Date
    Write-Host "    - Calculate Retention Date"

    try {
      if ($Param_Criteria -like "*Utc") {
        Write-Host "        UTC: True"
        $Temp_RetentionDays_Date = ((Get-Date).AddDays(-$($Param_RetentionDays))).ToUniversalTime()
        Write-Host "        Retention Date: $($Temp_RetentionDays_Date)"
      }
      else {
        Write-Host "        UTC: False"
        $Temp_RetentionDays_Date = (Get-Date).AddDays(-$($Param_RetentionDays))
      }

      Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1603 -Exit $true -Object $PSItem
    }

	# Get Directories
		Write-Host "    - Get Directories"

		try {
      $Dataset_Logging_Directories = Get-ChildItem -Path $Param_Path -Depth $Param_Depth -Directory -Recurse # | Where-Object -FilterScript { $_.Name -like "202*" }

      foreach ($Item in $Dataset_Logging_Directories) {
        # Create Custom Objects
          $Temp_Logging_Directory = [PSCustomObject]@{
            "Path"          = $Item.FullName
            # "Parent"        = $Item.Parent
            "Name"          = $Item.BaseName
            "$Param_Criteria" = $Item."$($Param_Criteria)"
            "Depth"         = $Item.FullName.Replace($Param_Path,"").Trim([System.IO.Path]::DirectorySeparatorChar).Split([System.IO.Path]::DirectorySeparatorChar).Count - 1
            "Folders"       = $null
            "Files"         = $null
            "Size(MB)"      = $null
            "Remove"        = $null
            "Reason"        = $null
            "Status"        = $null
          }

        # Add Object to Array
          $Dataset_Logging_Directories_Results += $Temp_Logging_Directory
      }

			Write-Host "        Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 1604 -Exit $true -Object $PSItem
		}

	# Analyze Removal Criteria
    Write-Host "    - Analyze Removal Criteria"

    try {
      foreach ($Item in $Dataset_Logging_Directories_Results) {
        # Retention Days Analysis
          if ($Item."$($Param_Criteria)" -lt $Temp_RetentionDays_Date) {
            $Item.Remove = $true
            $Item.Reason = "Age"
            $Item.Status = "Pending Removal"
          }
          else {
            $Item.Remove = $false
            $Item.Reason = "Age"
            $Item.Status = "Skipped"
          }

        # Ignore Shallow Directories
          if ($Item.Depth -lt $Param_Depth) {
            $Item.Remove = $false
            $Item.Reason = "Depth"
            $Item.Status = "Skipped"
          }

        # Remove Shallow Directories if Empty
          if ((($Item.Depth -lt $Param_Depth) -and ($Item.Depth -gt 0)) -and ((Get-ChildItem -Path $Item.Path).Count -eq 0)) {
            $Item.Remove = $true
            $Item.Reason = "Empty"
            $Item.Status = "Pending Removal"
          }
      }

      Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1605 -Exit $true -Object $PSItem
    }

  # Get Directory Measurements
    Write-Host "    - Get Directory Measurements"

    try {
      foreach ($Item in ($Dataset_Logging_Directories_Results | Where-Object -Property "Remove" -eq $true)) {
        if ($Item.Depth -eq $Param_Depth) {
          $Temp_Logging_Directory_Measure  = Get-ChildItem -Path $Item.Path -Recurse
          $Item."Folders"     = ($Temp_Logging_Directory_Measure | Where-Object -Property PSIsContainer -eq $true).Count
          $Item."Files"       = ($Temp_Logging_Directory_Measure | Where-Object -Property PSIsContainer -eq $false).Count
          if (($Temp_Logging_Directory_Measure | Where-Object -Property PSIsContainer -eq $false).Count -gt 0) {
            $Item."Size(MB)"    = ($Temp_Logging_Directory_Measure | Measure-Object -Sum Length).Sum / 1mb
          }
          else {
            $Item."Size(MB)"    = 0
          }
        }
        else {
          $Item."Folders"     = "-"
          $Item."Files"       = "-"
          $Item."Size(MB)"    = "0"
        }
      }

      Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1606 -Exit $true -Object $PSItem
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

	# Remove Folders
    Write-Host "    - Remove Folders"

    try {
      $Temp_Logging_Directory_Count = ($Dataset_Logging_Directories_Results | Where-Object -Property Remove -eq $true | Measure-Object).Count
      Write-Host "        Count: $($Temp_Logging_Directory_Count)"
      if ($Temp_Logging_Directory_Count -eq 0) {
        Write-Host "        Status: Skipped"
      }
      else {
        foreach ($Item in ($Dataset_Logging_Directories_Results | Where-Object -Property Remove -eq $true)) {
          Write-Host "        $($Item.Path)"
          Remove-Item -LiteralPath $Item.Path -Recurse -Force
          $Item.Status = "Removed"
        }
        Write-Host "        Space Recovered (GB): $([System.Math]::Round(($Dataset_Logging_Directories_Results | Where-Object -Property "Remove" -eq $true | Measure-Object -Sum "Size(MB)").Sum / 1GB, 2))"
        Write-Host "        Status: Success"
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

	Write-Host "  Output"

	# Output Results (CSV)
		Write-Host "    - Output Results (CSV)"

		try {
      $Temp_Output_CSVFile = "$($Param_OutputDir)\$($Param_OutputName).csv"
      Write-Host "        Path: $($Temp_Output_CSVFile)"
      $Dataset_Logging_Directories_Results | ConvertTo-Csv | Out-File -FilePath $Temp_Output_CSVFile
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