# MECM Toolkit - Content - Share Design Layout

This design is for the content and folder structure for all MEC content that is consumed and referenced by the MECM console and everinment.

&nbsp;

## Content Share

### Basic Prerequisites

To start, the MECM share should meet the following specifications and expectations:

- Resides on redundant, highly available storage
  - Does not reside on the Primary Site Server or any other servers in the MECM hierarchy
- Has limited Modify access to only those MECM Admins who should be editing the content
  - This will prevent accidental modifications that can break automation and deployment

### Directories

| Folder Name  | Structure                    | Description                                                                                                 |
|--------------|------------------------------|-------------------------------------------------------------------------------------------------------------|
| [share name] | \\\\[server name]\\[share name] | This should be a dedicated share created specifically for storing and referencing the content used by MECM. |
|              |                              |                                                                                                             |

&nbsp;

## Directory Structures

Within the content share, there are a number of directories that can be configured with standard structures to make it easy to store, identify, and utilize the content within them.

&nbsp;

### Primary Folders

This table provides the list of primary folders in the share as well as a brief description of them. These folders are meant to logically break the content out in the same way it is done within the MECM console to try and provide a close 1:1 relationship when viewing both and trying to find content  on the share as it pertains to where you are seeing it within the console.

| Folder Name       | Structure                                           | Description                                                                                                                                     |
|-------------------|-----------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| Applications      | \\\\[storage name]\\[share name]\\Applications      | Parent folder for storing all content related to Applications.                                                                                  |
| Backups           | \\\\[storage name]\\[share name]\\Backups           | Parent folder for storing all backup content that comes out of MECM. Such as exported: Applications, Backups, Collections, Task Sequences, etc. |
| Drivers           | \\\\[storage name]\\[share name]\\Drivers           | Parent folder for storing all content related to Drivers and Driver Packages.                                                                   |
| Operating Systems | \\\\[storage name]\\[share name]\\Operating Systems | Parent folder for storing all content related to Operating Systems and the deployment of OSes.                                                  |
| Packages          | \\\\[storage name]\\[share name]\\Packages          | Parent folder for storing all content related to Packages.                                                                                      |
| Scripts           | \\\\[storage name]\\[share name]\\Scripts           | Parent folder for storing all content related to Scripts.                                                                                       |
| Software Updates  | \\\\[storage name]\\[share name]\\Software Updates  | Parent folder for storing all content related to Software Updates.                                                                              |

&nbsp;

### Applications

This folder structure outline is meant to help isolate and ensure all files are kept in an easy to access folder for each version of an application. When an application is deocommissioned, you know you can safely remove the entire contents of the version folder without affecting other versions within your environment.

| Folder Name    | Name Source                          | Structure                                                               | Description                                                                                                                                                                                                                                         | Example                                               |
|----------------|--------------------------------------|-------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------|
| [Publisher]    | Dynamic: App Registry Uninstall Hive | ..\Applications\\[Publisher]                                            | This is a parent folder for storing all software that is created by a specific publisher.                                                                                                                                                           | Google LLC                                            |
| [Product Name] | Dynamic: App Registry Uninstall Hive | ..\Applications\\[Publisher]\\[Product Name]                            | For organizing software products into a single folder.                                                                                                                                                                                              | Google Chrome                                         |
| [Version]      | Dynamic: App Registry Uninstall Hive | ..\Applications\\[Publisher]\\[Product Name]\\[Version]                 | A product is further subdivided into the versions that are deployed within the organization in order to keep the content relevant to each version separated from other versions.                                                                    | 80.0.3987.149                                         |
| Documents      | Static                               | ..\Applications\\[Publisher]\\[Product Name]\\[Version]\\Documents      | For storing any documents related to the installation, packaging, or use of the product.                                                                                                                                                            | Google LLC - Google Chrome - Silent Install Params.md |
| Icon           | Static                               | ..\Applications\\[Publisher]\\[Product Name]\\[Version]\\Icon           | For storing the Icon associated with the product in the catalog. The file should be 512 px x 512 px and should best present the product using a familiar icon.                                                                                      | Icon.png                                              |
| Install        | Static                               | ..\Applications\\[Publisher]\\[Product Name]\\[Version]\\Install        | For storing the Install files that are associated with the product and version specifically. You should also store any customization files or installation configurations here.                                                                     | [various sets of files]                               |
| - x86/x64      | Static                               | ..\Applications\\[Publisher]\\[Product Name]\\[Version]\\Install\\xXX   | Optional: If the environment requires both types of Install architectures, you can further subdivide the folder into architectures.                                                                                                                 | x64                                                   |
| License        | Static                               | ..\Applications\\[Publisher]\\[Product Name]\\[Version]\\License        | For storing any files related to the Licensing of this specific Product and Version. Note: If the files are needed for install, place them both here as well as in the Install folder so that it's easy to find just licensing info in this folder. | License.lic                                           |
| Modify         | Static                               | ..\Applications\\[Publisher]\\[Product Name]\\[Version]\\Modify         | For storing the Modify files that are necessary when providing users the ability to modify large or complex installs on their device. Note: This is not often used but it is good to have it in place should you need it.                           | [various sets of files]                               |
| - x86/x64      | Static                               | ..\Applications\\[Publisher]\\[Product Name]\\[Version]\\Modify\\xXX    | Optional: If the environment requires both types of Modify architectures, you can further subdivide the folder into architectures.                                                                                                                  | x64                                                   |
| Uninstall      | Static                               | ..\Applications\\[Publisher]\\[Product Name]\\[Version]\\Uninstall      | For storing the Uninstall files that are associated with the product and version specifically. This allows for a smaller subset of files to be presented if you don't need to download the whole install data set just to remove a product.         | [various sets of files]                               |
| - x86/x64      | Static                               | ..\Applications\\[Publisher]\\[Product Name]\\[Version]\\Uninstall\\xXX | Optional: If the environment requires both types of Uninstall architectures, you can further subdivide the folder into architectures.                                                                                                               | x64                                                   |

&nbsp;

### Backups

The backups folder has a loose structure and is meant to just allow for a place to store exports and other backups from the MECM environment. There are a couple of standard folder recommendations that should be used.

| Folder Name    | Structure                  | Description                                                                                                                                                                                                                                                                    |
|----------------|----------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Applications   | ..\Backups\\Applications   | For storing exports of Applications. This is helpful for storing known good application configs prior to modifications or when performing console/database cleanups.                                                                                                           |
| Environment    | ..\Backups\\Environment    | For storing the actual MECM environment backup that you configure within the console. This ensures the backup is centrally and easily located and is also on redundant, high quality storage.                                                                                  |
| Task Sequences | ..\Backups\\Task Sequences | For storing exports of Task Sequences. This is helpful for keeping historical versioning without clogging up the console or causing dependency locks on old application versions that can't be deleted because they are associated with a Task Sequence still in the database. |
|                |                            |                                                                                                                                                                                                                                                                                |

&nbsp;

### Drivers

| Folder Name    | Name Source            | Structure                                                   | Description                                                                                                                                                                                                                                                                                  | Example                  |
|----------------|------------------------|-------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------|
| [Manufacturer] | Manufacturer of Driver | ..\Drivers\\[Manufacturer]                                  | This is a parent folder for storing all drivers created by a specific publisher.                                                                                                                                                                                                             | Dell Inc.                |
| [Model]        | Model of Device        | ..\Drivers\\[Manufacturer]\\[Model]                         | A folder for storing each version of the specific model's drivers. This allows for easy lifecycle management.                                                                                                                                                                                | XPS 15 7590              |
| [Version]      | Version of Drivers     | ..\Drivers\\[Manufacturer]\\[Model]\\[Version]              | A folder for storing all files related to the specified version of the drivers.                                                                                                                                                                                                              | A00-59MW4                |
| Original       | Static                 | ..\Drivers\\[Manufacturer]\\[Model]\\[Version]\\Original    | A folder for storing the original downloaded file that is usually compressed into a CAB or ZIP file.                                                                                                                                                                                         | 7590-win11-A00-59MW4.CAB |
| Extracted      | Static                 | ..\Drivers\\[Manufacturer]\\[Model]\\[Version]\\Extracted   | A folder for storing the extracted content from the original download. This is typically what you will point MECM at for Driver importing.                                                                                                                                                   | [various files]          |
| MECM Source    | Static                 | ..\Drivers\\[Manufacturer]\\[Model]\\[Version]\\MECM Source | A folder for storing the MECM Driver Package source content. When creating a driver package you will need to tell MECM where it can store the package. It makes sense to store it here so when you decommission the driver version, you can delete all content associated with that version. The content here will copy from the referenced Extracted folder and MECM will import them into this MECM Source folder for distribution. | [various files]          |

&nbsp;

### Operating Systems

| Folder Name         | Name Source         | Structure                                                                                       | Description                                                                                                                                                                                                                                                                                                                                                                                                                       | Example           |
|---------------------|---------------------|-------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------|
| [Operating System]  | Name of OS          | ..\Operating Systems\\[Operating System]                                                        | This is the parent folder for the main Operating System versions and files that will be kept within child folders.                                                                                                                                                                                                                                                                                                                | Windows 10        |
| [Build Version]     | Build Version of OS | ..\Operating Systems\\[Operating System]\\[Build Version]                                       | This is a sub-folder used to start differentiating and isolating content for each major version of the Operating System that is released.                                                                                                                                                                                                                                                                                         | 22H2              |
| [Build Sub-version] | Build Sub-version   | ..\Operating Systems\\[Operating System]\\[Build Version]\\[Build Sub-Version]                  | This is the serviced Windows builds that are downloaded from the Microsoft VLSC site. They have sub-versions to indicate the incremental servicing order.                                                                                                                                                                                                                                                                         | 22H2.3            |
| - ISO               | Static              | ..\Operating Systems\\[Operating System]\\[Build Version]\\[Build Sub-Version]\\ISO             | This folder is for storing the original ISO download of the OS. Most organizations save this file in case you need to build a demo/test box or VM and want it to be vanilla OOB for comparison or testing.                                                                                                                                                                                                                        | [filename].iso    |
| - Upgrade Package   | Static              | ..\Operating Systems\\[Operating System]\\[Build Version]\\[Build Sub-Version]\\Upgrade Package | This folder contains the entire extracted content of the ISO. This set of files is imported into MECM and used for In-place upgrades of the Windows OS. This must be the entire content for upgrades.                                                                                                                                                                                                                             | [various files]   |
| - WIM               | Static              | ..\Operating Systems\\[Operating System]\\[Build Version]\\[Build Sub-Version]\\WIM             | This folder contains just the install.wim file that you can copy from the Upgrade Package folder once the WIM is extracted. This is the file used only for new OS Deployments (not upgrades). This file is duplicated and kept here because MECM will copy and modify this file as part of its management and you don't want to use the same file in the Upgrade Package folder to prevent cross-use in MECM and corrupted files. | install.wim       |
| Features on Demand  | Static              | ..\Operating Systems\\[Operating System]\\[Build Version]\\Features on Demand                   | Features on Demand content downloaded from the Microsoft VLSC site. These files are version specific and are used to install features within Windows. For example: RSAT tools, .NET Framework, etc.                                                                                                                                                                                                                               | [various files]   |
| Group Policy        | Static              | ..\Operating Systems\\[Operating System]\\[Build Version]\\Group Policy                         | ADMX files and Group Policy Settings spreadsheet available from Microsoft for supporting the latest build of Windows.                                                                                                                                                                                                                                                                                                             | [admx/adml files] |
| Icon                | Static              | ..\Operating Systems\\[Operating System]\\[Build Version]\\Icon                                 | A simple icon that can be used on the Task Sequences when configuring this specific OS for deployment. Can be the standard OS icon or a custom, internal icon that helps users recognize what they are requesting.                                                                                                                                                                                                                | icon.png          |
| Unattend            | Static              | ..\Operating Systems\\[Operating System]\\[Build Version]\\Unattend                             | An unattend.xml file that is used for the silent deployment of the OS. This file is created using the Windows SIM tool from the Windows ADK.                                                                                                                                                                                                                                                                                      | unattend.xml      |
|                     |                     |                                                                                                 |                                                                                                                                                                                                                                                                                                                                                                                                                                   |                   |

&nbsp;

### Packages

This folder structure is usually created to match the Applications folder structure above. Most content placed here is a part of an application deployment or something similar and so content should be stored within the same style folder structure so you can easily find files with the same logic and structure.

&nbsp;

### Scripts

This folder structure is usually created to match the Applications folder structure above. Most content placed here is a part of an application deployment or something similar and so content should be stored within the same style folder structure so you can easily find files with the same logic and structure.

&nbsp;

### Software Updates

The folder structure is usually setup so that content for ADRs and other package content can be easily organized, managed, and removed.

> Note: Still need to finalize a structure for this

&nbsp;

## Visual Folder Structure Example

Assume that all folders represented below begin at the share folder. They are indented in order to indicate their parent/child relationship.

- \\\\[storage name]
  - Applications
    - [Publisher]
      - [Product Name]
        - [Version]
          - Documents
          - Icon
          - Install
            - x64
            - x86
          - License
          - Modify
            - x64
            - x86
          - Uninstall
            - x64
            - x86
  - Backups
    - Applications
    - Environment
    - Task Sequences
  - Drivers
    - [Manufacturer]
      - [Model]
        - [Version]
          - Original
          - Extracted
          - MECM Source
  - Operating Systems
    - [Operating System]
      - [Build Version]
        - [Build Sub-version]
          - ISO
          - Upgrade Package
          - WIM
        - Features on Demand
        - Group Policy
        - Icon
        - Unattend
  - Packages
    - [Same as Applications]
  - Scripts
    - [Same as Applications]
  - Software Updates
    - [TBD]

&nbsp;

## Code Snippet for Creating Folder Structure

Use the following code snippet to quickly generate the above structure at the target folder.

```powershell
#-------------------------------------------------------------------------------------------------------------
# Write Output Header Info
#-------------------------------------------------------------------------------------------------------------
# Outputs header data to host so that the SMSTS.log file will reflect the execution of this script
#-------------------------------------------------------------------------------------------------------------
#Region

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  VividRock - MECM Toolkit - Content Share"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Description:    Script for creating folder structure of a content share."
    Write-Host "    Version:        1.0"
    Write-Host "    Author:         Dustin Estes"
    Write-Host "    Created:        2017-01-18"
    Write-Host "    Owner:          VividRock LLC"
    Write-Host "    Copyright:      VividRock LLC - All Rights Reserved"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""

#EndRegion Write Output Header Info
#-------------------------------------------------------------------------------------------------------------


#-------------------------------------------------------------------------------------------------------------
# Logging
#-------------------------------------------------------------------------------------------------------------
#    Section for configuring logging output
#-------------------------------------------------------------------------------------------------------------
#Region

    $Script_Exec_Timestamp = $($(Get-Date).ToUniversalTime().ToString("yyyy-MM-dd_HHmmssZ"))
    $Log = "$env:USERPROFILE\Documents\VividRock\MECM Toolkit\ContentShare_" + $Script_Exec_Timestamp + ".log"
    Start-Transcript -Path $Log -Force

    Write-Host ""

#EndRegion Logging
#-------------------------------------------------------------------------------------------------------------


#-------------------------------------------------------------------------------------------------------------
#    Input Prompts
#-------------------------------------------------------------------------------------------------------------
#    Prompts and gathers input from the script caller
#-------------------------------------------------------------------------------------------------------------
#Region

    # Get Content Share Path
        Write-Host "  Provide the network path to the Content Share root directory"
        Write-host "    - For Example:  \\storagename\directory"
        Write-Host ""
        $Input_Path_Destination = Read-Host -Prompt "    - Path"

        # Trim Leading/Trailing Single & Double Quotes if Exist
            $Input_Path_Destination = $Input_Path_Destination.Trim("`"'")

#EndRegion Input Prompts
#-------------------------------------------------------------------------------------------------------------


#-------------------------------------------------------------------------------------------------------------
# Set Variables
#-------------------------------------------------------------------------------------------------------------
#Region

    Write-Host "  Set Variables"

    # Set Directory Hash Tables
        Write-Host "    - Primary Directory Hash Table: " -NoNewline

        $Hashtable_Directory_PrimaryDirectories = @(
            "\Applications"
            "\Backups"
            "\Drivers"
            "\Operating Systems"
            "\Packages"
            "\Scripts"
            "\Software Updates"
        )

        Write-Host "Success" -ForegroundColor Green

        Write-Host "    - Sub-Directory Hash Table: " -NoNewline

        $Hashtable_Directory_SubDirectories = @(
            "\Applications\[Publisher]"
            "\Applications\[Publisher]\[Product Name]"
            "\Applications\[Publisher]\[Product Name]\[Version]"
            "\Applications\[Publisher]\[Product Name]\[Version]\Documents"
            "\Applications\[Publisher]\[Product Name]\[Version]\Icon"
            "\Applications\[Publisher]\[Product Name]\[Version]\Install"
            "\Applications\[Publisher]\[Product Name]\[Version]\Install\x64"
            "\Applications\[Publisher]\[Product Name]\[Version]\Install\x86"
            "\Applications\[Publisher]\[Product Name]\[Version]\License"
            "\Applications\[Publisher]\[Product Name]\[Version]\Modify"
            "\Applications\[Publisher]\[Product Name]\[Version]\Modify\x64"
            "\Applications\[Publisher]\[Product Name]\[Version]\Modify\x86"
            "\Applications\[Publisher]\[Product Name]\[Version]\Uninstall"
            "\Applications\[Publisher]\[Product Name]\[Version]\Uninstall\x64"
            "\Applications\[Publisher]\[Product Name]\[Version]\Uninstall\x86"

            "\Backups\Applications"
            "\Backups\Environment"
            "\Backups\Task Sequences"

            "\Drivers\[Manufacturer]"
            "\Drivers\[Manufacturer]\[Model]"
            "\Drivers\[Manufacturer]\[Model]\[Version]"
            "\Drivers\[Manufacturer]\[Model]\[Version]\Original"
            "\Drivers\[Manufacturer]\[Model]\[Version]\Extracted"
            "\Drivers\[Manufacturer]\[Model]\[Version]\MECM Source"

            "\Operating Systems\[Operating System]"
            "\Operating Systems\[Operating System]\[Build Version]"
            "\Operating Systems\[Operating System]\[Build Version]\[Build Sub-Version]"
            "\Operating Systems\[Operating System]\[Build Version]\[Build Sub-Version]\ISO"
            "\Operating Systems\[Operating System]\[Build Version]\[Build Sub-Version]\Upgrade Package"
            "\Operating Systems\[Operating System]\[Build Version]\[Build Sub-Version]\WIM"
            "\Operating Systems\[Operating System]\[Build Version]\Features on Demand"
            "\Operating Systems\[Operating System]\[Build Version]\Group Policy"
            "\Operating Systems\[Operating System]\[Build Version]\Icon"
            "\Operating Systems\[Operating System]\[Build Version]\Unattend"

            "\Operating Systems\Windows PE"
            "\Operating Systems\Windows PE\[Build Version]"
            "\Operating Systems\Windows PE\[Build Version]\ISO"

            "\Packages\[Publisher]"
            "\Packages\[Publisher]\[Product Name]"
            "\Packages\[Publisher]\[Product Name]\[Version]"

            "\Scripts\[Publisher]"
            "\Scripts\[Publisher]\[Product Name]"
            "\Scripts\[Publisher]\[Product Name]\[Version]"
        )

        Write-Host "Success" -ForegroundColor Green

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Set Variables
#-------------------------------------------------------------------------------------------------------------


#-------------------------------------------------------------------------------------------------------------
# Create Folder Structure
#-------------------------------------------------------------------------------------------------------------
#Region

    Write-Host "  Create Folder Structure"

    # Set Create Parent Directories
        Write-Host "    - Create Parent Directories"

        try {
            foreach ($Directory in $Hashtable_Directory_PrimaryDirectories) {
                $Concat_DirToCreate = $Input_Path_Destination + $Directory
                Write-Host "        $($Concat_DirToCreate): " -NoNewline
                try {
                    if (Test-Path -Path $Concat_DirToCreate) {
                        Write-Host "Already Exists" -ForegroundColor DarkGray
                    }
                    else {
                        New-Item -Path $Concat_DirToCreate -ItemType Directory -Force -ErrorAction Stop | Out-Null
                        Write-Host "Success" -ForegroundColor Green
                    }
                }
                catch {
                    Write-Host "Error" -ForegroundColor Red
                    Write-Host "          $($PSItem.Exception)"
                    Exit 1
                }
            }
        }
        catch {
            Write-Host "Error" -ForegroundColor Red
            Write-Host "          $($PSItem.Exception)"
            Exit 1
        }

    # Set Create Sub-Directories
        Write-Host ""
        Write-Host "    - Create Sub-Directories"

        try {
            foreach ($SubDirectory in $Hashtable_Directory_SubDirectories) {
                $Concat_DirToCreate = $Input_Path_Destination + $SubDirectory
                Write-Host "        $($Concat_DirToCreate): " -NoNewline
                try {
                    if (Test-Path -Path $Concat_DirToCreate) {
                        Write-Host "Already Exists" -ForegroundColor DarkGray
                    }
                    else {
                        New-Item -Path $Concat_DirToCreate -ItemType Directory -Force -ErrorAction Stop | Out-Null
                        Write-Host "Success" -ForegroundColor Green
                    }
                }
                catch {
                    Write-Host "Error" -ForegroundColor Red
                    Write-Host "          $($PSItem.Exception)"
                    Exit 1
                }
            }
        }
        catch {
            Write-Host "Error" -ForegroundColor Red
            Write-Host "          $($PSItem.Exception)"
            Exit 1
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Create Folder Structure
#-------------------------------------------------------------------------------------------------------------


#-------------------------------------------------------------------------------------------------------------
# Write Output Footer Info
#-------------------------------------------------------------------------------------------------------------
# Outputs footer data to host so that the SMSTS.log file will reflect the execution of this script
#-------------------------------------------------------------------------------------------------------------
#Region

    Write-Host "  Finalize Script Execution"

    # Stop Transcript Logging
        Write-Host "    - Stop Transcript Logging"
        Write-Host "        " -NoNewline
        Stop-Transcript

    # Write Closing Footer
        Write-Host "------------------------------------------------------------------------------"
        Write-Host "  End Script"
        Write-Host "------------------------------------------------------------------------------"
        Write-Host ""

#EndREgion Write Output Footer Info
#-------------------------------------------------------------------------------------------------------------
```

&nbsp;
