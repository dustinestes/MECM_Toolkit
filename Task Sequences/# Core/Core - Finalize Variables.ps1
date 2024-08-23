#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$Status            # Success, Failure
)

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Write Output Header Info to SMSTS.log
#--------------------------------------------------------------------------------------------
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - Task Sequences - Core - Finalize Variables"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:    Dustin Estes"
    Write-Host "    Company:   VividRock"
    Write-Host "    Date:      December 10, 2019"
    Write-Host "    Copyright: VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:   Creates the Finalize Task Sequence Variables necessary for using the Toolkit"
    Write-Host "    Reference: https://docs.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/log-files"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Create COM Objects
#--------------------------------------------------------------------------------------------
    Write-Host "  Create COM Objects"

    # Create TS Environment COM Object
        try {
            $Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
        }
        catch {
            Write-Host "    - Error: Could not create COM Object"
            Write-Host "          $($PSItem.Exception)"
            Exit 1000
        }

    Write-Host "    - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Set Variables
#--------------------------------------------------------------------------------------------
    Write-Host "  Set Variables"

    # Variable Table
        $HashTable_VR_Variables = @{
            "vr_ImageStatus"                = "$Status"                        # Used by the Tattoo WMI tool to write the status of the imaging process to WMI.

            "vr_Meta_DateStopObject"        = (Get-Date).ToUniversalTime()
            "vr_Meta_DateStopUTC"           = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd")
            "vr_Meta_TimeStopUTC"           = (Get-Date).ToUniversalTime().ToString("HH:mm:ss")
            "vr_Meta_TotalImageTime"        = "[Calculated in script below]"
        }

    Write-Host "    - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validate Data
#--------------------------------------------------------------------------------------------
    Write-Host "  Validate Data"

    Write-Host "    - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Transform Data
#--------------------------------------------------------------------------------------------
    Write-Host "  Transform Data"

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Create Task Sequence Variables
#--------------------------------------------------------------------------------------------
    Write-Host "  Create Task Sequence Variables"

    # Calculate Total Image Time
        try {
            $Temp_TimeSpan          = New-TimeSpan -Start $Object_MECM_TSEnvironment.Value("vr_Meta_DateStartObject") -End $HashTable_VR_Variables.vr_Meta_DateStopObject
            $Temp_TotalImageTime    = "$($Temp_TimeSpan.Days):$($Temp_TimeSpan.Hours):$($Temp_TimeSpan.Minutes):$($Temp_TimeSpan.Seconds):$($Temp_TimeSpan.Milliseconds)"
            $HashTable_VR_Variables.vr_Meta_TotalImageTime = $Temp_TotalImageTime
        }
        catch {
            Exit 1100
        }

    # Iterate Through Hash Table
        foreach ($Variable in $HashTable_VR_Variables.GetEnumerator()) {
            Write-Host "    - $($Variable.Name) = "$Variable.Value
            try {
                $Object_MECM_TSEnvironment.Value("$($Variable.Name)") = $Variable.Value
            }
            catch {
                Exit 1101
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