#-------------------------------------------------------------------------------------------------------------
# Write Output Header Info
#-------------------------------------------------------------------------------------------------------------
# Outputs header data to host so that the SMSTS.log file will reflect the execution of this script
#-------------------------------------------------------------------------------------------------------------
#Region

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - Content Share"
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
# Create COM Objects
#-------------------------------------------------------------------------------------------------------------
#Region

    # Write-Host "  Create COM Objects"

    # # Create MECM Client COM Object
    #     Write-Host "    - MECM Client: " -NoNewline

    #     try {
    #         $Object_MECMClient = New-Object -ComObject Microsoft.SMS.Client -ErrorAction Stop
    #         Write-Host "Success" -ForegroundColor Green
    #     }
    #     catch {
    #         Write-Host "Error" -ForegroundColor Red
    #         Write-Host "          $($PSItem.Exception)"
    #         Exit 1000
    #     }

    # # Create TS Environment COM Object
    #     Write-Host "    - MECM Task Sequence Environment: " -NoNewline
    #     if (Get-Process -Name TSManager -ErrorAction SilentlyContinue) {
    #         try {
    #             $Object_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
    #             Write-Host "Success" -ForegroundColor Green
    #         }
    #         catch {
    #             Write-Host "Error: Could not create COM Object" -ForegroundColor Red
    #             Write-Host "          $($PSItem.Exception)"
    #             Exit 1000
    #         }
    #         $TSEnvironment_Exists = $true
    #     }
    #     else {
    #         Write-Host "Skipped: Not Running in Task Sequence" -ForegroundColor DarkGray
    #         $TSEnvironment_Exists = $false
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Create COM Objects
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