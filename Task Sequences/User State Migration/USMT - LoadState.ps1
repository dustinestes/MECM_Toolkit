#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$EXEPath,                 # '%vr_USMT_ContentPath01%\amd64\loadstate.exe'
    [string]$StorePath,               # '%vr_USMT_StorePath%'
    [string]$LogPath,                 # '%vr_USMT_LogsPath%' or '%vr_Directory_TaskSequences%\USMT'
    [string[]]$MigFiles               # '%vr_USMT_ContentPath01%\amd64\MigApp.xml','%vr_USMT_ContentPath01%\amd64\MigUser.xml'
)

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - USMT - Run LoadState"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       January 19, 2024"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    This script takes input data to determine the execution parameters"
    Write-Host "                for the LoadState tool."
    Write-Host "    Links:      https://learn.microsoft.com/en-us/windows/deployment/usmt/usmt-loadstate-syntax"
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

    # Metadata

    # Names

    # Paths
        $Path_USMT_LoadStateEXE     = $EXEPath
        $Path_USMT_StateStore       = $StorePath
        $Path_USMT_Log              = $LogPath
        $Path_USMT_MigFiles         = $MigFiles

    # Files

    # Hashtables

    # Arrays

    # Registry

    # Output to Log
        Write-Host "    - Paths"
        Write-Host "        LoadState EXE: $($Path_USMT_LoadStateEXE)"
        Write-Host "        State Store: $($Path_USMT_StateStore)"
        Write-Host "        Logging: $($Path_USMT_Log)"
        Write-Host "        Mig Files: $($Path_USMT_MigFiles)"

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

    # LoadState EXE Exists
        Write-Host "    - LoadState EXE Exists"

        try {
            Write-Host "        Path: $($Path_USMT_LoadStateEXE)"
            if ((Test-Path -Path $Path_USMT_LoadStateEXE -ErrorAction Stop) -eq $true) {
                Write-Host "        Success"
            }
            else {
                Write-Host "        Failure"
                Throw
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
        }

    # State Store Path Exists
        Write-Host "    - State Store Path Exists"

        try {
            Write-Host "        Path: $($Path_USMT_StateStore)"
            if ((Test-Path -Path $Path_USMT_StateStore -ErrorAction Stop) -eq $true) {
                Write-Host "        Success"
            }
            else {
                New-Item -Path $Path_USMT_StateStore -ItemType Directory -ErrorAction Stop | Out-Null
                Write-Host "        Created"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1502 -Exit $true -Object $PSItem
        }

    # Logging Path Exists
        Write-Host "    - Logging Path Exists"

        try {
            Write-Host "        Path: $($Path_USMT_Log)"
            if ((Test-Path -Path $Path_USMT_Log -ErrorAction Stop) -eq $true) {
                Write-Host "        Success"
            }
            else {
                New-Item -Path $Path_USMT_StateStore -ItemType Directory -ErrorAction Stop | Out-Null
                Write-Host "        Created"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1503 -Exit $true -Object $PSItem
        }

    # Mig Files Exist
        Write-Host "    - Mig Files Exist"

        try {
            foreach ($Item in $Path_USMT_MigFiles) {
                Write-Host "        File: $($Item)"
                if ((Test-Path -Path $Item -ErrorAction Stop) -eq $true) {
                    Write-Host "        Success"
                }
                else {
                    Write-Host "        Failure"
                    Throw
                }
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1504 -Exit $true -Object $PSItem
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

    # Construct Installation String
        Write-Host "    - Construct Installation String"

        try {
            $Temp_Install_StateStore    = "`"$($Path_USMT_StateStore)`""
            $Temp_Install_Parameters    = "/v:5"
            $Temp_Install_Logging       = "/l:`"$($Path_USMT_Log)\loadstate.log`""
            $Temp_Install_Progress      = "/progress:`"$($Path_USMT_Log)\loadstateprogress.log`""
            $Temp_Install_InputFiles    = "/i:`"$($Path_USMT_MigFiles[0])`"","/i:`"$($Path_USMT_MigFiles[1])`""
            $Temp_Install_ArgumentList  = $Temp_Install_StateStore + " " + $Temp_Install_Parameters + " " + $Temp_Install_Logging + " " + $Temp_Install_Progress + " " + $Temp_Install_InputFiles
            Write-Host "        Command: $($Path_USMT_LoadStateEXE + `" `" + $Temp_Install_ArgumentList)"
            Write-Host "        Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
        }

    # Run USMT LoadState
        Write-Host "    - Run USMT LoadState"

        try {
            # Execute
                $Result_LoadState = Invoke-Expression -Command "$($Path_USMT_LoadStateEXE) $Temp_Install_ArgumentList"

            # Cleanup Output
                # Remove Empty Elements in Array
                    $Result_LoadState_Clean = $Result_LoadState | Where-Object -FilterScript {$_ -notin "",$null," "}

            # Evaluate Output
                if ($LASTEXITCODE -ne 0) {
                    # Output
                        Write-Host "        Error: $($LASTEXITCODE)"
                        Write-Host "        Message: $($Result_LoadState_Clean[$($Result_LoadState_Clean.Count - 3)])"
                        Exit $LASTEXITCODE
                }
                else {
                    Write-Host "        Success"
                }
        }
        catch {
            Write-vr_ErrorCode -Code 1602 -Exit $true -Object $PSItem
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
