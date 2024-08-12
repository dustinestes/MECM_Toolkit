#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$File,                      # 'VR_StartMenu_Standard_v1.0.xml'
    [string]$CacheDirectory             # '%VR_Directory_Cache%\StartMenu\'
)

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Write Output Header Info to SMSTS.log
#--------------------------------------------------------------------------------------------
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  Task Sequence Toolkit - Start Menu - Import Start Menu Template"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:    Dustin Estes"
    Write-Host "    Company:   VividRock"
    Write-Host "    Date:      December 23, 2019"
    Write-Host "    Copyright: VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:   This script will import the Start Menu layout template specified"
    Write-Host "               and apply it to the Default User profile."
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Set Variables
#--------------------------------------------------------------------------------------------
    Write-Host "  Set Variables"

    # Parameters
        $File_StartMenu_Template    = $File

    # Paths
        $Path_StartMenu_Cache       = $CacheDirectory
        $Path_StartMenu_Template    = $Path_StartMenu_Cache + $File_StartMenu_Template
        $Path_StartMenu_Default     = "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml"

    # Output to Log
        Write-Host "      - Start Menu Cache Path: $($Path_StartMenu_Cache)"
        Write-Host "      - Start Menu Template: $($File_StartMenu_Template)"
        Write-Host "      - Full File Path: $($Path_StartMenu_Template)"
        Write-Host "      - Defaul User Template: $($Path_StartMenu_Default)"

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validate Data
#--------------------------------------------------------------------------------------------

    Write-Host "  Validate Data"

    # Validate Cache Directory Exists
        Write-Host "      - Cache Directory Exists"

        If (Test-Path $Path_StartMenu_Cache) {
            Write-Host "          Success: Directory Exists"
        }
        Else {
            Write-Host "          Error: Directory Not Exists"
            Write-Host "          Command Name: "$Error[0].Exception.CommandName
            Write-Host "          Message: "$Error[0].Exception.Message
            Write-Host "          All: "$($Error[0].Exception | Select *)
            Exit 1201
        }

    # Validate Layout Template Exists
        Write-Host "      - Layout Template Exists"

        If (Test-Path $Path_StartMenu_Template) {
            Write-Host "          Success: Layout Template Exists"
        }
        Else {
            Write-Host "          Error: Layout Template Not Exists"
            Exit 1202
        }

    # Validate Default User Layout Template Exists
        Write-Host "      - Default User Layout Template Exists"

        If (Test-Path $Path_StartMenu_Default) {
            Write-Host "          Success: Default User Layout Template Exists"
        }
        Else {
            Write-Host "          Error: Default User Layout Template Not Exists"
            #Exit 1203
        }

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Main Execution
#--------------------------------------------------------------------------------------------

    Write-Host "  Main Execution"

    # # Import Start Menu Layout
    #     Write-Host "      - Import Start Menu Layout"

    #     try {
    #         Import-StartLayout -LayoutPath "$Path_StartMenu_Template" -MountPath "C:" # -ErrorAction Stop
    #         Write-Host "          Success: Start Menu Layout Imported"
    #     }
    #     catch {
    #         Write-Host "          Error: Failed to Import Start Menu Layout"
    #         Write-Host "          Command Name: "$Error[0].Exception.CommandName
    #         Write-Host "          Message: "$Error[0].Exception.Message
    #         Write-Host "          All: "$($Error[0].Exception | Select *)
    #         Exit 1401
    #     }

    # Import Start Menu Layout
        Write-Host "      - Import Start Menu Layout"

        try {
            Copy-Item -Path $Path_StartMenu_Template -Destination $Path_StartMenu_Default -Force -ErrorAction Stop
            Write-Host "          Success: Start Menu Layout Imported"
        }
        catch {
            Write-Host "          Error: Failed to Import Start Menu Layout"
            Write-Host "          Command Name: "$Error[0].Exception.CommandName
            Write-Host "          Message: "$Error[0].Exception.Message
            Write-Host "          All: "$($Error[0].Exception | Select *)
            Exit 1401
        }

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# End of Script
#--------------------------------------------------------------------------------------------

    Write-Host ""
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  End of Script"
    Write-Host "------------------------------------------------------------------------------"

#--------------------------------------------------------------------------------------------
