# #--------------------------------------------------------------------------------------------
# # Parameters
# #--------------------------------------------------------------------------------------------

# param (
#     [string[]]$TSVariables,               # '%_SMSTSMachineName%', '%%'
#     [string]$Destination,                 # 'R:\'
#     [string]$Source                       # 'C:\'
# )

# #--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string[]]$TSVariables = ("1101W10LAB21","ff"),
    [string]$Destination   = 'R:\',
    [string]$Source   = 'C:\'
)

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - Capture - Initialize Variables"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       January 16, 2024"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    This script initializes some variables and data for use by the"
    Write-Host "                capture process of a Task Sequence."
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

    # Metadata
        $Meta_DateTime_Start        = (Get-Date).ToUniversalTime()
        $Meta_DateTime_Timestamp    = (Get-Date).ToUniversalTime().ToString("yyyyMMdd-HHmmss")

    # Names
        $Name_Computer_Source       = $TSVariables[0]
        $Name_Capture_WIM           = $Name_Computer_Source + "_" + ($Source-replace '[^a-zA-Z]','')
        $Name_Capture_OutputFile    = $Name_Computer_Source + "_" + ($Source-replace '[^a-zA-Z]','') + ".wim"

    # Paths
        $Path_Capture_SourceDirectory       = $CaptureDir
        $Path_Capture_DesinationDirectory   = $Destination + $Name_Computer_Source + "\" + $Meta_DateTime_Timestamp + "\"

    # Files

    # Hashtables

    # Arrays

    # Registry

    # Output to Log
        Write-Host "    - Names"
        Write-Host "        Source Computer: $($Name_Computer_Source)"
        Write-Host "        WIM: $($Name_Capture_WIM)"
        Write-Host "        Output File: $($Name_Capture_OutputFile)"
        Write-Host "    - Paths"
        Write-Host "        Source Directory: $($Path_Capture_SourceDirectory)"
        Write-Host "        Destination Directory: $($Path_Capture_DesinationDirectory)"
        # Write-Host "    - Array Items"
        # foreach ($Item in $Array) {
        #     Write-Host "        $($Item)"
        # }

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

    Write-Host "  Environment"

    # Create TSEnvironment COM Object
        Write-Host "    - Create TSEnvironment COM Object"

        try {
            $Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
            Write-host "        Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1401 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Environment
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validation
#   Error Range: 1500 - 1599
#--------------------------------------------------------------------------------------------
#Region Validation

    Write-Host "  Validation"

    # Source Exists



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

    # # Enable NetJoinLegacyAccountReuse
    #     foreach ($Item in (Get-Variable -Name "Service_0*")) {
    #         Write-Host "    - $($Item.Name)"

    #         try {

    #             Write-Host "        Success"
    #         }
    #         catch {
    #             Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
    #         }
    #     }

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
