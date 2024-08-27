#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$Type,                          # OSD,USMT,IPU
    [string]$NetworkLogging,                # Enabled, Disabled
    [string]$OrgName="VividRock",           # Organization Name: "VividRock"
    [string]$OrgAcronym="VR",               # Organization Acronym: "VR"
    [string]$OrgRootDirName="VividRock",    # Root Name of C: Folder: "VividRock"
    [string]$OrgWMINamespace="MECM" # WMI Namespace for Custom Classes: "MECM_Toolkit"
)

#--------------------------------------------------------------------------------------------
Start-Transcript -Path "C:\VividRock\MECM Toolkit\Logs\Core\Initialize Variables.log"  -Append -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - Task Sequences - Core - Initialize Variables"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       December 10, 2019"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    Creates the Task Sequence Variables necessary for using the"
    Write-Host "                MECM Toolkit in a Task Sequence."
    Write-Host "    Links:      https://docs.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/log-files"
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
        $Param_Type             = $Type
        $Param_NetworkLogging   = $NetworkLogging
        $Param_OrgName          = $OrgName
        $Param_OrgAcronym       = $OrgAcronym
        $Param_OrgRootDirName   = $OrgRootDirName
        $Param_OrgWMINamespace  = $OrgWMINamespace

    # Metadata
        $Meta_Script_Start_DateTime     = Get-Date
        $Meta_Script_Complete_DateTime  = $null
        $Meta_Script_Complete_TimeSpan  = $null
        $Meta_Script_Result = $false,"Failure"

    # Names

    # Paths

    # Files

    # Hashtables
        $Hash_VR_Variables = @{
            "vr_Organization_Name"                        = $Param_OrgName                                                # Used by the toolkit to customize some of the output to the client's environment [to be set in task sequence]
            "vr_Organization_Acronym"                     = $Param_OrgAcronym                                             # Used by the toolkit to customize some of the output to the client's environment [to be set in task sequence]
            "vr_Organization_CustomRootDirName"           = $Param_OrgRootDirName                                         # Used by the toolkit to customize the name of the root directory [to be set in task sequence]
            "vr_Organization_CustomWMINamespace"          = $Param_OrgWMINamespace                                        # Used by the Tattoo WMI tool to customize the location within WMI where the image tattoo data is stored [to be set in task sequence]
            # "vr_ImageStatus"                        = "%vr_ImageStatus%"                                          # Used by the Tattoo WMI tool to write the status of the imaging process to WMI. [to be set in task sequence]

            "vr_Device_Manufacturer"                = "[to be set within this script]"
            "vr_Device_Model"                       = "[to be set within this script]"
            "vr_Device_ChassisType"                 = "[to be set within this script]"
            "vr_Device_SerialNumber"                = "[to be set within this script]"
            "vr_Device_AssetTag"                    = "[to be set within this script]"
            "vr_Device_DeviceType"                  = "[to be set within this script]"                              # Determined using chassis types and known models. Possible Values: Laptop, Desktop, Server, Unknown
            "vr_Device_Virtual"                     = "[to be set within this script]"                              # Determined using known models. Possible Values: Boolean true/false

            "vr_Network_Description"                = "[to be set within this script]"
            "vr_Network_MACAddress"                 = "[to be set within this script]"
            "vr_Network_IPAddress"                  = "[to be set within this script]"
            "vr_Network_IPSubnet"                   = "[to be set within this script]"
            "vr_Network_DefaultIPGateway"           = "[to be set within this script]"
            "vr_Network_DHCPServer"                 = "[to be set within this script]"
            "vr_Network_DNSDomain"                  = "[to be set within this script]"
            "vr_Network_DNSServerSearchOrder"       = "[to be set within this script]"

            "vr_Meta_ComputerName"                  = "[to be set within this script]"
            "vr_Meta_DateStartObject"               = $Meta_Script_Start_DateTime.ToUniversalTime()
            "vr_Meta_DateStopObject"                = "[to be set in task sequence using Core - Finalize Variables script]"
            "vr_Meta_DateStartUTC"                  = $Meta_Script_Start_DateTime.ToUniversalTime().ToString("yyyy-MM-dd")
            "vr_Meta_DateStopUTC"                   = "[to be set in task sequence using Core - Finalize Variables script]"
            "vr_Meta_TimeStartUTC"                  = $Meta_Script_Start_DateTime.ToUniversalTime().ToString("HH:mm:ss")
            "vr_Meta_TimeStopUTC"                   = "[to be set in task sequence using Core - Finalize Variables script]"
            "vr_Meta_TimeStampUTC"                  = $Meta_Script_Start_DateTime.ToUniversalTime().ToString("yyyyMMdd-HHmmss")
            "vr_Meta_TaskSequenceName"              = "[to be set within this script]"
            "vr_Meta_TaskSequenceType"              = $Param_Type
            "vr_Meta_TaskSequenceName_Clean"        = "[to be set within this script]"                              # The cleaned version of the task sequence name for creating valid file names

            "vr_Directory_RootDir"                  = "C:\$($Param_OrgRootDirName)"                      # The main container where all content gets created for the Toolkit
            "vr_Directory_MECM"                     = "%vr_Directory_RootDir%\MECM"                                 # The folder where all MECM related content will be created
            "vr_Directory_Cache"                    = "%vr_Directory_MECM%\Cache"                                   # A place to cache files needed for task sequences, scripts, or other files. The contents of this folder should only be items safe to delete once the operation is complete
                "vr_Directory_Cache_Backgrounds"    = "%vr_Directory_Cache%\Backgrounds"                            # A place to cache backgrounds for configuring the device
                "vr_Directory_Cache_StartMenu"      = "%vr_Directory_Cache%\StartMenu"                              # A place to cache Start Menu customization files
                "vr_Directory_Cache_Updates"        = "%vr_Directory_Cache%\Updates"                                # A place to cache files associated with a Windows Upgrade task sequence
            "vr_Directory_Logs"                     = "%vr_Directory_MECM%\Logs"                                    # A centralized log directory
                "vr_Directory_Applications"         = "%vr_Directory_Logs%\Applications"                            # A subdirectory for centralizing application related logs
                    "vr_Directory_Apps_Detection"   = "%vr_Directory_Applications%\Detection"                       # All log files associated with detecting an application
                    "vr_Directory_Apps_Install"     = "%vr_Directory_Applications%\Install"                         # All log files associated with installing an application
                    "vr_Directory_Apps_Uninstall"   = "%vr_Directory_Applications%\Uninstall"                       # All log files associated with uninstalling an application
                "vr_Directory_ConfigurationBaselines" = "%vr_Directory_Logs%\ConfigurationBaselines"                # A subdirectory for centralizing configuration baseline related logs
                    "vr_Directory_CB_Discovery"     = "%vr_Directory_ConfigurationBaselines%\Discovery"             # All log files associated wtih configuration baseline discovery
                    "vr_Directory_CB_Remediation"   = "%vr_Directory_ConfigurationBaselines%\Remediation"           # All log files associated wtih configuration baseline remediation
                "vr_Directory_Logs_Scripts"         = "%vr_Directory_Logs%\Scripts"                                 # A subdirectory for centralizing configuration baseline related logs
                "vr_Directory_TaskSequences"        = "%vr_Directory_Logs%\TaskSequences\%vr_Meta_TaskSequenceName_Clean%\%vr_Meta_TimeStampUTC%"    # All log files associated with Task Sequences
                    "vr_Directory_TS_Client"        = "%vr_Directory_TaskSequences%\Client"                         # A subdirectory for centralizing client related logs
                        "vr_Directory_TS_CCMSetup"  = "%vr_Directory_TS_Client%\CCMSetup"                              # All log files associated with the ccmsetup process
                    "vr_Directory_TS_EventLogs"     = "%vr_Directory_TaskSequences%\EventLogs"                      # A subdirectory for exporting event log files
                    "vr_Directory_TS_Validation"    = "%vr_Directory_TaskSequences%\Validation"                     # A subdirectory for storing output from the validation scripts in the toolkit
                    "vr_Directory_TS_Variables"     = "%vr_Directory_TaskSequences%\Variables"                      # A subdirectory for exporting the Task Sequence variable dump
                    "vr_Directory_TS_XML"           = "%vr_Directory_TaskSequences%\XML"                            # A subdirectory for exporting the XML content of all Task Sequences and Sub Taskequences executed
                "vr_Directory_Logs_Updates"         = "%vr_Directory_Logs%\Updates"                                 # All log files associated with Windows Updates
                "vr_Directory_Logs_Upgrades"        = "%vr_Directory_Logs%\Upgrades"                                # All log files associated with Windows Upgrades
            "vr_Directory_Tools"                    = "%vr_Directory_MECM%\Tools"                                   # A place to store tools that you need localized on devices for configuration, troubleshooting, support, etc.

            "vr_Logging_NetworkLogging"             = $Param_NetworkLogging                                         # [bool] Determines through parameter input whether the logging should also be uploaded to a network log repository.
            "vr_Logging_NetworkRepository"          = "[to be set in task sequence]"                                # [string] The network path that is used to upload logs to the network repository
            "vr_Logging_PrimaryLog"                 = "`"%vr_Directory_TaskSequences%\%vr_Meta_TaskSequenceName_Clean%.log`""          # [string] The VividRock Toolkit log file for easy reference and troublshooting
            #"vr_Logging_Content"                    = "[to be set by Logging steps]"                               # This variable stores the logging content throughout the Task Sequence so that it can be output at the end and contain all logging content from both the WinPE as well as the Windows environments and can survive any disk formatting or destructive steps in the Task Sequence.

            # To Do: Remove these in use in the Task Sequences and all other Toolkit files. Replace with above.
            #"vr_Network_LogRepository"              = "[to be set in task sequence]"                                # The network path that is used to upload logs to the network repository
            #"vr_File_TSLogFile"                     = "`"%vr_Directory_TaskSequences%\%vr_Meta_TaskSequenceName_Clean%.log`""          # The VividRock Toolkit log file for easy reference and troublshooting

            # "vr_LTI_Skip"                           = ""                                                           # [bool] Used as conditional execution logic to skip the LTI prompt when a device is a member of a Collection with predefined LTI variabless
        }

    # Arrays
        $Array_ChassisType_Laptop = @(
            8, 9, 10, 11, 12, 14, 18, 21, 30, 31, 32
        )
        $Array_ChassisType_Desktop = @(
            3, 4, 5, 6, 7, 13, 15, 16, 35, 36
        )
        $Array_ChassisType_Server = @(
            23, 28
        )
        $Array_Model_Virtual = @(
            "%Virtual Machine%"                 # Microsoft - Hyper-v
            "%VirtualBox%"                      # Oracle - VirtualBox
            "%VMware Virtual Platform%"         # VMware - Virtual Platform (BIOS)
            "%VMware7,1%"                     # VMware - Virtual Machines (UEFI)
        )
        $Array_Characters_Disallowed = @(
            "\\";        # This character needs to be escaped with a '\' so that the Replace function doesn't throw a Regular Expression error
            "/";
            ":";
            ",";
            "\?";        # This character needs to be escaped with a '\' so that the Replace function doesn't throw a Regular Expression error
            "&";
            "\*";        # This character needs to be escaped with a '\' so that the Replace function doesn't throw a Regular Expression error
            "#";
            "{";
            "}";
            "<";
            ">";
            "%";
            "~";
            "\|";        # This character needs to be escaped with a '\' so that the Replace function can process it correctly and remove the character
        )

    # Registry

    # WMI

    # Datasets

    # Temporary

    # Output to Log
        Write-Host "    - Parameters"
        foreach ($Item in (Get-Variable -Name "Param_*")) {
            Write-Host "        $(($Item.Name) -replace 'Param_',''): $($Item.Value)"
        }
        Write-Host "    - Array Items"
        foreach ($Item in (Get-Variable -Name "Array_*")) {
            Write-Host "        $(($Item.Name) -replace 'Array_',''): $($Item.Value)"
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

    # Create TSEnvironment COM Object
        Write-Host "    - Create TSEnvironment COM Object"

        try {
            $Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
            Write-Host "        Status: Success"
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

    # Write-Host "  Validation"

    # # Sub Directories
    #     Write-Host "    - Sub Directories"

    #     try {
    #         foreach ($Item in (Get-Variable -Name "Path_Local_*")) {
    #             Write-Host "        Path: $($Item.Value)"
    #             if (Test-Path -Path $Item.Value) {
    #                 Write-Host "            Status: Exists"
    #             }
    #             else {
    #                 New-Item -Path $Item.Value -ItemType Directory -Force -ErrorAction Stop | Out-Null
    #                 Write-Host "            Status: Created"
    #             }
    #         }
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Validation
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Data Gather
#   Error Range: 1600 - 1699
#--------------------------------------------------------------------------------------------
#Region Data Gather

    Write-Host "  Data Gather"

    # Get Device Information
        Write-Host "    - Get Device Information"

        try {
            # Get Data Objects
                $Temp_WMI_Win32ComputerSystem = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction Stop
                $Temp_WMI_Win32SystemEnclosure = Get-CimInstance -ClassName Win32_SystemEnclosure -ErrorAction Stop
                $Temp_WMI_Win32BIOS = Get-CimInstance -ClassName Win32_BIOS -ErrorAction Stop

            # Manufacturer
                if ($Temp_WMI_Win32ComputerSystem.Manufacturer) {
                    $Hash_VR_Variables.vr_Device_Manufacturer = $Temp_WMI_Win32ComputerSystem.Manufacturer
                }
                else {
                    $Hash_VR_Variables.vr_Device_Manufacturer = "[empty]"
                }

                Write-Host "        Manufacturer: $($Hash_VR_Variables.vr_Device_Manufacturer)"

            # Model
                if ($Temp_WMI_Win32ComputerSystem.Model) {
                    $Hash_VR_Variables.vr_Device_Model = $Temp_WMI_Win32ComputerSystem.Model
                }
                else {
                    $Hash_VR_Variables.vr_Device_Model = "[empty]"
                }

                Write-Host "        Model: $($Hash_VR_Variables.vr_Device_Model)"

            # Chassis Types
                if ($($Temp_WMI_Win32SystemEnclosure.ChassisTypes).ToString()) {
                    $Hash_VR_Variables.vr_Device_ChassisType = $($Temp_WMI_Win32SystemEnclosure.ChassisTypes).ToString()
                }
                else {
                    $Hash_VR_Variables.vr_Device_ChassisType = "[empty]"
                }

                Write-Host "        Chassis Type: $($Hash_VR_Variables.vr_Device_ChassisType)"

            # Serial Number
                if ((Get-CimInstance -ClassName Win32_SystemEnclosure).SerialNumber -notin $null,"","None") {
                    $Hash_VR_Variables.vr_Device_SerialNumber = (Get-CimInstance -ClassName Win32_SystemEnclosure).SerialNumber
                }
                elseif ((Get-CimInstance -ClassName Win32_BIOS).SerialNumber) {
                    $Hash_VR_Variables.vr_Device_SerialNumber = (Get-CimInstance -ClassName Win32_BIOS).SerialNumber
                }
                else {
                    $Hash_VR_Variables.vr_Device_SerialNumber = "[empty]"
                }

                Write-Host "        Serial Number: $($Hash_VR_Variables.vr_Device_SerialNumber)"

            # Asset Tag
                if ($Temp_WMI_Win32SystemEnclosure.SMBIOSAssetTag) {
                    $Hash_VR_Variables.vr_Device_AssetTag = $Temp_WMI_Win32SystemEnclosure.SMBIOSAssetTag
                }
                else {
                    $Hash_VR_Variables.vr_Device_AssetTag = "[empty]"
                }

                Write-Host "        Asset Tag: $($Hash_VR_Variables.vr_Device_AssetTag)"

            # Device Type
                switch ($Hash_VR_Variables.vr_Device_ChassisType) {
                    {$Array_ChassisType_Laptop -eq $_} { $Hash_VR_Variables.vr_Device_DeviceType = "Laptop" }
                    {$Array_ChassisType_Desktop -eq $_} { $Hash_VR_Variables.vr_Device_DeviceType = "Desktop" }
                    {$Array_ChassisType_Server -eq $_} { $Hash_VR_Variables.vr_Device_DeviceType = "Server" }
                    Default { $Hash_VR_Variables.vr_Device_DeviceType = "Unknown" }
                }

                Write-Host "        Device Type: $($Hash_VR_Variables.vr_Device_DeviceType)"

            # Is Virtual
                $Object_MECM_TSEnvironment.Value("vr_Device_Virtual") = $false

                foreach ($Item in $Array_Model_Virtual) {
                    if ($Item -match $Hash_VR_Variables.vr_Device_Model) {
                        $Hash_VR_Variables.vr_Device_Virtual = $true
                        $Hash_VR_Variables.vr_Device_DeviceType = "Virtual Machine"
                    }
                }

                Write-Host "        Is Virtual: $($Hash_VR_Variables.vr_Device_Virtual)"

            # Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
        }

# Get Network Information
        Write-Host "    - Get Network Information"

        try {
            # Iterate Over Adapters
                $Temp_WMI_Win32NetworkAdapterConfiguration      = Get-CimInstance -ClassName "Win32_NetworkAdapterConfiguration" | Where-Object -FilterScript { $_.Description -notlike "*WAN Mini*" -and $_.IPAddress -notin $null,"" } | Select-Object -Property "Index","Description","MACAddress","IPAddress","IPSubnet","DefaultIPGateway","DHCPServer","DNSDomain","DNSServerSearchOrder"
                foreach ($Adapter in $Temp_WMI_Win32NetworkAdapterConfiguration) {
                    Write-Host "        Index: $($Adapter.Index)"
                    foreach ($Property in $Adapter.PSObject.Properties) {
                        # Output to Log
                            if ($Property.Name -ne "Index") {
                                Write-Host "            $($Property.Name): $($Property.Value)"
                            }

                        # Set Hashtable Values
                            switch ($Property.Name) {
                                "Index" { <# Do Nothing #> }
                                "Description" { $Hash_VR_Variables."vr_Network_$($Property.Name)" = $Property.Value }
                                "MACAddress" { $Hash_VR_Variables."vr_Network_$($Property.Name)" = $Property.Value }
                                "IPAddress" { $Hash_VR_Variables."vr_Network_$($Property.Name)" = $Property.Value -join ", " }
                                "IPSubnet" { $Hash_VR_Variables."vr_Network_$($Property.Name)" = $Property.Value -join ", " }
                                "DefaultIPGateway" { $Hash_VR_Variables."vr_Network_$($Property.Name)" = $Property.Value -join ", " }
                                "DHCPServer" { $Hash_VR_Variables."vr_Network_$($Property.Name)" = $Property.Value }
                                "DNSDomain" { $Hash_VR_Variables."vr_Network_$($Property.Name)" = $Property.Value }
                                "DNSServerSearchOrder" { $Hash_VR_Variables."vr_Network_$($Property.Name)" = $Property.Value -join ", " }
                                Default {}
                            }
                    }
                }

            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1602 -Exit $true -Object $PSItem
        }

    # Get Task Sequence Information
        Write-Host "    - Get Task Sequence Information"

        try {
            # Computer Name
                $Hash_VR_Variables.vr_Meta_ComputerName = $Object_MECM_TSEnvironment.Value("_SMSTSMachineName")
                Write-Host "        Computer Name: $($Hash_VR_Variables.vr_Meta_ComputerName)"

            # Task Sequence Name
                $Hash_VR_Variables.vr_Meta_TaskSequenceName = $Object_MECM_TSEnvironment.Value("_SMSTSPackageName")
                Write-Host "        Task Sequence Name: $($Hash_VR_Variables.vr_Meta_TaskSequenceName)"

            # Task Sequence Name (Cleaned)
                $Temp_Characters_Cleaned = @()
                $Hash_VR_Variables.vr_Meta_TaskSequenceName_Clean = $Hash_VR_Variables.vr_Meta_TaskSequenceName

                foreach ($Character in $Array_Characters_Disallowed) {
                    if ($Hash_VR_Variables.vr_Meta_TaskSequenceName_Clean -match "[$Character]") {
                        $Temp_Characters_Cleaned += $Character
                        $Hash_VR_Variables.vr_Meta_TaskSequenceName_Clean = $Hash_VR_Variables.vr_Meta_TaskSequenceName_Clean -replace "$($Character)",""
                    }
                  }

                  Write-Host "        Task Sequence Name (Cleaned): $($Hash_VR_Variables.vr_Meta_TaskSequenceName_Clean)"
                  Write-Host "            Characters Removed: $($Temp_Characters_Cleaned)"

            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1603 -Exit $true -Object $PSItem
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

    # Write-Host "  Execution"

    # # [StepName]
    #     Write-Host "    - [StepName]"

    #     try {

    #         Write-Host "        Status: Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
    #     }

    # # [StepName]
    #     foreach ($Item in (Get-Variable -Name "Path_*")) {
    #         Write-Host "    - $($Item.Name)"

    #         try {

    #             Write-Host "        Status: Success"
    #         }
    #         catch {
    #             Write-vr_ErrorCode -Code 1702 -Exit $true -Object $PSItem
    #         }
    #     }

    # # Determine Script Result
    #     $Meta_Script_Result = $true,"Success"

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Execution
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Output
#   Error Range: 1800 - 1899
#--------------------------------------------------------------------------------------------
#Region Output

    Write-Host "  Output"

    # Create Task Sequence Variables
        Write-Host "    - Create Task Sequence Variables"

        try {
            foreach ($Variable in $Hash_VR_Variables.GetEnumerator()) {
                Write-Host "        $($Variable.Name): $($Variable.Value)"

                $Object_MECM_TSEnvironment.Value("$($Variable.Name)") = $Variable.Value
            }
            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1801 -Exit $true -Object $PSItem
        }

    # # [StepName]
    #     Write-Host "    - [StepName]"

    #     try {

    #         Write-Host "        Status: Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1801 -Exit $true -Object $PSItem
    #     }

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
        Write-Host "  Script Result: $($Meta_Script_Result[0])"
        Write-Host "  Script Started: $($Meta_Script_Start_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
        Write-Host "  Script Completed: $($Meta_Script_Complete_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
        Write-Host "  Total Time: $($Meta_Script_Complete_TimeSpan.Days) days, $($Meta_Script_Complete_TimeSpan.Hours) hours, $($Meta_Script_Complete_TimeSpan.Minutes) minutes, $($Meta_Script_Complete_TimeSpan.Seconds) seconds, $($Meta_Script_Complete_TimeSpan.Milliseconds) milliseconds"
        Write-Host "------------------------------------------------------------------------------"
        Write-Host "  End of Script"
        Write-Host "------------------------------------------------------------------------------"

#EndRegion Footer
#--------------------------------------------------------------------------------------------

Stop-Transcript
Return $Meta_Script_Result[1]