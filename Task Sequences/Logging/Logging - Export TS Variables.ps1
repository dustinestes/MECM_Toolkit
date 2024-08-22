#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$Filename,                  # 'VR_TaskSequence_Variables.csv'
    [string]$Destination                # '%vr_Directory_TaskSequences%'
)

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - Logging - Export TS Variables"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       December 12, 2019"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    This script will export the Task Sequence Variables and their"
    Write-Host "                values that are set at the time it is executed"
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
        $Param_Filename     = $Filename
        $Param_Destination  = $Destination

    # Metadata

    # Names

    # Paths

    # Files

    # Hashtables

    # Arrays
        $Array_VariablesToExclude   = @(
            # These Store Unusable or Human Unreadable Data So They Just Increase the Size of the Log Unecessarily
                "_SMSTSAppManClientConfigPolicy"
                "_SMSTSAuthenticator"
                "_SMSTSCIVersionInfoPolicy"
                "_SMSTSClientConfigPolicy"
                "_SMSTSClientSelfProveToken"
                "_SMSTSCloudConfigPolicy"
                "_SMSTSDPAuthToken"
                "_SMSTSInstructionStackString"
                "_SMSTSMediaPFX"
                "_SMSTSMPCerts"
                "_SMSTSNAAConfigPolicy"
                "_SMSTSPolicy_ScopeId_*"
                "_SMSTSPolicyVR[a-zA-Z_0-9][a-zA-Z_0-9][a-zA-Z_0-9][a-zA-Z_0-9][a-zA-Z_0-9]_*"
                "_SMSTSPublicRootKey"
                "_SMSTSRebootSettingsConfigPolicy"
                "_SMSTSReserved[a-zA-Z_0-9]-[a-zA-Z_0-9][a-zA-Z_0-9][a-zA-Z_0-9]"
                "_SMSTSRootCACerts"
                "_SMSTSScanToolPolicy"
                "_SMSTSSoftDistClientConfig"
                "_SMSTSSoftwareUpdatePolicy"
                "_SMSTSSWUpdateClientConfig"
                "_TSSub-VR[a-zA-Z_0-9][a-zA-Z_0-9][a-zA-Z_0-9][a-zA-Z_0-9][a-zA-Z_0-9]"
                "OSDRunPowerShellScriptSourceScript"
                "SMSTSAppPolicyEvaluationJobID__ScopeId_*"
                "SMSTSInstallApplicationJobID__ScopeId_*"

            # These Are Exported Elsewhere
                "_SMSTSTaskSequence"
        )

    # Output to Log
        Write-Host "    - Filename: $($Param_Filename)"
        Write-Host "    - Destination: $($Param_Destination)"
        Write-Host "    - Excluded Variables:"
        foreach ($Item in $Array_VariablesToExclude) {
            Write-Host "        $($Item)"
        }

    Write-Host "    - Complete"
    Write-Host ""

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

    # Create TS Environment COM Object
        Write-Host "    - Create TS Environment COM Object"

        try {
            $Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
            Write-Host "        Success"
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

    # Destination Exists
        Write-Host "    - Destination Exists"

        try {
            If (Test-Path $Param_Destination) {
                Write-Host "        Success"
            }
            Else {
                New-Item -Path $Param_Destination -ItemType Directory -ErrorAction Stop | Out-Null
                Write-Host "        Created"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
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

    # Get TS Variables
        Write-Host "    - Get TS Variables"

        try {
            $MECM_TSEnvVars = $Object_MECM_TSEnvironment.GetVariables()
            Write-Host "        Total: $($MECM_TSEnvVars.Count)"
            Write-Host "        Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
        }

    # Filter Variables
        Write-Host "    - Filter Variables"

        try {
            # Create Empty Dataset
                $Dataset_Results = @()

            # Iterate Through Variables
                foreach ($Item in $MECM_TSEnvVars) {

                    # Create the Initial Object
                        $CustomObject_Results = [PSCustomObject]@{
                            "Variable"  = $Item
                            "Value"     = "N/A"
                            "Status"    = "Included"
                            "Match"     = "N/A"
                            "MatchType" = "N/A"
                        }

                    # Iterate Through Each Excluded Variable to Compare with Variable List
                        foreach ($Item_Exclude in $Array_VariablesToExclude) {

                            if ([System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($Item_Exclude)) {
                                if ($Item -match $Item_Exclude) {
                                    $CustomObject_Results.Status    = "Excluded"
                                    $CustomObject_Results.Match     = $Item_Exclude
                                    $CustomObject_Results.MatchType = "Wildcard"
                                }
                            }
                            elseif ($Item -eq $Item_Exclude) {
                                    $CustomObject_Results.Status    = "Excluded"
                                    $CustomObject_Results.Match     = $Item_Exclude
                                    $CustomObject_Results.MatchType = "Literal"
                            }
                        }

                    # Add Custom Object to Array of Results
                        $Dataset_Results += $CustomObject_Results
                }

            # Output Counts
                Write-Host "        Included: $(($Dataset_Results | Where-Object -Property Status -eq "Included").Count)"
                Write-Host "        Excluded: $(($Dataset_Results | Where-Object -Property Status -eq "Excluded").Count)"
        }
        catch {
            Write-vr_ErrorCode -Code 1602 -Exit $true -Object $PSItem
        }

    # Get Data
        Write-Host "    - Get Data"

        try {
            foreach ($Item in ($Dataset_Results)) {
                if ($Item.Status -eq "Excluded") {
                    Write-Host "        $($Item.Variable): [$($Item.Status)]"
                }
                else {
                    ($Dataset_Results | Where-Object -Property Variable -eq $Item.Variable).Value = $Object_MECM_TSEnvironment.Value("$($Item.Variable)")

                    Write-Host "        $($Item.Variable): $($Item.Value)"
                }
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1603 -Exit $true -Object $PSItem
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

    Write-Host "  Output"

    # # [StepName]
    #     Write-Host "    - [StepName]"

    #     try {

    #         Write-host "        Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1901 -Exit $true -Object $PSItem
    #     }

    # Export to Log File
        Write-Host "    - Export to Log File"

        try {

            $Dataset_Results | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath $($Param_Destination + "/" + $Param_Filename) -Force -ErrorAction Stop
            Write-Host "        Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1901 -Exit $true -Object $PSItem
        }

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
