# MECM Toolkit - Applications - PowerShell Installation Script Builder

The below ToC links you to the various sections and code snippets within this markdown file. These snippets should be used to build the installation scripts and also help to maintain standards.

## Table of Contents

- [MECM Toolkit - Applications - PowerShell Installation Script Builder](#mecm-toolkit---applications---powershell-installation-script-builder)
  - [Table of Contents](#table-of-contents)
  - [MECM](#mecm)
    - [PowerShell Script Install/Uninstall](#powershell-script-installuninstall)
    - [Powershell Executable Install/Uninstall](#powershell-executable-installuninstall)
    - [Add a Delay Before MECM Evaluates](#add-a-delay-before-mecm-evaluates)
  - [Logging](#logging)
    - [Start Logging](#start-logging)
    - [End Logging](#end-logging)
  - [Installation](#installation)
    - [Standard Installation](#standard-installation)
  - [Uninstallation](#uninstallation)
    - [Standard Uninstallation](#standard-uninstallation)
    - [MSI Bulk Uninstallation](#msi-bulk-uninstallation)
  - [Add/Remove Programs (ARP) Entry](#addremove-programs-arp-entry)
    - [Add ARP Entry](#add-arp-entry)
    - [Remove ARP Entry](#remove-arp-entry)
  - [Delay/Sleep](#delaysleep)
    - [Start Sleep](#start-sleep)
  - [File \& Folder Management](#file--folder-management)
    - [Copy Files](#copy-files)
  - [WMI Management](#wmi-management)
  - [Shortcut Management](#shortcut-management)
    - [Create Start Menu Shortcut (All Users)](#create-start-menu-shortcut-all-users)
    - [Create Start Menu Shortcut (Current User)](#create-start-menu-shortcut-current-user)
  - [Service Management](#service-management)
    - [Stop a Service](#stop-a-service)
    - [Start a Service](#start-a-service)
    - [Restart a Service](#restart-a-service)
  - [Process Management](#process-management)
    - [Stop a Process](#stop-a-process)
    - [Wait for a Process to Start](#wait-for-a-process-to-start)
  - [Certificate Management](#certificate-management)
    - [Install All Certificate Files](#install-all-certificate-files)
    - [Install Specific Certificate Files](#install-specific-certificate-files)
  - [Driver Management](#driver-management)
  - [Registry Management](#registry-management)
    - [Add/Modify Registry Property (System)](#addmodify-registry-property-system)
    - [Add/Modify Registry Property (Current User)](#addmodify-registry-property-current-user)
    - [Add/Modify All Users Profiles](#addmodify-all-users-profiles)
  - [Registry Sample Modules](#registry-sample-modules)
    - [File Type Association](#file-type-association)
      - [Registry](#registry)
      - [DISM](#dism)
  - [Environment Variable Management](#environment-variable-management)
    - [Add/Modify Environment Variable](#addmodify-environment-variable)
    - [Remove Environment Variable](#remove-environment-variable)


&nbsp;

## MECM

The following snippets are used when creating applications within MECM.

| Name | Purpose | Description | Link |
| ---- | ------- | ----------- | ---- |
| PowerShell Script Install/Uninstall | MECM | This command is used to install/uninstall apps using a PowerShell script. | [Link](###­-powershell-script-install_uninstall) |
| PowerShell Executable Install/Uninstall | MECM | This command is used to install/uninstall apps using their direct install executables. There is also an option to add a delay/sleep timer to this. | [Link](###-powershell-executable-install_uninstall) |
| Add a Delay Before MECM Evaluates | MECM | This additional command is used in conjunction with the above command to add a delay/sleep timer to this. | [Link](###-add-a-delay-before-mecm-evaluates) |

&nbsp;

### PowerShell Script Install/Uninstall

Snippet

```powershell
Powershell.exe -ExecutionPolicy Bypass -File "[scriptname].ps1"
```

&nbsp;

Example

```powershell
Powershell.exe -ExecutionPolicy Bypass -File "Manufacturer_Product_Version_Install.ps1"
```

&nbsp;

### Powershell Executable Install/Uninstall

> Notes:
>
> -	Filepath: points to the filename (use dot sourcing)
> -	Argumentlist: provide command line parameters

&nbsp;

Snippet

```powershell
Powershell.exe -ExecutionPolicy Bypass -Command "Start-Process -NoNewWindow -FilePath '[. \Filepath]' -Argumentlist '[Argumentlist]' -Wait"
```

&nbsp;

Example

```powershell
Powershell.exe -ExecutionPolicy Bypass -Command "Start-Process -NoNewWindow -FilePath 'C:\Program Files\SoftwareName\uninstall.exe' -ArgumentList '/S' -Wait"
```

&nbsp;

### Add a Delay Before MECM Evaluates

You can add a delay to the completion of this command by placing the following code at the end of the above snippet, after the "-Wait" param and inside the double quotes.

&nbsp;

Snippet

```powershell
; Start-Sleep -Seconds [Integer]
```

&nbsp;

Example

```powershell
Powershell.exe -ExecutionPolicy Bypass -Command "Start-Process -NoNewWindow -FilePath 'C:\Program Files\VividRock\uninstall.exe' -ArgumentList '/S' -Wait; Start-Sleep -Seconds 15"
```

&nbsp;

## Logging

The following snippets are used to envelope PowerShell Scripts with transcript logging for simple output info when you need to troubleshoot deployments.

| Name | Purpose | Description | Link |
| ---- | ------- | ----------- | ---- |
| Start Logging | Logging | Begins the transcript of the PowerShell script. All app-specific text should be used inbetween this start snippet and the End Logging Snippet. | [Link](###-logging---start-snippet) |
| End Logging | Logging | Ends the transcript of the PowerShell script. All app-specifc text should be usd inbetween this end snippet and the Start Logging Snippet. | [Link](###-logging---end-snippet) |

&nbsp;

### Start Logging

Snippet

> Notes:
>
> - [logname]: Use a standard naming convention for log files. Format: Publisher_ProductName_Version
> - [_PS_install.log]: ensure to use this suffix so as to distinguish the ouput file from this PowerShell script from the standard log generated from the actual application install/uninstall.

&nbsp;

```powershell
# Start Logging
    Start-Transcript -Path "C:\ProgramData\VividRock\MECMScriptToolkit\Logging\Application\Install\[logname]_PS_Install.log"
```

&nbsp;

Example

```powershell
# Start Logging
    Start-Transcript -Path "C:\ProgramData\VividRock\MECMScriptToolkit\Logging\Application\Install\VividRock_ApplciationName_1.5.0_PS_Install.log"
```

&nbsp;

### End Logging

Snippet

> Notes:
>
> There are no parameters for this.

&nbsp;

```powershell
# End Logging
    Stop-Transcript
```

&nbsp;

Example

```powershell
# End Logging
    Stop-Transcript
```

&nbsp;

## Installation

| Name | Purpose | Description | Link |
| ---- | ------- | ----------- | ---- |
| Standard Installation | Installation | A basic PowerShell snippet for simply installing an application. | [Link](###-standard-installation) |

&nbsp;

### Standard Installation

Snippet

> Notes:
>
> - Filepath: points to the filename (use dot sourcing)
> - Argumentlist: provide command line parameters
> - ExitCode: added to the end so that the output ExitCode of the operation is returned to MECM.

&nbsp;

> Passing Quotation Marks:
> To pass quotes through the ArgumentList or other parameters, use the tilda escape key with a second set of quotes: "INSTALLDIR='"C:Program Files\VividRock\ApplicationName'""

&nbsp;

```powershell
# Install Application
    Start-Process -NoNewWindow -FilePath ".\[filepath]" -Argumentlist "[parameters for installation]" -Wait
```

&nbsp;

Example (EXE)

```powershell
# Install Application
    Start-Process -NoNewWindow -FilePath ".\setup.exe" -Argumentlist "-s", "-fl.\Manufacturer_Product_Version_Install.iss", "-f2C:\ProgramData\VividRock\MECMScriptToolkit\Logging\Application\Install\Manufacturer_Product_Version_Install.log" -Wait
```

&nbsp;

Example (MSI)

> Important:
>
> Issues were found when trying to use the MSI method with dot sourcing. Removing dot sourcing in the example below worked successfully.

```powershell
# Install Application
    Start-Process -NoNewWindow -FilePath "MsiExec.exe" -Argumentlist "/i","Filename.msi","/qn","/l*v C:\ProgramData\VividRock\MECMScriptToolkit\Logging\Application\Install\Manufacturer_Product_Version_Install.log" -Wait
```

&nbsp;

## Uninstallation

The following snippets are for uninstalling applications:

| Name | Purpose | Description | Link |
| ---- | ------- | ----------- | ---- |
| Standard Uninstallation | Uninstallation | A basic PowerShell snippet for simply uninstalling an application. | [Link](###-standard-uninstallation) |
| MSI Bulk Uninstallation | Uninstallation | Use a hashtable of values to bulk remove multiple MSIs with minimal lines of code. | [Link](###-msi-bulk-uninstallation) |

&nbsp;

### Standard Uninstallation

Snippet

> Notes:
>
> - [Filepath]: points to the filename (use dot sourcing)
> -	[Argumentlist]: provide command line parameters
> - [ExitCode]: added to the end so that the output Exitcode of the operation is returned to MECM.

&nbsp;

```powershell
# Uninstall Application
    (Start-Process -NoNewWindow -FilePath ".\[Filepath]" -Argumentlist "[parameters for installation]" -Wait).ExitCode
```

&nbsp;

Example (EXE)

```powershell
# Uninstall Application
    (Start-Process -NoNewWindow -FilePath ".\setup.exe" -Argumentlist "-s", "-fl.\Manufacturer_Product_Version_Uninstall.iss", "-f2C:\ProgramData\VividRock\MECMScriptToolkit\Logging\Application\Uninstall\Manufacturer_Product_Version_Uninstall.log" -Wait).ExitCode
```

&nbsp;

Example (MSI)

>	Important:
>
>	Issues were found when trying to use the MSI method with dot sourcing. Removing dot sourcing in the example below worked successfully.

```powershell
# Uninstall Application
    (Start-Process -NoNewWindow -FilePath "msiexec.exe" -ArgumentList "/x","{VR000000-0000-0000-0000-000000000000}","/qn","/l·v
C:\ProgramData\VividRock\MECMScriptToolkit\Logging\Application\Uninstall\Manufacturer_Product_Version_Uninstall.log" -Wait).ExitCode
```

&nbsp;

### MSI Bulk Uninstallation

This should only be used when the application's primary installation manager or uninstaller will not remove all products that are installed by the application.

Snippet

> Notes:
>
> -	[ConcatenatedName]: provide the concatenated name used to uniquely name log files (Standard = Manufacturer_Product_Version)
> - [GUID/FilePath]: provides the product code GUID or points to the product MSI

&nbsp;

```powershell
# Uninstall Applications (MSI Bulk)
    # Define Variables
        $Hashtable_MSIs = @{
            "[ConcatenatedName]" = "[GUID/FilePath]"
        }

    # Uninstall Applications
        foreach ($item in $Hashtable_MSIs.GetEnumerator()) {
            (Start-Process -NoNewWindow -FilePath "MsiExec.exe" -ArgumentList "/x", "$($_.Value)", "/qn", "/l*v C:\ProgramData\VividRock\MECMScriptToolkit\Logging\Application\Uninstall\$($_.Key)_Uninstall.log" -Wait).ExitCode
        }
```

&nbsp;

## Add/Remove Programs (ARP) Entry

The following snippets are for adding or removing the Add/Remove Programs (ARP) Entry in the registry. This is especially helpful to include for applications with non-standard installers, powershell modules, etc. that do not create their own ARP entries.

> Important:
>
> The ARP data is what is inventoried by the MECM agent for reporting installed products across an organization.

### Add ARP Entry

Snippet

```powershell
# Add ARP Entry
  # Create Folder
    $Temp_Entry = New-Item -Path "[RegistryUninstallKeyPath]" -Name "[ProductName]"

  # Add Properties
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "Publisher" -Value "[Publisher]" -PropertyType "String"
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "DisplayName" -Value "[ProductName]" -PropertyType "String"
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "DisplayVersion" -Value "[Version]" -PropertyType "String"
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "DisplayIcon" -Value "[PathToICOFile]" -PropertyType "String"
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "InstallDate" -Value $(Get-Date -Format "yyyyMMdd") -PropertyType "String"
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "InstallLocation" -Value "[PathToInstallation]" -PropertyType "String"
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "UninstallString" -Value "[UninstallCommand]" -PropertyType "String"
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "EstimatedSize" -Value "[NumericalValueInKB]" -PropertyType "DWord"
```

Example

```powershell
# Add ARP Entry
  # Create Folder
    $Temp_Entry = New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" -Name "Dell Command | PowerShell Provider - 2.8.0"

  # Add Properties
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "Publisher" -Value "Dell Inc." -PropertyType "String"
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "DisplayName" -Value "Dell Command | PowerShell Provider" -PropertyType "String"
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "DisplayVersion" -Value "2.8.0" -PropertyType "String"
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "DisplayIcon" -Value "C:\Program Files\WindowsPowerShell\Modules\DellCommandPowerShellProvider\2.8.0\icon.ico" -PropertyType "String"
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "InstallDate" -Value $(Get-Date -Format "yyyyMMdd") -PropertyType "String"
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "InstallLocation" -Value "C:\Program Files\WindowsPowerShell\Modules\DellCommandPowerShellProvider\2.8.0\" -PropertyType ""
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "UninstallString" -Value "Powershell.exe -ExecutionPolicy Bypass -File `"Uninstall.ps1`"" -PropertyType "String"
    New-ItemProperty -Path $Temp_Entry.PSPath -Name "EstimatedSize" -Value "5692" -PropertyType "DWord"
```

### Remove ARP Entry

> Note:
>
> To remove an ARP entry you just need to remove the parent Registry Key that contains all of the property/value pairs.

Snippet

```powershell
# Remove ARP Entry
  # Remove Folder
    Remove-Item -Path "[RegistryKeyPath]"
```

Example

```powershell
# Remove ARP Entry
  # Remove Folder
    Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Dell Command | PowerShell Provider - 2.8.0"
```


&nbsp;

## Delay/Sleep

The following snippets are for adding delays or sleeping execution of the script.

| Name | Purpose | Description | Link |
| ---- | ------- | ----------- | ---- |
| Start Sleep | Delay/Sleep | sleeps the execution of the script for the specified number of seconds. | [Link](###-logging---start-start-snippet) |

&nbsp;

### Start Sleep

Snippet

> Notes:
>
> - [seconds]: provide an integer for how many seconds you want to sleep the execution
>
> Alternate Parameters
>  - -Milliseconds [milliseconds] - This can be used instead of seconds.

&nbsp;

```powershell
# Sleep Script Execution
    Start-Sleep -Seconds [seconds]
```

&nbsp;

Example

```powershell
# Sleep Script Execution
    Start-Sleep -Seconds 15
```

&nbsp;

## File & Folder Management

The following snippets are for managing files and folders:

| Name | Purpose | Description | Link |
| ---- | ------- | ----------- | ---- |
| Copy Files | File Management | Used to copy files to the specified destination on the device. | [Link](###-copy-files) |

&nbsp;

### Copy Files

Snippet

> Notes:
>
> - [filepath]: points to a file to copy to the destination
> - [destinationpath]: folder to copy the file to

&nbsp;

```powershell
# Copy Files
    Copy-Item -Path ".\[filepath]" -Destination "[destinationpath]" -Force
```

&nbsp;

Example

```powershell
# Copy Files
    Copy-Item -Path ".\Configuration.ini" -Destination "C:\Program Files\VividRock\" -Force
```

&nbsp;

## WMI Management

The following snippets are for managing files and folders:

| Name | Purpose | Description | Link |
| ---- | ------- | ----------- | ---- |
|  |  |  |  |

&nbsp;

> Need to add in some sections of code here for managing WMI. Possible options could be:
>
> - Run WMI Method
> - Add WMI Entry
> - Modify WMI Entry
> - Delete WMI Entry

&nbsp;

## Shortcut Management

The following snippets are for managing shortcuts:

| Name | Purpose | Description | Link |
| ---- | ------- | ----------- | ---- |
| Create Start Menu Shortcut (All Users) | Shortcut Management | Create a missing or useful shortcut on the start menu during application installation. This creates the link for All Users. | [Link](###-create-start-menu-shortcut-all-users) |
| Create Start Menu Shortcut (Current User) | Shortcut Management | Create a missing or useful shortcut on the start menu during application installation. This creates the link for the Current User. | [Link](###-create-start-menu-shortcut-current-user) |

&nbsp;

### Create Start Menu Shortcut (All Users)

Snippet

> Notes:
>
> - [PublisherName]: same as the name in MECM or Apps and Features so the user is familiar
> - [ShortcutName]: name you want the link to displayin the start menu (usually the name of the program the shortcut will launch)
> - [ShortcutTarget]: path to the target file the shortcut will execute

&nbsp;

```powershell
# Create Start Menu Shortcut for All Users
    # Define Variables
        $PublisherName = "[PublisherName]"
        $ShortcutName = "[ShortcutName]"
        $ShortcutTarget = "[ShortcutTarget]"

    # Constants (Do Not Edit)
        $StartMenuPath = $env:ProgramData + "\Microsoft\Windows\Start Menu\Programs\"

    # Create Shortcut
        New-Item -Path $StartMenuPath -Name $PublisherName -ItemType "Directory" -ErrorAction Continue
        $Object_Shell = New-Object -ComObject ("WScript.Shell")
        $Shortcut = $Object_Shell.CreateShortcut($StartMenuPath + $PublisherName + "\" + $ShortcutName + ".lnk")
        $Shortcut.TargetPath = $ShortcutTarget
        $Shortcut.Save()
```

&nbsp;

Example

```powershell
# Create Start Menu Shortcut for All Users
    # Define Variables
        $PublisherName = "VividRock"
        $ShortcutName = "MECM Script Toolkit"
        $ShortcutTarget = "C:\Program Files\VividRock\MECM Script Toolkit\Toolkit.exe"

    # Constants (Do Not Edit)
        $StartMenuPath = $env:ProgramData + "\Microsoft\Windows\Start Menu\Programs\"

    # Create Shortcut
        New-Item -Path $StartMenuPath -Name $PublisherName -ItemType "Directory" -ErrorAction Continue
        $Object_Shell = New-Object -ComObject ("WScript.Shell")
        $Shortcut = $Object_Shell.CreateShortcut($StartMenuPath + $PublisherName + "\" + $ShortcutName + ".lnk")
        $Shortcut.TargetPath = $ShortcutTarget
        $Shortcut.Save()
```

&nbsp;

### Create Start Menu Shortcut (Current User)

Snippet

> Notes:
>
> - [PublisherName]: same as the name in MECM or Apps and Features so the user is familiar
> - [ShortcutName]: name you want the link to displayin the start menu (usually the name of the program the shortcut will launch)
> - [ShortcutTarget]: path to the target file the shortcut will execute

&nbsp;

```powershell
# Create Start Menu Shortcut for Current User
    # Define Variables
        $PublisherName = "[PublisherName]"
        $ShortcutName = "[ShortcutName]"
        $ShortcutTarget = "[ShortcutTarget]"

    # Constants (Do Not Edit)
        $StartMenuPath = $env:USERPROFILE + "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\"

    # Create Shortcut
        New-Item -Path $StartMenuPath -Name $PublisherName -ItemType "Directory" -ErrorAction Continue
        $Object_Shell = New-Object -ComObject ("WScript.Shell")
        $Shortcut = $Object_Shell.CreateShortcut($StartMenuPath + $PublisherName + "\" + $ShortcutName + ".lnk")
        $Shortcut.TargetPath = $ShortcutTarget
        $Shortcut.Save()
```

&nbsp;

Example

```powershell
# Create Start Menu Shortcut for Current User
    # Define Variables
        $PublisherName = "VividRock"
        $ShortcutName = "MECM Script Toolkit"
        $ShortcutTarget = "C:\Program Files\VividRock\MECM Script Toolkit\Toolkit.exe"

    # Constants (Do Not Edit)
        $StartMenuPath = $env:USERPROFILE + "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\"

    # Create Shortcut
        New-Item -Path $StartMenuPath -Name $PublisherName -ItemType "Directory" -ErrorAction Continue
        $Object_Shell = New-Object -ComObject ("WScript.Shell")
        $Shortcut = $Object_Shell.CreateShortcut($StartMenuPath + $PublisherName + "\" + $ShortcutName + ".lnk")
        $Shortcut.TargetPath = $ShortcutTarget
        $Shortcut.Save()
```

&nbsp;

## Service Management

The following snippets are for managing services:

| Name | Purpose | Description | Link |
| ---- | ------- | ----------- | ---- |
| Stop Service | Service Management | Used to stop a specific service that is running | [Link](###-stop-a-service) |
| Start Service | Service Management | Used to start a specific service that is not running | [Link](###-start-a-service) |
| Restart Service | Service Management | Used to restart a specific service that is running | [Link](###-restart-a-service) |


&nbsp;

### Stop a Service

Snippet

> Notes:
>
> - [servicename]: provide the name of the service you want to stop

&nbsp;

```powershell
# Stop a Service
    Stop-Service -Name "[servicename]" -NoWait -Force
```

&nbsp;

Example

```powershell
# Stop a Service
    Stop-Service -Name "Spooler" -NoWait -Force
```

&nbsp;

### Start a Service

Snippet

> Notes:
>
> - [servicename]: provide the name of the service you want to start

&nbsp;

```powershell
# Start a Service
    Start-Service -Name "[servicename]"
```

&nbsp;

Example

```powershell
# Start a Service
    Start-Service -Name "Spooler"
```

&nbsp;

### Restart a Service

Snippet

> Notes:
>
> - [servicename]: provide the name of the service you want to restart

&nbsp;

```powershell
# Restart a Service
    Restart-Service -Name "[servicename]" Force
```

&nbsp;

Example

```powershell
# Restart a Service
    Restart-Service -Name "Spooler" -Force
```

&nbsp;

## Process Management

The following snippets are for managing processes:

| Name | Purpose | Description | Link |
| ---- | ------- | ----------- | ---- |
| Stop a Process | Process Management | Used to stop a specific process that is running. | [Link](###-stop-a-process) |
| Wait for Process to Start | Process Management | Used to suspend the script execution until the specified process starts. | [Link](###-wait-for-process-to-start) |
| Wait for Process to Stop | Process Management | Used to suspend the script execution until the specified process stops. | [Link](###-wait-for-process-to-stop) |

&nbsp;

### Stop a Process

Snippet

> Notes:
>
> - [processname]: provide the name of the process you want to stop.

&nbsp;

```powershell
# Stop a Process
    Stop-Process -Name "[processname]" -Force
```

&nbsp;

Example

```powershell
# Stop a Process
    Stop-Process -Name "notepad" -Force
```

&nbsp;

### Wait for a Process to Start

Snippet

> Notes:
>
> - [ProcessName]: provide the name of the process you want to monitor for.
> - [WaitInterval]: provide the number of seconds you want to wait between checks for the process (no quotes, this needs to be an integer).

&nbsp;

```powershell
# Wait for a Process to Start
    # Define Variables
        $ProcessName = "[processname]"
        $WaitInterval = [waitinterval]

    # Monitor for Process
        do {
            Write-Host "Waiting"
            Start-Sleep -Seconds $WaitInterval
        } until (
            Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
        )
```

&nbsp;

Example

```powershell
# Wait for a Process to Start
    # Define Variables
        $ProcessName = "notepad"
        $WaitInterval = 5

    # Monitor for Process
        do {
            Write-Host "Waiting"
            Start-Sleep -Seconds $WaitInterval
        } until (
            Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
        )
```

&nbsp;

## Certificate Management

The following snippets are managing certificates:

| Name | Purpose | Description | Link |
| ---- | ------- | ----------- | ---- |
| Install All Certificate Files | Certificate Management | Get all certificate files in the specified directory and install them into the specified certificate store. | [Link](###-install-all-certificate-files) |
| Install Specific Certificate Files | Certificate Management | Utilizes a hash table so you can specify each certificate to install and the desired certificate store. | [Link](###-install-specific-certificate-files) |

&nbsp;

### Install All Certificate Files

Snippet

> Notes:
>
> - [sourcepath]: the path to the folder that will be recursively searched for cert files
> - [extension]: the extension used to search and find the certificate files
> - [certificatestore]: the store to import the certificates into

&nbsp;

```powershell
# Install All Certificate Files
    # Define Variables
        $SourcePath = "[sourcepath]"
        $Extension = "[extension]"
        $CertificateStore = "[certificatestore]"

    # Install the Certificates
        $CertificateFiles = Get-ChildItem -Path ".\" -Recurse | Where-Object {$_.Extension -eq $Extension} | Select-Object FullName
        foreach ($item in $CertificateFiles) {
            $RelativePath = ($item.FullName | Resolve-Path -Relative)
            Import-Certificate -FilePath $RelativePath -CertStoreLocation "Cert:\LocalMachine\$($CertificateStore)"
        }
```

Example

```powershell
# Install All Certificate Files
    # Define Variables
        $SourcePath = ".\"
        $Extension = ".cer"
        $CertificateStore = "TrustedPublisher"

    # Install the Certificates
        $CertificateFiles = Get-ChildItem -Path ".\" -Recurse | Where-Object {$_.Extension -eq $Extension} | Select-Object FullName
        foreach ($item in $CertificateFiles) {
            $RelativePath = ($item.FullName | Resolve-Path -Relative)
            Import-Certificate -FilePath $RelativePath -CertStoreLocation "Cert:\LocalMachine\$($CertificateStore)"
        }
```

&nbsp;

### Install Specific Certificate Files

> This needs to be created. Use a hash table approach to enumerate and process each key/value pair.

&nbsp;

## Driver Management

The following snippets are for managing drivers:

| Name | Purpose | Description | Link |
| ---- | ------- | ----------- | ---- |
|  |  |  |  |

&nbsp;

> This needs to be created.

&nbsp;

## Registry Management

The following snippets are for managing registry keys:

| Name | Purpose | Description | Link |
| ---- | ------- | ----------- | ---- |
| Add Registry Key | Al |  |  |
| Add/Modify Registry Property (System) | Registry Management | Adds the property/value pair or modifies the existing property/value pair if it exists. | [Link](###-add_modify-registry-property-_system_) |
| Add/Modify Registry Property (Current User) | Registry Management | Adds the property/value pair or modifies the existing property/value pair if it exists. | [Link](###-add_modify-registry-property-_current-user_) |

&nbsp;

### Add/Modify Registry Property (System)

Snippet

> Notes:
>
> - [registrypath]: the registry path where the property/value pair be added/modified
> - [propertyname]: name of the property to add/modify
> - [propertyvalue]: value to add/modify in the property
> - [propertytype]: property type of the property/value you are adding/modifying. The possible values are: String, ExpandString, Binary, DWord, MultiString, QWord, Unknown

&nbsp;

```powershell
# Add/Modify Registry Property (System)
    # Define Variables
        $RegistryPath = "[registrypath]"
        $PropertyName = "[propertyname]"
        $PropertyValue = "[propertyvalue]"
        $PropertyType = "[propertytype]"

    # Ensure Registry Path Exists
        New-Item -Path $RegistryPath -Force

    # Add/Modify Property Value Pair
        New-ItemProperty -Path $RegistryPath -Name $PropertyName -Value $PropertyValue -PropertyType $PropertyType -Force | Out-Null
```

&nbsp;

Example

```powershell
# Add/Modify Registry Property (System)
    # Define Variables
        $RegistryPath = "HKLM:\SOFTWARE\VividRock\MECMScriptToolkit"
        $PropertyName = "CheckForUpdates"
        $PropertyValue = "0"
        $PropertyType = "String"

    # Ensure Registry Path Exists
        New-Item -Path $RegistryPath -Force

    # Add/Modify Property Value Pair
        New-ItemProperty -Path $RegistryPath -Name $PropertyName -Value $PropertyValue -PropertyType $PropertyType -Force | Out-Null
```

&nbsp;

### Add/Modify Registry Property (Current User)

This is the exact same as the code for the System snippets above. The only difference being you make sure you use "HKCU:\" in the registry path.

> Script not duplicated here for brevity and to reduce the number of copies of the code that have to be maintained.

&nbsp;

### Add/Modify All Users Profiles

Snippet

> Notes:
>
> - Add the registry changes you want to make inside the block with the header: Add Per-User Registry Changes Here
> - Ensure you use the $UserKey variable as this is set to each loaded profile

&nbsp;

```powershell
<# -----------------------------------------------------------------------------------------------------------------------------
    Add/Modify All Users Profiles
--------------------------------------------------------------------------------------------------------------------------------
    Version: 1.0

    Purpose: Used to modify the registry of every user profile on the device. Default profile optional.

    How it Works:
        1. Gets every user profile from the registry by searching for profiles that match a valid user SID (using regex) and selects the following:
            a. User SID
            b. Path to user profile NTuser.dat file
        2. Add the .DEFAULT profile to the list if enabled (used for adding the changes to new user profiles when new logins occur)
        3. Loops through each user profile that was discovered
            a. If the user NTuser.dat file is not loaded, it loads the registry hive to HKU:\[SID]
            b. Processes code that is entered in the specified block for all per-user registry changes
            c. Unloads the user profile NTuser.dat
        4. Iterates through user profiles until complete
----------------------------------------------------------------------------------------------------------------------------- #>

# Get Each User Profile SID and Path to the Profile
  $User_Profiles = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*" | Where-Object {$_.PSChildName -match "S-1-5-21-(\d+-?){4}$"} | Select-Object @{Name="SID"; Expression={$_.PSChildName}}, @{Name="Hive"; Expression={"$($_.ProfileImagePath)\NTuser.dat"}}

# Add the .DEFAULT User Profile
  [array]$User_Profiles += [pscustomobject] @{
    SID = "USERTEMPLATE"
    Hive = "C:\Users\Default\NTUSER.dat"
  }

# Loop Through Each Profile on the Machine
  foreach ($Profile in $User_Profiles) {
    # Load if Not Already Loaded
      if (($Hive_Loaded = Test-Path -Path "Registry::HKEY_USERS\$($Profile.SID)") -eq $false) {
        Start-Process -FilePath "cmd.exe" -ArgumentList "/c reg.exe load HKU\$($Profile.SID) $($Profile.Hive)" -Wait -WindowStyle Hidden
      }

    <# -----------------------------------------------------------------------------------------------------------------------------
      Add Per-User Registry Changes Here
    --------------------------------------------------------------------------------------------------------------------------------
      Use the below variable declaration to create a variable with the correct path for the currently loaded user hive in the
      array of profiles in $User_Profiles
        $UserKey = "Registry::HKEY_Users\$($Profile.SID)\"
    ----------------------------------------------------------------------------------------------------------------------------- #>
      #Region

      # Define the UserKey Variable to the Currently Loaded Profile
        $UserKey = "Registry::HKEY_Users\$($Profile.SID)"

      # Create Hashtable of Property Value Sets
        $Hash_PropertyValueSets = @{
          01 = @{
            "Name"  = "License"
            "Value" = "Subscription"
            "Path"  = "$($UserKey)\SOFTWARE\VividRock\PrecipicePS"
            "PropertyType" = "String"
          }
          02 = @{
            "Name"  = "Version"
            "Value" = "1"
            "Path"  = "$($UserKey)\SOFTWARE\VividRock\PrecipicePS"
            "PropertyType" = "Dword"
          }
        }

      # Iterate Through Property Value Sets
        foreach ($item in $Hash_PropertyValueSets.GetEnumerator()) {
          # Set Cmdlet Parameters
            $Hash_Parameters = @{
              Path  = $($item.value.Path)
              Name  = $($item.value.Name)
              Value = $($item.value.Value)
              Force = $true
              WhatIf = $false
              ErrorAction = "Continue"
            }

          # Check for Path and Create if Not Exist
            if (!(Test-Path -Path $Hash_Parameters.Path)) {
              $Registry_NewItem = New-Item -Path $Hash_Parameters.Path -Force
            }

          # Check for Property and Create or Modify Value Based on Existence
            if (!(Get-ItemProperty -Path $Hash_Parameters.Path -Name $Hash_Parameters.Name -ErrorAction SilentlyContinue)) {
              $Registry_NewItemProperty = New-ItemProperty @Hash_Parameters -PropertyType $($item.Value.PropertyType)
            }
            else {
              $Registry_SetItemProperty = Set-ItemProperty @Hash_Parameters
            }
        }

    <# -----------------------------------------------------------------------------------------------------------------------------
        #EndRegion
    ----------------------------------------------------------------------------------------------------------------------------- #>

    # Unload NTuser.dat
      if ($Hive_Loaded -eq $false) {
        # Remove the Variables that Store the Registry Operations (Resolves Access Denied Issue on Unload)
          Remove-Variable -Name 'Registry_NewItem' -Force -ErrorAction SilentlyContinue
          Remove-Variable -Name 'Registry_SetItemProperty' -Force -ErrorAction SilentlyContinue
          Remove-Variable -Name 'Registry_NewItemProperty' -Force -ErrorAction SilentlyContinue
          [gc]::Collect()
          Start-Sleep -Seconds 5

        # Unload the Hive
          Start-Process -FilePath "cmd.exe" -ArgumentList "/c reg.exe unload HKU\$($Profile.SID)" -Wait -WindowStyle Hidden | Out-Null
      }
  }
```

&nbsp;

Example

```powershell
# Example Omitted for Brevity
```

&nbsp;

## Registry Sample Modules

The following are sampel modules you can use to make changes to the registry.

| Name | Purpose | Description | Link |
| ---- | ------- | ----------- | ---- |
| File Type Association | Sample Module | Add this snippet to the Add/Modify All Users Profiles snippet so that you can iterate through each profile and change the default application that is used when opening the specific file type. | [Link](###-file-type-association) |

&nbsp;

### File Type Association

In order to set a default application for all users, including new users who login, you have to use 2 tools.

> Note:
>
> It's important to note the distinction below. While most registry edits to the .DEFAULT user profile will be enough to configure all newly created profiles, this is not the case when dealing with Default Applications. The DISM tool MUST BE USED to affect new profiles.

&nbsp;

| Tool | Description |
| ---- | ----------- |
| Registry | The registry is how you will modify all existing profiles so that they use the new Default Application associated with the file type. |
| DISM | The DISM tool is how you set the Default Application for all new profiles that are created when new users login. An XML needs to be exported from a manually configured device and then edited to include only the changes you want. Then it will be imported in to devices to configure them. This is the same process if you were to deploy the settings via GPO. |

&nbsp;

#### Registry

This snippet for the registry part of the process performs the following actions:

- Defines the $RegistryRootKey variable
- Defines the $KeyValuePairs hashtable
- Concatenates the $UserRootKey path
- Deletes the $UserRootKey if it exists
- ENumerates and iterates through the nested hashtables to create each registry entry adding the keys and property/value pairs for each nested hashtable of data

&nbsp;

Snippet

> Notes:
>
> The following are the only items you need to edit in the snippet
>
> - $RegistryRootKey - is for defining the root registry key for the file extension
> - $KeyValuePairs - a hashtable of nested hashtables. The incrementing of "01", "02", "03" etc. doesn't matter because PowerShell enumerates them in no particular order. The numbers are just to satisfy the name requirement and help to visually distinguish.
>   - Path = Path to the registry key where you want to create the related property and value
>   - Name = The name of the property in the property/value pair
>   - Value = The value of the property in the property/value pair
>   - PropertyType = The type of the property. Supported values are: String, ExpandString, Binary, DWord, MultiString, QWord, Unknown
>

&nbsp;

```powershell
# Define Variables
    $RegistryRootKey = "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.pcb"

    $KeyValuePairs = @{
        "01" = @{
            "Path" = "$($RegistryRootKey)\OpenWithProgids"
            "Name" = "PBBrowser"
            "Value" = ([byte[]]@())
            "PropertyType" = ""
        }
        "02" = @{
            "Path" = "$($RegistryRootKey)\OpenWithList"
            "Name" = "a"
            "Value" = "PCBBrowser.exe"
            "PropertyType" = "String"
        }
        "03" = @{
            "Path" = "$($RegistryRootKey)\OpenWithList"
            "Name" = "MRUList"
            "Value" = "a"
            "PropertyType" = "String"
        }
    }

# Construct the User Key Path
    $UserRootKey = "Registry::HKEY_USERS\$($UserProfile.SID)\$($RegistryRootKey)"

# Remove the Existing Registry Key
    if (Test-Path -Path $UserRootKey) {
        Remove-Item -Path $UserRootKey -Recurse -Force
    }

# Iterate Through Nested Hashtable
    foreach ($Hashtable in $KeyValuePairs.Values) {
        # Construct the User Key Path
            $UserKey = "Registry::HKEY_USERS\$($UserProfile.SID)\$($Hashtable.Path)"

        # Create Key If Not Exists
            if (!(Test-Path $UserKey)) {
                New-Item -Path $UserKey -Force | Out-Null
            }

        # Add New Registry Values
            New-ItemProperty -Path $UserKey -Name $Hashtable.Name -Value $Hashtable.Value -PropertyType $Hashtable.PropertyType -Force | Out-Null
    }
```

&nbsp;

#### DISM

Using he DISM.ex tool (available on all Windows 10 devices), you can export/import the Default Application Associations on a device. The process is pretty straightforward:

- Configure a device manually with the desired Default Application associations
- Run the below export command to output this to an XML (this outputs all associations so some cleanup is necessary)
- Delete all lines except the settings you actually want to apply
- Run the below import command on devices you want to apply the Default Application settings to

&nbsp;

Snippet (Export)

> Notes:
>
> This is only to be used once to gather your desired settings.
>
> - [filepath]: Name of the file you want to export the settings to

&nbsp;

```powershell
# Export Default Application Associations
    Dism.exe /Online /Export-DefaultAppAssociations:"[filepath].xml"
```

&nbsp;

Snippet (Import)

> Notes:
>
> Running as System is expected adn will apply to all new users. Does NOT have to be run as a user.
>
> - [filepath]: Name of the exported file you want to import

&nbsp;

```powershell
# Import Default Application Associations
    Dism.exe /Online /Import-DefaultAppAssociations:"[filepath].xml"
```

&nbsp;

&nbsp;

---

## Environment Variable Management

The following snippets are for managing environment variables:

| Name | Purpose | Description | Link |
| ---- | ------- | ----------- | ---- |
| Add/Modify Environment Variable | Environment Variable Management | Allows you to add an Environment Variable and its value to the specified scope. | [Link](###-addmodify-environment-variable) |
| Remove Environment Variable | Environment Variable Management | Allows you to remove an Environment Variable and its value from the specified scope. | [Link](###-remove-environment-variable) |

&nbsp;

### Add/Modify Environment Variable

Snippet

> Notes:
>
> - [variablename]: the name of the variable you want to add/modify
> - [variablevalue]: the value you want to store with the variable
> - [scope]: the scope that the variable will be added to (Machine, User, Process)

&nbsp;

```powershell
# Add/Modify an Environment Variable
    [System.Environment]::SetEnvironmentVariable('[variablename]','[variablevalue]','[scope]')
```

&nbsp;

Example

```powershell
# Add/Modify an Environment Variable
    [System.Environment]::SetEnvironmentVariable('LICENSE_SERVER','28000@SERVERNAME','Machine')
```

&nbsp;

### Remove Environment Variable

Snippet

> Notes:
>
> - [variablename]: the name of the variable you want to remove
> - [variablevalue]: the value you want to store with the variable
> - [scope]: the scope that the variable exists in (Machine, User, Process)

&nbsp;

```powershell
# Remove an Environment Variable
    [System.Environment]::SetEnvironmentVariable('[variablename]','','[scope]')
```

&nbsp;

Example

```powershell
# Remove an Environment Variable
    [System.Environment]::SetEnvironmentVariable('LICENSE_SERVER','','Machine')
```

&nbsp;


