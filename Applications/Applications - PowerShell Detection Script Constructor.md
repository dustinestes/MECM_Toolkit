# MECM Toolkit - Applications - PowerShell Detection Script Builder

## About

The detection logic you create with these snippets works by processing the detection script in a linear direction from top to bottom. Each detection module will process it's code and determine if the detection value is true or false. These work together to set an overall detection value which is evalauted by the detection wrappers.

At the end of the script, the overall detection is evaluated and the script either outputs a boolean true or false depending on the results of all detection modules.

## Table of Contents

- [MECM Toolkit - Applications - PowerShell Detection Script Builder](#mecm-toolkit---applications---powershell-detection-script-builder)
  - [About](#about)
  - [Table of Contents](#table-of-contents)
- [Detection Wrappers](#detection-wrappers)
  - [Primary](#primary)
- [Detection Modules](#detection-modules)
  - [Applications](#applications)
    - [Application - Win32 (Registry)](#application---win32-registry)
    - [Application - Win32 (WMI)](#application---win32-wmi)
    - [Application - MSIX (WMI)](#application---msix-wmi)
  - [Files \& Folders](#files--folders)
    - [File \& Folder (Existential)](#file--folder-existential)
    - [File \& Folder (Content)](#file--folder-content)
  - [Registry](#registry)
    - [Property/Value Pair](#propertyvalue-pair)
  - [Shortcuts](#shortcuts)
    - [Shortcut (Existential)](#shortcut-existential)
    - [Shortcut (Configuration)](#shortcut-configuration)
  - [Hashes](#hashes)
    - [Checksum](#checksum)
  - [Services](#services)
    - [Service (Existential)](#service-existential)
    - [Service (Configuration)](#service-configuration)
    - [Service (State)](#service-state)
  - [Processes](#processes)
    - [Process (Existential)](#process-existential)
  - [Certificates](#certificates)
    - [Certificate (Existential)](#certificate-existential)
  - [Drivers](#drivers)
    - [Driver (Existential)](#driver-existential)
  - [Environment Variables](#environment-variables)
    - [Environment Variable (Existential \& Value)](#environment-variable-existential--value)
- [Appendix](#appendix)
  - [Frequently Asked Questions (FAQ)](#frequently-asked-questions-faq)
    - [How do I use multiple instances of the same detection module?](#how-do-i-use-multiple-instances-of-the-same-detection-module)
  - [Detection Method Template](#detection-method-template)

&nbsp;

# Detection Wrappers

Detection wrappers are used as the basis for building any Application detection script. Functionality of the wrappers can be expanded by adding any of the Detection Modules into them.

These wrappers provide some basic functionality such as:

- Logging
- Data Gathering
- Detection Tracking
- Metadata Output

## Primary

This is the main detection wrapper that is used for most Application detections within MECM.

Features:

- Logging
- Results Tracking
- Metadata

Snippet:

```powershell
#--------------------------------------------------------------------------------------------
# Logging
#--------------------------------------------------------------------------------------------
#Region Logging

$Path_Logging_File  = $($env:vr_Directory_Logs + "\Applications\Detection\VividRock_DetectionScriptBuilder_1.0.log")
$Params_Logging     = @{ FilePath = $Path_Logging_File; Append = $true }
Out-File -InputObject "" -FilePath $Path_Logging_File

#EndRegion Logging
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Out-File -InputObject "------------------------------------------------------------------------------" @Params_Logging
    Out-File -InputObject "  VividRock - MECM Toolkit - Applications - Detection Logic" @Params_Logging
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

# Detection Modules

The detection modules are meant to be used within the detection wrappers. You should add each module after the section labeled "Detection Modules" and before the section labeled "Detection Results".

## Applications

### Application - Win32 (Registry)

The following snippet is for detecting an Application installation using the registry installation paths.

> Notes:
>
> - App_Win32Reg_Publisher -the value that is stored in the Publisher registry property
> - App_Win32Reg_DisplayName -the value that is stored in the DisplayName registry property
> - App_Win32Reg_DisplayVersion -the value that is stored in the DisplayVersion registry property

Snippet:

```powershell
    # -------------------------------------------------------
    # Application - Win32 (Registry)
    # -------------------------------------------------------
    #Region Application - Win32 (Registry)

    Write-Host "    - Application - Win32 (Registry)"

    # Initialize Detection Values
        $Detection_App_Win32Reg_01  = $false
        $Temp_Count_Matches         = 0

    # Variables
        Write-Host "        Variables"

        $App_Win32Reg_Publisher         = "Inkscape"
        $App_Win32Reg_DisplayName       = "Inkscape"
        $App_Win32Reg_DisplayVersion    = "1.2.2"

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
            Write-Host "            $(($Item.Name) -replace 'App_Win32Reg_',''): $($Item.Value)"
        }

    # Detection
        Write-Host "        Detection"

        if ($App_Win32Reg_VersionDataType -eq "String") {
            switch ($Dataset_App_Win32Reg_Applications) {
                {($_.GetValue("Publisher") -like $App_Win32Reg_Publisher) -and ($_.GetValue("DisplayName") -like $App_Win32Reg_DisplayName) -and ($_.GetValue("DisplayVersion") -eq $App_Win32Reg_DisplayVersion)} {
                    Write-Host "            Exact Match: $($_.GetValue("Publisher")) - $($_.GetValue("DisplayName")) - $($_.GetValue("DisplayVersion")) ($($_.Name))"
                    $Temp_Count_Matches += 1
                }
                Default {}
            }
        }
        elseif ($App_Win32Reg_VersionDataType -eq "Integer") {
            switch ($Dataset_App_Win32Reg_Applications) {
                {($_.GetValue("Publisher") -like $App_Win32Reg_Publisher) -and ($_.GetValue("DisplayName") -like $App_Win32Reg_DisplayName) -and ([System.Version]$_.GetValue("DisplayVersion") -eq [System.Version]$App_Win32Reg_DisplayVersion)} {
                    Write-Host "            Exact Match: $($_.GetValue("Publisher")) - $($_.GetValue("DisplayName")) - $($_.GetValue("DisplayVersion")) ($($_.Name))"
                    $Temp_Count_Matches += 1
                }
                {($_.GetValue("Publisher") -like $App_Win32Reg_Publisher) -and ($_.GetValue("DisplayName") -like $App_Win32Reg_DisplayName) -and ([System.Version]$_.GetValue("DisplayVersion") -gt [System.Version]$App_Win32Reg_DisplayVersion)} {
                    Write-Host "            Newer Version: $($_.GetValue("Publisher")) - $($_.GetValue("DisplayName")) - $($_.GetValue("DisplayVersion")) ($($_.Name))"
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
```

&nbsp;

### Application - Win32 (WMI)

The following snippet is for detecting MSI Application installations using WMI Classes.

Classes

- [Win32_InstalledWin32Program](https://learn.microsoft.com/en-us/windows/win32/wmisdk/win32-installedwin32program)

> Notes:
>
> Requires administrative rights to query the class
>
> Required Variables to edit
> - App_Win32WMI_Vendor - the value that is stored in the Vendor WMI property
> - App_Win32WMI_Name - the value that is stored in the Name WMI property
> - App_Win32WMI_Version - the value that is stored in the Version WMI property

Snippet:

```powershell
    # -------------------------------------------------------
    # Application - Win32 (WMI)
    # -------------------------------------------------------
    #Region Application - Win32 (WMI)

        Write-Host "    - Application - Win32 (WMI)"

        # Initialize Detection Values
            $Detection_App_Win32WMI_01  = $false
            $Temp_Count_Matches         = 0

        # Variables
            Write-Host "        Variables"

            $App_Win32WMI_Vendor      = "Inkscape"
            $App_Win32WMI_Name        = "Inkscape"
            $App_Win32WMI_Version     = "1.2.2"

            $Dataset_App_Win32WMI_Products = Get-CimInstance -ClassName Win32_InstalledWin32Program -ErrorAction Stop

            foreach ($Item in (Get-Variable -Name "App_Win32WMI_*")) {
                Write-Host "            $(($Item.Name) -replace 'App_Win32WMI_',''): $($Item.Value)"
            }

        # Detection
            Write-Host "        Detection"

            switch ($Dataset_App_Win32WMI_Products) {
                # Match Vendor Name and Exact Version
                {($_.Vendor -eq $App_Win32WMI_Vendor) -and ($_.Name -eq $App_Win32WMI_Name) -and ($_.Version -eq $App_Win32WMI_Version)} {
                    Write-Host "            Exact Match: $($_.Vendor) - $($_.Name) - $($_.Version)"
                    $Temp_Count_Matches += 1
                }
                # Match Vendor Name and Newer Version
                {($_.Vendor -eq $App_Win32WMI_Vendor) -and ($_.Name -eq $App_Win32WMI_Name) -and ([System.Version]$_.Version -gt [System.Version]$App_Win32WMI_Version)} {
                    Write-Host "            Newer Version: $($_.Vendor) - $($_.Name) - $($_.Version)"
                    $Temp_Count_Matches += 1
                }
                Default {  }
            }

            if ($Temp_Count_Matches -eq 0) {
                Write-Host "          Failure: No match found"
            }

        # Evalaution
            if ($Temp_Count_Matches -gt 0) {
                $Detection_App_Win32WMI_01 = $true
            }
            else {
                $Detection_App_Win32WMI_01 = $false
            }

    #EndRegion Application - Win32 (WMI)
    # -------------------------------------------------------
```

&nbsp;

### Application - MSIX (WMI)

The following snippet is for detecting an Application installation using WMI Classes.

Classes

- [Win32_InstalledStoreProgram](https://learn.microsoft.com/en-us/windows/win32/wmisdk/win32-installedstoreprogram)

> Notes:
>
> Requires administrative rights to query the class
>
> Required Variables to edit
> - App_MSIXWMI_Vendor - the value that is stored in the Vendor WMI property
> - App_MSIXWMI_Name - the value that is stored in the Name WMI property
> - App_MSIXWMI_Version - the value that is stored in the Version WMI property

Snippet:

```powershell
    # -------------------------------------------------------
    # Application - MSIX (WMI)
    # -------------------------------------------------------
    #Region Application - MSIX (WMI)

    Write-Host "    - Application - MSIX (WMI)"

    # Initialize Detection Values
        $Detection_App_MSIXWMI_01   = $false
        $Temp_Count_Matches         = 0

    # Variables
        Write-Host "        Variables"

        $App_MSIXWMI_Vendor      = "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US"
        $App_MSIXWMI_Name        = "Microsoft.MicrosoftEdge.Stable"
        $App_MSIXWMI_Version     = "127.0.2651.74"

        $Dataset_App_MSIXWMI_Products = Get-CimInstance -ClassName Win32_InstalledStoreProgram -ErrorAction Stop

        foreach ($Item in (Get-Variable -Name "App_MSIXWMI_*")) {
            Write-Host "            $(($Item.Name) -replace 'App_MSIXWMI_',''): $($Item.Value)"
        }

    # Detection
        Write-Host "        Detection"

        switch ($Dataset_App_MSIXWMI_Products) {
            # Match Vendor Name and Exact Version
            {($_.Vendor -eq $App_MSIXWMI_Vendor) -and ($_.Name -eq $App_MSIXWMI_Name) -and ($_.Version -eq $App_MSIXWMI_Version)} {
                Write-Host "            Exact match: $($_.Vendor) - $($_.Name) - $($_.Version)"
                $Temp_Count_Matches += 1
            }
            # Match Vendor Name and Newer Version
            {($_.Vendor -eq $App_MSIXWMI_Vendor) -and ($_.Name -eq $App_MSIXWMI_Name) -and ([System.Version]$_.Version -gt [System.Version]$App_MSIXWMI_Version)} {
                Write-Host "            Newer Version: $($_.Vendor) - $($_.Name) - $($_.Version)"
                $Temp_Count_Matches += 1
            }
            Default {  }
        }

        if ($Temp_Count_Matches -eq 0) {
            Write-Host "          Failure: No match found"
        }

    # Evalaution
        if ($Temp_Count_Matches -gt 0) {
            $Detection_App_MSIXWMI_01 = $true
        }
        else {
            $Detection_App_MSIXWMI_01 = $false
        }

    #EndRegion Application - MSIX (WMI)
    # -------------------------------------------------------
```

&nbsp;

## Files & Folders

### File & Folder (Existential)

The following snippet is for detecting an array list of files and folders on the device.

> Required Variables
> - FilesFolders_Paths - array of folder and file paths to detect

Snippet:

```powershell
    # -------------------------------------------------------
    # Files & Folders: Existential
    # -------------------------------------------------------
    #Region Files & Folders: Existential

        Write-Host "    - Files & Folders: Existential"

        # Initialize Detection Values
            $Detection_FilesFolders_Exist_01  = $false
            $Temp_Count_Failures        = 0

        # Variables
            Write-Host "        Variables"

            $FilesFolders_Exist_Paths = @(
                "C:\Program Files\VividRock\Detection Script Builder\1.0\Filename.log",
                "C:\Program Files\VividRock\Detection Script Builder\1.0\Filename.json"
            )

            foreach ($Item in (Get-Variable -Name "FilesFolders_Exist_*")) {
                Write-Host "            $(($Item.Name) -replace 'FilesFolders_Exist_',''): $($Item.Value)"
            }

        # Detection
            Write-Host "        Detection"
            switch ($FilesFolders_Exist_Paths) {
                {Test-Path -Path $_} {
                    Write-Host "            Path Found: $($_)"
                }
                Default {
                    Write-Host "            Path Not Found: $($_)"
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
```

&nbsp;

### File & Folder (Content)

The following snippet is for validating the content of a file.

> Required Variables
> - FilesFolders_Content_FilePath - path to the file you want to analyze the content of
> - FilesFolders_Content_Expression - PowerShell expression used to get and analyze the content to determine a true/false result

Snippet:

```powershell
    # -------------------------------------------------------
    # Files & Folders: Content
    # -------------------------------------------------------
    #Region Files & Folders: Content

        Write-Host "    - Files & Folders: Content"

        # Initialize Detection Values
            $Detection_FilesFolders_Content_01 = $false
            $Temp_Count_Failures = 0

        # Variables
            Write-Host "        Variables"

            $FilesFolders_Content_FilePath = "C:\Program Files\VividRock\Detection Script Builder\1.0\Filename.log"
            $FilesFolders_Content_Expression = "[System.Version]((Get-Content -Path `"$($FilesFolders_Content_FilePath)`") -split `"=`")[1] -ge [System.Version]`"1.23.111`""

            foreach ($Item in (Get-Variable -Name "FilesFolders_Content_*")) {
                Write-Host "            $(($Item.Name) -replace 'FilesFolders_Content_',''): $($Item.Value)"
            }

        # Detection
            Write-Host "        Detection"

            if (Test-Path -Path $FilesFolders_Content_FilePath) {
                # Get Content
                    $Temp_Result_Expression = Invoke-Expression -Command $FilesFolders_Content_Expression
                    if ($Temp_Result_Expression -eq $true) {
                        Write-Host "            Result: Success"
                    }
                    else {
                        Write-Host "            Result: Failure"
                        $Temp_Count_Failures += 1
                    }
            }
            else {
                Write-Host "            Failure: File Not Exists"
            }

        # Evaluation
            if ($Temp_Count_Failures -gt 0) {
                $Detection_FilesFolders_Content_01 = $false
            }
            else {
                $Detection_FilesFolders_Content_01 = $true
            }

    #EndRegion Files & Folders: Content
    # -------------------------------------------------------
```

&nbsp;

## Registry

### Property/Value Pair

The following snippet is for detecting a single registry property/value pair to make sure the expected value is present. These can be stacked to create multiple checks if needed.

> Required Variables
> - Reg_PropertyValue_Key - the key (path) to the property/value pair
> - Reg_PropertyValue_PropertyName - the name of the property
> - Reg_PropertyValue_PropertyValue - the desired value of the property

Snippet:

```powershell
    # -------------------------------------------------------
    # Registry: Property/Value Pair
    # -------------------------------------------------------
    #Region Registry: Property/Value Pair

    Write-Host "    - Registry: Property/Value Pair"

    # Initialize Detection Values
        $Detection_Reg_PropertyValue_01  = $false
        $Temp_Count_Failures        = 0

    # Variables
        Write-Host "        Variables"

        $Reg_PropertyValue_Key           = "HKLM:\SOFTWARE\VividRock\Detection Script Builder\1.0"
        $Reg_PropertyValue_PropertyName  = "Install Location"
        $Reg_PropertyValue_PropertyValue = "C:\Program Files\VividRock\Detection Script Builder\1.0"

        foreach ($Item in (Get-Variable -Name "Reg_PropertyValue_*")) {
            Write-Host "            $(($Item.Name) -replace 'Reg_PropertyValue_',''): $($Item.Value)"
        }

    # Detection
        Write-Host "        Detection"

        if (Test-Path -Path $Reg_PropertyValue_Key) {
            $Temp_Reg_PropertyValue_ExistingProperty = (Get-ItemProperty -Path $Reg_PropertyValue_Key -Name $Reg_PropertyValue_PropertyName -ErrorAction SilentlyContinue).$Reg_PropertyValue_PropertyName
            if ($Temp_Reg_PropertyValue_ExistingProperty -eq $Reg_PropertyValue_PropertyValue) {
                Write-Host "            Match Found"
                Write-Host "                Existing Value: $($Temp_Reg_PropertyValue_ExistingProperty)"
                Write-Host "                Desired Value: $($Reg_PropertyValue_PropertyValue)"
            }
            else {
                Write-Host "            Failure: Property Values Do Not Match"
                Write-Host "                Existing Value: $($Temp_Reg_PropertyValue_ExistingProperty)"
                Write-Host "                Desired Value: $($Reg_PropertyValue_PropertyValue)"
                $Temp_Count_Failures += 1
            }
        }
        else {
            Write-Host "            Failure: Registry Key Not Exists"
            $Temp_Count_Failures += 1
        }

    # Evaluation
        if ($Temp_Count_Failures -gt 0) {
            $Detection_Reg_PropertyValue_01 = $false
        }
        else {
            $Detection_Reg_PropertyValue_01 = $true
        }

        #EndRegion Registry: Property/Value Pair
    # -------------------------------------------------------
```

&nbsp;

## Shortcuts

### Shortcut (Existential)

Shortcuts are files and, therefore, can be discovered using the same scripted logic found in the Files and Folders detection method.

> Note: Section left intentionally blank. See referenced detection module.

&nbsp;

### Shortcut (Configuration)

This detection method will validate the desired configuration of the shortcut to ensure its actual config matches the desired one.

| GUI Name              | Object Name           | DataType      | Example                       | Description                           |
|-----------------------|-----------------------|---------------|-------------------------------|---------------------------------------|
| None                  | FullPath              | String        | C:\ProgramData\Microsoft\Windows\Start Menu\Programs\VividRock\example.lnk| Path to the link file to analyze |
| Target                | TargetPath            | String        | C:\VividRock\example.exe      | Path to target exe/file to run        |
| [None]                | Arguments             | String        | -help                         | Series of arguments to pass to target |
| Start in              | WorkingDirectory      | String        | C:\VividRock\                 | Path to working directory for process |
| Shortcut key          | Hotkey                | String        | F3                            | Hotkey to activate shortcut           |
| Run                   | WindowStyle           | Int32         | 1                             | Defines window style (argument notes) |
| Comment               | Description           | String        | Run the example application   | Short description of shortcut         |

> Argument Notes
>
> WindowStyle Allowed Values
> - 1 = Normal Window
> - 7 = Minimized
> - 3 = Maximized

Snippet:

```powershell
    # -------------------------------------------------------
    # Shortcut: Configuration
    # -------------------------------------------------------
    #Region Shortcut: Configuration

    Write-Host "    - Shortcut: Configuration"

    # Initialize Detection Values
        $Detection_Shortcut_Config_01   = $false
        $Temp_Count_Failures            = 0

    # Variables
        Write-Host "        Variables"

        $Shortcut_Config_FullName           = "C:\Users\[UserName]\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\VividRock\VividRock.lnk"
        $Shortcut_Config_TargetPath         = "C:\Program Files\VividRock\bin\VividRock.exe"
        $Shortcut_Config_Arguments          = ""
        $Shortcut_Config_WorkingDirectory   = "C:\Program Files\VividRock\bin\"
        $Shortcut_Config_HotKey             = ""
        $Shortcut_Config_WindowStyle        = "1"
        $Shortcut_Config_Description        = ""

        foreach ($Item in (Get-Variable -Name "Shortcut_Config_*")) {
            Write-Host "            $(($Item.Name) -replace 'Shortcut_Config_',''): $($Item.Value)"
        }

    # Detection
        Write-Host "        Detection"

        $Temp_WScriptShell_Object   = New-Object -ComObject WScript.Shell
        $Temp_Config_SourceObject   = $Temp_WScriptShell_Object.CreateShortcut($Shortcut_Config_FullName)

        foreach ($Item in (Get-Variable -Name "Shortcut_Config_*")) {
            $Temp_Config_Name = $(($Item.Name) -replace 'Shortcut_Config_','')

            if ($Temp_Config_SourceObject.$($Temp_Config_Name) -eq $Item.Value) {
                Write-Host "            $($Temp_Config_Name): Value Match"
            }
            else {
                Write-Host "            $($Temp_Config_Name): Value Mismatch"
                Write-Host "                Desired: $($Item.Value)"
                Write-Host "                Actual: $($Temp_Config_SourceObject.$($Temp_Config_Name))"
                $Temp_Count_Failures += 1
            }
        }

    # Evaluation
        if ($Temp_Count_Failures -gt 0) {
            $Detection_Shortcut_Config_01 = $false
        }
        else {
            $Detection_Shortcut_Config_01 = $true
        }

        #EndRegion Shortcut: Configuration
    # -------------------------------------------------------
```

&nbsp;

## Hashes

### Checksum

The following snippet is for comparing SHA256 hashes to make sure the values match.

> Required Variables
> - VariableName - Description

Snippet:

```powershell
    # -------------------------------------------------------
    # Hashes: Checksum
    # -------------------------------------------------------
    #Region Hashes: Checksum

    Write-Host "    - Hashes: Checksum"

    # Initialize Detection Value
        $Detection_Hashes_Checksum_01   = $false
        $Temp_Count_Failures            = 0

    # Variables
        Write-Host "        Variables"

        $Hashes_Checksum_Algorithm = "SHA256"

        $Dataset_Hashes_Checksum_FileChecksumPairs = @{
            "C:\Program Files\VividRock\Detection Script Builder\1.0\Filename.json"     = "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855"
            "C:\Program Files\VividRock\Detection Script Builder\1.0\Filename.yamls"     = "3B836FDBFD810B487A7EADEBF231215AC5BDBEB32D887FA6696C29C180BF0DAF"
        }

        foreach ($Item in (Get-Variable -Name "Hashes_Checksum_*")) {
            Write-Host "            $(($Item.Name) -replace 'Hashes_Checksum_',''): $($Item.Value)"
        }
        foreach ($Item in $Dataset_Hashes_Checksum_FileChecksumPairs.GetEnumerator()) {
            Write-Host "            $($Item.Key)  =  $($Item.Value)"
        }

    # Detection
        Write-Host "        Detection"

        foreach ($Item in $Dataset_Hashes_Checksum_FileChecksumPairs.GetEnumerator()) {
            if (Test-Path -Path $Item.Key) {
                $Temp_Hash_Actual = (Get-FileHash -Path $Item.Key -Algorithm $Hashes_Checksum_Algorithm).Hash

                # Compare to Expected Hash Value
                    if ($Item.Value -eq $Temp_Hash_Actual) {
                        Write-Host "            $($Item.Key | Split-Path -Leaf): Hash Match"
                    }
                    else {
                        # Set OverallDetection to False if Doesn't Match
                        Write-Host "            $($Item.Key | Split-Path -Leaf): Hash Mismatch"
                        Write-Host "                Desired: $($Item.Value)"
                        Write-Host "                Actual:  $($Temp_Hash_Actual)"
                            $Temp_Count_Failures += 1
                    }
            }
            else {
                Write-Host "            $($Item.Key | Split-Path -Leaf): File Not Found"
                # Set OverallDetection to False Since File is Not Present
                    $Temp_Count_Failures += 1
            }
        }

        # Evaluation
            if ($Temp_Count_Failures -gt 0) {
                $Detection_Hashes_Checksum_01 = $false
            }
            else {
                $Detection_Hashes_Checksum_01 = $true
            }

    #EndRegion Hashes: Checksum
    # -------------------------------------------------------
```

&nbsp;

## Services

### Service (Existential)

Determine the existence of the specified service(s).

> Required Variables
> - VariableName - Description

Snippet:

```powershell
    # To Do
```

&nbsp;

### Service (Configuration)

Evaluate the configuration of the specified service.

> Required Variables
> - VariableName - Description

Snippet:

```powershell
    # To Do
```

&nbsp;

### Service (State)

Evaluate the current state of the specified service.

> Required Variables
> - VariableName - Description

Snippet:

```powershell
    # To Do
```

&nbsp;

## Processes

### Process (Existential)

Determine the existence of the specified process(es).

> Required Variables
> - VariableName - Description

&nbsp;

Snippet:

```powershell
    # To Do
```

&nbsp;

## Certificates

### Certificate (Existential)

Determine the existence of the specified certificate(s).

> Required Variables
> - VariableName - Description

Snippet:

```powershell
    # To Do
```

&nbsp;

## Drivers

### Driver (Existential)

Determine the existence of the specified driver(s).

> Required Variables
> - VariableName - Description

Snippet:

```powershell
    # To Do
```

&nbsp;

## Environment Variables

### Environment Variable (Existential & Value)

The below snippet allows you to perform detection logic on both the existence of an environment variable as well as its expected value.

> Required Variables
> - VariableName - Description

Snippet:

```powershell
    # -------------------------------------------------------
    # Environment Variables
    # -------------------------------------------------------
    #Region Environment Variables

        Write-Host "    - Environment Variables"

        # Initialize Detection Value
            $Detection_EnvironmentVariables_01      = $false
            $Count_EnvironmentVariables_Failures    = 0

        # Variables
            Write-Host "        Variables"

            # Existential: To check for existence only, provide the environment variable name as the key and leave the value field as an empty string
            # Value Match: To check for existence and that the environment variable's value matches, provide both the key and value
            $Hash_EnvironmentVariables = @{
                "SystemDrive" = "C:"
                #"JAVA_HOME" = ""
                "COLORTERM" = ""
            }

            foreach ($Item in $Hash_EnvironmentVariables.GetEnumerator()) {
                Write-Host "            $($Item.Key)  =  $($Item.Value)"
            }

            $Dataset_EnvironmentVariables = [System.Environment]::GetEnvironmentVariables()

        # Detection
            Write-Host "        Detection"

            # Existential Check
                foreach ($Item in $Hash_EnvironmentVariables.GetEnumerator()) {
                    if ($Item.Value -in "",$null) {
                        if ($Dataset_EnvironmentVariables.Keys -contains $Item.Name) {
                            Write-Host "            $($Item.Name): Exists"
                        }
                        else {
                            Write-Host "            $($Item.Name): Not Exists"
                            $Count_EnvironmentVariables_Failures += 1
                        }
                    }
                    if ($Item.Value -notin "",$null) {
                        if ($Item.Value -eq $Dataset_EnvironmentVariables.$($Item.Name)) {
                            Write-Host "            $($Item.Name): Value Match"
                        }
                        else {
                            Write-Host "            $($Item.Name): Value Mismatch"
                            $Count_EnvironmentVariables_Failures += 1
                        }
                    }
                }

        # Evaluation
            if ($Count_EnvironmentVariables_Failures -gt 0) {
                $Detection_EnvironmentVariables_01 = $false
            }
            else {
                $Detection_EnvironmentVariables_01 = $true
            }

    #EndRegion Environment Variables
    # -------------------------------------------------------
```

&nbsp;

# Appendix

## Frequently Asked Questions (FAQ)

### How do I use multiple instances of the same detection module?



## Detection Method Template

The following template can be used to build new and custom detection methods to be used within the wrappers.

```powershell
    # -------------------------------------------------------
    # [Template]
    # -------------------------------------------------------
    #Region [Template]

    Write-Host "    - [Template]"

    # Initialize Detection Values
        $Detection_Template_01  = $false
        $Temp_Count_Failures        = 0

    # Variables
        Write-Host "        Variables"

        $Template_Variable = "Value"

        foreach ($Item in (Get-Variable -Name "Template_*")) {
            Write-Host "            $(($Item.Name) -replace 'Template_',''): $($Item.Value)"
        }

    # Detection
        Write-Host "        Detection"

    # Evaluation
        if ($Temp_Count_Failures -gt 0) {
            $Detection_Template_01 = $false
        }
        else {
            $Detection_Template_01 = $true
        }

        #EndRegion [Template]
    # -------------------------------------------------------
```