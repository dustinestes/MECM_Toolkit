#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
	[Parameter(Mandatory = $false,
		HelpMessage = "Export the group policy settings to a file type")]
		[ValidatePattern('^(disabled|csv|json)$')]
		[string]$ExportGroupPolicySettings="disabled",
	[Parameter(Mandatory = $false,
		HelpMessage = "Tests the connectivity to all the service's endpoint")]
		[ValidatePattern('^(enabled|disabled)$')]
		[string]$TestConnectivity="disabled",
	[Parameter(Mandatory = $false,
		HelpMessage = "Gets data about all the apps installed on the device")]
		[ValidatePattern('^(enabled|disabled)$')]
		[string]$GetAllApps="disabled",
	[Parameter(Mandatory = $false,
		HelpMessage = "Gets data about all the apps installed on the device with available updates")]
		[ValidatePattern('^(enabled|disabled)$')]
		[string]$GetAppsWithUpdates="disabled",
	[Parameter(Mandatory = $false,
		HelpMessage = "Uses the winget tool to update all apps that have available updates")]
		[ValidatePattern('^(enabled|disabled)$')]
		[string]$UpgradeAllApps="disabled",
	[Parameter(Mandatory = $false,
		HelpMessage = "Installs all applications using the name, id, or moniker of the package provided in a CSV format")]
		[string]$InstallApps="",							# Radness,Notepad++.Notepad++,Microsoft.XMLNotepad
	[Parameter(Mandatory = $false,
		HelpMessage = "Repairs all applications using the name, id, or moniker of the package provided in a CSV format")]
		[string]$RepairApps="",
	[Parameter(Mandatory = $false,
		HelpMessage = "Uninstalls all applications using the name, id, or moniker of the package provided in a CSV format")]
		[string]$UninstallApps="",
	[Parameter(Mandatory = $false,
		HelpMessage = "Collects all settings.json files from the user and system contexts")]
		[ValidatePattern('^(enabled|disabled)$')]
		[string]$CollectSettingsFiles="disabled",
	[Parameter(Mandatory = $false,
		HelpMessage = "Collects all application log files, windows event logs, and other output related to the service (if they exist)")]
		[ValidatePattern('^(enabled|disabled)$')]
		[string]$CollectLogFiles="disabled",
	[Parameter(Mandatory = $false,
		HelpMessage = "Repairs the Winget package manager using the Winget Client powershell module downloaded from the PSGallery")]
		[ValidatePattern('^(enabled|disabled)$')]
		[string]$RepairWinget="disabled"
)

#--------------------------------------------------------------------------------------------
# Logging
#--------------------------------------------------------------------------------------------
#Region Logging

# Metadata
$Meta_Script_Execution_User     = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$Meta_Script_Start_DateTime     = Get-Date
$Meta_Script_Complete_DateTime  = $null
$Meta_Script_Complete_TimeSpan  = $null

$Path_Logging_Directory    	= "\\mecmcontent\repo\Logging\Script Output\WinGet Toolkit\$($env:COMPUTERNAME)\$(Get-Date -Format "yyyy-MM-dd_HHmmss")"
$Path_Logging_File          = "$($Path_Logging_Directory)\WinGet - Toolkit.log"
$Params_Logging             = @{ FilePath = "Filesystem::$($Path_Logging_File)"; Append = $true }

New-Item -Path $Path_Logging_Directory -ItemType Directory -Force | Out-Null
Out-File -InputObject "" -FilePath $Path_Logging_File

#EndRegion Logging
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

Out-File -InputObject "------------------------------------------------------------------------------" @Params_Logging
Out-File -InputObject "  MECM Toolkit - Scripts - Winget - Toolkit" @Params_Logging
Out-File -InputObject "------------------------------------------------------------------------------" @Params_Logging
Out-File -InputObject "  Author:     Dustin Estes" @Params_Logging
Out-File -InputObject "  Company:    VividRock" @Params_Logging
Out-File -InputObject "  Date:       2025-12-18" @Params_Logging
Out-File -InputObject "  Copyright:  VividRock LLC - All Rights Reserved" @Params_Logging
Out-File -InputObject "  Purpose:    Provides a number of useful functions for supporting endpoints." @Params_Logging
Out-File -InputObject "  Links:      None" @Params_Logging
Out-File -InputObject "  Version:    1.0" @Params_Logging
Out-File -InputObject "------------------------------------------------------------------------------" @Params_Logging
Out-File -InputObject "" @Params_Logging
Out-File -InputObject "  Execution Context" @Params_Logging
Out-File -InputObject "    Username: $($Meta_Script_Execution_User.Name)" @Params_Logging
Out-File -InputObject "    AuthenticationType: $($Meta_Script_Execution_User.AuthenticationType)" @Params_Logging
Out-File -InputObject "    ImpersonationLevel: $($Meta_Script_Execution_User.ImpersonationLevel)" @Params_Logging
Out-File -InputObject "    IsAuthenticated: $($Meta_Script_Execution_User.IsAuthenticated)" @Params_Logging
Out-File -InputObject "    IsSystem: $($Meta_Script_Execution_User.IsSystem)" @Params_Logging
Out-File -InputObject "" @Params_Logging
Out-File -InputObject "  Parameters" @Params_Logging
foreach ($Item in $PSBoundParameters.GetEnumerator()) {
	Out-File -InputObject "    $($Item.Key.PadRight(($PSBoundParameters.Keys | Measure-Object -Property Length -Maximum).Maximum + 1)): $($Item.Value)" @Params_Logging
}
Out-File -InputObject "" @Params_Logging

#EndRegion Header
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Variables
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Variables

$ErrorActionPreference          = "Stop"
$Meta_Script_Result             = $null,$null			# Format: Exit Code, STDOUT

#EndRegion Variables
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Functions
#   Error Range: 1300 - 1399
#--------------------------------------------------------------------------------------------
#Region Functions

function New-RecursivePath ($Path) {
	begin {

	}

	process {
		try {
			# Network Path Type
				if ($Path -like "\\*") {
					$Temp_PathSplit = $Path -split "\\" | Where-Object { $_ -notin "",$null}
					foreach ($Item in $Temp_PathSplit) {
						# Concatenate Path
							if ($Item -eq $Temp_PathSplit[0]) {
								$Temp_PathRecurse = "filesystem::\\$($Item)" + "\"
							}
							else {
								$Temp_PathRecurse += $Item + "\"
							}

						# Create New Path Item
							if (($Item -ne $Temp_PathSplit[0]) -and ((Test-Path -Path $Temp_PathRecurse) -ne $true)) {
								New-Item -Path $Temp_PathRecurse -ItemType Directory
							}
					}
				}
			# All Other Path Types
				else {
					$Temp_PathSplit = $Path -split "\\" | Where-Object { $_ -notin "",$null}
					foreach ($Item in $Temp_PathSplit) {
						$Temp_PathRecurse += $Item + "\"
						if (Test-Path -Path $Temp_PathRecurse) {
							# Do Nothing
						}
						else {
							New-Item -Path $Temp_PathRecurse -ItemType Directory
						}
					}
				}

		}
		catch {
			Write-vr_ErrorCode  -Code 1301 -Exit $true -Object $PSItem
		}
	}

	end {

	}
}

function Get-ADMLText {
	param ([string]$ID, [string]$ADMXFilePath, [string]$Language)

	$Path_ADML = "$([System.IO.Path]::GetDirectoryName($ADMXfilePath))\$Language\$([System.IO.Path]::GetFileNameWithoutExtension($ADMXFilePath)).adml"
	if (Test-Path $Path_ADML) {
		[xml]$Content_ADML = Get-Content -Path $Path_ADML
		$Text = $Content_ADML.policyDefinitionResources.resources.stringTable.string | Where-Object { $_.id -eq $ID }
		if ($Text) {
			return $Text.'#text'
		}
	}

	return $null
}

function Get-ADMXPolicies {
	param([string]$FilePath,[string]$Language)

	# Load the ADMX file as XML
	[xml]$Content_ADMX = Get-Content -Path $FilePath

	$Dataset_PolicySettings = @()

	# Iterate Through Each Policy
	foreach ($Policy in $Content_ADMX.policyDefinitions.policies.policy) {
		# Construct Object
		$Temp_Object = [PSCustomObject]@{
			Name            = $Policy.name
			DisplayName 		= Get-ADMLText -ID ($Policy.displayName -replace "\$\(string\.(.+)\)", '$1') -ADMXFilePath $FilePath -Language $Language
			Class           = $Policy.class
			RegistryKeyPath	= $Policy.key
			RegistryKeyName	= $Policy.valueName
		}

		# Add to Dataset
		$Dataset_PolicySettings += $Temp_Object
	}

	# Return Dataset
	Return $Dataset_PolicySettings
}

#EndRegion Functions
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Environment
#   Error Range: 1400 - 1499
#--------------------------------------------------------------------------------------------
#Region Environment



#EndRegion Environment
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Prerequisites
#   Error Range: 1600 - 1699
#--------------------------------------------------------------------------------------------
#Region Prerequisites

Out-File -InputObject "  Prerequisites" @Params_Logging

$Prerequisites_Dependencies = @(
	[PSCustomObject]@{
		Name 				= "Microsoft.VCLibs.140*"
		VersionMin	= [System.Version] "14.0.33519.0"
		Message			= "Validation not performed"
		Status			= "Pending"				# Pending, Pass, Fail
	}
	[PSCustomObject]@{
		Name 				= "Microsoft.WindowsAppRuntime.1.8"
		VersionMin	= [System.Version] "0.0"
		Message			= "Validation not performed"
		Status			= "Pending"				# Pending, Pass, Fail
	}
)
$Prerequisites_Apps = @(
	[PSCustomObject]@{
		Name 				= "Microsoft.DesktopAppInstaller"
		VersionMin	= [System.Version] "0.0"
		Message			= "Validation not performed"
		Status			= "Pending"				# Pending, Pass, Fail
	}
	[PSCustomObject]@{
		Name 				= "Microsoft.Winget.Source"
		VersionMin	= [System.Version] "2025.0"
		Message			= "Validation not performed"
		Status			= "Pending"				# Pending, Pass, Fail
	}
)

# -------------------------------------------------------
# Dependencies
# -------------------------------------------------------
#Region Dependencies

Out-File -InputObject "    - Dependencies" @Params_Logging

foreach ($Item in $Prerequisites_Dependencies) {
	Out-File -InputObject "        $($Item.Name)" @Params_Logging
	Out-File -InputObject "          VersionMin: $($Item.VersionMin)" @Params_Logging

	try {
		# Get Dependency Data
		if ($Meta_Script_Execution_User.IsSystem) {
			Out-File -InputObject "          Command: Get-AppxProvisionedPackage -Online | Where-Object {`$_.DisplayName -eq $Item.Name}" @Params_Logging
			$Temp_Dataset = Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq $Item.Name}
		}
		else {
			Out-File -InputObject "          Command: Get-AppxPackage -Name $($Item.Name)" @Params_Logging
			$Temp_Dataset = Get-AppxPackage -Name $Item.Name
		}
		Out-File -InputObject "          Count: $(($Temp_Dataset | Measure-Object).Count)" @Params_Logging

		# Determine Install State
		if ($Temp_Dataset) {
			if ($Temp_Dataset | Where-Object {$_.Version -ge $Item.VersionMin}) {
				foreach ($Element in $Temp_Dataset) {
					Out-File -InputObject "            Name: $($Element.Name)" @Params_Logging
					Out-File -InputObject "              Version: $($Element.Version)" @Params_Logging
					Out-File -InputObject "              Architecture: $($Element.Architecture)" @Params_Logging
					Out-File -InputObject "              PackageFullName: $($Element.PackageFullName)" @Params_Logging
					Out-File -InputObject "              InstallLocation: $($Element.InstallLocation)" @Params_Logging
				}
				Out-File -InputObject "          Installed: True" @Params_Logging
				$Item.Message	= "Data found that matched the Name criteria and the VersionMin criteria"
				$Item.Status	= "Pass"
			}
			else {
				Out-File -InputObject "          Installed: False" @Params_Logging
				$Item.Message	= "Data not found that matched the Name criteria but not the VersionMin criteria"
				$Item.Status	= "Fail"
			}
		}
		else {
			Out-File -InputObject "          Installed: False" @Params_Logging
			$Item.Message	= "Data not found that matched the Name criteria"
			$Item.Status	= "Fail"
		}
	}
	catch {
		Out-File -InputObject "          Status: Error, $($_.Exception.Message)" @Params_Logging
		$Meta_Script_Result = 1601,"Failure"
	}
}

#EndRegion Dependencies
# -------------------------------------------------------

# -------------------------------------------------------
# Apps
# -------------------------------------------------------
#Region Apps

Out-File -InputObject "    - Apps" @Params_Logging

foreach ($Item in $Prerequisites_Apps) {
	Out-File -InputObject "        $($Item.Name)" @Params_Logging
	Out-File -InputObject "          VersionMin: $($Item.VersionMin)" @Params_Logging

	try {
		# Get Dependency Data
		if ($Meta_Script_Execution_User.IsSystem) {
			Out-File -InputObject "          Command: Get-AppxProvisionedPackage -Online | Where-Object {`$_.DisplayName -eq $Item.Name}" @Params_Logging
			$Temp_Dataset = Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq $Item.Name}
		}
		else {
			Out-File -InputObject "          Command: Get-AppxPackage -Name $($Item.Name)" @Params_Logging
			$Temp_Dataset = Get-AppxPackage -Name $Item.Name
		}
		Out-File -InputObject "          Count: $(($Temp_Dataset | Measure-Object).Count)" @Params_Logging

		# Determine Install State
		if ($Temp_Dataset) {
			if ($Temp_Dataset | Where-Object {$_.Version -ge $Item.VersionMin}) {
				foreach ($Element in $Temp_Dataset) {
					Out-File -InputObject "            Name: $(if ($Element.Name) {$Element.Name} else {$Element.DisplayName})" @Params_Logging
					Out-File -InputObject "              Version: $($Element.Version)" @Params_Logging
					Out-File -InputObject "              Architecture: $($Element.Architecture)" @Params_Logging
					Out-File -InputObject "              PackageFullName: $($Element.PackageFullName)" @Params_Logging
					Out-File -InputObject "              InstallLocation: $($Element.InstallLocation)" @Params_Logging
				}
				Out-File -InputObject "          Installed: True" @Params_Logging
				$Item.Message	= "Data found that matched the Name criteria and the VersionMin criteria"
				$Item.Status	= "Pass"
			}
			else {
				Out-File -InputObject "          Installed: False" @Params_Logging
				$Item.Message	= "Data not found that matched the Name criteria but not the VersionMin criteria"
				$Item.Status	= "Fail"
			}
		}
		else {
			Out-File -InputObject "          Installed: False" @Params_Logging
			$Item.Message	= "Data not found that matched the Name criteria"
			$Item.Status	= "Fail"
		}
	}
	catch {
		Out-File -InputObject "          Status: Error, $($_.Exception.Message)" @Params_Logging
		$Meta_Script_Result = 1602,"Failure"
	}
}

#EndRegion Apps
# -------------------------------------------------------

#EndRegion Prerequisites
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1700 - 1799
#--------------------------------------------------------------------------------------------
#Region Execution

Out-File -InputObject "" @Params_Logging
Out-File -InputObject "  Execution" @Params_Logging

# -------------------------------------------------------
# Configuration
# -------------------------------------------------------
#Region Configuration

Out-File -InputObject "    - Configuration" @Params_Logging

if ($Prerequisites_Apps.Where({$_.Name -eq "Microsoft.DesktopAppInstaller.*"}).Status -ne "Fail") {
	# Get Winget Path
	Out-File -InputObject "        Paths" @Params_Logging
	try {
		if ($Meta_Script_Execution_User.IsSystem) {
			Out-File -InputObject "          Command: (Get-ChildItem -Path `"C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*\winget.exe`").FullName" @Params_Logging
			$Path_Winget = (Get-ChildItem -Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*\winget.exe").FullName
			Out-File -InputObject "            Winget.exe: $($Path_Winget)" @Params_Logging
		}
		else {
			Out-File -InputObject "          Command: (Get-Command winget.exe).Source" @Params_Logging
			$Path_Winget = (Get-Command winget.exe).Source
			Out-File -InputObject "            Winget.exe: $($Path_Winget)" @Params_Logging
		}
	}
	catch {
		Out-File -InputObject "        Status: Error, $($_.Exception.Message)" @Params_Logging
		$Meta_Script_Result = 1701,"Failure"
	}

	# Environment Variables
	Out-File -InputObject "        Environment Variables" @Params_Logging
	try {
		if ($Meta_Script_Execution_User.IsSystem) {
			Out-File -InputObject "          Command: `$env:PATH -split `";`" | Where-Object {`$_ -match [regex]::Escape(`"C:\WINDOWS\system32\config\systemprofile\AppData\Local\Microsoft\WindowsApps`")}" @Params_Logging
			$Temp_Env_PATH = $env:PATH -split ";" | Where-Object {$_ -match [regex]::Escape("C:\WINDOWS\system32\config\systemprofile\AppData\Local\Microsoft\WindowsApps")}
		}
		else {
			Out-File -InputObject "          Command: `$env:PATH -split `";`" | Where-Object {`$_ -match [regex]::Escape(`"AppData\Local\Microsoft\WindowsApps`")}" @Params_Logging
			$Temp_Env_PATH = $env:PATH -split ";" | Where-Object {$_ -match [regex]::Escape("AppData\Local\Microsoft\WindowsApps")}
		}
		Out-File -InputObject "            PATH: $($env:PATH)" @Params_Logging
		Out-File -InputObject "            PATH (Winget): $($Temp_Env_PATH)" @Params_Logging
		if ($Temp_Env_PATH) {
			Out-File -InputObject "          Status: Success" @Params_Logging
		}
		else {
			Out-File -InputObject "          Status: Error, Winget Dir Not Set in PATH" @Params_Logging
		}
	}
	catch {
		Out-File -InputObject "        Status: Error, $($_.Exception.Message)" @Params_Logging
		$Meta_Script_Result = 1702,"Failure"
	}

	# Firewall Rules
	Out-File -InputObject "        Firewall Rules" @Params_Logging
	try {
		# Desktop App Installer Data
		Out-File -InputObject "          Microsoft.DesktopAppInstaller" @Params_Logging
		Out-File -InputObject "            Command: Get-NetFirewallRule -All | Where-Object {($_.Name -match `"DesktopAppInstaller|Desktop App Installer`") -or ($_.ID -match `"DesktopAppInstaller|Desktop App Installer`") -or ($_.DisplayName -match `"DesktopAppInstaller|Desktop App Installer`") -or ($_.Group -match `"DesktopAppInstaller|Desktop App Installer`") -or ($_.Description -match `"DesktopAppInstaller|Desktop App Installer`") -or ($_.ElementName -match `"DesktopAppInstaller|Desktop App Installer`") -or ($_.InstanceID -match `"DesktopAppInstaller|Desktop App Installer`") -or ($_.CommonName -match `"DesktopAppInstaller|Desktop App Installer`") -or ($_.DisplayGroup -match `"DesktopAppInstaller|Desktop App Installer`") -or ($_.Group -match `"DesktopAppInstaller|Desktop App Installer`") -or ($_.PackageFamilyName -match `"DesktopAppInstaller|Desktop App Installer`") -or ($_.RuleGroup -match `"DesktopAppInstaller|Desktop App Installer`")}" @Params_Logging
		$Temp_Rules = Get-NetFirewallRule -All | Where-Object {($_.Name -match "DesktopAppInstaller|Desktop App Installer") -or ($_.ID -match "DesktopAppInstaller|Desktop App Installer") -or ($_.DisplayName -match "DesktopAppInstaller|Desktop App Installer") -or ($_.Group -match "DesktopAppInstaller|Desktop App Installer") -or ($_.Description -match "DesktopAppInstaller|Desktop App Installer") -or ($_.ElementName -match "DesktopAppInstaller|Desktop App Installer") -or ($_.InstanceID -match "DesktopAppInstaller|Desktop App Installer") -or ($_.CommonName -match "DesktopAppInstaller|Desktop App Installer") -or ($_.DisplayGroup -match "DesktopAppInstaller|Desktop App Installer") -or ($_.Group -match "DesktopAppInstaller|Desktop App Installer") -or ($_.PackageFamilyName -match "DesktopAppInstaller|Desktop App Installer") -or ($_.RuleGroup -match "DesktopAppInstaller|Desktop App Installer")}
		Out-File -InputObject "            Count: $(($Temp_Rules | Measure-Object).Count)" @Params_Logging
		if ($Temp_Rules) {
			foreach ($Rule in $Temp_Rules) {
				Out-File -InputObject "            $($Rule.Name)" @Params_Logging
				Out-File -InputObject "              ID: $($Rule.ID)" @Params_Logging
				Out-File -InputObject "              PackageFamilyName: $($Rule.PackageFamilyName)" @Params_Logging
				Out-File -InputObject "              DisplayName: $($Rule.DisplayName)" @Params_Logging
				Out-File -InputObject "              Description: $($Rule.Description)" @Params_Logging
				Out-File -InputObject "              Direction: $($Rule.Direction)" @Params_Logging
				Out-File -InputObject "              Action: $($Rule.Action)" @Params_Logging
				Out-File -InputObject "              Profile: $($Rule.Profile)" @Params_Logging
				Out-File -InputObject "              Enabled: $($Rule.Enabled)" @Params_Logging
				Out-File -InputObject "              PrimaryStatus: $($Rule.PrimaryStatus)" @Params_Logging
				Out-File -InputObject "              Status: $($Rule.Status)" @Params_Logging
				Out-File -InputObject "              StatusCode: $($Rule.StatusCode)" @Params_Logging
			}
			Out-File -InputObject "            Status: Success" @Params_Logging
		}
		else {
			Out-File -InputObject "            Status: No Rules Found" @Params_Logging
		}

		# Winget Data
		Out-File -InputObject "          Winget" @Params_Logging
		Out-File -InputObject "            Command: Get-NetFirewallRule -All | Where-Object {($_.Name -match `"winget`") -or ($_.ID -match `"winget`") -or ($_.DisplayName -match `"winget`") -or ($_.Group -match `"winget`") -or ($_.Description -match `"winget`") -or ($_.ElementName -match `"winget`") -or ($_.InstanceID -match `"winget`") -or ($_.CommonName -match `"winget`") -or ($_.DisplayGroup -match `"winget`") -or ($_.Group -match `"winget`") -or ($_.PackageFamilyName -match `"winget`") -or ($_.RuleGroup -match `"winget`")}" @Params_Logging
		$Temp_Rules = Get-NetFirewallRule -All | Where-Object {($_.Name -match "winget") -or ($_.ID -match "Winget") -or ($_.DisplayName -match "Winget") -or ($_.Group -match "Winget") -or ($_.Description -match "Winget") -or ($_.ElementName -match "Winget") -or ($_.InstanceID -match "Winget") -or ($_.CommonName -match "Winget") -or ($_.DisplayGroup -match "Winget") -or ($_.Group -match "Winget") -or ($_.PackageFamilyName -match "Winget") -or ($_.RuleGroup -match "Winget")}
		Out-File -InputObject "            Count: $(($Temp_Rules | Measure-Object -Sum).Count)" @Params_Logging
		if ($Temp_Rules) {
			foreach ($Rule in $Temp_Rules) {
				Out-File -InputObject "            $($Rule.Name)" @Params_Logging
				Out-File -InputObject "              ID: $($Rule.ID)" @Params_Logging
				Out-File -InputObject "              PackageFamilyName: $($Rule.PackageFamilyName)" @Params_Logging
				Out-File -InputObject "              DisplayName: $($Rule.DisplayName)" @Params_Logging
				Out-File -InputObject "              Description: $($Rule.Description)" @Params_Logging
				Out-File -InputObject "              Direction: $($Rule.Direction)" @Params_Logging
				Out-File -InputObject "              Action: $($Rule.Action)" @Params_Logging
				Out-File -InputObject "              Profile: $($Rule.Profile)" @Params_Logging
				Out-File -InputObject "              Enabled: $($Rule.Enabled)" @Params_Logging
				Out-File -InputObject "              PrimaryStatus: $($Rule.PrimaryStatus)" @Params_Logging
				Out-File -InputObject "              Status: $($Rule.Status)" @Params_Logging
				Out-File -InputObject "              StatusCode: $($Rule.StatusCode)" @Params_Logging
			}
			Out-File -InputObject "            Status: Success" @Params_Logging
		}
		else {
			Out-File -InputObject "            Status: No Rules Found" @Params_Logging
		}
	}
	catch {
		Out-File -InputObject "        Status: Error, $($_.Exception.Message)" @Params_Logging
		$Meta_Script_Result = 1703,"Failure"
	}





	# Group Policy Settings
	Out-File -InputObject "        Group Policy Settings" @Params_Logging
	try {
		$Temp_GPFilePaths = @(
			"C:\Windows\PolicyDefinitions\DesktopAppInstaller.admx"
		)
		$Dataset_PolicySettings = @()

		foreach ($File in $Temp_GPFilePaths) {
			Out-File -InputObject "          $([System.IO.Path]::GetFileNameWithoutExtension($File))" @Params_Logging
			Out-File -InputObject "            Command: Get-ADMXPolicies -FilePath $File -Language `"en-US`"" @Params_Logging
			$Temp_Policies = Get-ADMXPolicies -FilePath $File -Language "en-US"
			$Temp_Policies_Machine = $Temp_Policies | Where-Object {$_.Class -match "Machine|Both"}
			$Temp_Policies_User = $Temp_Policies | Where-Object {$_.Class -match "User|Both"}
			# $Temp_Policies_Paths = $Temp_Policies.RegistryKeyPath | Select-Object -Unique

			Out-File -InputObject "            Policies: $(($Temp_Policies_Machine | Measure-Object).Count) (Machine)  $(($Temp_Policies_User | Measure-Object).Count) (User)" @Params_Logging
			Out-File -InputObject "            Registry Paths: $(($Temp_Policies.RegistryKeyPath | Select-Object -Unique | Measure-Object).Count)" @Params_Logging

			# Get Machine Policy Settings
			Out-File -InputObject "            Machine Policy Settings" @Params_Logging
			foreach ($Path in ($Temp_Policies_Machine.RegistryKeyPath | Select-Object -Unique)) {
				$Path = "HKLM:\$($Path)"

				if (Test-Path -Path $Path) {
					$Temp_Registry = Get-Item -Path $Path

					foreach ($Property in $Temp_Registry.Property) {
						$Temp_Object = [PSCustomObject]@{
							Path 	= $Path
							Name  = $Property
							Value = $Temp_Registry.GetValue($Property)
							Type 	= $Temp_Registry.GetValueKind($Property)
						}
						$Dataset_PolicySettings += $Temp_Object
					}
				}
				else {
					Out-File -InputObject "              Status: Skipped, does not exist" @Params_Logging
				}
			}

			# Output to Log
			$Dataset_PolicySettings | Format-Table -Autosize | Out-String -Width 4096 -Stream | ForEach-Object {
				"              " + $_
			} | Out-File @Params_Logging

			# Export
			Out-File -InputObject "              Export" @Params_Logging
			Out-File -InputObject "                FileType: $($ExportGroupPolicySettings)" @Params_Logging

			switch ($ExportGroupPolicySettings) {
				"csv"		{ $Dataset_PolicySettings | ConvertTo-Csv -Delimiter "," -NoTypeInformation | Out-File -FilePath "$($Path_Logging_Directory)\GroupPolicy_Export.csv" }
				"json" 	{ $Dataset_PolicySettings | ConvertTo-Json -Depth 20 | Out-File -FilePath "$($Path_Logging_Directory)\GroupPolicy_Export.json" }
				Default {Out-File -InputObject "                Status: Skipped" @Params_Logging}
			}

			if ($ExportGroupPolicySettings -in "csv","json") {

			}
			else {
			}

			# Get User Policy Settings
			Out-File -InputObject "            User Policy Settings" @Params_Logging
			Out-File -InputObject "              Status: Not implemented yet" @Params_Logging












			Out-File -InputObject "            Policies" @Params_Logging

			foreach ($Policy in $Temp_Policies) {
				Out-File -InputObject "              $($Policy.DisplayName)" @Params_Logging
				Out-File -InputObject "                Name: $($Policy.Name)" @Params_Logging
				Out-File -InputObject "                Class: $($Policy.Class)" @Params_Logging
				Out-File -InputObject "                RegistryKeyPath: $($Policy.RegistryKeyPath)" @Params_Logging
				Out-File -InputObject "                RegistryKeyName: $($Policy.RegistryKeyName)" @Params_Logging
				Out-File -InputObject "                Registry Properties" @Params_Logging

				# Setup Paths Based on Policy Class
				switch ($Policy.Class) {
					"Machine" {
						$Temp_PolicyRegistryKeyPaths = @("HKLM:\$($Policy.RegistryKeyPath)")
					}
					"User" 		{
						$Temp_PolicyRegistryKeyPaths = @("HKCU:\$($Policy.RegistryKeyPath)")
					}
					"Both" 		{
						$Temp_PolicyRegistryKeyPaths = @("HKLM:\$($Policy.RegistryKeyPath)","HKCU:\$($Policy.RegistryKeyPath)")
					}
					Default {
						$Temp_PolicyRegistryKeyPaths = @("HKLM:\$($Policy.RegistryKeyPath)")
					}
				}

				foreach ($Path in $Temp_PolicyRegistryKeyPaths) {
					Out-File -InputObject "                  Path: $($Path)" @Params_Logging

					if (Test-Path -Path "$($Path)") {
						$Temp_RegistryObject = Get-Item -Path $Path

						if ($Temp_RegistryObject.Property -eq $Policy.Name) {
							$Temp_Object = [PSCustomObject]@{
								Name 	= $Policy.DisplayName
								Path 	= $Path
								Value = $Temp_RegistryObject.GetValue($Policy.Name)
								Type 	= $Temp_RegistryObject.GetValueKind($Policy.Name)
							}
							Out-File -InputObject "                    Value: $($Temp_Object.Value)" @Params_Logging
							Out-File -InputObject "                    Type: $($Temp_Object.Type)" @Params_Logging

							$Dataset_PolicySettings += $Temp_Object
						}
						else {
							Out-File -InputObject "                    Status: Setting not found" @Params_Logging
						}
					}
					else {
						Out-File -InputObject "                    Status: Skipped, does not exist" @Params_Logging
					}
				}
			}
		}


		# # Get Items in Registry Root
		# $Temp_Registry = Get-Item -Path $Temp_GPORoot -ErrorAction SilentlyContinue
		# if (($Temp_Registry | Measure-Object).Count -ge 1) {
		# 	foreach ($Property in $Temp_Registry.Property) {
		# 		Out-File -InputObject "            $($Property): $($Temp_Registry.GetValue($Property))" @Params_Logging
		# 	}
		# }
		# else {
		# 	Out-File -InputObject "            Status: Skipped, No GPO Settings found in the Registry Root" @Params_Logging
		# }

		# # Get Child Items in Registry Root
		# $Temp_Registry = Get-ChildItem -Path $Temp_GPORoot -Recurse -ErrorAction SilentlyContinue
		# if (($Temp_Registry | Measure-Object).Count -ge 1) {
		# 	foreach ($Property in $Temp_Registry) {
		# 		Out-File -InputObject "          $($Property.Name)" @Params_Logging
		# 		$PropertyDetails = Get-ItemProperty -Path $Property.PSPath
		# 		Out-File -InputObject "            $($Property): $($Value)" @Params_Logging
		# 	}
		# }
		# else {
		# 	Out-File -InputObject "            Status: Skipped, No GPO Settings found in the Registry Root Children" @Params_Logging
		# }
	}
	catch {
		Out-File -InputObject "        Status: Error, $($_.Exception.Message)" @Params_Logging
		$Meta_Script_Result = 1704,"Failure"
	}
Pause










	# Registry Settings
	Out-File -InputObject "        Registry Settings" @Params_Logging
	try {
		Out-File -InputObject "          HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Command Processor\KnownPackageManagers" @Params_Logging
		Out-File -InputObject "            Command: Get-ChildItem -Path `"HKLM:\SOFTWARE\Microsoft\Command Processor\KnownPackageManagers`"" @Params_Logging
		$Temp_Registry = Get-ChildItem -Path "HKLM:\SOFTWARE\Microsoft\Command Processor\KnownPackageManagers"
		foreach ($Item in $Temp_Registry) {
			Out-File -InputObject "              $($Item.PSChildName)" @Params_Logging
		}
		if ($Temp_Registry.Name -match "winget") {
			Out-File -InputObject "            Status: Success" @Params_Logging
		}
		else {
			Out-File -InputObject "            Status: Error, Winget Not Set as Known Package Manager" @Params_Logging
		}
	}
	catch {
		Out-File -InputObject "        Status: Error, $($_.Exception.Message)" @Params_Logging
		$Meta_Script_Result = 1705,"Failure"
	}

	# Winget Info
	Out-File -InputObject "        Winget Info" @Params_Logging
	try {
		Out-File -InputObject "          Command: & $Path_Winget --info" @Params_Logging
		$Temp_Output = & $Path_Winget --info
		Out-File -InputObject "          Output:" @Params_Logging
		if ($Temp_Output) {
			foreach ($Line in $Temp_Output) {
				Out-File -InputObject "            $($Line.TrimStart())" @Params_Logging
			}
			Out-File -InputObject "          Status: Success" @Params_Logging
		}
		else {
			Out-File -InputObject "          Status: Error, could not get Winget info" @Params_Logging
		}
	}
	catch {
		Out-File -InputObject "        Status: Error, $($_.Exception.Message)" @Params_Logging
		$Meta_Script_Result = 1706,"Failure"
	}

	# Winget Features
	Out-File -InputObject "        Winget Features" @Params_Logging
	try {
		Out-File -InputObject "          Command: & $Path_Winget features" @Params_Logging
		$Temp_Output = & $Path_Winget features
		Out-File -InputObject "          Output:" @Params_Logging
		if ($Temp_Output) {
			foreach ($Line in $Temp_Output) {
				Out-File -InputObject "            $($Line.TrimStart())" @Params_Logging
			}
			Out-File -InputObject "          Status: Success" @Params_Logging
		}
		else {
			Out-File -InputObject "          Status: Error, could not get Winget info" @Params_Logging
		}
	}
	catch {
		Out-File -InputObject "        Status: Error, $($_.Exception.Message)" @Params_Logging
		$Meta_Script_Result = 1707,"Failure"
	}
}
else {
	Out-File -InputObject "            Status: Skipped, failed prerequisite check" @Params_Logging
}

#EndRegion Configuration
# -------------------------------------------------------

# -------------------------------------------------------
# Test Connectvity
# -------------------------------------------------------
#Region Test Connectvity

Out-File -InputObject "    - Test Connectvity" @Params_Logging

if ($TestConnectivity -eq "enabled") {
	try {
		# Initialize Variables
		$URI_CDNBasic       = "cdn.winget.microsoft.com"
		$URI_CDNWebRequest  = "https://cdn.winget.microsoft.com/cache/source.msix"

		# Basic Network Test
		Out-File -InputObject "        Basic Network Test" @Params_Logging
		Out-File -InputObject "          URI: $($URI_CDNBasic)" @Params_Logging
		Out-File -InputObject "          Command: Test-NetConnection -ComputerName $URI_CDNBasic -Port 443 -WarningAction SilentlyContinue" @Params_Logging
		$Result_TCPTest = Test-NetConnection -ComputerName $URI_CDNBasic -Port 443 -WarningAction SilentlyContinue

		if ($Result_TCPTest.TcpTestSucceeded) {
			Out-File -InputObject "          SourceAddress: $($Result_TCPTest.SourceAddress.IPAddress)" @Params_Logging
			Out-File -InputObject "          RemotePort: $($Result_TCPTest.RemotePort)" @Params_Logging
			Out-File -InputObject "          RemoteAddress: $($Result_TCPTest.RemoteAddress)" @Params_Logging
			Out-File -InputObject "          ResolvedAddresses: $($Result_TCPTest.ResolvedAddresses)" @Params_Logging
			Out-File -InputObject "          Result: Success" @Params_Logging
		}
		else {
			Out-File -InputObject "          Result: Failure" @Params_Logging
		}

		# HTTP(S) Web Request Test
		Out-File -InputObject "        Web Request Test" @Params_Logging
		Out-File -InputObject "          URI: $($URI_CDNWebRequest)" @Params_Logging
		Out-File -InputObject "          Command: Invoke-WebRequest -Uri $URI_CDNWebRequest -Method Head -UseBasicParsing -TimeoutSec 10" @Params_Logging
		$Result_WebRequest = Invoke-WebRequest -Uri $URI_CDNWebRequest -Method Head -UseBasicParsing -TimeoutSec 10

		Out-File -InputObject "          Status Code: $($Result_WebRequest.StatusCode)" @Params_Logging
		if (($Result_WebRequest.StatusCode -ge 200) -and ($Result_WebRequest.StatusCode -lt 400)) {
			Out-File -InputObject "          Result: Success" @Params_Logging
		}
		else {
			Out-File -InputObject "          Result: Failure" @Params_Logging
		}
	}
	catch {
		Out-File -InputObject "        Status: Error, $($_.Exception.Message)" @Params_Logging
		$Meta_Script_Result = 1708,"Failure"
	}
}
else {
	Out-File -InputObject "        Parameter != enabled" @Params_Logging
}

#EndRegion Test Connectvity
# -------------------------------------------------------

# -------------------------------------------------------
# Get All Apps
# -------------------------------------------------------
#Region Get All Apps

Out-File -InputObject "    - Get All Apps" @Params_Logging

if (($GetAllApps -eq "enabled") -and ($Prerequisites_Apps.Where({$_.Name -eq "Microsoft.DesktopAppInstaller.*"}).Status -ne "Fail")) {
	try {
		# Get App Data
		Out-File -InputObject "        Command: & $Path_Winget list --accept-source-agreements" @Params_Logging
		$Temp_Output = & $Path_Winget list --accept-source-agreements
		$Temp_Output = $Temp_Output | Where-Object {$_ -notin ""," ","   \ ","   / ","   | ","   - "}

		Out-File -InputObject "        Output:" @Params_Logging
		foreach ($Line in $Temp_Output) {
			Out-File -InputObject "          $($Line.TrimStart())" @Params_Logging
		}
		Out-File -InputObject "        Status: Success" @Params_Logging
	}
	catch {
		Out-File -InputObject "        Status: Error, $($_.Exception.Message)" @Params_Logging
		$Meta_Script_Result = 1709,"Failure"
	}
}
elseif ($Prerequisites_Apps.Where({$_.Name -eq "Microsoft.DesktopAppInstaller.*"}).Status -eq "Fail") {
	Out-File -InputObject "        Status: Error, Cannot run, failed one or more prerequisite checks" @Params_Logging
}
else {
	Out-File -InputObject "        Parameter != enabled" @Params_Logging
}

#EndRegion Get All Apps
# -------------------------------------------------------

# -------------------------------------------------------
# Get Apps with Updates
# -------------------------------------------------------
#Region Get Apps with Updates

Out-File -InputObject "    - Get Apps with Updates" @Params_Logging

if (($GetAppsWithUpdates -eq "enabled") -and ($Prerequisites_Apps.Where({$_.Name -eq "Microsoft.DesktopAppInstaller.*"}).Status -ne "Fail")) {
	try {
		# Get App Data
		Out-File -InputObject "        Command: & $Path_Winget list --upgrade-available --accept-source-agreements" @Params_Logging
		$Temp_Output = & $Path_Winget list --upgrade-available --accept-source-agreements
		$Temp_Output = $Temp_Output | Where-Object {$_ -notin ""," ","   \ ","   / ","   | ","   - "}

		Out-File -InputObject "        Output:" @Params_Logging
		foreach ($Line in $Temp_Output) {
			Out-File -InputObject "          $($Line.TrimStart())" @Params_Logging
		}
		Out-File -InputObject "        Status: Success" @Params_Logging
	}
	catch {
		Out-File -InputObject "        Status: Error, $($_.Exception.Message)" @Params_Logging
		$Meta_Script_Result = 1710,"Failure"
	}
}
elseif ($Prerequisites_Apps.Where({$_.Name -eq "Microsoft.DesktopAppInstaller.*"}).Status -eq "Fail") {
	Out-File -InputObject "        Status: Error, Cannot run, failed one or more prerequisite checks" @Params_Logging
}
else {
	Out-File -InputObject "        Parameter != enabled" @Params_Logging
}

#EndRegion Get Apps with Updates
# -------------------------------------------------------

# -------------------------------------------------------
# Upgrade All Apps
# -------------------------------------------------------
#Region Upgrade All Apps

Out-File -InputObject "    - Upgrade All Apps" @Params_Logging

if (($UpgradeAllApps -eq "enabled") -and ($Prerequisites_Apps.Where({$_.Name -eq "Microsoft.DesktopAppInstaller.*"}).Status -ne "Fail")) {
	try {
		# Get App Data
		Out-File -InputObject "        Command: & $Path_Winget upgrade --all --force --accept-source-agreements --accept-package-agreements" @Params_Logging
		$Temp_Output = & $Path_Winget upgrade --all --force --accept-source-agreements --accept-package-agreements
		$Temp_Output = $Temp_Output | Where-Object {$_ -notin ""," ","   \ ","   / ","   | ","   - "}

		Out-File -InputObject "        Output:" @Params_Logging
		foreach ($Line in $Temp_Output) {
			Out-File -InputObject "          $($Line.TrimStart())" @Params_Logging
		}
		Out-File -InputObject "        Status: Success" @Params_Logging

	}
	catch {
		Out-File -InputObject "        Status: Error, $($_.Exception.Message)" @Params_Logging
		$Meta_Script_Result = 1711,"Failure"
	}
}
elseif ($Prerequisites_Apps.Where({$_.Name -eq "Microsoft.DesktopAppInstaller.*"}).Status -eq "Fail") {
	Out-File -InputObject "        Status: Error, Cannot run, failed one or more prerequisite checks" @Params_Logging
}
else {
	Out-File -InputObject "        Parameter != enabled" @Params_Logging
}

#EndRegion Upgrade All Apps
# -------------------------------------------------------

# -------------------------------------------------------
# Install Apps
# -------------------------------------------------------
#Region Install Apps

Out-File -InputObject "    - Install Apps" @Params_Logging

if (($InstallApps -notin $null,"") -and ($Prerequisites_Apps.Where({$_.Name -eq "Microsoft.DesktopAppInstaller.*"}).Status -ne "Fail")) {
	foreach ($App in $($InstallApps -split ",")) {
		Out-File -InputObject "        $($App)" @Params_Logging

		try {
			# Validate AppID Exists
			Out-File -InputObject "          Command: winget search $($App)" @Params_Logging
			$Temp_Output = & $Path_Winget search "$($App)"

			if (($Temp_Output[-1] -split " " | Where-Object {$_ -notin ""}) -eq $App) {
				$Validate_Exists = $true
			}
			else {
				$Validate_Exists = $false
			}
			Out-File -InputObject "          Exists: $($Validate_Exists)" @Params_Logging

			# Get Installation State
			Out-File -InputObject "          Command: winget list $($App)" @Params_Logging
			$Temp_Output = & $Path_Winget list "$($App)"

			if (($Temp_Output[-1] -split " " | Where-Object {$_ -notin ""}) -eq $App) {
				$Validate_Installed = $true
			}
			else {
				$Validate_Installed = $false
			}
			Out-File -InputObject "          Installed: $($Validate_Installed)" @Params_Logging

			# Install App
			if (($Validate_Exists -eq $true) -and ($Validate_Installed -eq $false)) {
				Out-File -InputObject "          Command: winget install $($App) --silent --verbose --accept-source-agreements --accept-package-agreements" @Params_Logging
				$Temp_Output = & $Path_Winget install "$($App)" --silent --verbose --accept-source-agreements --accept-package-agreements
				$Temp_Output = $Temp_Output | Where-Object {$_ -notin ""," ","   \ ","   / ","   | ","   - "}
				Out-File -InputObject "          Output:" @Params_Logging
				foreach ($Line in $Temp_Output) {
					Out-File -InputObject "            $($Line.TrimStart())" @Params_Logging
				}

				# Sleep to Prevent Checking Winget DP Too Early
				Start-Sleep -Seconds 5

			# Get Installation State
			Out-File -InputObject "          Command: winget list $($App)" @Params_Logging
			$Temp_Output = & $Path_Winget list "$($App)"

			if (($Temp_Output[-1] -split " " | Where-Object {$_ -notin ""}) -eq $App) {
				$Validate_Installed = $true
			}
			else {
				$Validate_Installed = $false
			}
			Out-File -InputObject "          Installed: $($Validate_Installed)" @Params_Logging
			}
			else {
				Out-File -InputObject "          Status: Skipped" @Params_Logging
			}
		}
		catch {
			Out-File -InputObject "        Status: Error, $($_.Exception.Message)" @Params_Logging
			$Meta_Script_Result = 1712,"Failure"
		}
	}
}
elseif ($Prerequisites_Apps.Where({$_.Name -eq "Microsoft.DesktopAppInstaller.*"}).Status -eq "Fail") {
	Out-File -InputObject "        Status: Error, Cannot run, failed one or more prerequisite checks" @Params_Logging
}
else {
	Out-File -InputObject "        No Applications Provided" @Params_Logging
}

#EndRegion Install Apps
# -------------------------------------------------------

# -------------------------------------------------------
# Repair Apps
# -------------------------------------------------------
#Region Repair Apps

Out-File -InputObject "    - Repair Apps" @Params_Logging

if (($RepairApps -notin $null,"") -and ($Prerequisites_Apps.Where({$_.Name -eq "Microsoft.DesktopAppInstaller.*"}).Status -ne "Fail")) {
	foreach ($App in $($RepairApps -split ",")) {
		Out-File -InputObject "        $($App)" @Params_Logging

		try {
			# Validate AppID Exists
			Out-File -InputObject "          Command: winget search $($App)" @Params_Logging
			$Temp_Output = & $Path_Winget search "$($App)"

			if (($Temp_Output[-1] -split " " | Where-Object {$_ -notin ""}) -eq $App) {
				$Validate_Exists = $true
			}
			else {
				$Validate_Exists = $false
			}
			Out-File -InputObject "          Exists: $($Validate_Exists)" @Params_Logging

			# Get Installation State
			Out-File -InputObject "          Command: winget list $($App)" @Params_Logging
			$Temp_Output = & $Path_Winget list "$($App)"

			if (($Temp_Output[-1] -split " " | Where-Object {$_ -notin ""}) -eq $App) {
				$Validate_Installed = $true
			}
			else {
				$Validate_Installed = $false
			}
			Out-File -InputObject "          Installed: $($Validate_Installed)" @Params_Logging

			# Repair App
			if (($Validate_Exists -eq $true) -and ($Validate_Installed -eq $true)) {
				Out-File -InputObject "          Command: winget repair $($App) --silent --verbose --accept-source-agreements --accept-package-agreements" @Params_Logging
				$Temp_Output = & $Path_Winget repair "$($App)" --silent --verbose --accept-source-agreements --accept-package-agreements
				$Temp_Output = $Temp_Output | Where-Object {$_ -notin ""," ","   \ ","   / ","   | ","   - "}
				Out-File -InputObject "          Output:" @Params_Logging
				foreach ($Line in $Temp_Output) {
					Out-File -InputObject "            $($Line.TrimStart())" @Params_Logging
				}

				# Sleep to Prevent Checking Winget DP Too Early
				Start-Sleep -Seconds 5

				# Get Installation State
				Out-File -InputObject "          Command: winget list $($App)" @Params_Logging
				$Temp_Output = & $Path_Winget list "$($App)"

				if (($Temp_Output[-1] -split " " | Where-Object {$_ -notin ""}) -eq $App) {
					Out-File -InputObject "          Status: Success" @Params_Logging
				}
				else {
					Out-File -InputObject "          Status: Error, App not found after attempting installation" @Params_Logging
				}
			}
			else {
				Out-File -InputObject "          Status: Skipped" @Params_Logging
			}
		}
		catch {
			Out-File -InputObject "        Status: Error, $($_.Exception.Message)" @Params_Logging
			$Meta_Script_Result = 1713,"Failure"
		}
	}
}
elseif ($Prerequisites_Apps.Where({$_.Name -eq "Microsoft.DesktopAppInstaller.*"}).Status -eq "Fail") {
	Out-File -InputObject "        Status: Error, Cannot run, failed one or more prerequisite checks" @Params_Logging
}
else {
	Out-File -InputObject "        No Applications Provided" @Params_Logging
}

#EndRegion Repair Apps
# -------------------------------------------------------

# -------------------------------------------------------
# Uninstall Apps
# -------------------------------------------------------
#Region Uninstall Apps

Out-File -InputObject "    - Uninstall Apps" @Params_Logging

if (($UninstallApps -notin $null,"") -and ($Prerequisites_Apps.Where({$_.Name -eq "Microsoft.DesktopAppInstaller.*"}).Status -ne "Fail")) {
	foreach ($App in $($UninstallApps -split ",")) {
		Out-File -InputObject "        $($App)" @Params_Logging

		try {
			# Validate AppID Exists
			Out-File -InputObject "          Command: winget search $($App)" @Params_Logging
			$Temp_Output = & $Path_Winget search "$($App)"

			if (($Temp_Output[-1] -split " " | Where-Object {$_ -notin ""}) -eq $App) {
				$Validate_Exists = $true
			}
			else {
				$Validate_Exists = $false
			}
			Out-File -InputObject "          Exists: $($Validate_Exists)" @Params_Logging

			# Get Installation State
			Out-File -InputObject "          Command: winget list $($App)" @Params_Logging
			$Temp_Output = & $Path_Winget list "$($App)"

			if (($Temp_Output[-1] -split " " | Where-Object {$_ -notin ""}) -eq $App) {
				$Validate_Installed = $true
			}
			else {
				$Validate_Installed = $false
			}
			Out-File -InputObject "          Installed: $($Validate_Installed)" @Params_Logging

			# Uninstall App
			if (($Validate_Exists -eq $true) -and ($Validate_Installed -eq $true)) {
				Out-File -InputObject "          Command: winget uninstall $($App) --silent --verbose" @Params_Logging
				$Temp_Output = & $Path_Winget uninstall "$($App)" --silent --verbose
				$Temp_Output = $Temp_Output | Where-Object {$_ -notin ""," ","   \ ","   / ","   | ","   - "}
				Out-File -InputObject "          Output:" @Params_Logging
				foreach ($Line in $Temp_Output) {
					Out-File -InputObject "            $($Line.TrimStart())" @Params_Logging
				}

				# Sleep to Prevent Checking Winget DP Too Early
				Start-Sleep -Seconds 5

				# Get Installation State
				Out-File -InputObject "          Command: winget list $($App)" @Params_Logging
				$Temp_Output = & $Path_Winget list "$($App)"

				if (($Temp_Output[-1] -split " " | Where-Object {$_ -notin ""}) -eq $App) {
					Out-File -InputObject "          Status: Error, App found after attempting uninstallation" @Params_Logging
				}
				else {
					Out-File -InputObject "          Status: Success" @Params_Logging
				}
			}
			else {
				Out-File -InputObject "          Status: Skipped" @Params_Logging
			}
		}
		catch {
			Out-File -InputObject "        Status: Error, $($_.Exception.Message)" @Params_Logging
			$Meta_Script_Result = 1714,"Failure"
		}
	}
}
elseif ($Prerequisites_Apps.Where({$_.Name -eq "Microsoft.DesktopAppInstaller.*"}).Status -eq "Fail") {
	Out-File -InputObject "        Status: Error, Cannot run, failed one or more prerequisite checks" @Params_Logging
}
else {
	Out-File -InputObject "        No Applications Provided" @Params_Logging
}

#EndRegion Uninstall Apps
# -------------------------------------------------------

#EndRegion Execution
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# File Collection
#   Error Range: 1700 - 1799
#--------------------------------------------------------------------------------------------
#Region File Collection

Out-File -InputObject "" @Params_Logging
Out-File -InputObject "  File Collection" @Params_Logging

# -------------------------------------------------------
# Settings JSON Files
# -------------------------------------------------------
#Region Settings JSON Files

Out-File -InputObject "    - Settings JSON Files" @Params_Logging

if (($CollectSettingsFiles -eq "enabled") -and ($Prerequisites_Apps.Where({$_.Name -eq "Microsoft.DesktopAppInstaller.*"}).Status -ne "Fail")) {
	# Initialize Variables
	$Temp_Paths = @{

	}
	$Temp_Filter = "settings.json"

	# Add System Paths
	if ($Meta_Script_Execution_User.IsSystem -ne $true) {
		$Temp_Paths.Add("System","$($env:LOCALAPPDATA)\Microsoft\WinGet\Settings")
	}

	# Add User Paths
	Get-ChildItem -Path "C:\Users" | Where-Object {$_.Name -notin "Public","TEMP"} | ForEach-Object {
		$Temp_Paths.Add("$($_.Name)","$($_.FullName)\AppData\Local\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState")
	}

	# Process Paths
	foreach ($Path in $Temp_Paths.GetEnumerator()) {
		try {
			Out-File -InputObject "        $($Path.Key)" @Params_Logging
			Out-File -InputObject "          Source Path: $($Path.Value)" @Params_Logging
			Out-File -InputObject "          Filter: $($Temp_Filter)" @Params_Logging

			# Test Existence
			if (Test-Path -Path $Path.Value) {
				Out-File -InputObject "          Exists: True" @Params_Logging

				# Get Files
				$Temp_Dataset = Get-ChildItem -Path $Path.Value -Recurse -Filter $Temp_Filter
				Out-File -InputObject "          Count: $(($Temp_Dataset | Measure-Object).Count)" @Params_Logging

				# Copy Files
				foreach ($File in $Temp_Dataset) {
					try {
						Out-File -InputObject "            File: $($File.FullName)" @Params_Logging

						# Concatenate Destination Path
						$Temp_Destination_Dir = "$($Path_Logging_Directory)\$($Path.Name)\$($File.DirectoryName | Split-Path -Leaf)\"
						Out-File -InputObject "              Destination: $($Temp_Destination_Dir)" @Params_Logging

						# Recursively Create Destination Path
						if (Test-Path "filesystem::$($Temp_Destination_Dir)\") {
							Out-File -InputObject "              Directory: Exists" @Params_Logging
						}
						else {
							New-RecursivePath -Path $Temp_Destination_Dir
							Out-File -InputObject "              Directory: Created" @Params_Logging
						}

						# Copy Items
						Copy-Item -Path $File.FullName -Destination "filesystem::$($Temp_Destination_Dir)\"
						Out-File -InputObject "              Result: Success" @Params_Logging
					}
					catch {
						Out-File -InputObject "              Result: Error, $($_.Exception.Message)" @Params_Logging
					}
				}

				Out-File -InputObject "          Status: Complete" @Params_Logging
			}
			else {
				Out-File -InputObject "          Exists: False" @Params_Logging
				Out-File -InputObject "          Status: Skipped" @Params_Logging
			}
		}
		catch {
			Out-File -InputObject "        Status: Error, $($_.Exception.Message)" @Params_Logging
			$Meta_Script_Result = 1715,"Failure"
		}
	}
}
elseif ($Prerequisites_Apps.Where({$_.Name -eq "Microsoft.DesktopAppInstaller.*"}).Status -eq "Fail") {
	Out-File -InputObject "        Status: Error, Cannot run, failed one or more prerequisite checks" @Params_Logging
}
else {
	Out-File -InputObject "        Parameter != enabled" @Params_Logging
}

#EndRegion Settings JSON Files
# -------------------------------------------------------

# -------------------------------------------------------
# Log Files
# -------------------------------------------------------
#Region Log Files

Out-File -InputObject "    - Log Files" @Params_Logging

if ($CollectLogFiles -eq "enabled") {
	# Initialize Variables
	$Temp_Paths = @{
		"User"		= "%LOCALAPPDATA%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir"
		"SYSTEM"	= "C:\Windows\Temp\WinGet\defaultState"
		"Intune"	= "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs"
	}
	$Temp_Filter = "*.log"

	# Process Paths
	foreach ($Path in $Temp_Paths.GetEnumerator()) {
		try {
			Out-File -InputObject "        $($Path.Key)" @Params_Logging
			Out-File -InputObject "          Source Path: $($Path.Value)" @Params_Logging
			Out-File -InputObject "          Filter: $($Temp_Filter)" @Params_Logging

			# Test Existence
			if (Test-Path -Path $Path.Value) {
				Out-File -InputObject "          Exists: True" @Params_Logging

				# Get Files
				$Temp_Dataset = Get-ChildItem -Path $Path.Value -Recurse -Filter $Temp_Filter
				Out-File -InputObject "          Count: $(($Temp_Dataset | Measure-Object).Count)" @Params_Logging

				# Copy Files
				foreach ($File in $Temp_Dataset) {
					try {
						Out-File -InputObject "            File: $($File.FullName)" @Params_Logging

						# Concatenate Destination Path
						$Temp_Destination_Dir = "$($Path_Logging_Directory)\$($Path.Name)\$($File.DirectoryName | Split-Path -Leaf)\"
						Out-File -InputObject "              Destination: $($Temp_Destination_Dir)" @Params_Logging

						# Recursively Create Destination Path
						if (Test-Path "filesystem::$($Temp_Destination_Dir)\") {
							Out-File -InputObject "              Directory: Exists" @Params_Logging
						}
						else {
							New-RecursivePath -Path $Temp_Destination_Dir
							Out-File -InputObject "              Directory: Created" @Params_Logging
						}

						# Copy Items
						Copy-Item -Path $File.FullName -Destination "filesystem::$($Temp_Destination_Dir)\"
						Out-File -InputObject "              Result: Success" @Params_Logging
					}
					catch {
						Out-File -InputObject "              Result: Error, $($_.Exception.Message)" @Params_Logging
					}
				}

				Out-File -InputObject "          Status: Complete" @Params_Logging
			}
			else {
				Out-File -InputObject "          Exists: False" @Params_Logging
				Out-File -InputObject "          Status: Skipped" @Params_Logging
			}
		}
		catch {
			Out-File -InputObject "        Status: Error, $($_.Exception.Message)" @Params_Logging
			$Meta_Script_Result = 1716,"Failure"
		}
	}
}
else {
	Out-File -InputObject "        Parameter != enabled" @Params_Logging
}

#EndRegion Log Files
# -------------------------------------------------------

#EndRegion File Collection
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Footer
#--------------------------------------------------------------------------------------------
#Region Footer

# Gather Data
$Meta_Script_Complete_DateTime  = Get-Date
$Meta_Script_Complete_TimeSpan  = New-TimeSpan -Start $Meta_Script_Start_DateTime -End $Meta_Script_Complete_DateTime

# Output
Out-File -InputObject "" @Params_Logging
Out-File -InputObject "------------------------------------------------------------------------------" @Params_Logging
Out-File -InputObject "  Script Result: $($Meta_Script_Result[1])" @Params_Logging
Out-File -InputObject "  Script Started: $($Meta_Script_Start_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)" @Params_Logging
Out-File -InputObject "  Script Completed: $($Meta_Script_Complete_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)" @Params_Logging
Out-File -InputObject "  Total Time: $($Meta_Script_Complete_TimeSpan.Days) days, $($Meta_Script_Complete_TimeSpan.Hours) hours, $($Meta_Script_Complete_TimeSpan.Minutes) minutes, $($Meta_Script_Complete_TimeSpan.Seconds) seconds, $($Meta_Script_Complete_TimeSpan.Milliseconds) milliseconds" @Params_Logging
Out-File -InputObject "------------------------------------------------------------------------------" @Params_Logging
Out-File -InputObject "  End of Script" @Params_Logging
Out-File -InputObject "------------------------------------------------------------------------------" @Params_Logging

#EndRegion Footer
#--------------------------------------------------------------------------------------------

Exit $Meta_Script_Result[0]