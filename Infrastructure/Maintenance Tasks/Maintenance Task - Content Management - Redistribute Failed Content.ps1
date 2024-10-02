#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
  [string]$SiteCode,                  # 'ABC'
  [string]$SMSProvider,               # '[ServerFQDN]'
  [array]$Exclude,                    # @('VR100001,VR100002')
  [string]$OutputDir,                 # '\\[URI]\Share'
  [string]$OutputName                 # 'Content Management - Redistribute Failed Content'
)

#--------------------------------------------------------------------------------------------
# Start-Transcript -Path "$($PSScriptRoot)\Logs\$(Get-Date -Format "yyyy-MM-dd")_$((Get-Item -Path $PSCommandPath).Basename).log" -ErrorAction SilentlyContinue
Start-Transcript -Path "$($OutputDir)\$($OutputName).log" -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

  Write-Host "------------------------------------------------------------------------------"
  Write-Host "  MECM Toolkit - Maintenance Tasks - Content Management - Redistribute Failed Content"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host "    Author:     Dustin Estes"
  Write-Host "    Company:    VividRock"
  Write-Host "    Date:       2024-09-03"
  Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
  Write-Host "    Purpose:    This script runs as a Scheduled Task and performs the tasks"
  Write-Host "                necessary to redistribute failed content distributions to their"
  Write-Host "                respective Distribution Points without unnecessarily redistributing"
  Write-Host "                to Distribution Points that already successfully received the content."
  Write-Host "    Links:      https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/core/servers/configure/sms_packagestatus-server-wmi-class"
  Write-Host "                https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/core/servers/configure/sms_package-server-wmi-class"
  Write-Host "                https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/osd/sms_imagepackage-server-wmi-class"
  Write-Host "                https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/osd/sms_bootimagepackage-server-wmi-class"
  Write-Host "                https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/osd/sms_operatingsysteminstallpackage-server-wmi-class"
  Write-Host "                https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/osd/sms_driverpackage-server-wmi-class"
  Write-host "                https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/sum/sms_softwareupdatespackage-server-wmi-class"
  Write-Host "                https://learn.microsoft.com/en-us/mem/configmgr/develop/reference/apps/sms_application-server-wmi-class"
  Write-Host "    Template:   1.1"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host ""

<#
  How To Use:
    Note: Perform all of the below steps on the Primary Site Server

    Create a Maintenance Tasks Service Account (if not already exists)
      1. Create account in AD: MECM_MaintTasks
      2. Grant the account the following MECM Role(s):
        - Application Author

    Create Source Content
      1. Save this script to a directory accessible by the Primary Site Server
        i.e. \\[servername]\[share]\VividRock\MECM Toolkit\Maintenance Tasks\Content Management\Content Management - Redistribute Failed Content.ps1

    Create Scheduled Task
      1. Create Folder Structure: Task Scheduler Library / [CompanyName] / MECM / Maintenance Tasks
      2. Create Scheduled Task
        General Tab
          Name: Content Management - Redistribute Failed Content
          Description: This script runs as a Scheduled Task and performs the tasks necessary to redistribute failed content distributions to their respective Distribution Points without unnecessarily redistributing to Distribution Points that already successfully received the content.
          User Account: MECM_MaintTasks
          Run Option: Run whether user is logged on or not
        Triggers Tab
          Note: Set this to run on a schedule that meets our organization's needs.
          Recommended: Every 4 Hours @ 23:00 Local Time
        Action Tab
          Action: Start a Program
            Program/Script: powershell.exe
            Arguments: -NoProfile -NoLogo -WindowStyle Hidden -ExecutionPolicy Bypass -File "" -SiteCode "" -SMSProvider "" -Exclude "" -OutputDir "" -OutputName ""
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
    $Param_SiteCode         = $SiteCode
    $Param_SMSProvider      = $SMSProvider
    $Param_Exclude          = $Exclude
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
    $Path_AdminService_ODataRoute = "https://$($Param_SMSProvider)/AdminService/v1.0/"
    $Path_AdminService_WMIRoute   = "https://$($Param_SMSProvider)/AdminService/wmi/"

  # Files

  # Hashtables
    $Hashtable_Content_ObjectTypeID = @{
      "2"     =   @{
        WMISource     = "SMS_Package"
        FriendlyName  = "Package"
      }
      "14"    =   @{
        WMISource     = "SMS_OperatingSystemInstallPackage"
        FriendlyName  = "Operating System Install Package"
      }
      "18"    =   @{
        WMISource     = "SMS_ImagePackage"
        FriendlyName  = "Image Package"
      }
      "19"    =   @{
        WMISource     = "SMS_BootImagePackage"
        FriendlyName  = "Boot Image Package"
      }
      "21"    =   @{
        WMISource     = "SMS_DeviceSettingPackage"
        FriendlyName  = "Device Settings Package"
      }
      "23"    =   @{
        WMISource     = "SMS_DriverPackage"
        FriendlyName  = "Driver Package"
      }
      "24"    =   @{
        WMISource     = "SMS_SoftwareUpdatesPackage"
        FriendlyName  = "Software Updates Package"
      }
      "31"    =   @{
        WMISource     = "SMS_Application"
        FriendlyName  = "Application"
      }
    }

    $Hashtable_SMSPackageStatus_Status = @{
      "0"	= "NONE"
      "1"	= "SENT"
      "2"	= "RECEIVED"
      "3"	= "INSTALLED"
      "4"	= "RETRY"
      "5"	= "FAILED"
      "6"	= "REMOVED"
      "7"	= "PENDING_REMOVE"
    }

  # Arrays

  # Registry

  # WMI
    $WMI_Class_Sources = @{
      "SMS_PackageStatus" = "Status"
      "SMS_DistributionPoint" = "DistributionPoint"
      "SMS_Package" = "Package"
      "SMS_OperatingSystemInstallPackage" = "Operating System Upgrade"
      "SMS_ImagePackage"  = "Operating System Image"
      "SMS_BootImagePackage"  = "Boot Image"
      "SMS_DeviceSettingPackage"  = "Device Setting"
      "SMS_DriverPackage" = "Driver Package"
      "SMS_SoftwareUpdatesPackage"  = "Software Update"
      "SMS_Application" = "Application"
    }

  # Datasets
    $Dataset_Redistribute_Results = @()

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
    Write-Host "    - WMI Class Sources"
    foreach ($Item in $WMI_Class_Sources.GetEnumerator()) {
      Write-Host "        $($Item.Key)"
    }
    Write-Host "    - Content Object Type IDs"
    foreach ($Item in $Hashtable_Content_ObjectTypeID.GetEnumerator()) {
      Write-Host "        $($Item.Key)"
      foreach ($SubItem in $Item.Value.GetEnumerator()) {
        Write-Host "          $($SubItem.Key): $($SubItem.Value)"
      }
    }
    Write-Host "    - SMS_PackageStatus: Status Codes"
    foreach ($Item in $Hashtable_SMSPackageStatus_Status.GetEnumerator()) {
      Write-Host "        $($Item.Key): $($Item.Value)"
    }
    Write-Host "    - Excluded"
    foreach ($Item in $Param_Exclude) {
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

  # WMI Classes
    Write-Host "    - WMI Classes"

    try {
      foreach ($Item in $WMI_Class_Sources.GetEnumerator().Name) {
        Write-Host "        Variable Name: Dataset_$($Item)"

        # Determine Expression
          if ($Item -eq "SMS_PackageStatus") {
            $Temp_Criteria = "?`$select=PackageId,PkgServer,Status%20&`$filter=Status%20eq%205"
          }
          elseif ($Item -eq "SMS_DistributionPoint") {
            $Temp_Criteria = "?`$select=PackageId,ObjectTypeID,SecureObjectID"
          }
          elseif ($Item -eq "SMS_Application") {
            $Temp_Criteria = "?`$select=ModelName,Manufacturer,LocalizedDisplayName,SoftwareVersion"
          }
          else {
            $Temp_Criteria = "?`$select=PackageId,Name"
          }

        # Create Variables with REST API Content
          New-Variable -Name "Dataset_$($Item)" -Value $((Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute + $Item + $Temp_Criteria)" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value)

          Write-Host "            Count: $(((Get-Variable -Name "Dataset_$($Item)").Value | Measure-Object).Count)"
      }

      Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
    }

	# Filter Datasets
    Write-Host "    - Filter Datasets"

    try {
      Write-Host "        SMS_DistributionPoint: Get Unique"
      Write-Host "          Old Count: $($Dataset_SMS_DistributionPoint.Count)"
      $Dataset_SMS_DistributionPoint = $Dataset_SMS_DistributionPoint | Get-Unique -AsString
      Write-Host "          New Count: $($Dataset_SMS_DistributionPoint.Count)"
      Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1602 -Exit $true -Object $PSItem
    }

	# Create Result Dataset
    Write-Host "    - Create Result Dataset"

    try {
      foreach ($Item in $Dataset_SMS_PackageStatus) {
        # Construct Temporarary Object
          $Temp_Object = [PSCustomObject]@{
            "PackageID"     = $Item.PackageID
            "ObjectTypeID"  = $null
            "ObjectType"    = $null
            "Name"          = $null
            "ModelName"     = $null
            "PkgServer"     = $null
            "Status"        = $Item.Status
            "Result"        = "Not Started"
          }

        # Get ObjectTypeID
          $Temp_Object.ObjectTypeID = ($Dataset_SMS_DistributionPoint | Where-Object -Property "PackageID" -eq $Item.PackageID).ObjectTypeID

        # Get ObjectType
          $Temp_Object.ObjectType = $Hashtable_Content_ObjectTypeID."$($Temp_Object.ObjectTypeID)".FriendlyName

        # Cleanup PkgServer String
          $Pattern    = '\\\\(.*?)\\'
          $Temp_Object.PkgServer = [regex]::Match($Item.PkgServer, $Pattern).Groups[1].Value

        # Add To Result Dataset
          $Dataset_Redistribute_Results += $Temp_Object
      }
      Write-Host "        Count: $($Dataset_Redistribute_Results.Count)"
      Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1603 -Exit $true -Object $PSItem
    }

	# Get Package Names
    Write-Host "    - Get Package Names"

    try {
      foreach ($Item in $Dataset_Redistribute_Results) {
        switch ($Item.ObjectTypeID) {
          2 {
            # Get Application ID
              $Item.ModelName = "N/A"

            # Get Name
              $Item.Name = ($Dataset_SMS_Package | Where-Object -Property "PackageID" -eq $Item.PackageID | Select-Object -First 1).Name
          }
          14 {
            # Get Application ID
              $Item.ModelName = "N/A"

            # Get Name
              $Item.Name = ($Dataset_SMS_OperatingSystemInstallPackage | Where-Object -Property "PackageID" -eq $Item.PackageID | Select-Object -First 1).Name
          }
          18 {
            # Get Application ID
              $Item.ModelName = "N/A"

            # Get Name
              $Item.Name = ($Dataset_SMS_ImagePackage | Where-Object -Property "PackageID" -eq $Item.PackageID | Select-Object -First 1).Name
          }
          19 {
            # Get Application ID
              $Item.ModelName = "N/A"

            # Get Name
              $Item.Name = ($Dataset_SMS_BootImagePackage | Where-Object -Property "PackageID" -eq $Item.PackageID | Select-Object -First 1).Name
          }
          23 {
            # Get Application ID
              $Item.ModelName = "N/A"

            # Get Name
              $Item.Name = ($Dataset_SMS_DriverPackage | Where-Object -Property "PackageID" -eq $Item.PackageID | Select-Object -First 1).Name
          }
          24 {
            # Get Application ID
              $Item.ModelName = "N/A"

            # Get Name
              $Item.Name = ($Dataset_SMS_SoftwareUpdatesPackage | Where-Object -Property "PackageID" -eq $Item.PackageID | Select-Object -First 1).Name
          }
          31 {
            # Get Application ID
              $Item.ModelName = ($Dataset_SMS_DistributionPoint | Where-Object -Property "PackageID" -eq $Item.PackageID | Select-Object -First 1).SecureObjectID

            # Get Name
              $Temp_Application_Object = ($Dataset_SMS_Application | Where-Object -Property "ModelName" -eq $Item.ModelName | Select-Object -First 1)
              $Item.Name = "$($Temp_Application_Object.Manufacturer) - $($Temp_Application_Object.LocalizedDisplayName) - $($Temp_Application_Object.SoftwareVersion)"
          }
          Default {$Temp_Object.ObjectType = "Unknown"}
        }
      }

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

	# Redistribute Content
		Write-Host "    - Redistribute Content"

		foreach ($Item in $Dataset_Redistribute_Results) {
      $Temp_Expression = $null

			Write-Host "        $($Item.Name)"
      Write-Host "          Target DP: $($Item.PkgServer)"

			try {
        switch ($Item.ObjectTypeID) {
          2  {
            $Temp_Expression = "Get-CMPackage -Id $($Item.PackageID) -Fast | Invoke-CMContentRedistribution -DistributionPointName $($Item.PkgServer)"
            $Item.Result = "Pending"
          }
          14 {
            $Temp_Expression = "Get-CMOperatingSystemInstaller -Id $($Item.PackageID) | Invoke-CMContentRedistribution -DistributionPointName $($Item.PkgServer)"
            $Item.Result = "Pending"
          }
          18 {
            $Temp_Expression = "Get-CMOperatingSystemImage -Id $($Item.PackageID) | Invoke-CMContentRedistribution -DistributionPointName $($Item.PkgServer)"
            $Item.Result = "Pending"
          }
          19 {
            $Temp_Expression = "Get-CMBootImage -Id $($Item.PackageID) | Invoke-CMContentRedistribution -DistributionPointName $($Item.PkgServer)"
            $Item.Result = "Pending"
          }
          21 {
            # Unknown
            $Item.Result = "Unknown"
          }
          23 {
            $Temp_Expression = "Get-CMDriverPackage -Id $($Item.PackageID) -Fast | Invoke-CMContentRedistribution -DistributionPointName $($Item.PkgServer)"
            $Item.Result = "Pending"
          }
          24 {
            $Temp_Expression = "Get-CMSoftwareUpdateDeploymentPackage -Id $($Item.PackageID) | Invoke-CMContentRedistribution -DistributionPointName $($Item.PkgServer)"
            $Item.Result = "Pending"
          }
          31 {
            $Temp_Expression = "Get-CMApplication -ModelName $($Item.ModelName) -Fast | Invoke-CMContentRedistribution -DistributionPointName $($Item.PkgServer)"
            $Item.Result = "Pending"
          }
          Default { $Item.Result = "Uknown ObjectTypeID" }
        }

        # Execute the Expression
          if ($Temp_Expression) {
            $Temp_Result = Invoke-Expression -Command $Temp_Expression
            $Item.Result = "Started"
            Write-Host "          Status: Started"
          }
          else {
            $Item.Result = "Skipped"
            Write-Host "          Status: Skipped. Operation unknown for this object type."
          }

        # # Sleep So MECM Can Process Content Distribution Request
        #   Start-Sleep -Seconds 3
			}
			catch {
				Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
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

  # Output Results (Console)
		Write-Host "    - Output Results (Console)"

		try {
      $Dataset_Redistribute_Results | Format-Table -Property PackageID,Name,Result
			Write-Host "        Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 1801 -Exit $true -Object $PSItem
		}

  # Output Results (CSV)
		Write-Host "    - Output Results (CSV)"

		try {
      $Temp_Output_CSVFile = "$($Param_OutputDir)\$($Param_OutputName).csv"
      Write-Host "        Path: $($Temp_Output_CSVFile)"
      Set-Location -Path "filesystem::$($Param_OutputDir)"
      $Dataset_Redistribute_Results | ConvertTo-Csv | Out-File -FilePath $Temp_Output_CSVFile
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