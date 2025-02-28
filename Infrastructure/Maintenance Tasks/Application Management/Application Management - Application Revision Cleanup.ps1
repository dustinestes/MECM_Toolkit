#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
  [string]$SMSProvider="",                 # '[ServerFQDN]'
  [int]$DaysOlderThan=30,                  # '30' An amount of days a revision must be older than before it is removed.
  [array]$AdminCategories=(""),            # ('[RegExPattern]','[RegExPattern]') Array of RegEx patterns to identify the Applications to include based on the matching Administrative Category they have assigned. Blank is equal to All included.
  [array]$Include=(""),                    # ('[RegExPattern]','[RegExPattern]') Array of RegEx Patterns to include. Only items with matching Publisher or LocalizedDisplayName will be included. Blank is equal to All included.
  [array]$Exclude=("^$"),                  # ('[RegExPattern]','[RegExPattern]') Array of RegEx Patterns to exclude. Everything but the items with matching Publisher or LocalizedDisplayName will be included. Blank is equal to All excluded.
  [string]$OutputDir="\\[path]\repo\Logging\Maintenance Tasks\Application Management\Revisions",                         # '\\[Path]' Directory to output the log and datasets to.
  [string]$OutputName="Application Management - Application Revision Cleanup",                         # '[Name]' Name to use for output log file.
  [bool]$Whatif=$false                               # [Bool] Determines if the script runs in a WhatIf mode or not. If true, the script only gathers data outputs the files, it will not make any changes to the MECM environment.
)

#--------------------------------------------------------------------------------------------
Start-Transcript -Path "Filesystem::$($OutputDir)\$($OutputName).log" -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

  Write-Host "------------------------------------------------------------------------------"
  Write-Host "  MECM Toolkit - Maintenance Tasks - Application Management - Application Revision Cleanup"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host "    Author:     Dustin Estes"
  Write-Host "    Company:    VividRock"
  Write-Host "    Date:       2025-02-13"
  Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
  Write-Host "    Purpose:    Remove the revisions of the Applications matching the criteria"
  Write-Host "                to cleanup old and unused data from the database."
  Write-Host "    Links:      None"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host ""

#EndRegion Header
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Variables
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Variables

  Write-Host "  Variables"

  # Parameters

  # Metadata
    $Meta_Script_Start_DateTime     = Get-Date
    $Meta_Script_Complete_DateTime  = $null
    $Meta_Script_Complete_TimeSpan  = $null
    $Meta_Script_Execution_User     = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $Meta_Script_Result = $false,"Failure"

  # Preferences
    $ErrorActionPreference        = "Stop"

  # Names

  # Paths
    # $Path_AdminService_ODataRoute = "https://$($SMSProvider)/AdminService/v1.0/"
    $Path_AdminService_WMIRoute   = "https://$($SMSProvider)/AdminService/wmi/"

  # Files

  # Hashtables

  # Arrays

  # Registry

  # WMI

  # Datasets
    $Dataset_Applications   = @()
    $Dataset_Revisions      = @()

  # Temporary

  # Output to Log
    Write-Host "    - Parameters"
    $Temp_Padding = ($PSBoundParameters.Keys | Measure-Object -Property Length -Maximum).Maximum + 1
    foreach ($Item in $PSBoundParameters.GetEnumerator()) {
      Write-Host "        $($Item.Key.PadRight($Padding)): $($Item.Value)"
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

  # API Routes
		Write-Host "    - API Routes"

		try {
			foreach ($Item in (Get-Variable -Name "Path_AdminService_*")) {
				Write-Host "        Route: $($Item.Value)"

				$Temp_API_Result = Invoke-RestMethod -Uri $Item.Value -Method Get -ContentType "Application/Json" -UseDefaultCredentials
				if ($Temp_API_Result) {
					Write-Host "          Status: Success"
				}
				else {
					Write-Host "          Status: Error"
					Throw
				}
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

	# Get Applications
    Write-Host "    - Get Applications"

    try {
      $Odata_Resource       = "SMS_Application"
      $Odata_Filter         = "?`$filter=IsExpired eq true and IsLatest eq false &`$select=CI_ID,CIVersion,Manufacturer,LocalizedDisplayName,SoftwareVersion,LocalizedCategoryInstanceNames,DateLastModified,IsEnabled,IsExpired,IsLatest,IsSuperseded"
      Write-Host "        WMIClass: $($Odata_Resource)"
      Write-Host "        Filter: $($Odata_Filter)"
      $Temp_SMS_Application = (Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $Odata_Resource + $Odata_Filter)" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value
      Write-Host "        Count: $($Temp_SMS_Application.Count)"
      Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
    }

  # Construct Application Data Set
    Write-Host "    - Construct Application Data Set"

		foreach ($Item in $Temp_SMS_Application) {
			Write-Host "        $($Item.LocalizedDisplayName)"

			try {
        $Temp_Object = [PSCustomObject]@{
          CI_ID                   = $Item.CI_ID
          CIVersion               = $Item.CIVersion
          Manufacturer            = $Item.Manufacturer
          LocalizedDisplayName    = $Item.LocalizedDisplayName
          SoftwareVersion         = $Item.SoftwareVersion
          LocalizedCategoryInstanceNames  = $Item.LocalizedCategoryInstanceNames
          DateLastModified        = $Item.DateLastModified
          IsEnabled               = $Item.IsEnabled
          IsExpired               = $Item.IsExpired
          IsLatest                = $Item.IsLatest
          IsSuperseded            = $Item.IsSuperseded
          Included                = $null
          Reasons                 = @()
        }

        $Dataset_Applications += $Temp_Object
				Write-Host "          Status: Success"
			}
			catch {
				Write-vr_ErrorCode -Code 1602 -Exit $true -Object $PSItem
			}
		}
    Write-Host "        Total: $(($Dataset_Applications | Measure-Object).Count)"
    Write-Host "        Status: Success"

	# Process Inclusion/Exclusion Rules
    Write-Host "    - Process Inclusion/Exclusion Rules"

		foreach ($Item in $Dataset_Applications) {
			try {
        Write-Host "        $($Item.LocalizedDisplayName)"

        # DaysOlderThan = False
        if ([DateTime]$Item.DateLastModified -gt (Get-Date).AddDays(-$DaysOlderThan)) {
          $Item.Reasons += "DaysOlderThan = False"
        }

        # IsLatest != False
        if ($Item.IsLatest -ne $false) {
          $Item.Reasons += "IsLatest != False"
        }

        # Administrative Category Matches
        if ($AdminCategories -in "",$null) {
          # Skip Because This Will Include All
        }
        else {
          $Temp_Counter = 0
          foreach ($Category in $Item.LocalizedCategoryInstanceNames) {
            if ($Category -in $AdminCategories) {
              $Temp_Counter ++
            }
          }
          if ($Temp_Counter -eq 0) {
            $Item.Reasons += "Administrative Category Not Matched"
          }
        }

        # Both Names Do Not Match Include Pattern
        if (($Item.Manufacturer -notmatch ($Include -join "|")) -and ($Item.LocalizedDisplayName -notmatch ($Include -join "|"))) {
          $Item.Reasons += "Include Pattern Not Match"
        }

        # Either Names Match Exclude Pattern
        if (($Item.Manufacturer -match ($Exclude -join "|")) -or ($Item.LocalizedDisplayName -match ($Exclude -join "|"))) {
          $Item.Reasons += "Exclude Pattern Match"
        }

        # Final Analysis
        if ($Item.Reasons -in "",$null) {
          $Item.Included = $true
          $Item.Reasons += "All Rules Passed"
        }
        else {
          $Item.Included = $false
        }

				Write-Host "          Status: Success"
			}
			catch {
				Write-vr_ErrorCode -Code 1603 -Exit $true -Object $PSItem
			}
		}
    Write-Host "        Included: $(($Dataset_Applications | Where-Object {$_.Included -eq $true} | Measure-Object).Count)"
    Write-Host "        Excluded: $(($Dataset_Applications | Where-Object {$_.Included -eq $false} | Measure-Object).Count)"
    Write-Host "        Total: $(($Dataset_Applications | Measure-Object).Count)"
    Write-Host "        Status: Success"

  # Construct Revision Dataset
    Write-Host "    - Construct Revision Dataset"

		foreach ($Item in ($Dataset_Applications | Where-Object {$_.Included -eq $true})) {
			try {
        Write-Host "        $($Item.LocalizedDisplayName)"
        $Temp_Object = [PSCustomObject]@{
          CI_ID             = $Item.CI_ID
          CIVersion         = $Item.CIVersion
          Manufacturer      = $Item.Manufacturer
          LocalizedDisplayName  = $Item.LocalizedDisplayName
          SoftwareVersion   = $Item.SoftwareVersion
          Status            = $null
        }

        $Dataset_Revisions += $Temp_Object
				Write-Host "          Status: Success"
			}
			catch {
				Write-vr_ErrorCode -Code 1607 -Exit $true -Object $PSItem
			}
		}
    Write-Host "        Total: $(($Dataset_Revisions | Measure-Object).Count)"
    Write-Host "        Status: Success"


	# # [StepName]
	# 	Write-Host "    - [StepName]"

	# 	try {

	# 		Write-Host "        Status: Success"
	# 	}
	# 	catch {
	# 		Write-vr_ErrorCode -Code 160? -Exit $true -Object $PSItem
	# 	}

	# # [StepName]
  #   Write-Host "    - [StepName]"

	# 	foreach ($Item in (Get-Variable -Name "Path_*")) {
	# 		Write-Host "        $($Item.Name)"

	# 		try {

	# 			Write-Host "          Status: Success"
	# 		}
	# 		catch {
	# 			Write-vr_ErrorCode -Code 160? -Exit $true -Object $PSItem
	# 		}
	# 	}

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

  if ($WhatIf -eq $true) {
    Write-Host "    - Skipped Because WhatIf = True"
  }
  else {
    # Remove Revisions
      Write-Host "    - Remove Revisions"

      foreach ($Item in $Dataset_Revisions) {
        try {
          Write-Host "        $($Item.Manufacturer) - $($Item.LocalizedDisplayName) - $($Item.SoftwareVersion)"
          Write-Host "          Revision: $($Item.CIVersion)"

          # Remove Entity
          $Odata_Resource = "SMS_Application/$($Item.CI_ID)"
          Write-Host "          Entity Path: $($Odata_Resource)"
          $Odata_Body = @{
          } | ConvertTo-Json

          $Result = Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $Odata_Resource)" -Method Delete -Body $Odata_Body -ContentType "application/json" -UseDefaultCredentials
          if ($Result -eq "") {
            $Item.Status = "Success"
          }
          else {
            $Item.Status = "Error"
          }

          Write-Host "          Status: Success"
        }
        catch {
          $Item.Status = "Error: $($PSItem.Exception.Message)"
          Write-Host "          Status: $($PSItem.Exception.Message)"
          # Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
        }
      }
      Write-Host "        Success: $(($Dataset_Revisions | Where-Object {$_.Status -match "Success"} | Measure-Object).Count)"
      Write-Host "        Error: $(($Dataset_Revisions | Where-Object {$_.Status -match "Error"} | Measure-Object).Count)"
      Write-Host "        Total: $(($Dataset_Revisions | Measure-Object).Count)"
      Write-Host "        Status: Success"
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

  # Output Datasets
		Write-Host "    - Output Dataset"

    foreach ($Item in (Get-Variable -Name "Dataset_*")) {
      try {
        Write-Host "        $($Item.Name)"
        Write-Host "        Path: $($OutputDir)\$($Item.Name).json"
        $Item.Value | ConvertTo-Json | Out-File -FilePath "Filesystem::$($OutputDir)\$($Item.Name).json"
        Write-Host "        Status: Success"
      }
      catch {
        Write-vr_ErrorCode -Code 1801 -Exit $true -Object $PSItem
      }
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
		Write-Host "  Script Result: $($Meta_Script_Result[1])"
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
