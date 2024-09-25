# Dell - Dell Command PowerShell Provider

This file provides a working set of installation, uninstallation, and detection scripts for the specified product.

How To Use:

1. Place the Command Line code into the Application's "Installation Program" field
2. Save the Script code into a ps1 file and save that to the source content folder for the application
3. Repeat for the Uninstallation Command Line and Installation Script
4. Add the Detection script to the

## Table of Contents

- [Dell - Dell Command PowerShell Provider](#dell---dell-command-powershell-provider)
  - [Table of Contents](#table-of-contents)
  - [2.8.0](#280)
    - [Installation](#installation)
    - [Uninstallation](#uninstallation)
    - [Detection](#detection)
- [Appendices](#appendices)
  - [Apdx A: Template](#apdx-a-template)
  - [\[Version\]](#version)
    - [Installation](#installation-1)
    - [Uninstallation](#uninstallation-1)
    - [Detection](#detection-1)
  - [Apdx B: Registry Paths for ARP Entries](#apdx-b-registry-paths-for-arp-entries)

&nbsp;

## 2.8.0

### Installation

The application is installed using this command line and installation script content.

Command Line

```cmd
Powershell.exe -ExecutionPolicy Bypass -File "Install.psl"
```

Script

```powershell
# Start Logging
  Start-Transcript -Path "C:\ProgramData\VividRock\MECMToolkit\Logging\Applications\Install\DellInc_DellCommandPowerShellProvider_2.8.0_PS_Install.log"

# Install Application
  # Create Folder(s)
    Write-Host "  - Create Folders"
    $Folders = @(
      "$env:ProgramFiles\WindowsPowerShell\Modules\DellCommandPowerShellProvider"
      "$env:ProgramFiles\WindowsPowerShell\Modules\DellCommandPowerShellProvider\2.8.0"
    )
    foreach ($Folder in $Folders) {
      if ((Test-Path -Path $Folder) -eq $false) {
        New-Item -Path $Folder -ItemType Directory | Out-Null
      }
    }

  # Copy Files
    Write-Host "  - Copy Files"
    Copy-Item -Path ".\*" -Destination $Folders[1] -Recurse

# Add ARP Entry
  # Create Folder
    $Temp_Entry = New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" -Name "Dell Command | PowerShell Provider - 2.8.0"

  # Add Properties
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "Publisher" -Value "Dell Inc." -PropertyType "String"
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "DisplayName" -Value "Dell Command | PowerShell Provider" -PropertyType "String"
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "DisplayVersion" -Value "2.8.0" -PropertyType "String"
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "DisplayIcon" -Value "C:\Program Files\WindowsPowerShell\Modules\DellCommandPowerShellProvider\2.8.0\icon.ico" -PropertyType "String"
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "InstallDate" -Value $(Get-Date -Format "yyyyMMdd") -PropertyType "String"
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "InstallLocation" -Value "C:\Program Files\WindowsPowerShell\Modules\DellCommandPowerShellProvider\2.8.0\" -PropertyType "String"
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "UninstallString" -Value "Powershell.exe -ExecutionPolicy Bypass -File `"Uninstall.ps1`"" -PropertyType "String"
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "EstimatedSize" -Value "5692" -PropertyType "DWord"

# End Logging
  Stop-Transcript
```

### Uninstallation

The application is uninstalled using this command line and script content.

Command Line

```cmd
Powershell.exe -ExecutionPolicy Bypass -File "Uninstall.psl"
```

Script

```powershell
# Start Logging
  Start-Transcript -Path "C:\ProgramData\VividRock\MECMToolkit\Logging\Applications\Uninstall\DellInc_DellCommandPowerShellProvider_2.8.0_PS_Uninstall.log"

# Uninstall Application
  # Remove Folder(s)
    Write-Host "  - Remove Folders"
    $Folders = @(
      "$env:ProgramFiles\WindowsPowerShell\Modules\DellCommandPowerShellProvider\2.8.0"
    )
    foreach ($Folder in $Folders) {
      if ((Test-Path -Path $Folder) -eq $true) {
        Remove-Item -Path $Folder -Recurse | Out-Null
      }
    }

# Remove ARP Entry
  # Remove Folder
    Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Dell Command | PowerShell Provider - 2.8.0"

# End Logging
  Stop-Transcript
```

### Detection

Script

```powershell
#--------------------------------------------------------------------------------------------
# Logging
#--------------------------------------------------------------------------------------------
#Region Logging

  $Path_Logging_File  = $($env:vr_Directory_Logs + "\Applications\Detection\DellInc_DellCommandPowerShellProvider_2.8.0.log")
  $Params_Logging     = @{ FilePath = $Path_Logging_File; Append = $true }
  if ((Test-Path -Path "C:\ProgramData\VividRock\MECMToolkit\Logging\Application\Detection") -eq $false) {
    New-Item -Path "C:\ProgramData\VividRock\MECMToolkit\Logging\Application\Detection" -ItemType Directory | Out-Null
  }
  Out-File -InputObject "" -FilePath $Path_Logging_File

#EndRegion Logging
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

  Out-File -InputObject "------------------------------------------------------------------------------" @Params_Logging
  Out-File -InputObject "  MECM Toolkit - Applications - Detection Logic" @Params_Logging
  Out-File -InputObject "------------------------------------------------------------------------------" @Params_Logging
  Out-File -InputObject "    Author:     Dustin Estes" @Params_Logging
  Out-File -InputObject "    Company:    VividRock" @Params_Logging
  Out-File -InputObject "    Date:       2017-03-13" @Params_Logging
  Out-File -InputObject "    Copyright:  VividRock LLC - All Rights Reserved" @Params_Logging
  Out-File -InputObject "    Purpose:    Used to detect an Application's installation status based on" @Params_Logging
  Out-File -InputObject "                modules added to the body of the script" @Params_Logging
  Out-File -InputObject "    Links:      None" @Params_Logging
  Out-File -InputObject "    Version:    2.0" @Params_Logging
  Out-File -InputObject "------------------------------------------------------------------------------" @Params_Logging
  Out-File -InputObject "" @Params_Logging

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

  # Metadata
    $Meta_Script_Start_DateTime     = Get-Date
    $Meta_Script_Complete_DateTime  = $null
    $Meta_Script_Complete_TimeSpan  = $null
    $Meta_Script_DetectionDelay = 0
    # Format: Exit Code, STDOUT, Log File Text
    $Meta_Script_Result = $null,$null,"Detection Not Performed"

#EndRegion Variables
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Detection Modules
#--------------------------------------------------------------------------------------------

  Out-File -InputObject "  Detection Modules" @Params_Logging

  # Delay Detection (If Necessary)
    Out-File -InputObject "    - Delay Detection: $($Meta_Script_DetectionDelay) seconds" @Params_Logging
    Start-Sleep -Seconds $Meta_Script_DetectionDelay

# -------------------------------------------------------
  # Application - Win32 (Registry)
  # -------------------------------------------------------
  #Region Application - Win32 (Registry)

    Out-File -InputObject "    - Application - Win32 (Registry)" @Params_Logging

    # Initialize Detection Values
      $Detection_App_Win32Reg_01  = $false
      $Temp_Count_Matches         = 0

    # Variables
      Out-File -InputObject "        Variables" @Params_Logging

      $App_Win32Reg_Publisher         = "Dell Inc."
      $App_Win32Reg_DisplayName       = "Dell Command | PowerShell Provider"
      $App_Win32Reg_DisplayVersion    = "2.8.0"

      switch ($App_Win32Reg_DisplayVersion) {
        {$App_Win32Reg_DisplayVersion -match "^[\d\.]+$"} { $App_Win32Reg_VersionDataType = "Integer" }
        Default { $App_Win32Reg_VersionDataType = "String" }
      }

      $App_Win32Reg_RegistryPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
      )

      $Dataset_App_Win32Reg_Applications = $null
      foreach ($Item in $App_Win32Reg_RegistryPaths) {
        $Dataset_App_Win32Reg_Applications += Get-ChildItem $Item
      }

      foreach ($Item in (Get-Variable -Name "App_Win32Reg_*")) {
        Out-File -InputObject "            $(($Item.Name) -replace 'App_Win32Reg_',''): $($Item.Value)" @Params_Logging
      }

    # Detection
      Out-File -InputObject "        Detection" @Params_Logging

      if ($App_Win32Reg_VersionDataType -eq "String") {
        switch ($Dataset_App_Win32Reg_Applications) {
          {($_.GetValue("Publisher") -like $App_Win32Reg_Publisher) -and ($_.GetValue("DisplayName") -like $App_Win32Reg_DisplayName) -and ($_.GetValue("DisplayVersion") -eq $App_Win32Reg_DisplayVersion)} {
            Out-File -InputObject "            Exact Match: $($_.GetValue("Publisher")) - $($_.GetValue("DisplayName")) - $($_.GetValue("DisplayVersion")) ($($_.Name))" @Params_Logging
            $Temp_Count_Matches += 1
          }
          Default {}
        }
      }
      elseif ($App_Win32Reg_VersionDataType -eq "Integer") {
        switch ($Dataset_App_Win32Reg_Applications) {
          {($_.GetValue("Publisher") -like $App_Win32Reg_Publisher) -and ($_.GetValue("DisplayName") -like $App_Win32Reg_DisplayName) -and ([System.Version]$_.GetValue("DisplayVersion") -eq [System.Version]$App_Win32Reg_DisplayVersion)} {
            Out-File -InputObject "            Exact Match: $($_.GetValue("Publisher")) - $($_.GetValue("DisplayName")) - $($_.GetValue("DisplayVersion")) ($($_.Name))" @Params_Logging
            $Temp_Count_Matches += 1
          }
          {($_.GetValue("Publisher") -like $App_Win32Reg_Publisher) -and ($_.GetValue("DisplayName") -like $App_Win32Reg_DisplayName) -and ([System.Version]$_.GetValue("DisplayVersion") -gt [System.Version]$App_Win32Reg_DisplayVersion)} {
            Out-File -InputObject "            Newer Version: $($_.GetValue("Publisher")) - $($_.GetValue("DisplayName")) - $($_.GetValue("DisplayVersion")) ($($_.Name))" @Params_Logging
            $Temp_Count_Matches += 1
          }
          Default {}
        }
      }

    # Evalaution
      if ($Temp_Count_Matches -gt 0) {
        $Detection_App_Win32Reg_01 = $true
      }
      else {
        $Detection_App_Win32Reg_01 = $false
      }

  #EndRegion Application - Win32 (Registry)
  # -------------------------------------------------------

  # -------------------------------------------------------
  # Files & Folders: Existential
  # -------------------------------------------------------
  #Region Files & Folders: Existential

    Out-File -InputObject "    - Files & Folders: Existential" @Params_Logging

    # Initialize Detection Values
      $Detection_FilesFolders_Exist_01  = $false
      $Temp_Count_Failures        = 0

    # Variables
      Out-File -InputObject "        Variables" @Params_Logging

      $FilesFolders_Exist_Paths = @(
        "C:\Program Files\WindowsPowerShell\Modules\DellCommandPowerShellProvider\2.8.0\DellBIOSProvider.psd1"
      )

      foreach ($Item in (Get-Variable -Name "FilesFolders_Exist_*")) {
        Out-File -InputObject "            $(($Item.Name) -replace 'FilesFolders_Exist_',''): $($Item.Value)" @Params_Logging
      }

    # Detection
      Out-File -InputObject "        Detection" @Params_Logging
      switch ($FilesFolders_Exist_Paths) {
        {Test-Path -Path $_} {
          Out-File -InputObject "            Path Found: $($_)" @Params_Logging
        }
        Default {
          Out-File -InputObject "            Path Not Found: $($_)" @Params_Logging
          $Temp_Count_Failures += 1
        }
      }

    # Evaluation
    if ($Temp_Count_Failures -gt 0) {
      $Detection_FilesFolders_Exist_01 = $false
    }
    else {
      $Detection_FilesFolders_Exist_01 = $true
    }

  #EndRegion Files & Folders: Existential
  # -------------------------------------------------------

#EndRegion Detection Modules
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Detection Results
#--------------------------------------------------------------------------------------------
#Region Detection Results

  Out-File -InputObject "  Detection Results" @Params_Logging

  $Overall_Count_Failures = 0

  # Output Module Results
    foreach ($Item in (Get-Variable -Name "Detection_*")) {
      Out-File -InputObject "    - $(($Item.Name) -replace 'Detection_',''): $($Item.Value)" @Params_Logging
      if ($Item.Value -eq $false) {
          $Overall_Count_Failures += 1
      }
    }
    Out-File -InputObject "`n    - Failure Total: $($Overall_Count_Failures)" @Params_Logging

  # Determine Overall Detection
    if ($Overall_Count_Failures -gt 0) {
        $Meta_Script_Result = 0,$null,"Application Not Detected"
    }
    elseif ($Overall_Count_Failures -eq 0) {
        $Meta_Script_Result = 0,$true,"Application Detected"
    }
    else {
        $Meta_Script_Result = $false,$null,"Error Occurred"
    }

#EndRegion Detection Results
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
    Out-File -InputObject "  Script Result: $($Meta_Script_Result[2])" @Params_Logging
    Out-File -InputObject "  Script Started: $($Meta_Script_Start_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)" @Params_Logging
    Out-File -InputObject "  Script Completed: $($Meta_Script_Complete_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)" @Params_Logging
    Out-File -InputObject "  Total Time: $($Meta_Script_Complete_TimeSpan.Days) days, $($Meta_Script_Complete_TimeSpan.Hours) hours, $($Meta_Script_Complete_TimeSpan.Minutes) minutes, $($Meta_Script_Complete_TimeSpan.Seconds) seconds, $($Meta_Script_Complete_TimeSpan.Milliseconds) milliseconds" @Params_Logging
    Out-File -InputObject "------------------------------------------------------------------------------" @Params_Logging
    Out-File -InputObject "  End of Script" @Params_Logging
    Out-File -InputObject "------------------------------------------------------------------------------" @Params_Logging

#EndRegion Footer
#--------------------------------------------------------------------------------------------

Write-Output -InputObject $Meta_Script_Result[1]
Exit $Meta_Script_Result[0]
```

&nbsp;

# Appendices

## Apdx A: Template

## [Version]

### Installation

The application is installed using this command line and installation script content.

Command Line

```cmd
Powershell.exe -ExecutionPolicy Bypass -File "Install.psl"
```

Script

```powershell

```

### Uninstallation

The application is uninstalled using this command line and script content.

Command Line

```cmd
Powershell.exe -ExecutionPolicy Bypass -File "Uninstall.psl"
```

Script

```powershell

```

### Detection

Script

```powershell

```

&nbsp;

## Apdx B: Registry Paths for ARP Entries

| Scope             | Path                                                                    |
|-------------------|-------------------------------------------------------------------------|
| Machine (x86)     | "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" |
| Machine (x64)     | "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"             |
| CurrentUser (x86) | "HKCU:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" |
| CurrentUser (x64) | "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"             |