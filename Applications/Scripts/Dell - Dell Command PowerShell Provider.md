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