#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$SourceName,                        # 'DEV - Windows - Install - 1.0.0'
    [string]$DestinationVersion,                # '1.0.1'
    [string]$DestinationName,                   # 'DEV - Windows - Install - 1.0.1'
    [string]$DestinationFolder,                 # 'Windows - 1.0.1'
    [string]$DestinationParentFolder,           # 'TaskSequence\1 - Development'
    [string]$SiteCode,                          # 'ABC'
    [string]$SMSProvider                        # '[ServerFQDN]'
)

#--------------------------------------------------------------------------------------------
Start-Transcript -Path "C:\VividRock\MECM Toolkit\Logs\Task Sequences\Copy TS and All Sub TSes.log" -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  VividRock - MECM Toolkit - Task Sequences - Copy TS and All Sub TSes"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       April 16, 2024"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    This script will copy the specified Task Sequence and all Sub"
    Write-Host "                Task Sequences associated with it with an unlimited depth. This"
    Write-Host "                allows you to easily increment the version of a Task Sequence"
    Write-Host "                and its dependents."
    Write-Host "    Links:      None"
    Write-Host "    Template:   1.0"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""

<#
    To Do:
        - Build Out Rename Function with Pattern Usage
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
        $Param_SiteCode                     = $SiteCode
        $Param_SMSProvider                  = $SMSProvider
        $Param_Source_Name                  = $SourceName
        $Param_Destination_Version          = $DestinationVersion
        # $Param_Destination_Name             = $DestinationName
        $Param_Destination_Folder           = $DestinationFolder
        $Param_Destination_ParentFolder     = $DestinationParentFolder

    # Metadata
        $Meta_Script_Start_DateTime         = Get-Date
        $Meta_Script_Complete_DateTime      = $null
        $Meta_Script_Complete_TimeSpan      = $null
        $Meta_Script_Result                 = $false,"Failure"

    # Constants
        # $Constant_TaskSequence_Name_MaxLength   = 50

    # Names

    # Paths
        $Path_Destination_FullPath          = $Param_Destination_ParentFolder + "\" + $Param_Destination_Folder

    # Files

    # Hashtables

    # Arrays

    # Registry

    # WMI

    # Datasets

    # Temporary

    # Output to Log
        Write-Host "    - Parameters"
        foreach ($Item in (Get-Variable -Name "Param_*")) {
            Write-Host "        $(($Item.Name) -replace 'Param_',''): $($Item.Value)"
        }
        Write-Host "    - Constants"
        foreach ($Item in (Get-Variable -Name "Constant_*")) {
            Write-Host "        $(($Item.Name) -replace 'Constant_',''): $($Item.Value)"
        }
        Write-Host "    - Paths"
        foreach ($Item in (Get-Variable -Name "Path_*")) {
            Write-Host "        $(($Item.Name) -replace 'Path_',''): $($Item.Value)"
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
                        Stop-Transcript
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

    # Get Task Sequence Children Using Recursion
        Write-Host "    - Get-vr_MECMTaskSequenceChildren"
        function Get-vr_MECMTaskSequenceChildren {

            [CmdletBinding()]
            Param(
                [Parameter(Mandatory=$true)]
                [string]$TsName
            )

            begin {

            }

            process {
                try {
                    $Temp_TS_Steps = Get-CMTSStepRunTaskSequence -TaskSequenceName $TsName -ErrorAction Stop | Select-Object -Property @{name="Parent"; expression={$($TsName)}},TsName,@{name="TsNameClean"; expression={($_.TsName -replace "$($_.TsPackageID),","").Trim()}},TsPackageID,@{name="New_TsParent"; expression={""}},@{name="New_TsName"; expression={""}},@{name="New_TsPackageID"; expression={""}},@{name="Status"; expression={"Unprocessed"}}
                    
                    foreach ($Item in $Temp_TS_Steps) {
                        if (Get-CMTSStepRunTaskSequence -TaskSequenceId $Item.TsPackageID -ErrorAction Stop) {
                           # Recursive Items Found
                                $Temp_TS_Steps += Get-vr_MECMTaskSequenceChildren -TsName $(($Item.TsName -replace "$($Item.TsPackageID),","").Trim()) -ErrorAction Stop
                        }
                        else {
                            # No Recursive Items Found, Do Nothing
                        }
                        $Item."Status" = "Processed"
                    }
                }
                catch {
                    Write-Host "        Error Reading Task Sequence Object: $($Item.TsPackageID) - $($Item.TsName)"
                    $Item."Status" = "Error"
                    $Temp_TS_Steps | Format-Table -AutoSize
                    Write-vr_ErrorCode -Code 1301 -Exit $true -Object $PSItem
                }
            }

            end {
                Return $Temp_TS_Steps
            }

        }

    # Copy, Rename, and Move a Task Sequence
        Write-Host "    - Copy-vr_MECMTaskSequence"
        function Copy-vr_MECMTaskSequence {

            [CmdletBinding()]
            Param(
                [Parameter(Mandatory=$true)]
                [string]$TsName,
                [Parameter(Mandatory=$true)]
                [string]$Destination
            )

            begin {

            }

            process {
                # Copy Task Sequence
                    try {
                        Write-Host "            Copy Task Sequence"

                        $Temp_TS_New_Object = Copy-CMTaskSequence -Name $TsName -ErrorAction Stop
                        Write-Host "                New Name: $($Temp_TS_New_Object.Name)"
                        Write-Host "                Status: Success"
                    }
                    catch {
                        Write-vr_ErrorCode -Code 1302 -Exit $true -Object $PSItem
                    }

                # Move Task Sequence
                    try {
                        Write-Host "            Move New Task Sequence"

                        Write-Host "                New Path: $($Destination)"
                        Move-CMObject -InputObject $Temp_TS_New_Object -FolderPath $Destination -ErrorAction Stop
                        Write-Host "                Status: Success"
                    }
                    catch {
                        Write-vr_ErrorCode -Code 1304 -Exit $true -Object $PSItem
                    }

                # # Rename Task Sequence
                #     try {
                #         Write-Host "    - Rename New Task Sequence"

                #         Write-Host "        Old Name: $($Temp_TS_New_Object.Name)"
                #         # $Temp_TS_New_Object | Set-CMTaskSequence -NewName $Param_Destination_Name -ErrorAction Stop
                #         # $Temp_TS_New_Object = Get-CMTaskSequence -Name $Param_Destination_Name -Fast -ErrorAction Stop
                #         Write-Host "        New Name: $($Temp_TS_New_Object.Name)"
                #         Write-Host "        Status: Success"
                #     }
                #     catch {
                #         Write-vr_ErrorCode -Code 1303 -Exit $true -Object $PSItem
                #     }
            }

            end {
                # Return: Status (Success/Failure), NewName, NewLocation
                    Return $Temp_TS_New_Object
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

    # Connect to MECM Infrastructure
        Write-Host "    - Connect to MECM Infrastructure"

        try {
            if (Test-Connection -ComputerName $Param_SMSProvider -Count 2 -Quiet) {
                # Import the PowerShell Module
                    Write-Host "        Import the PowerShell Module"

                    if((Get-Module ConfigurationManager -ErrorAction Stop) -in $null,"") {
                        Import-Module -Name "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" -ErrorAction Stop
                        Write-Host "            Status: Success"
                    }
                    else {
                        Write-Host "            Status: Already Imported"
                    }

                # Create the Site Drive
                    Write-Host "        Create the Site Drive"

                    Remove-PSDrive -Name $Param_SiteCode -PSProvider CMSite -ErrorAction Ignore

                    if((Get-PSDrive -Name $Param_SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -in $null,"") {
                        New-PSDrive -Name $Param_SiteCode -PSProvider CMSite -Root $Param_SMSProvider -ErrorAction Stop | Out-Null
                        Write-Host "            Status: Success"
                    }
                    else {
                        Write-Host "            Status: Already Exists"
                    }

                # Set the Location
                    Write-Host "        Set the Location"

                    if ((Get-Location -ErrorAction Stop).Path -ne "$($Param_SiteCode):\") {
                        Set-Location "$($Param_SiteCode):\" -ErrorAction Stop
                        Write-Host "            Status: Success"
                    }
                    else {
                        Write-Host "            Status: Already Set"
                    }
            }
            else {
                Write-Host "        Status: MECM Server Unreachable"
                Throw "Status: MECM Server Unreachable"
            }
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

    # Source Task Sequence Exists
        Write-Host "    - Source Task Sequence Exists"

        try {
            Write-Host "        Name: $($Param_Source_Name)"
            if (Get-CMTaskSequence -Name $Param_Source_Name -Fast -ErrorAction Stop) {
                Write-Host "            Status: Exists"
            }
            else {
                Write-Host "            Status: Not Exists"
                Throw "Not Exists: A Task Sequence with the specified name could not be found."
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
        }

    # # Destination Task Sequence Not Exists
    #     Write-Host "    - Destination Task Sequence Not Exists"

    #     try {
    #         Write-Host "        Name: $($Param_Destination_Name)"
    #         if (Get-CMTaskSequence -Name $Param_Destination_Name -Fast -ErrorAction Stop) {
    #             Write-Host "            Status: Exists"
    #             Throw "Exists: A Task Sequence with the specified name already exists."
                
    #         }
    #         else {
    #             Write-Host "            Status: Not Exists"
    #         }
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1502 -Exit $true -Object $PSItem
    #     }

    # Destination Parent Folder Exists
        Write-Host "    - Destination Parent Folder Exists"

        try {
            Write-Host "        Path: $($Param_Destination_ParentFolder)"

            if (Get-CMFolder -FolderPath $Param_Destination_ParentFolder -ErrorAction Stop) {
                Write-Host "            Status: Exists"
            }
            else {
                Write-Host "            Status: Not Exists"
                Throw "Not Exists: A Folder with the specified name could not be found."
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1503 -Exit $true -Object $PSItem
        }

    # Destination Folder Exists
        Write-Host "    - Destination Folder Exists"

        try {
            Write-Host "        Path: $($Path_Destination_FullPath)"

            if (Get-CMFolder -FolderPath $Path_Destination_FullPath -ErrorAction Stop) {
                Write-Host "            Status: Exists"
            }
            else {
                New-CMFolder -ParentFolderPath $Param_Destination_ParentFolder -Name $Param_Destination_Folder -ErrorAction Stop | Out-Null
                Write-Host "            Status: Created"
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
# Data Gather
#   Error Range: 1600 - 1699
#--------------------------------------------------------------------------------------------
#Region Data Gather

    Write-Host "  Data Gather"

    # Get Task Sequence Children
        Write-Host "    - Get Task Sequence Children"

        try {
            $Dataset_TS_Children = Get-vr_MECMTaskSequenceChildren -TsName $Param_Source_Name -ErrorAction SilentlyContinue
            Write-Host "        Status: Success"

            $Dataset_TS_Children | Format-Table -ErrorAction Stop
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

    # Copy Source Task Sequence
        Write-Host "    - Source Task Sequence"
    
        try {
            Write-Host "        Name: $($Param_Source_Name)"
            $Temp_TS_New_Parent = Copy-vr_MECMTaskSequence -TsName $Param_Source_Name -Destination $Path_Destination_FullPath
            Write-Host "            Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
        }


    # Copy Child Task Sequences
        Write-Host "    - Child Task Sequences"

        foreach ($Item in $Dataset_TS_Children) {
            try {
                # Copy Object
                    Write-Host "        Name: $($Item.TsNameClean)"
                    $Temp_TS_New_Object = Copy-vr_MECMTaskSequence -TsName $Item.TsNameClean -Destination $Path_Destination_FullPath
                    Write-Host "            Status: Success"

                # Update Dataset with New Values
                    if ($Item.Parent -eq $Param_Source_Name) {
                        $Item.New_TsParent = $Temp_TS_New_Parent.Name
                    }
                    else {
                        $Item.New_TsParent = ($Dataset_TS_Children | Where-Object -FilterScript { $_.TsNameClean -eq $Item.Parent }).New_TsName
                    }
                    
                    $Item.New_TsName = $Temp_TS_New_Object.Name
                    $Item.New_TsPackageID = $Temp_TS_New_Object.PackageID
            }
            catch {
                Write-vr_ErrorCode -Code 1702 -Exit $true -Object $PSItem
            }
        }

    # Replace Step References
        Write-Host "    - Replace Step References"

        foreach ($Item in $Dataset_TS_Children) {
            try {
                Write-Host "        Name: $($Item.New_TsName)"
                $Temp_TS_Step_ToReplace = Get-CMTaskSequenceStepRunTaskSequence -TaskSequenceName $Item.New_TsParent | Where-Object -FilterScript { $_.TsPackageID -eq $Item.TsPackageID }
                Write-Host "            Parent: $($Item.New_TsParent)"
                Write-Host "            Step Name: $($Temp_TS_Step_ToReplace.Name)"
                $Temp_TS_New_ChildTS    = Get-CMTaskSequence -TaskSequencePackageId $Item.New_TsPackageID -Fast
                Set-CMTaskSequenceStepRunTaskSequence -TaskSequenceName $Item.New_TsParent -RunTaskSequence $Temp_TS_New_ChildTS -StepName $Temp_TS_Step_ToReplace.Name
                Write-Host "            Status: Success"
            }
            catch {
                Write-vr_ErrorCode -Code 1703 -Exit $true -Object $PSItem
            }
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
        Write-Host "  Script Started: $($Meta_Script_Start_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd_HHmmss`")) (UTC)"
        Write-Host "  Script Completed: $($Meta_Script_Complete_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd_HHmmss`")) (UTC)"
        Write-Host "  Total Time: $($Meta_Script_Complete_TimeSpan.Days) days, $($Meta_Script_Complete_TimeSpan.Hours) hours, $($Meta_Script_Complete_TimeSpan.Minutes) minutes, $($Meta_Script_Complete_TimeSpan.Seconds) seconds, $($Meta_Script_Complete_TimeSpan.Milliseconds) milliseconds"
        Write-Host "------------------------------------------------------------------------------"
        Write-Host "  End of Script"
        Write-Host "------------------------------------------------------------------------------"

#EndRegion Footer
#--------------------------------------------------------------------------------------------

Return $Meta_Script_Result[1]
Stop-Transcript
