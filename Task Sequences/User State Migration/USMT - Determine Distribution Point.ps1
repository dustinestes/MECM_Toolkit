#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

# param (
#     [string]$ParamName                # [ExampleInputValues]
# )

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - Task Sequences - USMT - Determine Distribution Point"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       January 18, 2024"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    This script determines the Distribution Point a device should"
    Write-Host "                use based on the Boundary Group the client is assigned to."
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
        $Meta_MECM_ClientBoundaryGroupID    = (Get-WmiObject -Namespace "root\ccm\LocationServices" -Class "BoundaryGroupCache" -ErrorAction Stop).BoundaryGroupIDs
        $Meta_MECM_ClientBoundaryGroupCount = ($Meta_MECM_ClientBoundaryGroupID | Measure-Object).Count
    # Names

    # Paths

    # Files

    # Hashtables
        $Hashtable_MECM_DistributionPointMapping = @{
            16777218 = @{
                "Boundary Group"        = "[Name]"
                "Distribution Point"    = "[ServerFQDN]"
            }
            16777220 = @{
                "Boundary Group"        = "[Name]"
                "Distribution Point"    = "[ServerFQDN]"
            }
            16777221 = @{
                "Boundary Group"        = "[Name]"
                "Distribution Point"    = "[ServerFQDN]"
            }
        }

    # Arrays
        $Array_MECM_ResolvedDPs = @()

    # Registry

    # Output to Log
        Write-Host "    - Metadata"
        Write-Host "        Client Boundary Group ID: $($Meta_MECM_ClientBoundaryGroupID)"
        Write-Host "        Client Boundary Group Count: $($Meta_MECM_ClientBoundaryGroupCount)"
        Write-Host "    - Boundary Group ID  | Name | Distribution Point"
        foreach ($Item in $Hashtable_MECM_DistributionPointMapping.GetEnumerator()) {
            Write-Host "        $($Item.Name)  |  $($Item.Value.'Boundary Group')  |  $($Item.Value.'Distribution Point')"
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

    # Build Dataset
        Write-Host "    - Build Dataset"

        try {
            # Set Counter
                $Counter_DPs = 0

            # Build Dataset
                if ($Meta_MECM_ClientBoundaryGroupCount -gt 1) {
                    Write-Host "        Warning: Client is assigned to multiple Boundary Groups. Attempting to identify first avaialble Distribution Point."

                    do {
                        foreach ($Item in $Hashtable_MECM_DistributionPointMapping.GetEnumerator()) {
                            if ($Item.Name -in $Meta_MECM_ClientBoundaryGroupID[$Counter_DPs]) {
                                $Temp_DP_Resolved = [PSCustomObject]@{
                                    'Group ID' = $Meta_MECM_ClientBoundaryGroupID[$Counter_DPs]
                                    'Boundary Name' = $Item.Value.'Boundary Group'
                                    'Distribution Point' = $Item.Value.'Distribution Point'
                                    'Reachable' = $null
                                }

                                Write-Host "        Group ID: $($Temp_DP_Resolved.'Group ID')"
                                Write-Host "        Boundary Name: $($Temp_DP_Resolved.'Boundary Name')"
                                Write-Host "        Distribution Pont: $($Temp_DP_Resolved.'Distribution Point')"

                                $Array_MECM_ResolvedDPs += $Temp_DP_Resolved
                                $Counter_DPs += 1
                            }
                        }
                    } until (
                        $Counter_DPs -ge $Meta_MECM_ClientBoundaryGroupCount
                    )
                }
                else {
                    foreach ($Item in $Hashtable_MECM_DistributionPointMapping.GetEnumerator()) {
                        if ([string]$Item.Name -eq $Meta_MECM_ClientBoundaryGroupID) {
                            $Temp_DP_Resolved = [PSCustomObject]@{
                                'Group ID' = $Meta_MECM_ClientBoundaryGroupID
                                'Boundary Name' = $Item.Value.'Boundary Group'
                                'Distribution Point' = $Item.Value.'Distribution Point'
                                'Reachable' = $null
                            }

                            Write-Host "        Group ID: $($Temp_DP_Resolved.'Group ID')"
                            Write-Host "        Boundary Name: $($Temp_DP_Resolved.'Boundary Name')"
                            Write-Host "        Distribution Pont: $($Temp_DP_Resolved.'Distribution Point')"

                            $Array_MECM_ResolvedDPs += $Temp_DP_Resolved
                        }
                    }
                }

            # Exit if No Distribution Points are Resolved
                if (($Array_MECM_ResolvedDPs | Measure-Object).Count -le 0) {
                    Write-Host "        No Distribution Points were found that correspond to the client Boundary Group(s). Cannot continue."
                    Throw
                }
        }
        catch {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
        }

    # Distribution Point(s)
        Write-Host "    - Distribution Point(s)"

        try {
            foreach ($Item in $Array_MECM_ResolvedDPs) {
                if ($Item.'Distribution Point' -in "",$null) {
                    Write-Host "        [No Distribution Point Defined]"
                    $Item.'Reachable' = "False"
                }
                else {
                    Write-Host "        $($Item.'Distribution Point')"
                    $Item.'Reachable' = Test-Connection -ComputerName $Item.'Distribution Point' -Count 2 -Quiet -ErrorAction SilentlyContinue
                }

                Write-Host "        Reachable: $($Item.'Reachable')"
            }

            # Exit if No Distribution Points are Reachable
                if (($Array_MECM_ResolvedDPs | Where-Object -Property Reachable -eq True | Measure-Object).Count -le 0) {
                    Write-Host "        No Distribution Points are reachable. Cannot continue."
                    Throw
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1502 -Exit $true -Object $PSItem
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

    # Write-Host "  Execution"

    # # [StepName]
    #     Write-Host "    - [StepName]"

    #     try {

    #         Write-Host "        Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

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

    # Set Task Sequence Variables
        Write-Host "    - Set Task Sequence Variables"

        try {
            $Object_MECM_TSEnvironment.Value("vr_USMT_DistributionPoint") = ($Array_MECM_ResolvedDPs | Where-Object -Property Reachable -eq True | Select-Object -First 1).'Distribution Point'
            Write-Host "        Name: vr_USMT_DistributionPoint"
            Write-Host "        Value: $(($Array_MECM_ResolvedDPs | Where-Object -Property Reachable -eq True | Select-Object -First 1).'Distribution Point')"
            Write-host "        Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1901 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

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
