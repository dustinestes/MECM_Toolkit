#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
  [string]$Namespace,               			# "root\VividRock\MECM"
  [string]$ClassName,                     # "vr_Certificates"
  [string]$ClassVersion,                  # "1.0"                   This is used to increment the version of your WMI Class when changes are made to its construct
  [array]$CertificateStores,              # @("LocalMachine\My","CurrentUser\My")
  [switch]$Recurse,                       # [Switch]                Determines whether the search for certificates is recursive or not
  [bool]$RemoveInvalid,                   # [boolean]               If true, the script will remove any WMI Instances that do not match the list of Certificate thumbprints. This can help cleanup deleted/uninstalled certificates from WMI. Warning: If you enable this setting and you run this script with different parameters, could remove instances found by a previous execution. It is recommended you only run one instance of this script on the device and use the parameters to be as inclusive as necessary to get all Certificates in one execution.
  [string]$OutputDir                      # "\\[PathToOutput]"      If blank, no output is performed
)

#--------------------------------------------------------------------------------------------
# Start-Transcript -Path "C:\VividRock\MECM Toolkit\Logs\Configuration Item\Certificate - Mirror to WMI.log" -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

  Write-Host "------------------------------------------------------------------------------"
  Write-Host "  MECM Toolkit - Configuration Item - Certificate - Mirror to WMI"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host "    Author:     Dustin Estes"
  Write-Host "    Company:    VividRock"
  Write-Host "    Date:       2020-09-12"
  Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
  Write-Host "    Purpose:    Converts Certificate properties and data to WMI entries so they"
	Write-Host "								can be inventoried by MECM."
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

  # Files

  # Hashtables

  # Arrays

  # Patterns
    $Pattern_Certificates_StoreName       = "Certificate::(?:.*?)\\(.*?)\\"
    $Pattern_Certificates_TemplateName    = "^Template=(.+)\([0-9\.]+\)"

  # Registry

  # WMI

  # Datasets
    $Dataset_Certificates = @()

  # Temporary

  # Output to Log
    Write-Host "    - Parameters"
    $Temp_Padding = ($PSBoundParameters.Keys | Measure-Object -Property Length -Maximum).Maximum + 1
    foreach ($Item in $PSBoundParameters.GetEnumerator()) {
      Write-Host "        $($Item.Key.PadRight($Temp_Padding)): $($Item.Value)"
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

  # New-vr_WMIClass
    Write-Host "    - New-vr_WMIClass"
    function New-vr_WMIClass () {
      [CmdletBinding()]
      param (
          [Parameter()]
          [string]$Namespace,
          [Parameter()]
          [string]$ClassName,
          [Parameter()]
          [decimal]$ClassVersion
      )

      begin {

      }

      process {
        try {
          # Create WMI Class Object
            $Class_Object = New-Object System.Management.ManagementClass ($Namespace, [String]::Empty, $null)
            $Class_Object["__Class"] = $ClassName

          # Add Qualifiers to Class Object
            $Class_Object.Qualifiers.Add("Static", $true)
            $Class_Object.Qualifiers.Add("Version", "$($ClassVersion)")

          # Add Properties to Class Object
            $Class_Object.Properties.Add("Name", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("Thumbprint", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("Subject", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("SubjectAlternativeName", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("SubjectKeyIdentifier", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("AuthorityKeyIdentifier", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("FriendlyName", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("Issuer", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("IssuedBy", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("ValidFromUTC", [System.Management.CimType]::DateTime, $false)
            $Class_Object.Properties.Add("ValidToUTC", [System.Management.CimType]::DateTime, $false)
            $Class_Object.Properties.Add("ValidFromString", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("ValidToString", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("Archived", [System.Management.CimType]::Boolean, $false)
            $Class_Object.Properties.Add("KeyUsage", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("EnhancedKeyUsageList", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("CertificateTemplate", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("CertificateTemplateName", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("SerialNumber", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("Version", [System.Management.CimType]::SInt32, $false)
            $Class_Object.Properties.Add("SignatureAlgorithm", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("PrivateKeyKeyExchangeAlgorithm", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("PrivateKeyProviderName", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("PrivateKeyExportable", [System.Management.CimType]::Boolean, $false)
            $Class_Object.Properties.Add("PrivateKeyHardwareDevice", [System.Management.CimType]::Boolean, $false)
            $Class_Object.Properties.Add("PrivateKeySignatureAlgorithm", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("PrivateKeySize", [System.Management.CimType]::SInt32, $false)
            $Class_Object.Properties.Add("PublicKeyAlgorithm", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("PublicKeyProviderName", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("PublicKeySize", [System.Management.CimType]::SInt32, $false)
            $Class_Object.Properties.Add("PublicKeyString", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("StoreLocation", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("StoreName", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("StoreOwner", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("CIM_LastUpdatedUTC", [System.Management.CimType]::DateTime, $false)

          # Declare Key(s) in Class Object
            $Class_Object.Properties["Name"].Qualifiers.Add("Key", $true)
            $Class_Object.Properties["Thumbprint"].Qualifiers.Add("Key", $true)

          # Put WMI Class Object
            $Class_Object.Put() | Out-Null
        }
        catch {
          Write-vr_ErrorCode -Code 1301 -Exit $true -Object $PSItem
        }
      }

      end {

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

  # WMI Path Exists
    Write-Host "    - WMI Path Exists"
    Write-Host "        $($Namespace)"
    $Temp_Path = $null

		foreach ($Item in ($Namespace -split "\\")) {
			try {
        Write-Host "          Namespace: $($Temp_Path + $Item)"
        $Result = Get-WmiObject -Namespace $($Temp_Path + $Item) -Class "__NAMESPACE" -ErrorAction SilentlyContinue
        if ($Result) {
          Write-Host "            Status: Exists"
        }
        else {
          Set-WmiInstance -Namespace $Temp_Path.TrimEnd("\") -Class "__NAMESPACE" -Arguments @{Name="$($Item)"} -ErrorAction SilentlyContinue | Out-Null
          Write-Host "            Status: Created"
        }

        $Temp_Path += $item + "\"
			}
			catch {
			  Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
			}
		}

  # WMI Class Exists
		Write-Host "    - WMI Class Exists"

		try {
      if (Get-CimClass -Namespace $Namespace -ClassName $ClassName) {
        Write-Host "        Status: Exists"
      }
		}
		catch {
      if ($_.Exception.Message -like "*Not found*") {
        New-vr_WMIClass -Namespace $Namespace -ClassName $ClassName -ClassVersion $ClassVersion

        Write-Host "        Status: Created"
      }
      else {
        Write-vr_ErrorCode -Code 1502 -Exit $true -Object $PSItem
      }
    }

  # WMI Class Version
    Write-Host "    - WMI Class Version"

    try {
      $Temp_ClassVersion = ((Get-CimClass -Namespace $Namespace -ClassName $ClassName).CimClassQualifiers | Where-Object -Property Name -eq "Version").Value
        Write-Host "        Current: $($Temp_ClassVersion)"
        Write-Host "        Required: $($ClassVersion)"

      if ($Temp_ClassVersion -ge $ClassVersion) {
        Write-Host "        Status: Valid"
      }
      else {
        # Remove Existing Class
          Remove-WmiObject -Namespace $Namespace -Class $ClassName

        # Create New Class
          New-vr_WMIClass -Namespace $Namespace -ClassName $ClassName -ClassVersion $ClassVersion

        Write-Host "        Status: Recreated"
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

	# Get Certificates from Stores
    Write-Host "    - Get Certificates from Stores"
    $Temp_Certificates = @()

    foreach ($Item in ($CertificateStores | ForEach-Object { "Cert:\$($_)" })) {
      try {
        Write-Host "        Store: $($Item)"
        Write-Host "          Recurse: $($Recurse)"
        $Temp_Certificates += Get-ChildItem -Path $Item -Recurse:$($Param_Recurse)
        Write-Host "          Count: $(($Temp_Certificates | Where-Object -Property "PSParentPath" -match `"$([regex]::Escape($Item -replace 'Cert:\\'))`" | Measure-Object).Count)"
      }
      catch {
        Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
      }
    }

    Write-Host "          Status: Success"

	# Construct Dataset
    Write-Host "    - Construct Dataset"

    foreach ($Item in $Temp_Certificates) {
      try {
        Write-Host "        $($Item.Thumbprint): $($Item.Subject)"

        # Create Custom Objects and Add to Array
          $Temp_Object = [PSCustomObject]@{
            "Name"                            = $Item.Thumbprint
            "Thumbprint"                      = $Item.Thumbprint
            "Subject"                         = $Item.Subject
            "SubjectAlternativeName"          = $null # Value Set Below
            "SubjectKeyIdentifier"            = $null # Value Set Below
            "AuthorityKeyIdentifier"          = $null # Value Set Below
            "FriendlyName"                    = $Item.FriendlyName
            "Issuer"                          = $Item.Issuer
            "IssuedBy"                        = $Item.GetNameInfo("SimpleName", $true)
            "ValidFromUTC"                    = $Item.NotBefore
            "ValidToUTC"                      = $Item.NotAfter
            "ValidFromString"                 = $Item.GetEffectiveDateString()
            "ValidToString"                   = $Item.GetExpirationDateString()
            "Archived"                        = $Item.Archived
            "KeyUsage"                        = $null # Value Set Below
            "EnhancedKeyUsageList"            = (($Item.EnhancedKeyUsageList | Select-Object -ExpandProperty "FriendlyName") -join ",") # Necessary to Prevent Object[] Data Type
            "CertificateTemplate"             = $null # Value Set Below
            "CertificateTemplateName"         = $null # Value Set Below
            "SerialNumber"                    = $Item.SerialNumber
            "Version"                         = $Item.Version
            "SignatureAlgorithm"              = $Item.SignatureAlgorithm.FriendlyName
            "PrivateKeyKeyExchangeAlgorithm"  = $Item.PrivateKey.KeyExchangeAlgorithm
            "PrivateKeyProviderName"          = $Item.PrivateKey.CspKeyContainerInfo.ProviderName
            "PrivateKeyExportable"            = $Item.PrivateKey.CspKeyContainerInfo.Exportable
            "PrivateKeyHardwareDevice"        = $Item.PrivateKey.CspKeyContainerInfo.HardwareDevice
            "PrivateKeySignatureAlgorithm"    = $Item.PrivateKey.SignatureAlgorithm
            "PrivateKeySize"                  = $Item.PrivateKey.KeySize
            "PublicKeyAlgorithm"              = $Item.PublicKey.Key.KeyExchangeAlgorithm
            "PublicKeyProviderName"           = $null # Value Set Below # $Item.PublicKey.Key.CspKeyContainerInfo.ProviderName
            "PublicKeySize"                   = $Item.PublicKey.Key.KeySize
            "PublicKeyString"                 = $Item.GetPublicKeyString()
            "StoreLocation"                   = if ($Item.PSPath -match "LocalMachine") {"LocalMachine"} elseif ($Item.PSPath -match "CurrentUser") {"CurrentUser"} else {"Unknown"}
            "StoreName"                       = ([regex]::Match($Item.PSPath, $Pattern_Certificates_StoreName)).Groups[1].Value
            "StoreOwner"                      = $Meta_Script_Execution_User.Name
            "CIM_LastUpdatedUTC"              = (Get-Date).ToUniversalTime()
          }

        # Certificate Template Name
          $Temp_Object.CertificateTemplate = $Item.Extensions | Where-Object -FilterScript {$_.Oid.FriendlyName -in "Certificate Template Name", "Certificate Template Information"} | Select-Object -First 1

          # Format Output to Friendly Name
            if ($Temp_Object.CertificateTemplate -notin "", $null) {
              $Temp_Object.CertificateTemplate = $Temp_Object.CertificateTemplate.Format(1)
            }

          # Extract Template Name (Certificate Template Information)
            if ($Temp_Object.CertificateTemplate -match $Pattern_Certificates_TemplateName ) {
              $Temp_Object.CertificateTemplateName = ([regex]::Match($Temp_Object.CertificateTemplate, $Pattern_Certificates_TemplateName)).Groups[1].Value
            }

        # Extension Data
          foreach ($Item_2 in "Subject Alternative Name", "Subject Key Identifier", "Authority Key Identifier", "Key Usage") {
            if ($Item.Extensions | Where-Object -FilterScript {$_.Oid.FriendlyName -in $Item_2} | Select-Object -First 1) {
              $Temp_Object.$($Item_2 -replace " ","") = ($Item.Extensions | Where-Object -FilterScript {$_.Oid.FriendlyName -in $Item_2} | Select-Object -First 1).Format(0) # -replace "Other Name:|Principal Name="
            }
            else {
              $Temp_Object.$($Item_2 -replace " ","") = ""
            }
          }

        # Public Key Provider Name
        # For some reason you have to allow this property to write to the console before its sub properties are populated.
          $Item.PublicKey | Select-Object -ExpandProperty Key
          $Temp_Object.PublicKeyProviderName = $Item.PublicKey.Key.CspKeyContainerInfo.ProviderName

        # Add to Dataset
          $Dataset_Certificates += $Temp_Object

        Write-Host "          Status: Success"
      }
      catch {
        Write-vr_ErrorCode -Code 1602 -Exit $true -Object $PSItem
      }
    }
    Write-Host "        Count: $(($Dataset_Certificates | Measure-Object).Count)"

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

	# Create Certificate WMI Instances
    Write-Host "    - Create Certificate WMI Instances"

    foreach ($Item in $Dataset_Certificates) {
      try {
        Write-Host "        $($Item.Thumbprint): $($Item.Subject)"
        $Temp_Exists = Get-CimInstance -Namespace $Namespace -ClassName $ClassName | Where-Object -Property "Thumbprint" -eq $Item.Thumbprint

        # Construct Property Hashtable Excluding Empty Values to Avoid CimType Validation Errors
          $Temp_PropertyMap = @{}
          $Item.psobject.Properties | Where-Object {$_.Value -notin "",$null} | ForEach-Object {$Temp_PropertyMap.Add($_.Name,$_.Value)}

        # Remove Existing Instance Since we Cant Write Empty Values and Updating Instance Would Not Nullify any Existing Values
          if ($Temp_Exists) {
            Get-CimInstance -Namespace $Namespace -ClassName $ClassName -Filter "Thumbprint = '$($Temp_PropertyMap.Thumbprint)'" | Remove-CimInstance
            Write-Host "          Existing Instance: Removed"
          }

        # Create Instance
          New-CimInstance -Namespace $Namespace -ClassName $ClassName -Key "Thumbprint" -Property $Temp_PropertyMap | Out-Null
          Write-Host "          Status: Created"
      }
      catch {
        Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
      }
    }

  # Remove Invalid Certificate WMI Instances
    Write-Host "    - Remove Invalid Certificate WMI Instances"

    foreach ($Item in (Get-CimInstance -Namespace $Namespace -ClassName $ClassName)) {
      if ($RemoveInvalid) {
        try {
          Write-Host "        $($Item.Thumbprint): $($Item.Subject)"

          # Does Not Match Newly Discovered Certificates
            if ($Dataset_Certificates.Thumbprint -notcontains $Item.Thumbprint) {
              Get-CimInstance -Namespace $Namespace -ClassName $ClassName -Filter "Thumbprint = '$($Item.Thumbprint)'" | Remove-CimInstance
              Write-Host "          Status: Removed Invalid Instance"
            }
            else {
              Write-Host "          Status: Valid Instance"
            }
        }
        catch {
          Write-vr_ErrorCode -Code 1702 -Exit $true -Object $PSItem
        }
      }
      else {
        Write-Host "        Status: Parameter Set to False"
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

	# # Write Datasets to Files
  #   Write-Host "    - Write Datasets to Files"
  #   foreach ($Item in (Get-Variable -Name "Dataset_*")) {
  #     try {
  #       if ($OutputDir -notin "", $null) {
  #         Write-Host "        $($Item.Name)"
  #         $Item.Value | ConvertTo-Json | Out-File -FilePath "$($Path_Outputs_DatasetFiles)\$($Item.Name).json"
  #         Write-Verbose "          Path: $($Path_Outputs_DatasetFiles)\$($Item.Name).json"
  #         Write-Host "          Status: Success"
  #       }
  #       else {
  #         Write-Verbose "          Path: Not Provided"
  #         Write-Host "          Status: Skipped, No Directory Argument Provided"
  #       }

  #     }
  #     catch {
  #       Write-vr_ErrorCode -Code 1801 -Exit $true -Object $PSItem
  #     }
  #   }

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

	# # Remove WMI Objects (For Development & Validation ONLY)
	# 	Write-Host "    - Remove WMI Objects"

	# 	try {
	# 		if ($Temp_Cleanup_UserInput -in "Y", "Yes") {
  #       # Remove Class
  #         do {
  #           $Temp_Input_Cleanup_WMI = Read-Host -Prompt "        Do you want to remove the Class: $($ClassName)? [Y]es or [N]o"
  #         } until (
  #           $Temp_Input_Cleanup_WMI -in "Y","Yes","N","No"
  #         )

  #         if ($Temp_Input_Cleanup_WMI) {
  #           Remove-WmiObject -Namespace $Namespace -Class $ClassName
  #           Write-Host "          Status: Removed"
  #         }
  #         else {
  #           Write-Host "          Status: Skipped"
  #         }

  #       # Remove Namespace
  #         do {
  #           $Temp_Input_Cleanup_WMI = Read-Host -Prompt "        Do you want to remove the Namespace path: $($Namespace)? [Y]es or [N]o"
  #         } until (
  #           $Temp_Input_Cleanup_WMI -in "Y","Yes","N","No"
  #         )

  #         if ($Temp_Input_Cleanup_WMI) {
  #           Get-WmiObject -query "Select * From __Namespace Where Name='VividRock'" -Namespace "root" | Remove-WmiObject
  #           Write-Host "          Status: Removed"
  #         }
  #         else {
  #           Write-Host "          Status: Skipped"
  #         }
	# 		}
	# 		else {
	# 			Write-Host "        Status: Skipped"
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

# Stop-Transcript -ErrorAction SilentlyContinue
Return $Meta_Script_Result[0]
