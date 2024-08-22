#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string[]]$Extensions              # 'ms-vscode.powershell','redhat.vscode-xml'
    # [string]$Update                     # True/False
)

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - VS Code - Configure Installation"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       January 12, 2020"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    This script will configure an installation of Visual Studio Code"
    Write-Host "                with options to install Extensions and Update the client."
    Write-Host "    Links:      https://code.visualstudio.com/docs/editor/command-line"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""

#EndRegion Header
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Variables
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Variables

    Write-Host "  Variables"

    # Parameters
        $Param_Extensions   = $Extensions
        # $Param_Update       = $Update

    # Metadata

    # Names

    # Paths
        $Path_VSCode_SystemInstall      = "C:\Program Files\Microsoft VS Code\bin"
        $Path_VSCode_UserInstall        = "$($env:USERPROFILE)\AppData\Local\Programs\Microsoft VS Code\bin"

    # Files

    # Hashtables

    # Arrays

    # Output to Log
        Write-Host "    - Extensions: $($Param_Extensions)"
        # Write-Host "    - Update: $($Param_Update)"

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Variables
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Functions
#   Error Range: 1300 - 1399
#--------------------------------------------------------------------------------------------
#Region Functions

    Write-Host "  Functions"

    # Write Error Codes
        Write-Host "    - Write-vr_ErrorCode"
        function Write-vr_ErrorCode ($Code,$Exit,$Object) {
            # Code: XXXX   4-digit code to identify where in script the operation failed
            # Exit: Boolean option to define if  exits or not
            # Object: The error object created when the script encounters an error ($Error[0], $PSItem, etc.)

            begin {

            }

            process {
                Write-Host "        Error: $($Object.Exception.ErrorId)"
                Write-Host "        Command Name: $($Object.CategoryInfo.Activity)"
                Write-Host "        Message: $($Object.Exception.Message)"
                Write-Host "        Line/Position: $($Object.Exception.Line)/$($Object.Exception.Offset)"
            }

            end {
                switch ($Exit) {
                    $true {
                        Write-Host "        Exit: $($Code)"
                        Exit $Code
                    }
                    $false {
                        Write-Host "        Return"
                        Return
                    }
                    Default {
                        Write-Host "        Unknown Exit option in Write-vr_ErrorCode parameter"
                    }
                }
            }
        }

        Write-Host "        Success"

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Functions
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Environment
#   Error Range: 1400 - 1499
#--------------------------------------------------------------------------------------------
#Region Environment

    # Write-Host "  Environment"



    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Environment
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validation
#   Error Range: 1500 - 1599
#--------------------------------------------------------------------------------------------
#Region Validation

    Write-Host "  Validation"

    # VS Code Install Type
        Write-Host "    - VS Code Install Type"

        try {
            if (Test-Path -Path $Path_VSCode_SystemInstall -ErrorAction Stop) {
                Write-Host "        System"
            }
            if (Test-Path -Path $Path_VSCode_UserInstall -ErrorAction Stop) {
                Write-Host "        User"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
        }

    # Winget Installed
    # Required for Updating VS Code
        # Write-Host "    - Winget Installed"

        # try {
        #     if (Test-Path -Path $Path_Winget_SystemInstall -ErrorAction Stop) {
        #         Write-Host "        System"
        #     }
        #     else {
        #         Write-Host "        Not Installed"
        #         $Validation_WinGet_Installed = $false
        #     }
        # }
        # catch {
        #     Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
        # }


    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Validation
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1600 - 1699
#--------------------------------------------------------------------------------------------
#Region Execution

    Write-Host "  Execution"

    # Install Extensions
        Write-Host "    - Install Extensions"

        if ($Param_Extensions -in $null,"") {
            Write-Host "        Skipped: No extensions defined"
        }
        else {
            foreach ($Item in $Param_Extensions) {
                Write-Host "        $($Item.Name)"

                try {
                    Start-Process -NoNewWindow -FilePath 'code' -ArgumentList "--install-extension","$($Item)","-Force" -Wait -ErrorAction Stop
                    Write-Host "        Success"
                }
                catch {
                    Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
                }
            }
        }

    # Upgrade Application
        # Write-Host "    - Upgrade Application"

        # if ($Param_Update -in $null,"") {
        #     Write-Host "        Skipped: Update parameter undefined"
        # }
        # elseif ($Param_Update -eq "False") {
        #     Write-Host "        Disabled: Update set to False"
        # }
        # elseif ($Param_Update -eq "True") {
        #     # Install Winget
        #         Write-Host "    - Install Winget"

        #         if ($Validation_WinGet_Installed -eq $true) {
        #             Write-Host "        Skipped"
        #         }
        #         else {
        #             try {
        #                 Add-AppxPackage -RegisterByFamilyName -MainPackage "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe" -ErrorAction Stop
        #                 Write-Host "        Success"
        #             }
        #             catch {
        #                 Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
        #             }
        #         }

        #     # Upgrade VS Code
        #         try {
        #             Start-Process -NoNewWindow -FilePath 'code' -ArgumentList "--install-extension","$($Item)" -Wait -ErrorAction Stop
        #             Write-Host "        Success"
        #         }
        #         catch {
        #             Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
        #     }
        # }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Execution
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Cleanup
#   Error Range: 1800 - 1899
#--------------------------------------------------------------------------------------------
#Region Cleanup

    # Write-Host "  Cleanup"

    # # [StepName]
    #     Write-Host "    - [StepName]"

    #     try {

    #         Write-host "        Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1801 -Exit $true -Object $PSItem
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Cleanup
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Output
#   Error Range: 1900 - 1999
#--------------------------------------------------------------------------------------------
#Region Output

    # Write-Host "  Output"

    # # [StepName]
    #     Write-Host "    - [StepName]"

    #     try {

    #         Write-host "        Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1901 -Exit $true -Object $PSItem
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Output
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Footer
#--------------------------------------------------------------------------------------------
#Region Footer

    Write-Host ""
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  End of Script"
    Write-Host "------------------------------------------------------------------------------"

#EndRegion Footer
#--------------------------------------------------------------------------------------------
