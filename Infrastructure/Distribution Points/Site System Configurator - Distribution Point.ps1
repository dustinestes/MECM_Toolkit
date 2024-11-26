#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
  [string]$SiteCode,                          # 'ABC'
  [string]$SMSProvider,                       # '[ServerFQDN]'
  [array]$AdminGroupMembers,                  # ('GroupName','UserName')
	[string]$DiskDriveLetter,                   # 'E:'
  [int]$DiskDriveSizeMinMB,                   # '300'
	[string]$DiskDriveLabel,                    # 'MECM Distribution Point Content'
	[string]$CertTemplateAuth,                  # 'Computer Authentication'
  [string]$CertTemplateIIS,                   # 'IIS Server'
	[string]$CertTargetStore                    # 'cert:\LocalMachine\My'
)

#--------------------------------------------------------------------------------------------
  Start-Transcript -Path "C:\VividRock\MECM Toolkit\Logs\Site System Configuration\DistributionPoint.log" -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

  Write-Host "------------------------------------------------------------------------------"
  Write-Host "  MECM Toolkit - Infrastructure - Site System Configuration - Distribution Point"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host "    Author:     Dustin Estes"
  Write-Host "    Company:    VividRock"
  Write-Host "    Date:       2016-02-18"
  Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
  Write-Host "    Purpose:    Automatically configure a server as a Site System Server with"
	Write-Host "								the prerequisites and role for Distribution Points."
  Write-Host "    Links:      None"
  Write-Host "    Template:   1.1"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host ""

<#
	How to Use:
		1. Log on to the Site System Server
		2. Open PowerShell ISE in an Administrative context
		3. Paste the contents of this script into the script pane
		4. Execute this script in its entirety
		5. Follow the prompts in the console window providing feedback where necessary
		6. Perform the manual steps provided (if prompted)
		7. Confirm everything is completed so the script can cleanup

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
    $Param_SiteCode         		= $SiteCode
    $Param_SMSProvider      		= $SMSProvider
		$Param_AdminGroupMembers		= $AdminGroupMembers
		$Param_DiskDriveLetter			= $DiskDriveLetter
    $Param_DiskDriveSizeMinMB   = $DiskDriveSizeMinMB
		$Param_DiskDriveLabel				= $DiskDriveLabel
		$Param_CertTemplateAuth 		= $CertTemplateAuth
    $Param_CertTemplateIIS  		= $CertTemplateIIS
		$Param_CertTargetStore			= $CertTargetStore

  # Metadata
    $Meta_Script_Start_DateTime     = Get-Date
    $Meta_Script_Complete_DateTime  = $null
    $Meta_Script_Complete_TimeSpan  = $null
    $Meta_Script_Execution_User     = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $Meta_Script_Result 						= $false,"Failure"

  # Preferences
    $ErrorActionPreference        = "Stop"
    $CMPSSuppressFastNotUsedCheck = $true

  # Names
    $Name_Server_DNS    = $env:COMPUTERNAME
    $Name_Server_FQDN   = $Name_Server_DNS + "." + $env:USERDNSDOMAIN

  # Paths
    # $Path_AdminService_ODataRoute = "https://$($Param_SMSProvider)/AdminService/v1.0/"
    # $Path_AdminService_WMIRoute   = "https://$($Param_SMSProvider)/AdminService/wmi/"

  # Files

  # Hashtables
    $Hashtable_RolesFeatures = [ordered] @{
      # Role Service = Name

      # Add .NET Framework
          ".Net Framework 4.6" = "NET-Framework-45-Core"
          ".Net TCP Port Sharing" = "NET-WCF-TCP-PortSharing45"

      # Add Remote Differential
          "Remote Differential Compression" = "RDC"

      # Install File Server
          "File and Storage Services" = "FS-FileServer"

      # Install Windows Deployment Services
          "Windows Deployment Services" = "WDS"
          "WDS Deployment Server" = "WDS-Deployment"
          "WDS Transport Server" = "WDS-Transport"
          "WDS RSAT Tools" = "WDS-AdminPack"

      # Install Background Intelligent Transfer Service (BITS)
          "Background Intelligent Tranfser Service" = "BITS"
          "BITS IIS Server Extensions" = "BITS-IIS-Ext"
          "BITS RSAT Tools" = "RSAT-Bits-Server"

      # Add IIS Features
          "Web Server (IIS) Security" = "Web-Security"
          "Web Server (IIS) Request Filtering" = "Web-Filtering"
          "Web Server (IIS) Windows Authentication" = "Web-Windows-Auth"
          "Web Server (IIS) IIS 6 WMI Compatibility" = "Web-WMI"
          "Web Server (IIS) IIS 6 Metabase Compatibility" = "Web-Metabase"
          "Web Server (IIS) IIS Management Scripts and Tools" = "Web-Scripting-Tools"
          "Web Server (IIS) ISAPI Extensions" = "Web-ISAPI-Ext"
    }

  # Arrays

  # Registry

  # WMI

  # Datasets

	# Filters
		$Filter_DiskDrive_VolumeSizeMB = $Param_DiskDriveSizeMinMB
		$Filter_DiskDrive_VolumeDriveLetter = $Param_DiskDriveLetter,"",$null
		$Filter_DiskDrive_VolumeDriveType = 3

  # Temporary

  # Output to Log
    Write-Host "    - Parameters"
    foreach ($Item in (Get-Variable -Name "Param_*")) {
      Write-Host "        $(($Item.Name) -replace 'Param_',''): $($Item.Value)"
    }
    Write-Host "    - Names"
    foreach ($Item in (Get-Variable -Name "Name_*")) {
      Write-Host "        $(($Item.Name) -replace 'Path_',''): $($Item.Value)"
    }
    Write-Host "    - Filters"
    foreach ($Item in (Get-Variable -Name "Filter_*")) {
      Write-Host "        $(($Item.Name) -replace 'Filter_',''): $($Item.Value)"
    }
    Write-Host "    - Roles & Features"
    foreach ($Item in $Hashtable_RolesFeatures.GetEnumerator()) {
      Write-Host "        $($Item.Key): $($Item.Value)"
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

				# # Set the Location
				# 	Write-Host "        Set the Location"

				# 	if ((Get-Location).Path -ne "$($Param_SiteCode):\") {
				# 		Set-Location "$($Param_SiteCode):\"
				# 		Write-Host "            Status: Success"
				# 	}
				# 	else {
				# 		Write-Host "            Status: Already Set"
				# 	}
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


	# Disk Drives
    Write-Host "    - Disk Drives"

    try {
      $Temp_DiskDrives_Target = Get-CimInstance -ClassName Win32_Volume | Where-Object -Property DriveLetter -eq $Param_DiskDriveLetter

      # Drive Exists
        if ($Temp_DiskDrives_Target -notin "",$null) {
          Write-Host "        Drive Exists ($($Param_DiskDriveLetter)): True"
        }
        else {
          Write-Host "        Drive Exists ($($Param_DiskDriveLetter)): False"
          Throw "A drive with the specified drive letter was not found."
        }

      # Drive Size Adequate
        if ($Temp_DiskDrives_Target.Capacity -ge ($Param_DiskDriveSizeMinMB * 1kb)) {
          Write-Host "        Drive Size Adequate ($($Param_DiskDriveSizeMinMB) MB): True"
        }
        else {
          Write-Host "        Drive Size Adequate ($($Param_DiskDriveSizeMinMB)): False"
          Throw "A drive with adequate capacity was not found ($($Param_DiskDriveSizeMinMB) MB or greater)."
        }

      Write-Host "        Status: Success"
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

	# Administrators Group Membership
    Write-Host "    - Administrators Group Membership"

    try {
      $Temp_Group_Aministrators_Members = Get-LocalGroupMember -Name "Administrators"
      Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
    }

	# Target Disk Drive
    Write-Host "    - Target Disk Drive"

    try {
      $Temp_DiskDrives_Target = Get-CimInstance -ClassName Win32_Volume | Where-Object -Property DriveLetter -eq $Param_DiskDriveLetter

      Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1602 -Exit $true -Object $PSItem
    }

	# [StepName]
		Write-Host "    - [StepName]"

		try {

			Write-Host "        Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 1603 -Exit $true -Object $PSItem
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

	# Local Administrators Group Membership
		Write-Host "    - Local Administrators Group Membership"

    foreach ($Item in $Param_AdminGroupMembers) {
      try {
        Write-Host "      Member: $($Item)"
        if ($Item -in $Temp_Group_Aministrators_Members) {
          Write-Host "        Status: Already Exists"
        }
        else {
          Add-LocalGroupMember -Group "Administrators" -Member $Item
          Write-Host "        Status: Added"
        }
      }
      catch {
        Write-vr_ErrorCode -Code 1701 -Exit $false -Object $PSItem
      }
    }

  #------------------------------------------------------------------------------------------

	# Configure Data Drive
		Write-Host "    - Configure Data Drive"

		try {
      Write-Host "        Letter: $($Temp_DiskDrives_Target.DriveLetter)"
      Write-Host "        Capacity (GB): $([math]::Round($Temp_DiskDrives_Target.Capacity / 1mb, 2))"
      Write-Host "        New Label: $($Param_DiskDriveLabel)"

      Set-CimInstance -InputObject $Temp_DiskDrives_Target -Property @{Label = "$($Param_DiskDriveLabel)"}

			Write-Host "        Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 1702 -Exit $true -Object $PSItem
		}

  # Add NO_SMS_ON_DRIVE.sms File
		Write-Host "    - Add NO_SMS_ON_DRIVE.sms File"

		try {
      $Temp_Path_MECM_NoSMSFile = "$($Temp_DiskDrives_Target.DriveLetter)\NO_SMS_ON_DRIVE.sms"
      Write-Host "        Path: $($Temp_Path_MECM_NoSMSFile)"

      if (Test-Path -Path $Temp_Path_MECM_NoSMSFile -PathType Leaf) {
        Write-Host "        Status: Already Exist"
      }
      else {
          New-Item -Path $($Param_DiskDriveLetter + "\") -Name "NO_SMS_ON_DRIVE.sms" -ItemType File -Force | Out-Null
          Write-Host " Success"
      }

			Write-Host "        Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 1703 -Exit $false -Object $PSItem
		}

	# Start UI for Validation
    Write-Host "    - Start UI for Validation"

    try {
      Start-Process -FilePath explorer.exe
      Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1704 -Exit $true -Object $PSItem
    }

  #------------------------------------------------------------------------------------------

  # Enroll in Certificates
    Write-Host "    - Enroll in Certificates"

    # Computer Authentication Certificate
      Write-Host "        Template Name: $($Param_CertTemplateAuth)"

			try {
        $Temp_Result_Enroll = Get-Certificate -CertStoreLocation $Param_CertTargetStore -Template "$($Param_CertTemplateAuth)" -Url ldap:

        Write-Host "          Status:   "$Temp_Result_Enroll.Status
        Write-Host "          Subject:  "$Temp_Result_Enroll.Certificate.Subject
        Write-Host "          Key Usage:"$Temp_Result_Enroll.Certificate.EnhancedKeyUsageList
        Write-Host "          Issued:   "$Temp_Result_Enroll.Certificate.NotBefore
        Write-Host "          Expires:  "$Temp_Result_Enroll.Certificate.NotAfter
			}
			catch {
				Write-vr_ErrorCode -Code 1705 -Exit $true -Object $PSItem
			}

    # IIS Certificate
      Write-Host "        Template Name: $($Param_CertTemplateIIS)"

      try {
        $Temp_Result_Enroll = Get-Certificate -SubjectName $("CN=" + $Name_Server_FQDN) -DnsName $Name_Server_DNS, $Name_Server_FQDN -CertStoreLocation $Param_CertTargetStore -Template "$($Param_CertTemplateIIS)" -Url ldap:

        Write-Host "          Status:   "$Temp_Result_Enroll.Status
        Write-Host "          Subject:  "$Temp_Result_Enroll.Certificate.Subject
        Write-Host "          Key Usage:"$Temp_Result_Enroll.Certificate.EnhancedKeyUsageList
        Write-Host "          Issued:   "$Temp_Result_Enroll.Certificate.NotBefore
        Write-Host "          Expires:  "$Temp_Result_Enroll.Certificate.NotAfter
      }
      catch {
        Write-vr_ErrorCode -Code 1706 -Exit $true -Object $PSItem
      }


	# Start UI for Validation
    Write-Host "    - Start UI for Validation"

    try {
      Start-Process -FilePath certlm.msc
      Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1707 -Exit $true -Object $PSItem
    }

  #------------------------------------------------------------------------------------------

	# Install Roles and Features
    Write-Host "    - Install Roles and Features"

    foreach ($Item in $Hashtable_RolesFeatures.GetEnumerator()) {
      Write-Host "        $($Item.Key)"

      try {
        if ((Get-WindowsFeature -Name $Item.Value).Installed -eq $true) {
          Write-Host "        Status: Already Installed"
        }
        else {
          $Temp_Result_Install = Install-WindowsFeature -Name $Item.Value

          if ($Temp_Result_Install.Success -eq $true) {
            Write-Host "        Status: Installed"
            Write-Host "        Feature Result: $($Temp_Result_Install.FeatureResult)"
            Write-Host "        Restart Needed: $($Temp_Result_Install.RestartNeeded)"
          }
          else {
            Write-Host "        Status: Error Installing Role. Try installing manually before proceeding."
            Pause
          }
        }

        # Sleep to Allow for Changes to Take Effect
          Start-Sleep -Seconds 10
      }
      catch {
        Write-vr_ErrorCode -Code 1708 -Exit $true -Object $PSItem
      }
    }

	# Start UI for Validation
    Write-Host "    - Start UI for Validation"

    try {
      Start-Process -FilePath ServerManager.exe -ArgumentList "-arw"
      Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1709 -Exit $true -Object $PSItem
    }

  #------------------------------------------------------------------------------------------

	# Configure IIS Role
    Write-Host "    - Configure IIS Role"

    # Get Certificate Information
      Write-Host "        Get Certificate Information"

      try {
        Write-Host "          Name: $($Param_CertTemplateIIS)"
        $Temp_Result_Certificate = Get-ChildItem $Param_CertTargetStore | Where-Object -FilterScript {($_.Extensions.Format(1)[0].split('(')[0] -replace "template=") -match $Param_CertTemplateIIS}
        Write-Host "          Thumbprint: $($Temp_Result_Certificate.Thumbprint)"
      }
      catch {
        Write-vr_ErrorCode -Code 1710 -Exit $true -Object $PSItem
      }

    # Create SSL Binding Using Certificate
      Write-Host "        Create SSL Binding Using Certificate"

      try {
        Write-Host "          Website Name: Default Web Site"
        Write-Host "          Port Binding: *:443"
        Write-Host "          Protocol: HTTPS"
        $Temp_Result_IISConfigure = New-IISSiteBinding -Name "Default Web Site" -BindingInformation "*:443:" -CertificateThumbPrint $Temp_Result_Certificate.Thumbprint -CertStoreLocation $Param_CertTargetStore -Protocol https
        Write-Host "          Status: Success"
      }
      catch {
        Write-vr_ErrorCode -Code 1711 -Exit $true -Object $PSItem
      }

	# Start UI for Validation
    Write-Host "    - Start UI for Validation"

    try {
      Start-Process -FilePath inetmgr.exe
      Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1712 -Exit $true -Object $PSItem
    }

  #------------------------------------------------------------------------------------------

  # Set the MECM Drive Location
    Write-Host "    - Set the MECM Drive Location"

    try {
      Write-Host "            Path: $($Param_SiteCode):\"
      if ((Get-Location).Path -ne "$($Param_SiteCode):\") {
        Set-Location "$($Param_SiteCode):\"
        Write-Host "            Status: Success"
      }
      else {
        Write-Host "            Status: Already Set"
      }

      Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1713 -Exit $true -Object $PSItem
    }

	# Add Server to Hierarchy
		Write-Host "    - Add Server to Hierarchy"

		try {
      New-CMSiteSystemServer -SiteSystemServerName $Name_Server_FQDN -SiteCode $Param_SiteCode
			Write-Host "        Status: Success"

      # Pause to Allow Change to Take Effect
        Start-Sleep -Seconds 30
		}
		catch {
			Write-vr_ErrorCode -Code 1714 -Exit $true -Object $PSItem
		}

	# Add Distribution Point Role
    Write-Host "    - Add Distribution Point Role"

    try {
      $Temp_Params = @{
          ClientConnectionType = "Intranet"
          EnableSsl                     = $true
          MinimumFreeSpaceMB            = 1024
          PrimaryContentLibraryLocation = $Param_DiskDriveLetter -replace ":",""
          PrimaryPackageShareLocation   = $Param_DiskDriveLetter -replace ":",""
          SiteCode                      = $Param_SiteCode
          SiteSystemServerName          = $Name_Server_FQDN
          CertificateExpirationTimeUtc  = [DateTime]::Now.AddYears(30)
      }

      Add-CMDistributionPoint @Temp_Params

      Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1702 -Exit $true -Object $PSItem
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
		Write-Host "  Script Result: $($Meta_Script_Result[1])"
		Write-Host "  Script Started: $($Meta_Script_Start_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
		Write-Host "  Script Completed: $($Meta_Script_Complete_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
		Write-Host "  Total Time: $($Meta_Script_Complete_TimeSpan.Days) days, $($Meta_Script_Complete_TimeSpan.Hours) hours, $($Meta_Script_Complete_TimeSpan.Minutes) minutes, $($Meta_Script_Complete_TimeSpan.Seconds) seconds, $($Meta_Script_Complete_TimeSpan.Milliseconds) milliseconds"
		Write-Host "------------------------------------------------------------------------------"
		Write-Host "  End of Script"
		Write-Host "------------------------------------------------------------------------------"

#EndRegion Footer
#--------------------------------------------------------------------------------------------

Stop-Transcript -ErrorAction SilentlyContinue
Return $Meta_Script_Result[0]