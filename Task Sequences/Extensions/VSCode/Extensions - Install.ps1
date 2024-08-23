#--------------------------------------------------------------------------------------------
# Write Output Header Info to SMSTS.log
#--------------------------------------------------------------------------------------------
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - Task Sequences - Extensions - Install"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:    Dustin Estes"
    Write-Host "    Company:   VividRock"
    Write-Host "    Date:      December 14, 2019"
    Write-Host "    Copyright: VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:   This script will install all the VS Code extensions in the folder."
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Set Variables
#--------------------------------------------------------------------------------------------
    Write-Host "  Set Variables"

    # Paths
        $Path_VSCode_CLI = "C:\Program Files\Microsoft VS Code\bin\code"

    # Extensions
        $Array_VSCode_Extensions = Get-ChildItem -Path "." -Filter "*.vsix" -Recurse

    # Output to Log
        Write-Host "      - VS Code CLI: " $Path_VSCode_CLI
        Write-Host "      - Extensions to Install"
        foreach ($Item in $Array_VSCode_Extensions) {
            Write-Host "          $($Item.Name)"
        }

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validate Data
#--------------------------------------------------------------------------------------------

    Write-Host "  Validate Data"

    # Validate VS Code Exists
        Write-Host "      - VS Code Exists: "$Path_VSCode_CLI

        If (Test-Path $Path_VSCode_CLI) {
            Write-Host "          Exists: VS Code Already Installed"
        }
        Else {
            Write-Host "          Error: VS Code Not Installed. Terminating Extension Installation"
            Exit 1001
        }

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Main Execution
#--------------------------------------------------------------------------------------------

    Write-Host "  Main Execution"

    # Iterate Through Extensions & Install
        foreach ($Item in $Array_VSCode_Extensions) {
            Write-Host "      - Installing Extension: " $Item.Name
            Write-Host "          $($Item.FullName)"
            try {
                Start-Process -FilePath $Path_VSCode_CLI -ArgumentList "--install-extension $($Item.FullName)","--force" -Wait -WindowStyle Hidden -ErrorAction Stop
                Write-Host "          Success"
            }
            catch {
                Write-Host "          Failed"
                #Exit 1002
            }
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
