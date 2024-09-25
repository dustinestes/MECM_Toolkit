# Dell - Dell Command PowerShell Provider

This file provides a working set of installation, uninstallation, and detection scripts for the specified product.

How To Use:

1. Place the Command Line code into the Application's "Installation Program" field
2. Save the Script code into a ps1 file and save that to the source content folder for the application
3. Repeat for the Uninstallation Command Line and Installation Script
4. Add the Detection code to the Application once created within MECM

## Table of Contents

- [Dell - Dell Command PowerShell Provider](#dell---dell-command-powershell-provider)
  - [Table of Contents](#table-of-contents)
  - [\[Version\]](#version)
    - [Installation](#installation)
    - [Uninstallation](#uninstallation)
    - [Detection](#detection)
- [Appendices](#appendices)
  - [Apdx A: Template](#apdx-a-template)
  - [\[Version\]](#version-1)
    - [Installation](#installation-1)
    - [Uninstallation](#uninstallation-1)
    - [Detection](#detection-1)
  - [Apdx B: Registry Paths for ARP Entries](#apdx-b-registry-paths-for-arp-entries)

&nbsp;

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
<#--------------------------------------------------------------------------------------------------------------------
    MECM Detection Method: Microsoft SQL Server
----------------------------------------------------------------------------------------------------------------------
    Author:  Dustin Estes
    Date:    September 14th, 2020

    This script will attempt to detect the version and edition of the SQL server software for each instance found.
    The logic will then determine if SQL Server is installed using the following logic:
        - Is "Detected Edition" value "equal to" the "Expected Edition" value provided below?
        AND
        - Is the "Detected Version" value "greater than or equal to" the "Expected Version" value provided below?

    The script then uses the following "Exit" logic to provide MECM with the output needed to state True or False
        Exit 0 = Expected Values detected
        Exit 1 = Expected Values not detected

----------------------------------------------------------------------------------------------------------------------#>
# Provide the Expected values for the Detection check
    $ExpectedEdition = "Enterprise Edition"
    $ExpectedVersion = "15.0.2000.5"

# Get all instances of SQL Server
    $instances = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server').InstalledInstances

# Process each instance found in the array
    foreach ($i in $instances) {
        $p = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL').$i
        $DetectedEdition = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$p\Setup").Edition
        $DetectedVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$p\Setup").Version

        If (($DetectedEdition -eq $ExpectedEdition) -and ([version]::Parse($DetectedVersion) -ge [version]::Parse($ExpectedVersion)) ){
            #write-host "Detected Edition = $DetectedEdition" -ForegroundColor Yellow
            #write-host "Detected Version = $DetectedVersion" -ForegroundColor Yellow
            write-host "Expected values found. SQL Server is installed." -ForegroundColor Green
            Exit 0
        }
        Else {

        }
}
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