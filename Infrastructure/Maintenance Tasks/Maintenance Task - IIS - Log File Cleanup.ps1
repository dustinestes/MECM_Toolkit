#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
  [int]$RetentionDays,                  # '30'
  [string]$Criteria,                    # 'CreationTime','CreationTimeUtc','LastAccessTime','LastAccessTimeUtc','LastWriteTime','LastWriteTimeUtc'
  [string]$OutputDir,                   # '\\[URI]\Share'
  [string]$OutputName                   # 'IIS - Log File Cleanup'
)

#--------------------------------------------------------------------------------------------
Start-Transcript -Path "$($OutputDir)\$($OutputName).log" -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

  Write-Host "------------------------------------------------------------------------------"
  Write-Host "  MECM Toolkit - Maintenance Tasks - IIS - Log File Cleanup"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host "    Author:     Dustin Estes"
  Write-Host "    Company:    VividRock"
  Write-Host "    Date:       2025-02-09"
  Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
  Write-Host "    Purpose:    Removes log files that are older than the provided days of"
  Write-Host "                retention."
  Write-Host "    Links:      None"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host ""

<#
  How To Use:
  Note: Perform all of the below steps on the Primary Site Server

  Create Source Content
    1. Save this script to a directory accessible by the Primary Site Server
      i.e. \\[servername]\[share]\VividRock\MECM Toolkit\Maintenance Tasks\Maintenance Task - IIS - Log File Cleanup.ps1

  Create Scheduled Task
    1. Create Folder Structure: Task Scheduler Library / [CompanyName] / MECM / Maintenance Tasks
    2. Create Scheduled Task
      General Tab
        Name: IIS - Log File Cleanup
        Description: This script runs as a Scheduled Task and performs the tasks necessary to cleanup old log files based on the retention days defined.
        User Account: SYSTEM
        Run Option: Run whether user is logged on or not
      Triggers Tab
        Note: Set this to run on a schedule that meets your organization's needs.
        Recommended: Every 1 weeks @ 23:00 Local Time
      Action Tab
        Action: Start a Program
          Program/Script: powershell.exe
          Arguments: -NoProfile -NoLogo -WindowStyle Hidden -ExecutionPolicy Bypass -File "\\[Path]\Repo\Scripts\Maintenance Tasks\IIS\Maintenance Task - IIS - Log File Cleanup.ps1" -RetentionDays "30" -Criteria "CreationTimeUtc" -OutputDir "\\[Path]\Repo\Logging\Maintenance Tasks\IIS" -OutputName "Maintenance Task - IIS - Log File Cleanup"
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

  # Names

  # Paths

  # Files

  # Hashtables

  # Arrays

  # Registry

  # WMI

  # Datasets
    $Dataset_Websites = @()

  # Temporary

  # Output to Log
    Write-Host "    - Parameters"
    foreach ($Item in (Get-Variable -Name "Param_*")) {
      Write-Host "        $(($Item.Name) -replace 'Param_',''): $($Item.Value)"
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

  # Calculate Cleanup Date
  Write-Host "    - Calculate Cleanup Date"

  try {
    if ($Param_Criteria -like "*Utc") {
      Write-Host "        UTC: True"
      $Temp_CleanupDate = ((Get-Date).AddDays(-$($Param_RetentionDays))).ToUniversalTime()
      Write-Host "        Retention Date: $($Temp_CleanupDate)"
    }
    else {
      Write-Host "        UTC: False"
      $Temp_CleanupDate = (Get-Date).AddDays(-$($Param_RetentionDays))
    }

    Write-Host "        Status: Success"
  }
  catch {
    Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
  }

	# Get Websites
		Write-Host "    - Get Websites"

		try {
      foreach ($Item in $(Get-Website)) {
        Write-Host "        $($Item.name)"

        $Temp_Object = [PSCustomObject]@{
          ID                = $Item.id
          Name              = $Item.name
          LogEnabled        = $Item.logFile.enabled
          LogDirectory      = "$($Item.logFile.directory)\w3svc$($Item.id)".Replace("%SystemDrive%",$env:SystemDrive)
          SizeStart         = $null
          SizeEnd           = $null
          Files             = $null
          FilesToRemove     = $null
          SizeRemoved       = $null
        }

        $Dataset_Websites += $Temp_Object
      }
			Write-Host "        Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 1602 -Exit $true -Object $PSItem
		}

  # Get Log Files
    Write-Host "    - Get Log Files"

    foreach ($Item in $Dataset_Websites) {
			Write-Host "        $($Item.Name)"

			try {
        $Item.Files        = Get-ChildItem -Path $Item.LogDirectory -Recurse
        $Item.SizeStart    = ($Item.Files | Measure-Object -Sum Length).Sum
        Write-Host "          Directory: $($Item.LogDirectory)"
        Write-Host "          Count: $($Item.Files.Count)"
        Write-Host "          Size: $($Item.SizeStart)"
				Write-Host "          Status: Success"
			}
			catch {
				Write-vr_ErrorCode -Code 1603 -Exit $true -Object $PSItem
			}
		}

	# Determine Files to Remove
  	Write-Host "    - Determine Files to Remove"

		foreach ($Item in $Dataset_Websites) {
			Write-Host "        $($Item.Name)"

      try {
        $Item.FilesToRemove = $Item.Files | Where-Object {$_.($Param_Criteria) -lt $Temp_CleanupDate}
        $Item.SizeRemoved   = ($Item.FilesToRemove | Measure-Object -Sum Length).Sum
        $Item.SizeEnd       = $Item.SizeStart - $Item.SizeRemoved
        Write-Host "          Count: $($Item.FilesToRemove.Count)"
        Write-Host "          Size: $($Item.SizeRemoved)"
        Write-Host "          Status: Success"

        if ($Item.FilesToRemove -in "", $null) {
          $Item.FilesToRemove = "none"
          $Item.SizeRemoved = 0
        }
      }
      catch {
        Write-vr_ErrorCode -Code 1604 -Exit $true -Object $PSItem
      }
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

	# Remove Log Files
  Write-Host "    - Remove Log Files"
  foreach ($Item in ($Dataset_Websites | Where-Object {$_.FilesToRemove -notin "",$null,"none"})) {
    Write-Host "        $($Item.Name)"

    foreach ($File in $Item.FilesToRemove) {
      try {
        Remove-Item -Path $File.FullName -Force
        Write-Host "          Filename: $($File.Name),  $($Param_Criteria): $($File.($Param_Criteria)),  Status: Removed"
      }
      catch {
        Write-Host "          Filename: $($File.Name),  $($Param_Criteria): $($File.($Param_Criteria)),  Status: Failed to Remove"
        # Write-vr_ErrorCode -Code 1701 -Exit $false -Object $PSItem
      }
    }
    Write-Host "          Status: Success"
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

	# Output Results (JSON)
		Write-Host "    - Output Results (JSON)"

		try {
      $Temp_Output_File = "$($Param_OutputDir)\$($Param_OutputName).json"
      Write-Host "        Path: $($Temp_Output_File)"
      $Dataset_Websites | ConvertTo-Json | Out-File -FilePath $Temp_Output_File
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