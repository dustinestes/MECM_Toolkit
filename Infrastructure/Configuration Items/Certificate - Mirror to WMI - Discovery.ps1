#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
  [string]$Namespace="root\VividRock\MECM",               				  # "root\VividRock\MECM"
  [string]$ClassName="vr_Certificates",                             # "vr_Certificates"
  [array]$CertificateStores=@("LocalMachine\My","CurrentUser\My"),  # @("LocalMachine\My","CurrentUser\My")
  [string]$Recurse="True",                                          # "True" or "False"
  [string]$OutputDir=""                                             # "\\[PathToOutput]"          If blank, no output is performed
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
    $Param_Namespace          = $Namespace
    $Param_ClassName          = $ClassName
    $Param_CertificateStores  = $CertificateStores
    $Param_Recurse            = [System.Convert]::ToBoolean($Recurse)
    $Param_OutputDir          = $OutputDir

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
    $Path_Outputs_DatasetFiles      = if ($Param_OutputDir -notin "", $null) {"$($Param_OutputDir)\Datasets"} else {"No Output Directory Defined"}


  # Files

  # Hashtables

  # Arrays
    $Array_Certificates_Stores = $Param_CertificateStores | ForEach-Object { "Cert:\$($_)" }

  # Patterns
    $Pattern_Certificates_StoreName       = "Certificate::(?:.*?)\\(.*?)\\"
    $Pattern_Certificates_TemplateName    = "^Template=(.+)\([0-9\.]+\)"

  # Registry

  # WMI
    $WMI_Class_Version = "1.0"

  # Datasets
    $Dataset_Certificates_ClassInput = @()
      # Description: Stores the constructed Certificate Class object inputs during the Data Gather phase
      # Columns:
      # TODO: Update columns once gather and design is complete

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
    Write-Host "    - Certificate Stores"
    foreach ($Item in (Get-Variable -Name "Array_Certificates_Stores*")) {
      Write-Host "        $(($Item.Name) -replace 'Array_',''): $($Item.Value)"
    }
    Write-Host "    - Patterns"
    foreach ($Item in (Get-Variable -Name "Pattern_*")) {
      Write-Host "        $(($Item.Name) -replace 'Pattern_',''): $($Item.Value)"
    }
    Write-Host "    - WMI"
    foreach ($Item in (Get-Variable -Name "WMI_*")) {
      Write-Host "        $(($Item.Name) -replace 'WMI_',''): $($Item.Value)"
    }
    Write-Host "    - Datasets"
    foreach ($Item in (Get-Variable -Name "Dataset_*")) {
      Write-Host "        $($Item.Name)"
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
            $Class_Object.Properties.Add("ValidFrom", [System.Management.CimType]::DateTime, $false)
            $Class_Object.Properties.Add("ValidTo", [System.Management.CimType]::DateTime, $false)
            $Class_Object.Properties.Add("KeyUsage", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("EnhancedKeyUsageList", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("CertificateTemplate", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("SerialNumber", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("Version", [System.Management.CimType]::SInt32, $false)
            $Class_Object.Properties.Add("PublicKeyProviderName", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("SignatureAlgorithm", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("PublicKeyAlgorithm", [System.Management.CimType]::String, $false)
            $Class_Object.Properties.Add("PublicKeySize", [System.Management.CimType]::SInt32, $false)
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

  # Output Directories Exist
    Write-Host "    - Output Directories Exist"

    try {
      foreach ($Item in (Get-Variable -Name "Path_Outputs_*")) {
        Write-Host "        $($Item.Name): $($Item.Value)"

        if ($Param_OutputDir -in "", $null) {
          Write-Host "          Status: Skipped, No Directory Argument Provided"
        }
        elseif ((Test-Path -Path "filesystem::$($Item.Value)") -ne $true) {
          New-RecursivePath -Path $Item.Value | Out-Null
          Write-Host "          Status: Created"
        }
        else {
          Write-Host "          Status: Exists"
        }
      }
    }
    catch {
      Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
    }

  # WMI Path Exists
    Write-Host "    - WMI Path Exists"
    Write-Host "        $($Param_Namespace)"
    $Temp_Path_Concatenation = $null

		foreach ($Item in ($Param_Namespace -split "\\")) {
			try {
        $Temp_Path_Concatenation += $item
        Write-Host "          Namespace: $($Temp_Path_Concatenation)"
        Get-CimInstance -Namespace $Temp_Path_Concatenation -ClassName "__Namespace" | Out-Null
        Write-Host "            Status: Exists"
			}
			catch {
        if ($_.Exception.Message -like "*Invalid namespace*") {
          $Temp_WMI_Class = [wmiclass]"$($Temp_Path_Concatenation | Split-Path):__namespace"
          $Temp_WMI_Root = $Temp_WMI_Class.CreateInstance()
          $Temp_WMI_Root.Name = $Item
          $Temp_WMI_Root.Put() | Out-Null
          Write-Host "            Status: Created"
        }
        else {
				  Write-vr_ErrorCode -Code 1502 -Exit $true -Object $PSItem
        }
			}
      finally {
        $Temp_Path_Concatenation += "\"
      }
		}

  # WMI Class Exists
		Write-Host "    - WMI Class Exists"

		try {
      if (Get-CimClass -Namespace $Param_Namespace -ClassName $Param_ClassName) {
        Write-Host "        Status: Exists"
      }
		}
		catch {
      if ($_.Exception.Message -like "*Not found*") {
        New-vr_WMIClass -Namespace $Param_Namespace -ClassName $Param_ClassName -ClassVersion $WMI_Class_Version

        Write-Host "        Status: Created"
      }
      else {
        Write-vr_ErrorCode -Code 1503 -Exit $true -Object $PSItem
      }
    }

  # WMI Class Version
    Write-Host "    - WMI Class Version"

    try {
      $Temp_WMI_Class_Version = ((Get-CimClass -Namespace $Param_Namespace -ClassName $Param_ClassName).CimClassQualifiers | Where-Object -Property Name -eq "Version").Value
        Write-Host "        Current: $($Temp_WMI_Class_Version)"
        Write-Host "        Required: $($WMI_Class_Version)"

      if ($Temp_WMI_Class_Version -ge $WMI_Class_Version) {
        Write-Host "        Status: Valid"
      }
      else {
        # Remove Existing Class
          Remove-WmiObject -Namespace $Param_Namespace -Class $Param_ClassName

        # Create New Class
          New-vr_WMIClass -Namespace $Param_Namespace -ClassName $Param_ClassName -ClassVersion $WMI_Class_Version

        Write-Host "        Status: Recreated"
      }
    }
    catch {
      Write-vr_ErrorCode -Code 1504 -Exit $true -Object $PSItem
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
    $Temp_Dataset_Certificates = @()

    foreach ($Item in $Array_Certificates_Stores) {
      try {
        Write-Host "        Store: $($Item)"
        $Temp_Dataset_Certificates += Get-ChildItem -Path $Item -Recurse:$($Param_Recurse)
        Write-Host "          Count: $(($Temp_Dataset_Certificates | Where-Object -Property "PSParentPath" -match `"$([regex]::Escape($Item -replace 'Cert:\\'))`" | Measure-Object).Count)"
      }
      catch {
        Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
      }
    }

    Write-Host "          Status: Success"

	# Construct Dataset
    Write-Host "    - Construct Dataset"

    foreach ($Item in $Temp_Dataset_Certificates) {
      try {
        Write-Host "        $($Item.Thumbprint): $($Item.Subject)"

        # Create Custom Objects and Add to Array
          $Temp_Dataset_Object = [PSCustomObject]@{
            "Name"                    = $Item.Thumbprint
            "Thumbprint"              = $Item.Thumbprint
            "Subject"                 = $Item.Subject
            "SubjectAlternativeName"  = $null # Value Set Below
            "SubjectKeyIdentifier"    = $null # Value Set Below
            "AuthorityKeyIdentifier"  = $null # Value Set Below
            "FriendlyName"            = $Item.FriendlyName
            "Issuer"                  = $Item.Issuer
            "ValidFrom"               = $Item.NotBefore
            "ValidTo"                 = $Item.NotAfter
            "KeyUsage"                = $null # Value Set Below
            "EnhancedKeyUsageList"    = (($Item.EnhancedKeyUsageList | Select-Object -ExpandProperty "FriendlyName") -join ",") # Necessary to Prevent Object[] Data Type
            "CertificateTemplate"     = $null # Value Set Below
            "SerialNumber"            = $Item.SerialNumber
            "Version"                 = $Item.Version
            "SignatureAlgorithm"      = $Item.SignatureAlgorithm.FriendlyName
            "PublicKeyProviderName"   = $Item.PublicKey.Key.CspKeyContainerInfo.ProviderName
            "PublicKeyAlgorithm"      = $item.PublicKey.Key.KeyExchangeAlgorithm
            "PublicKeySize"           = $Item.PublicKey.Key.KeySize
            "StoreLocation"           = if ($Item.PSPath -match "LocalMachine") {"LocalMachine"} elseif ($Item.PSPath -match "CurrentUser") {"CurrentUser"} else {"Unknown"}
            "StoreName"               = ([regex]::Match($Item.PSPath, $Pattern_Certificates_StoreName)).Groups[1].Value
            "StoreOwner"              = $Meta_Script_Execution_User.Name
            "CIM_LastUpdatedUTC"      = (Get-Date).ToUniversalTime()
          }

        # Certificate Template Name
          $Temp_Dataset_Object.CertificateTemplate = $Item.Extensions | Where-Object -FilterScript {$_.Oid.FriendlyName -in "Certificate Template Name", "Certificate Template Information"} | Select-Object -First 1

          # Format Output to Friendly Name
            if ($Temp_Dataset_Object.CertificateTemplate -notin "", $null) {
              $Temp_Dataset_Object.CertificateTemplate = $Temp_Dataset_Object.CertificateTemplate.Format(1)
            }

          # Extract Template Name if Necessary (Certificate Template Information)
            if ($Temp_Dataset_Object.CertificateTemplate -match $Pattern_Certificates_TemplateName ) {
              $Temp_Dataset_Object.CertificateTemplate = ([regex]::Match($Temp_Dataset_Object.CertificateTemplate, $Pattern_Certificates_TemplateName)).Groups[1].Value
            }

        # Extension Data
          foreach ($Item_2 in "Subject Alternative Name", "Subject Key Identifier", "Authority Key Identifier", "Key Usage") {
            if ($Item.Extensions | Where-Object -FilterScript {$_.Oid.FriendlyName -in $Item_2} | Select-Object -First 1) {
              $Temp_Dataset_Object.$($Item_2 -replace " ","") = ($Item.Extensions | Where-Object -FilterScript {$_.Oid.FriendlyName -in $Item_2} | Select-Object -First 1).Format(0) # -replace "Other Name:|Principal Name="
            }
            else {
              $Temp_Dataset_Object.$($Item_2 -replace " ","") = ""
            }
          }

        # Fill In Empty Values to Avoid Instance Creation Issues On Null Values
          foreach ($Item_2 in $Temp_Dataset_Object.psobject.Properties) {
            if ($Item_2.Value -in "", $null) {
              $Item_2.Value = "null"
            }
          }

        # Add to Dataset
          $Dataset_Certificates_ClassInput += $Temp_Dataset_Object

        Write-Host "          Status: Success"
      }
      catch {
        Write-vr_ErrorCode -Code 1602 -Exit $true -Object $PSItem
      }
    }

    Write-Host "        Count: $(($Dataset_Certificates_ClassInput | Measure-Object).Count)"

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

    foreach ($Item in $Dataset_Certificates_ClassInput) {

      try {
        Write-Host "        $($Item.Thumbprint): $($Item.Subject)"
        $Temp_WMI_ExistingInstance = Get-CimInstance -Namespace $Param_Namespace -ClassName $Param_ClassName | Where-Object -Property "Thumbprint" -eq $Item.Thumbprint

        $Temp_PropertyMap = @{
          "Name"                    = $Item.Thumbprint
          "Thumbprint"              = $Item.Thumbprint
          "Subject"                 = $Item.Subject
          "SubjectAlternativeName"  = $Item.SubjectAlternativeName
          "SubjectKeyIdentifier"    = $Item.SubjectKeyIdentifier
          "AuthorityKeyIdentifier"  = $Item.AuthorityKeyIdentifier
          "FriendlyName"            = $Item.FriendlyName
          "Issuer"                  = $Item.Issuer
          "ValidFrom"               = $Item.ValidFrom
          "ValidTo"                 = $Item.ValidTo
          "KeyUsage"                = $Item.KeyUsage
          "EnhancedKeyUsageList"    = $Item.EnhancedKeyUsageList
          "CertificateTemplate"     = $Item.CertificateTemplate
          "SerialNumber"            = $Item.SerialNumber
          "Version"                 = $Item.Version
          "SignatureAlgorithm"      = $Item.SignatureAlgorithm
          "PublicKeyProviderName"   = $Item.PublicKeyProviderName
          "PublicKeyAlgorithm"      = $Item.PublicKeyAlgorithm
          "PublicKeySize"           = $Item.PublicKeySize
          "StoreLocation"           = $Item.StoreLocation
          "StoreName"               = $Item.StoreName
          "StoreOwner"              = $Item.StoreOwner
          "CIM_LastUpdatedUTC"      = $Item.CIM_LastUpdatedUTC
        }

        if ($Temp_WMI_ExistingInstance -in "", $null) {
          New-CimInstance -Namespace $Param_Namespace -ClassName $Param_ClassName -Key "Thumbprint" -Property $Temp_PropertyMap | Out-Null

          Write-Host "          Status: Created"
        }
        else {
          Set-CimInstance -InputObject $Temp_WMI_ExistingInstance -Property $Temp_PropertyMap | Out-Null

          Write-Host "          Status: Updated"
        }

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

	# Write Datasets to Files
    Write-Host "    - Write Datasets to Files"
    foreach ($Item in (Get-Variable -Name "Dataset_*")) {
      try {
        if ($Param_OutputDir -notin "", $null) {
          Write-Host "        $($Item.Name)"
          $Item.Value | ConvertTo-Json | Out-File -FilePath "$($Path_Outputs_DatasetFiles)\$($Item.Name).json"
          Write-Verbose "          Path: $($Path_Outputs_DatasetFiles)\$($Item.Name).json"
          Write-Host "          Status: Success"
        }
        else {
          Write-Verbose "          Path: Not Provided"
          Write-Host "          Status: Skipped, No Directory Argument Provided"
        }

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

	# # Remove WMI Objects (For Development & Validation ONLY)
	# 	Write-Host "    - Remove WMI Objects"

	# 	try {
	# 		if ($Temp_Cleanup_UserInput -in "Y", "Yes") {
  #       # Remove Class
  #         do {
  #           $Temp_Input_Cleanup_WMI = Read-Host -Prompt "        Do you want to remove the Class: $($Param_ClassName)? [Y]es or [N]o"
  #         } until (
  #           $Temp_Input_Cleanup_WMI -in "Y","Yes","N","No"
  #         )

  #         if ($Temp_Input_Cleanup_WMI) {
  #           Remove-WmiObject -Namespace $Param_Namespace -Class $Param_ClassName
  #           Write-Host "          Status: Removed"
  #         }
  #         else {
  #           Write-Host "          Status: Skipped"
  #         }

  #       # Remove Namespace
  #         do {
  #           $Temp_Input_Cleanup_WMI = Read-Host -Prompt "        Do you want to remove the Namespace path: $($Param_Namespace)? [Y]es or [N]o"
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