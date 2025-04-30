
#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
  [string]$SiteCode="FSI",                    # 'ABC'
  [string]$SMSProvider="v0002ws0127.flightsafety.com",               # '[ServerFQDN]'
  [string]$CollNamePattern="AM - User - [Manufacturer] - [LocalizedDisplayName]",                # Pattern that uses a string replace method in the Data Gather section to construct the new Collection Names.
  [int]$TargetContainerNodeID=16777268,                   # ContainerNodeID of the Folder that you want the newly created collections to be contained in.
  [array]$AdminCategories=("ServiceNow Enabled"),                 # ('[RegExPattern]','[RegExPattern]') Array of RegEx patterns to identify the Applications to include based on the matching Administrative Category they have assigned.
  [array]$Include=("Microsoft Endpoint","SNOW"),                       # ('[RegExPattern]','[RegExPattern]') Array of RegEx Patterns to include. Only items that match will be included. Blank is equal to All included.
  [array]$Exclude=("^$"),                       # ('[RegExPattern]','[RegExPattern]') Array of RegEx Patterns to exclude. Everything but the items that match will be included. Blank is equal to All excluded.
  [string]$OutputDir="\\mecmcontent\repo\Logging\Maintenance Tasks\Application Management\ServiceNow",                         # '\\[Path]' Directory to output the log and datasets to.
  [string]$OutputName="Collections - Create Application Management Collections for All Applications",                         # 'Collections - Create Application Management Collections for All Applications' Name to use for output log file.
  [bool]$Whatif=$false                               # [Bool] Determines if the script runs in a WhatIf mode or not. If true, the script only gathers data outputs the files, it will not make any changes to the MECM environment.
)

#--------------------------------------------------------------------------------------------
Start-Transcript -Path "Filesystem::$($OutputDir)\$($OutputName).log" -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

  Write-Host "------------------------------------------------------------------------------"
  Write-Host "  MECM Toolkit - ServiceNow - Create Application Management Collections"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host "    Author:     Dustin Estes"
  Write-Host "    Company:    VividRock"
  Write-Host "    Date:       2025-02-13"
  Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
  Write-Host "    Purpose:    Create a set of Application Management collections that are used"
  Write-Host "                by ServiceNow to for application request workflows"
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
    $Dataset_Collections    = @()

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
      $Odata_WMIClass       = "SMS_Application"
      $OData_Query         = "?`$filter=IsExpired eq false and IsLatest eq true &`$select=ModelName,Manufacturer,LocalizedDisplayName,SoftwareVersion,LocalizedCategoryInstanceNames,NumberOfDeploymentTypes,IsEnabled,IsExpired,IsLatest,IsSuperseded"
      Write-Host "        WMIClass: $($Odata_WMIClass)"
      Write-Host "        Filter: $($OData_Query)"
      $Temp_SMS_Application = (Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $Odata_WMIClass + $OData_Query)" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value
      Write-Host "        Count: $($Temp_SMS_Application.Count)"
      Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
    }

  # Get Collections
    Write-Host "    - Get Collections"

    try {
      $Odata_WMIClass       = "SMS_Collection"
      $OData_Query         = "?`$filter=IsBuiltIn eq false &`$select=CollectionID,Name,ObjectPath"
      Write-Host "        WMIClass: $($Odata_WMIClass)"
      Write-Host "        Filter: $($OData_Query)"
      $Temp_SMS_Collection = (Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $Odata_WMIClass + $OData_Query)" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value
      Write-Host "        Count: $($Temp_SMS_Collection.Count)"
      Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1602 -Exit $true -Object $PSItem
    }

	# # Get DeploymentTypes
  #   Write-Host "    - Get DeploymentTypes"

  #   try {
  #     $Odata_WMIClass           = "SMS_DeploymentType"
  #     $OData_Query             = "?`$filter=IsExpired eq false and IsLatest eq true &`$selectLocalizedDisplayName,IsEnabled,IsExpired,IsLatest,IsSuperseded,AppModelName,ModelName"
  #     Write-Host "        WMIClass: $($Odata_WMIClass)"
  #     Write-Host "        Filter: $($OData_Query)"
  #     $Temp_SMS_DeploymentType  = (Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $Odata_WMIClass + $OData_Query)" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value
  #     Write-Host "        Count: $($Temp_SMS_DeploymentType.Count)"
  #     Write-Host "        Status: Success"
  #   }
  #   catch {
  #     Write-vr_ErrorCode -Code 1603 -Exit $true -Object $PSItem
  #   }

  # Construct Application Data Set
    Write-Host "    - Construct Application Data Set"

		foreach ($Item in $Temp_SMS_Application) {
			# Write-Host "        $($Item.LocalizedDisplayName)"

			try {
        $Temp_Object = [PSCustomObject]@{
          ModelName               = $Item.ModelName
          Manufacturer            = $Item.Manufacturer
          LocalizedDisplayName    = $Item.LocalizedDisplayName
          SoftwareVersion         = $Item.SoftwareVersion
          LocalizedCategoryInstanceNames  = $Item.LocalizedCategoryInstanceNames
          NumberOfDeploymentTypes = $Item.NumberOfDeploymentTypes
          # DeploymentTypes = @()
          IsEnabled               = $Item.IsEnabled
          IsExpired               = $Item.IsExpired
          IsLatest                = $Item.IsLatest
          IsSuperseded            = $Item.IsSuperseded
          Included                = $null
          Reasons                 = @()
          Status                  = $null
        }

        $Dataset_Applications += $Temp_Object
				# Write-Host "          Status: Success"
			}
			catch {
				Write-vr_ErrorCode -Code 1604 -Exit $true -Object $PSItem
			}
		}
    Write-Host "        Total: $(($Dataset_Applications | Measure-Object).Count)"
    Write-Host "        Status: Success"

  # # Add DeploymentTypes to Applications Dataset
  #   Write-Host "    - Add DeploymentTypes to Applications Dataset"

  #   foreach ($Item in $Temp_SMS_DeploymentType) {
  #     # Write-Host "        $($Item.LocalizedDisplayName)"

  #     try {
  #       $Temp_Object = [PSCustomObject]@{
  #         AppModelName    = $Item.AppModelName
  #         ModelName       = $Item.ModelName
  #         Name            = $Item.LocalizedDisplayName
  #         IsEnabled       = $Item.IsEnabled
  #         IsLatest        = $Item.IsLatest
  #         IsExpired       = $Item.IsExpired
  #         IsSuperseded    = $Item.IsSuperseded
  #       }

  #       ($Dataset_Applications | Where-Object {$_.ModelName -eq $Item.AppModelName}).DeploymentTypes += $Temp_Object
  #       # $Dataset_DeploymentTypes += $Temp_Object

  #       # Write-Host "          Status: Success"
  #     }
  #     catch {
  #       Write-vr_ErrorCode -Code 1605 -Exit $true -Object $PSItem
  #     }
  #   }
  #   Write-Host "        Status: Success"

	# Process Inclusion/Exclusion Rules
    Write-Host "    - Process Inclusion/Exclusion Rules"

		foreach ($Item in $Dataset_Applications) {
			try {
        # Write-Host "        $($Item.LocalizedDisplayName)"

        # IsEnabled = False
        if ($Item.IsEnabled -eq $false) {
          $Item.Reasons += "IsEnabled = False"
        }

        # IsExpired = True
        if ($Item.IsExpired) {
          $Item.Reasons += "IsExpired = True"
        }

        # IsLatest = False
        if ($Item.IsLatest -eq $false) {
          $Item.Reasons += "IsLatest = False"
        }

        # IsSuperseded = True
        if ($Item.IsSuperseded) {
          $Item.Reasons += "IsSuperseded = True"
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

				# Write-Host "          Status: Success"
			}
			catch {
				Write-vr_ErrorCode -Code 1606 -Exit $true -Object $PSItem
			}
		}
    Write-Host "        Included: $(($Dataset_Applications | Where-Object {$_.Included -eq $true} | Measure-Object).Count)"
    Write-Host "        Excluded: $(($Dataset_Applications | Where-Object {$_.Included -eq $false} | Measure-Object).Count)"
    Write-Host "        Total: $(($Dataset_Applications | Measure-Object).Count)"
    Write-Host "        Status: Success"

  # Construct Collections Dataset
    Write-Host "    - Construct Collections Dataset"

		foreach ($Item in ($Dataset_Applications | Where-Object {$_.Included -eq $true})) {
			try {
        # Write-Host "        $($Item.LocalizedDisplayName)"
        $Temp_Object = [PSCustomObject]@{
          Manufacturer      = $Item.Manufacturer
          LocalizedDisplayName  = $Item.LocalizedDisplayName
          SoftwareVersion   = $Item.SoftwareVersion
          CollectionID      = $null
          CollectionName    = $CollNamePattern -replace [regex]::Escape("[Manufacturer]"),$Item.Manufacturer -replace [regex]::Escape("[LocalizedDisplayName]"),($Item.LocalizedDisplayName -replace " - $($Item.SoftwareVersion)","")
          CharCount         = $null
          InvalidChars      = $null
          CollectionExists  = $null
          Status            = $null
        }

        # Add Dynamic Properties
        $Temp_Object.CharCount = $Temp_Object.CollectionName.Length
        $Temp_Object.InvalidChars = $Temp_Object.InvalidChars = if ([char[]]$Temp_Object.CollectionName | Where-Object {$_ -in [System.IO.Path]::GetInvalidFileNameChars()}) {$true} else {$false}

        $Dataset_Collections += $Temp_Object
				# Write-Host "          Status: Success"
			}
			catch {
				Write-vr_ErrorCode -Code 1607 -Exit $true -Object $PSItem
			}
		}
    Write-Host "        Names with InvalidChars: $(($Dataset_Collections | Where-Object {$_.InvalidChars -eq $true} | Measure-Object).Count)"
    Write-Host "        Names > Length Limit (255): $(($Dataset_Collections | Where-Object {$_.CharCount -gt 255} | Measure-Object).Count)"
    Write-Host "        Total: $(($Dataset_Collections | Measure-Object).Count)"
    Write-Host "        Status: Success"

	# Check for Collection Existence
    Write-Host "    - Check for Collection Existence"

		foreach ($Item in $Dataset_Collections) {
			try {
        # Write-Host "        $($Item.Name)"

        if ($Item.CollectionName -in $Temp_SMS_Collection.Name) {
          $Item.CollectionExists = $true
        }
        else {
          $Item.CollectionExists = $false
        }

				# Write-Host "          Status: Success"
			}
			catch {
				Write-vr_ErrorCode -Code 1608 -Exit $true -Object $PSItem
			}
		}
    Write-Host "        Exist: $(($Dataset_Collections | Where-Object {$_.CollectionExists -eq $true} | Measure-Object).Count)"
    Write-Host "        Not Exist: $(($Dataset_Collections | Where-Object {$_.CollectionExists -eq $false} | Measure-Object).Count)"
    Write-Host "        Total: $(($Dataset_Collections | Measure-Object).Count)"
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
    # Create Collections
      Write-Host "    - Create Collections"

      foreach ($Item in $Dataset_Collections) {
        try {
          # Write-Host "          $($Item.Name)"

          if ($Item.CollectionExists -eq $true) {
            $Item.Status = "Skipped"
          }
          else {
            # Create Collection
              $WebAPI_WMIClass       = "SMS_Collection"
              Write-Host "        WMIClass: $($WebAPI_WMIClass)"
              $WebAPI_Body = @{
                Name                = $Item.CollectionName
                LimitToCollectionID = "SMS00004"
                Comment             = "Collection created using the Maintenance Task: ServiceNow - Create Application Management Collections. Run on endpoint: $($env:COMPUTERNAME)"
                CollectionType      = 1
              } | ConvertTo-Json

              $Result = Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $WebAPI_WMIClass)" -Method Post -Body $WebAPI_Body -ContentType "application/json" -UseDefaultCredentials
              if ($Result.Name -eq $Item.CollectionName) {
                $Item.CollectionID  = $Result.CollectionID
                $Item.Status        = "Created"
              }
              else {
                $Item.Status = "Error"
              }

            # Create Container Item for Collection to Move to Folder
              $WebAPI_WMIClass       = "SMS_ObjectContainerItem"
              Write-Host "        WMIClass: $($WebAPI_WMIClass)"
              $WebAPI_Body = @{
                ContainerNodeID = $TargetContainerNodeID  # ID of Parent Folder to Contain Collection: SMS_ObjectContainerNode.ContainerNodeID
                InstanceKey     = $Item.CollectionID  # CollectionID of Collection to Move to Folder: SMS_Collection.CollectionID
                ObjectType      = 5001                # 5000 = Device, 5001 = User: SMS_ObjectContainerItem
              } | ConvertTo-Json

              $Result = Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $WebAPI_WMIClass)" -Method Post -Body $WebAPI_Body -ContentType "application/json" -UseDefaultCredentials
              if ($Result.ContainerNodeID -eq $TargetContainerNodeID) {
                # Do Nothing
              }
              else {
                $Item.Status = "Error"
              }

            # # Update Container Item for Collection
            #   $WebAPI_WMIClass       = "SMS_ObjectContainerItem.MoveMembers"
            #   Write-Host "        WMIClass: $($WebAPI_WMIClass)"
            #   $WebAPI_Body = @{
            #     InstanceKeys          = @("FSI0027E")
            #     ContainerNodeID       = 16777269
            #     TargetContainerNodeID = 16777268
            #     ObjectType            = 5001
            #   } | ConvertTo-Json

            #   $Result = Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $WebAPI_WMIClass)" -Method Post -Body $WebAPI_Body -ContentType "application/json" -UseDefaultCredentials
            #   if ($Result -eq 0) {
            #     # Success
            #   }
            #   else {
            #     # Failure
            #   }

          }

          # Write-Host "          Status: Success"
        }
        catch {
          $Item.Status = "Error: $($PSItem.Exception.Message)"
          # Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
        }
      }
      Write-Host "        Created: $(($Dataset_Collections | Where-Object {$_.Status -eq "Created"} | Measure-Object).Count)"
      Write-Host "        Skipped: $(($Dataset_Collections | Where-Object {$_.Status -eq "Skipped"} | Measure-Object).Count)"
      Write-Host "        Errors: $(($Dataset_Collections | Where-Object {$_.Status -eq "Error"} | Measure-Object).Count)"
      Write-Host "        Total: $(($Dataset_Collections | Measure-Object).Count)"
      Write-Host "        Status: Success"

    # # [StepName]
    #   Write-Host "    - [StepName]"

    #   try {

    #     Write-Host "        Status: Success"
    #   }
    #   catch {
    #     Write-vr_ErrorCode -Code 170? -Exit $true -Object $PSItem
    #   }

    # # [StepName]
    #   Write-Host "    - [StepName]"

    #   foreach ($Item in (Get-Variable -Name "Path_*")) {
    #     Write-Host "        $($Item.Name)"

    #     try {

    #       Write-Host "        Status: Success"
    #     }
    #     catch {
    #       Write-vr_ErrorCode -Code 170? -Exit $true -Object $PSItem
    #     }
    #   }
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