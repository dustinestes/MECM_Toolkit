#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
	[string]$ContentID="911a2f",                   # '[ContentID]'     Regex pattern to identify one or more content IDs to delete. Null is equal to all content IDs.
	[int]$OlderThanDays,                # '[OlderThanDays]' An amount of days a content must be older than before it is deleted. Null is equal to all content.
	[int]$SizeMB,                          # '[SizeMB]'        An amount of megabytes a content must be larger than before it is deleted. Null is equal to all content.
  [switch]$IncludeOrphaned=$true              # True/False      If enabled, checks the path to the MECM Client cache for folders that do not match the paths of the elements returned by the Client API.
  # [string]$SiteCode,                  # 'ABC',
  # [string]$SMSProvider,               # '[ServerFQDN]'
  # [string]$ParamName                  # '[ExampleInputValues]'
)

#--------------------------------------------------------------------------------------------
# Start-Transcript -Path "C:\VividRock\MECM Toolkit\Logs\Task Sequence\Client - Clear Cache.log" -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

  Write-Host "------------------------------------------------------------------------------"
  Write-Host "  MECM Toolkit - Task Sequence - Client - Clear Cache"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host "    Author:     Dustin Estes"
  Write-Host "    Company:    VividRock"
  Write-Host "    Date:       December 23, 2019"
  Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
  Write-Host "    Purpose:    This script will attempt to clear the client cache. If content"
  Write-Host "                is set to be persisted, then the MECM API will honor this"
  Write-Host "                setting and not delete the content"
  Write-Host "    Links:      None"
  Write-Host "    Template:   1.1"
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
    $Param_ContentID          = $ContentID
    $Param_OlderThanDays      = $OlderThanDays
    $Param_SizeMB             = $SizeMB
    $Param_IncludeOrphaned    = $IncludeOrphaned
    # $Param_SiteCode         = $SiteCode
    # $Param_SMSProvider      = $SMSProvider
    # $Param_ParamName        = $ParamName

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
    # $Path_AdminService_ODataRoute = "https://$($Param_SMSProvider)/AdminService/v1.0/"
    # $Path_AdminService_WMIRoute   = "https://$($Param_SMSProvider)/AdminService/wmi/"

  # Files

  # Hashtables

  # Arrays

  # Registry

  # WMI

  # Datasets
    $Dataset_MECM_CacheElements = @()

  # Temporary

  # Output to Log
    Write-Host "    - Parameters"
    foreach ($Item in $PSBoundParameters.GetEnumerator()) {
      Write-Host "        $($Item.Key.PadRight(($PSBoundParameters.Keys | Measure-Object -Property Length -Maximum).Maximum + 1)): $($Item.Value)"
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
            # Stop-Transcript
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

	# # Connect to MECM Infrastructure
	# 	Write-Host "    - Connect to MECM Infrastructure"

	# 	try {
	# 		if (Test-Connection -ComputerName $Param_SMSProvider -Count 2 -Quiet) {
	# 			# Import the PowerShell Module
	# 				Write-Host "        Import the PowerShell Module"

	# 				if((Get-Module ConfigurationManager -ErrorAction SilentlyContinue) -in $null,"") {
	# 					Import-Module -Name "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"
	# 					Write-Host "            Status: Success"
	# 				}
	# 				else {
	# 					Write-Host "            Status: Already Imported"
	# 				}

	# 			# Create the Site Drive
	# 				Write-Host "        Create the Site Drive"

	# 				if((Get-PSDrive -Name $Param_SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -in $null,"") {
	# 					New-PSDrive -Name $Param_SiteCode -PSProvider CMSite -Root $Param_SMSProvider | Out-Null
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

	# Create ResourceMgr COM Object
		Write-Host "    - Create ResourceMgr COM Object"

		try {
			$Object_MECM_ResourceMgr = New-Object -ComObject "UIResource.UIResourceMgr"
			Write-Host "        Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 1404 -Exit $true -Object $PSItem
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

  # Parameters
		Write-Host "    - Parameters"

		try {
      Write-Host "        OlderThanDays: Set to -1 if Null"
      
      if ($Param_OlderThanDays -in "",$null,0) {
        $Param_OlderThanDays = -1
        Write-Host "          Status: Success"
      }
      else {
        Write-Host "          Status: Skipped"
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

	# Get Cache Info
    Write-Host "    - Get Cache Info"

    try {
      $Dataset_MECM_CacheInfo = $Object_MECM_ResourceMgr.GetCacheInfo()

			Write-Host "        Location: $($Dataset_MECM_CacheInfo.Location)"
			Write-Host "        TotalSize: $($Dataset_MECM_CacheInfo.TotalSize)"
			Write-Host "        FreeSize: $($Dataset_MECM_CacheInfo.FreeSize)"
			Write-Host "        TombStoneDuration: $($Dataset_MECM_CacheInfo.TombStoneDuration)"
			Write-Host "        MaxCacheDuration: $($Dataset_MECM_CacheInfo.MaxCacheDuration)"
			Write-Host "        ReservedSize: $($Dataset_MECM_CacheInfo.ReservedSize)"
			Write-Host "        Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 1603 -Exit $true -Object $PSItem
		}
    
  # Get Cache Elements
    Write-Host "    - Get Cache Elements"
    
    try {
      $Dataset_MECM_CacheElements = @()
      
      foreach ($Item in $Object_MECM_ResourceMgr.GetCacheInfo().GetCacheElements()) {
        $Temp_Item = [PSCustomObject]@{
          CacheElementID      = $Item.CacheElementId
          ContentID           = $Item.ContentId
          Version             = $Item.ContentVersion
          Location            = $Item.Location
          ReferenceCount      = $Item.ReferenceCount
          LastReferenceTime   = $Item.LastReferenceTime
          AgeDays             = ((Get-Date) - $Item.LastReferenceTime).Days
          Size                = $Item.ContentSize
          SizeMB              = [math]::Round($Item.ContentSize / 1kb, 2)
          Delete              = $false
          Status              = "Not Processed"
        }
        
        $Dataset_MECM_CacheElements += $Temp_Item
      }
      
			Write-Host "        Count: $(($Dataset_MECM_CacheElements | Measure-Object).Count)  ($(($Dataset_MECM_CacheElements.SizeMB | Measure-Object -Sum).Sum) MB)"
			Write-Host "        Status: Success"
		}
		catch {
      Write-vr_ErrorCode -Code 1604 -Exit $true -Object $PSItem
		}
    
  # Get Cache Directory Info
    Write-Host "    - Get Cache Directory Info"

    if ($Param_IncludeOrphaned) {
      try {
        $Dataset_MECM_CacheDirectoryInfo = @()
  
        foreach ($Item in (Get-ChildItem -Path $Dataset_MECM_CacheInfo.Location -Directory -Recurse -Depth 1)) {
          $Temp_Item = [PSCustomObject]@{
            Name        = $Item.Name
            Path        = $Item.FullName
            Parent      = $Item.Parent
            SizeMB      = [math]::Round( (Get-ChildItem -Path $Item.FullName -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1mb, 2)
            IsOrphaned  = if ($Item.FullName -in $Dataset_MECM_CacheElements.Location) { $false } else { $true }
            Status      = "Not Processed"
          }
  
          $Dataset_MECM_CacheDirectoryInfo += $Temp_Item
        }
  
        Write-Host "        Count: $(($Dataset_MECM_CacheDirectoryInfo | Measure-Object).Count)  ($(($Dataset_MECM_CacheDirectoryInfo | Measure-Object -Property SizeMB -Sum).Sum) MB)"
        Write-Host "        Orphaned: $(($Dataset_MECM_CacheDirectoryInfo | Where-Object {$_.IsOrphaned -eq $true} | Measure-Object).Count)  ($(($Dataset_MECM_CacheDirectoryInfo | Where-Object {$_.IsOrphaned -eq $true} | Measure-Object -Property SizeMB -Sum).Sum) MB)"
        Write-Host "        Status: Success"
      }
      catch {
        Write-vr_ErrorCode -Code 1604 -Exit $true -Object $PSItem
      }
    }
    else {
      Write-Host "        Status: Skipped, IncludeOrphaned parameter not supplied"
    }
    
  # Filter Cache Elements
    Write-Host "    - Filter Cache Elements"

    try {
      foreach ($Item in $Dataset_MECM_CacheElements) {
        if (($Item.ContentId -match $Param_ContentID) -and ($Item.AgeDays -gt $Param_OlderThanDays) -and ($Item.SizeMB -gt $Param_SizeMB)) {
          $Item.Delete = $true
        }
      }
			Write-Host "        Delete: $((($Dataset_MECM_CacheElements | Where-Object {$_.Delete -eq $true}) | Measure-Object).Count)  ($((($Dataset_MECM_CacheElements | Where-Object {$_.Delete -eq $true}) | Measure-Object -Property SizeMB -Sum).Sum) MB)"
			Write-Host "        Remain: $((($Dataset_MECM_CacheElements | Where-Object {$_.Delete -eq $false}) | Measure-Object).Count)  ($((($Dataset_MECM_CacheElements | Where-Object {$_.Delete -eq $false}) | Measure-Object -Property SizeMB -Sum).Sum) MB)"
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

	# Delete Cache Elements
		Write-Host "    - Delete Cache Elements"

		try {
			foreach ($Item in $Dataset_MECM_CacheElements) {
        Write-Host "        ContentID: $($Item.ContentId)"
        Write-Host "        Location: $($Item.Location)"

        if ($Item.Delete) {
          Write-Host "        CacheElementID: $($Item.CacheElementID)"
          Write-Host "        Version: $($Item.Version)"
          Write-Host "        LastReferenceTime: $($Item.LastReferenceTime)"
          Write-Host "        AgeDays: $($Item.AgeDays)"
          Write-Host "        SizeMB: $($Item.SizeMB)"
          Write-Host "        Delete: $($Item.Delete)"

          $Object_MECM_ResourceMgr.GetCacheInfo().DeleteCacheElement([string]$($Item.CacheElementID))

          if (($Object_MECM_ResourceMgr.GetCacheInfo().GetCacheElements() | Where-Object {$_.CacheElementID -eq $Item.CacheElementID})) {
            $Item.Status = "Persisted"
          }
          else {
            $Item.Status = "Deleted"
          }
        }
        else {
          $Item.Status = "Skipped"
        }
        
        Write-Host "        Status: $($Item.Status)"
        Write-Host ""
			}
		}
		catch {
      $Item.Status = "Error"
			Write-vr_ErrorCode -Code 1701 -Exit $false -Object $PSItem
		}
  
	# Delete Orphaned Directories
    Write-Host "    - Delete Orphaned Directories"

    if ($Param_IncludeOrphaned) {
      try {
        foreach ($Item in $Dataset_MECM_CacheDirectoryInfo) {
          Write-Host "        Name: $($Item.Name)"
          Write-Host "        Path: $($Item.Path)"
          Write-Host "        Size: $($Item.SizeMB)"
          
          if ($Item.IsOrphaned) {
            Remove-Item -Path $Item.Path -Recurse -Force -Confirm:$false
  
            if (Test-Path -Path $Item.Path) {
              $Item.Status = "Error"
            }
            else {
              $Item.Status = "Deleted"
            }
          }
          else {
            $Item.Status = "Skipped"
          }
          
          Write-Host "        Status: $($Item.Status)"
          Write-Host ""
        }
      }
      catch {
        $Item.Status = "Error"
        Write-vr_ErrorCode -Code 1702 -Exit $false -Object $PSItem
      }
    }
    else {
      Write-Host "        Status: Skipped, IncludeOrphaned parameter not supplied"
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

	# Results
		Write-Host "    - Results"

		try {
      Write-Host "        Persisted"
      Write-Host "          Count: $((($Dataset_MECM_CacheElements | Where-Object {($_.Delete -eq $true) -and ($_.Status -eq "Persisted")}) | Measure-Object).Count)"
      Write-Host "          Size (MB): $((($Dataset_MECM_CacheElements | Where-Object {($_.Delete -eq $true) -and ($_.Status -eq "Persisted")}).SizeMB | Measure-Object -Sum).Sum)"
      Write-Host "        Cleared"
      Write-Host "          Count: $((($Dataset_MECM_CacheElements | Where-Object {($_.Delete -eq $true) -and ($_.Status -ne "Persisted")}) | Measure-Object).Count)"
      Write-Host "          Size (MB): $((($Dataset_MECM_CacheElements | Where-Object {($_.Delete -eq $true) -and ($_.Status -ne "Persisted")}).SizeMB | Measure-Object -Sum).Sum)"
      Write-Host "        Orphaned"
      Write-Host "          Count: $((($Dataset_MECM_CacheDirectoryInfo | Where-Object {($_.IsOrphaned -eq $true) -and ($_.Status -notin "Skipped")}) | Measure-Object).Count)"
      Write-Host "          Size (MB): $((($Dataset_MECM_CacheDirectoryInfo | Where-Object {($_.IsOrphaned -eq $true) -and ($_.Status -notin "Skipped")}).SizeMB | Measure-Object -Sum).Sum)"
      Write-Host "        Skipped"
      Write-Host "          Count: $((($Dataset_MECM_CacheElements | Where-Object {$_.Delete -eq $false}) | Measure-Object).Count)"
      Write-Host "          Size (MB): $((($Dataset_MECM_CacheElements | Where-Object {$_.Delete -eq $false}).SizeMB | Measure-Object -Sum).Sum)"
			
		}
		catch {
			Write-vr_ErrorCode -Code 1801 -Exit $false -Object $PSItem
		}
    
  # Datasets
    Write-Host "    - Datasets"
    
    try {
      $Dataset_MECM_CacheElements

      $Dataset_MECM_CacheDirectoryInfo
    }
    catch {
      Write-vr_ErrorCode -Code 1802 -Exit $false -Object $PSItem
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

# Stop-Transcript
Return $Meta_Script_Result[0]