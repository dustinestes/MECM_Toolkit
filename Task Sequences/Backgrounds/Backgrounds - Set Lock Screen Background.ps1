#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$Filename,                  # 'Image_Success.jpg'
    [string]$Directory                  # '%vr_Directory_Backgrounds%\Imaging'
)

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  Task Sequence Toolkit - Backgrounds - Set Lock Screen Background"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       December 23, 2019"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    This script will set the background image of the lock screen"
    Write-Host "                of a device based on the status of the Task Sequence."
    Write-Host "    Links:      None"
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
        $Param_Filename         = $Filename
        $Param_Directory        = $Directory

    # Metadata

    # Names

    # Paths
        $Path_File_FilePath = $Param_Directory + "\" + $Param_Filename

    # Files

    # Hashtables

    # Arrays

    # Registry
        $Registry_01 = @{
            "Path"          = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
            "Name"          = "LockScreenImage"
            "Value"         = $Path_File_FilePath
            "PropertyType"  = "String"
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

    # Output to Log
        Write-Host "    - Parameters"
        Write-Host "        Filename: $($Param_Filename)"
        Write-Host "        Directory: $($Param_Directory)"
        foreach ($Item in (Get-Variable -Name "Registry_0*")) {
            Write-Host "    $($Item.Name)"
            Write-Host "        Path: $($Item.Value.Path)"
            Write-Host "        Name: $($Item.Value.Name)"
            Write-Host "        Value: $($Item.Value.Value)"
            Write-Host "        PropertyType: $($Item.Value.PropertyType)"
        }

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

    # # Create TSEnvironment COM Object
    #     Write-Host "    - Create TSEnvironment COM Object"

    #     try {
    #         $Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
    #         Write-host "        Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1401 -Exit $true -Object $PSItem
    #     }

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

    # Directory Exists
        Write-Host "    - Directory Exists"

        try {
            If (Test-Path -Path $Param_Directory) {
                Write-Host "        Success"
            }
            Else {
                Write-Error -Message "The path supplied in the Directory parameter does not exist on the device." -ErrorAction Stop
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
        }

    # File Exists
        Write-Host "    - File Exists"

        try {
            If (Test-Path -Path $Path_File_FilePath) {
                Write-Host "        Success"
            }
            Else {
                Write-Error -Message "The file supplied in the Filename parameter does not exist on the device at the path supplied in the Directory parameter." -ErrorAction Stop
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1502 -Exit $true -Object $PSItem
        }

    # Registry Path Exists
        Write-Host "    - Registry Path Exists"

        try {
            If (Test-Path -Path $Registry_01.Path) {
                Write-Host "        Success"
            }
            Else {
                New-Item -Path $Registry_01.Path -ErrorAction Stop | Out-Null
                Write-Host "        Created"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1503 -Exit $true -Object $PSItem
        }

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

    # Modify Registry
        foreach ($Item in (Get-Variable -Name "Registry_0*")) {
            Write-Host "      - $($Item.Name)"

            try {
                New-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -Value $Item.Value.Value -PropertyType $Item.Value.PropertyType -Force:$($Item.Value.Force) -ErrorAction $Item.Value.ErrorAction | Out-Null
                Write-Host "        Success"
            }
            catch {
                Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
            }
        }

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
