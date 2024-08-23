#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$ComputerName,                      # '%OSDComputerName%'
    [string]$TargetOU                           # '%OSDJoinDomainOUName%'
)

#--------------------------------------------------------------------------------------------
# Start-Transcript -Path "C:\VividRock\MECM Toolkit\Logs\Active Directory\Move Object to Target OU.log"  -Append -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - Active Directory - Move Object to Target OU (.NET)"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       [Date]"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    Checks the current OU of a device and moves it to the target OU"
    Write-Host "                if it is not there already."
    Write-Host "    Links:      None"
    Write-Host "    Template:   1.0"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""

<#
    Requirements:
        - None
    To Do:
        - Item
        - Item
#>

#EndRegion Header
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Variables
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Variables

    Write-Host "  Variables"

    # Parameters
        $Param_ComputerName     = $ComputerName
        $Param_TargetOU         = $TargetOU

    # Metadata
        $Meta_Script_Start_DateTime     = Get-Date
        $Meta_Script_Complete_DateTime  = $null
        $Meta_Script_Complete_TimeSpan  = $null
        $Meta_Script_Result = $false,"Failure"

    # Names

    # Paths

    # Files

    # Hashtables

    # Arrays

    # Registry

    # WMI

    # Datasets

    # Filters
        $Filter_ADSI_Computer       = "sAMAccountName=$($Param_ComputerName)$"
        $Filter_ADSI_OU             = "(&(ObjectClass=OrganizationalUnit)(distinguishedname=$($Param_TargetOU -replace "LDAP://",`"`")))"

    # Temporary

    # Output to Log
        Write-Host "    - Parameters"
        foreach ($Item in (Get-Variable -Name "Param_*")) {
            Write-Host "        $(($Item.Name) -replace 'Param_',''): $($Item.Value)"
        }
        Write-Host "    - Expressions"
        foreach ($Item in (Get-Variable -Name "Expression_*")) {
            Write-Host "        $(($Item.Name) -replace 'Expression_',''): $($Item.Value)"
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
                        Write-Host "        Continue Processing..."
                    }
                    Default {
                        Write-Host "        Unknown Exit option in Write-vr_ErrorCode parameter"
                    }
                }
            }
        }

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

    # # Create TSEnvironment COM Object
    #     Write-Host "    - Create TSEnvironment COM Object"

    #     try {
    #         $Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
    #         Write-Host "        Status: Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1401 -Exit $true -Object $PSItem
    #     }

    # Create ADSISearcher Object
        Write-Host "    - Create ADSISearcher Object"

        try {
            $Object_ADSI_Searcher = New-Object -TypeName System.DirectoryServices.DirectorySearcher
            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1402 -Exit $true -Object $PSItem
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

    # Computer Object
        Write-Host "    - Computer Object"

        try {
            $Object_ADSI_Searcher.Filter = $Filter_ADSI_Computer

            if ($Object_ADSI_Searcher.FindOne()) {
                Write-Host "        Status: Exists"
            }
            else {
                Write-Host "        Status: Not Found"
                Throw "Computer object not found in AD"
            }

            $Object_ADSI_Searcher.Dispose()
        }
        catch {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
        }

    # Organizational Unit
        Write-Host "    - Organizational Unit"

        try {
            $Object_ADSI_Searcher.Filter = $Filter_ADSI_OU

            if ($Object_ADSI_Searcher.FindOne()) {
                Write-Host "        Status: Exists"
            }
            else {
                Write-Host "        Status: Not Found"
                Throw "OU object not found in AD"
            }

            $Object_ADSI_Searcher.Dispose()
        }
        catch {
            Write-vr_ErrorCode -Code 1502 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Validation
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Data Gather
#   Error Range: 1600 - 1699
#--------------------------------------------------------------------------------------------
#Region Data Gather

    Write-Host "  Data Gather"

    # AD Computer Object
        Write-Host "    - AD Computer Object"

        try {
            $Object_ADSI_Searcher.Filter = $Filter_ADSI_Computer
            $Object_AD_Computer     = $Object_ADSI_Searcher.FindOne()
            Write-Host "        Name: $($Object_AD_Computer.Properties.dnshostname)"
            Write-Host "        Current OU: $($Object_AD_Computer.Properties.distinguishedname.replace("CN=$($Param_ComputerName),","LDAP://"))"
            Write-Host "        Operating System: $($Object_AD_Computer.Properties.operatingsystem)"
            Write-Host "        Created: $($Object_AD_Computer.Properties.whencreated)"
            Write-Host "        Modified: $($Object_AD_Computer.Properties.whenchanged)"
            Write-Host "        Last Logon: $([datetime]::FromFileTimeUTC($Object_AD_Computer.Properties.lastlogontimestamp[0]))"
        }
        catch {
            Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Data Gather
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1700 - 1799
#--------------------------------------------------------------------------------------------
#Region Execution

    Write-Host "  Execution"

    # Move to Correct OU
        Write-Host "    - Move to Correct OU"

        try {
            if (($Object_AD_Computer.Properties.distinguishedname.replace("CN=$($Param_ComputerName),","LDAP://")) -eq $Param_TargetOU) {
                Write-Host "        Current OU: $($Object_AD_Computer.Properties.distinguishedname.replace("CN=$($Param_ComputerName),","LDAP://"))"
                Write-Host "        Target OU:  $($Param_TargetOU)"
                Write-Host "        Status: Already in correct OU"
            }
            else {
                # Move Object
                    $Object_ADSI_Computer     = [ADSI]"$($Object_AD_Computer.Path)"
                    $Result_Move = $Object_ADSI_Computer.psbase.MoveTo([ADSI]"$($Param_TargetOU)")

                # Output
                    Write-Host "        Status: Object Moved"


                # $Counter_Move_Attempts  = 0

                # do {
                #     # Increment Counter
                #         $Counter_Move_Attempts ++

                #     # Output Data
                #         Write-Host "        Attempt: $($Counter_Move_Attempts)"
                #         Write-Host "            Current OU: LDAP://$(($Object_ADSI_Computer.distinguishedName -split '(?=OU=)',2)[-1])"
                #         Write-Host "            Target OU:  $($Param_TargetOU)"

                #     # Move Object
                #         $Object_ADSI_Computer     = [ADSI]"$($Object_AD_Computer.Path)"
                #         $Result_Move = $Object_ADSI_Computer.psbase.MoveTo([ADSI]"$($Param_TargetOU)")

                #     # Sleep
                #         Start-Sleep -Seconds 20

                #     # Validate
                #         $Object_ADSI_Computer     = [ADSI]"$($Param_TargetOU.Replace(`"LDAP://`",`"LDAP://CN=$($Param_ComputerName),`"))"

                # } until (
                #     (($Object_ADSI_Computer.distinguishedName.replace("CN=$($Param_ComputerName),","LDAP://")) -eq $Param_TargetOU) -or ($Counter_Move_Attempts -ge 5)
                # )

                # # Output Status
                #     if (($Object_ADSI_Computer.distinguishedName.replace("CN=$($Param_ComputerName),","LDAP://")) -eq $Param_TargetOU) {
                #         Write-Host "        Status: Success"
                #     }
                #     else {
                #         Throw "Computer object was not successfully moved"
                #     }
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
        }

    # Determine Script Result
        $Meta_Script_Result = $true,"Success"

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Execution
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Output
#   Error Range: 1800 - 1899
#--------------------------------------------------------------------------------------------
#Region Output

    # Write-Host "  Output"

    # # [StepName]
    #     Write-Host "    - [StepName]"

    #     try {

    #         Write-Host "        Status: Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1801 -Exit $true -Object $PSItem
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Output
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Cleanup
#   Error Range: 1900 - 1999
#--------------------------------------------------------------------------------------------
#Region Cleanup

    # Write-Host "  Cleanup"

    # # Confirm Cleanup
    #     Write-Host "    - Confirm Cleanup"

    #     do {
    #         $Temp_Cleanup_UserInput = Read-Host -Prompt "        Do you want to automatically clean up the unecessary content from this script? [Y]es or [N]o" -ErrorAction Stop
    #     } until (
    #         $Temp_Cleanup_UserInput -in "Y","Yes","N","No"
    #     )

    # # [StepName]
    #     Write-Host "    - [StepName]"

    #     try {
    #         if ($Temp_Cleanup_UserInput -in "Y", "Yes") {

    #             Write-Host "        Status: Success"
    #         }
    #         else {
    #             Write-Host "            Status: Skipped"
    #         }
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1901 -Exit $true -Object $PSItem
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Cleanup
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Footer
#--------------------------------------------------------------------------------------------
#Region Footer

    # Gather Data
        $Meta_Script_Complete_DateTime  = Get-Date
        $Meta_Script_Complete_TimeSpan  = New-TimeSpan -Start $Meta_Script_Start_DateTime -End $Meta_Script_Complete_DateTime

    # Output
        Write-Host ""
        Write-Host "------------------------------------------------------------------------------"
        Write-Host "  Script Result: $($Meta_Script_Result[0])"
        Write-Host "  Script Started: $($Meta_Script_Start_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
        Write-Host "  Script Completed: $($Meta_Script_Complete_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
        Write-Host "  Total Time: $($Meta_Script_Complete_TimeSpan.Days) days, $($Meta_Script_Complete_TimeSpan.Hours) hours, $($Meta_Script_Complete_TimeSpan.Minutes) minutes, $($Meta_Script_Complete_TimeSpan.Seconds) seconds, $($Meta_Script_Complete_TimeSpan.Milliseconds) milliseconds"
        Write-Host "------------------------------------------------------------------------------"
        Write-Host "  End of Script"
        Write-Host "------------------------------------------------------------------------------"

#EndRegion Footer
#--------------------------------------------------------------------------------------------

Return $Meta_Script_Result[1]
# Stop-Transcript