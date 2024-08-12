#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$SiteCode="ABC",                                        # "ABC"
    [string]$SMSProvider="[serverfqdn]",                            # "[ServerFQDN]"
    [string]$Source="SU - Workstations - Windows 11",               # 'SU - Workstations - Windows 11'
    [string]$Target="SU - Microsoft 365 - Apps for Enterprise"      # 'SU - Microsoft 365 - Apps for Enterprise'
)

#--------------------------------------------------------------------------------------------
Start-Transcript -Path "C:\VividRock\MECM Toolkit\Logs\Software Updates\Copy Deployments to ADR.log"  -Append:$false -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  VividRock - MECM Toolkit - Software Updates - Copy Deployments to ADR"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       2021-09-23"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    Copy all of the Deployments from a Source ADR to a Target ADR."
    Write-Host "    Links:      None"
    Write-Host "    Template:   1.0"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""

<#
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
        $Param_SiteCode         = $SiteCode
        $Param_SMSProvider      = $SMSProvider
        $Param_Source           = $Source
        $Param_Target           = $Target

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
        $Array_XML_IgnoredNodes = @(
            'xsi'
            'xsd'
            'DeploymentId'
            'DeploymentNumber'
            'CollectionId'
            'IncludeSub'
        )

        $Array_XML_ChangeLog = @()

    # Registry

    # WMI

    # Datasets

    # Temporary

    # Output to Log
        Write-Host "    - Parameters"
        foreach ($Item in (Get-Variable -Name "Param_*")) {
            Write-Host "        $(($Item.Name) -replace 'Param_',''): $($Item.Value)"
        }
        Write-Host "    - XML Ignored Items"
        foreach ($Item in $Array_XML_IgnoredNodes) {
            Write-Host "        $($Item)"
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

                    if((Get-PSDrive -Name $Param_SiteCode -PSProvider CMSite -ErrorAction Stop) -in $null,"") {
                        New-PSDrive -Name $Param_SiteCode -PSProvider CMSite -Root $Param_SMSProvider -ErrorAction Stop
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

    # Source ADR Exists
        Write-Host "    - Source ADR Exists"

        try {
            Write-Host "        Name: $($Param_Source)"
            if (Get-CMAutoDeploymentRule -Name $Param_Source -Fast) {
                Write-Host "            Status: Exists"
            }
            else {
                Throw "Error: An ADR with that name could not be found."
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
        }

    # Target ADR Exists
        Write-Host "    - Target ADR Exists"

        try {
            Write-Host "        Name: $($Param_Target)"
            if (Get-CMAutoDeploymentRule -Name $Param_Target -Fast) {
                Write-Host "            Status: Exists"
            }
            else {
                Throw "Error: An ADR with that name could not be found."
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
# Data Gather
#   Error Range: 1600 - 1699
#--------------------------------------------------------------------------------------------
#Region Data Gather

    Write-Host "  Data Gather"

    # Source ADR Deployments
        Write-Host "    - Source ADR Deployments"

        try {
            $Dataset_ADR_Source = Get-CMAutoDeploymentRuleDeployment -Name $Param_Source -ErrorAction Stop
            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
        }

    # Target ADR Object
        Write-Host "    - Target ADR Object"

        try {
            $Dataset_ADR_Target = Get-CMSoftwareUpdateAutoDeploymentRule -Name $Param_Target -Fast -ErrorAction Stop
            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1602 -Exit $true -Object $PSItem
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

    # Iterate Over Deployments
        foreach ($Deployment in ($Dataset_ADR_Source)) {

            # Create Deployment
                Write-Host "    - Create Deployment"

                try {
                    Write-Host "        Name: $($Deployment.CollectionName)"
                    New-CMAutoDeploymentRuleDeployment -InputObject $Dataset_ADR_Target -CollectionId $Deployment.CollectionID -EnableDeployment $true -ErrorAction Stop | Out-Null
                    Write-Host "        Status: Success"
                }
                catch [System.ArgumentException] {
                    # This error seems unavoidable. However, it does not seem to cause any issue that it does occur. Continue anyways but provide the output in the console and log.
                    Write-Host "        Status: $($_.Exception.Message)"
                }
                catch {
                    Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
                }

            # Load Source XML
                Write-Host "    - Load Source Deployment Template XML"

                try {
                    [xml]$Temp_ADR_Deployment_Source_XML    = [xml]$Deployment.DeploymentTemplate
                    Write-Host "        Status: Success"
                }
                catch {
                    Write-vr_ErrorCode -Code 1702 -Exit $true -Object $PSItem
                }

            # Load Target XML
                Write-Host "    - Load Target Deployment Template XML"

                try {
                    $Temp_ADR_Deployment_Target             = Get-CMAutoDeploymentRuleDeployment -Name $Param_Target -ErrorAction Stop | Where-Object -FilterScript { $_.CollectionName -eq $Deployment.CollectionName } -ErrorAction Stop
                    [xml]$Temp_ADR_Deployment_Target_XML    = $Temp_ADR_Deployment_Target.DeploymentTemplate
                    Write-Host "        Status: Success"
                }
                catch {
                    Write-vr_ErrorCode -Code 1703 -Exit $true -Object $PSItem
                }

            # Copy XML Node Values from Source to Target
                Write-Host "    - Copy XML Node Values from Source to Target"

                foreach ($Item in $Temp_ADR_Deployment_Source_XML.DeploymentCreationActionXML.GetEnumerator()) {
                    try {
                        $Temp_XML_Changes_Object = [PSCustomObject]@{
                            "Target"        = $Dataset_ADR_Target.Name
                            "Deployment"    = $Deployment.CollectionName
                            "Node"          = $Item.Name
                            "Old Value"     = $Temp_ADR_Deployment_Target_XML.DeploymentCreationActionXML.$($Item.Name)
                            "New Value"     = $Item.InnerText
                            "Status"        = "Pending"
                        }

                        if ($Item.Name -notin $Array_XML_IgnoredNodes) {
                            If ($Temp_ADR_Deployment_Target_XML.DeploymentCreationActionXML.$($Item.Name) -in $null,"") {
                                # Create Node if Not Exist
                                    $Temp_XML_NewChild = $Temp_ADR_Deployment_Target_XML.CreateElement("$($Item.Name)")
                                    $Temp_ADR_Deployment_Target_XML.SelectSingleNode("DeploymentCreationActionXML").AppendChild($Temp_XML_NewChild)
                            }

                            # Set XML Value
                                $Temp_ADR_Deployment_Target_XML.DeploymentCreationActionXML.$($Item.Name) = $Item.InnerText

                            # Set Custom Object Status
                                $Temp_XML_Changes_Object.Status = "Copied"
                        }
                        else {
                            # Set Custom Object Status
                                $Temp_XML_Changes_Object.Status = "Ignored"
                        }

                        # Add Custom Object to Dataset
                            $Array_XML_ChangeLog += $Temp_XML_Changes_Object
                            $Temp_XML_Changes_Object = $null
                    }
                    catch {
                        Write-vr_ErrorCode -Code 1704 -Exit $true -Object $PSItem
                    }
                }

                Write-Host "        Status: Success"

            # Put XML Changes
                Write-Host "    - Put XML Changes"

                try {
                    $Temp_ADR_Deployment_Target.DeploymentTemplate = $Temp_ADR_Deployment_Target_XML.OuterXml
                    $Temp_ADR_Deployment_Target.Put()
                    Write-Host "        Status: Success"
                }
                catch {
                    Write-vr_ErrorCode -Code 1705 -Exit $true -Object $PSItem
                }

                Write-Host ""
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

    Write-Host "  Output"

    # Output Change Log Table
        Write-Host "    - Output Change Log Table"

        try {
            $Array_XML_ChangeLog | Format-Table -ErrorAction Stop
            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1801 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

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
        Write-Host "  Script Result: $($Meta_Script_Result[1])"
        Write-Host "  Script Started: $($Meta_Script_Start_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
        Write-Host "  Script Completed: $($Meta_Script_Complete_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
        Write-Host "  Total Time: $($Meta_Script_Complete_TimeSpan.Days) days, $($Meta_Script_Complete_TimeSpan.Hours) hours, $($Meta_Script_Complete_TimeSpan.Minutes) minutes, $($Meta_Script_Complete_TimeSpan.Seconds) seconds, $($Meta_Script_Complete_TimeSpan.Milliseconds) milliseconds"
        Write-Host "------------------------------------------------------------------------------"
        Write-Host "  End of Script"
        Write-Host "------------------------------------------------------------------------------"

#EndRegion Footer
#--------------------------------------------------------------------------------------------

Stop-Transcript
Return $Meta_Script_Result[0]