#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$Prefix,                # '%vr_Organization_Acronym%'
    [string]$NamespaceRoot,         # '%vr_Organization_Name%'
    [string]$NamespaceChild,        # 'MECM_Toolkit'
    [string]$ClassName              # Options: 'WindowsImage','USMT','WindowsUpgrade'
)

#--------------------------------------------------------------------------------------------
Start-Transcript -Path "C:\VividRock\MECM Toolkit\Logs\Task Sequences\Tattoo-WMIMethod.log"  -Append -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - Tattoo - WMI Method"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       October 07, 2017"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    Tattoos the WMI/CIM of a Windows device for easy reporting."
    Write-Host "    Links:      None"
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
        $Param_Prefix           = $Prefix
        $Param_NamespaceRoot    = $NamespaceRoot
        $Param_NamespaceChild   = $NamespaceChild
        $Param_ClassName        = $ClassName


    # Metadata
        $Meta_Script_Start_DateTime     = Get-Date
        $Meta_Script_Complete_DateTime  = $null
        $Meta_Script_Complete_TimeSpan  = $null
        [bool]$Meta_Script_Success = $false

    # Names

    # Paths

    # Files

    # Hashtables
        $HashTable_TattooProperties = @{
            <# Custom Task Sequence Values #>
            <#
            000 = @{
                WMIName         = ""
                TSVariableName  = ""
                DataType        = "String"
                Value           = ""
            }
            #>

            <# Required for WMI Entry #>
            Key = @{
                WMIName         = "Name"
                TSVariableName  = ""
                DataType        = "String"
                Value           = "Default"
            }

            <# Builtin Task Sequence Values #>
            101 = @{
                WMIName         = "MECM_OrganizationName"
                TSVariableName  = "_SMSTSOrgName"
                DataType        = "String"
                Value           = ""
            }
            102 = @{
                WMIName         = "MECM_SiteCode"
                TSVariableName  = "_SMSTSSiteCode"
                DataType        = "String"
                Value           = ""
            }
            103 = @{
                WMIName         = "MECM_ManagementPoint"
                TSVariableName  = "_SMSTSMP"
                DataType        = "String"
                Value           = ""
            }
            104 = @{
                WMIName         = "TS_PackageID"
                TSVariableName  = "_SMSTSPackageID"
                DataType        = "String"
                Value           = ""
            }
            105 = @{
                WMIName         = "TS_AdvertisementID"
                TSVariableName  = "_SMSTSAdvertID"
                DataType        = "String"
                Value           = ""
            }
            106 = @{
                WMIName         = "TS_Name"
                TSVariableName  = "_SMSTSPackageName"
                DataType        = "String"
                Value           = ""
            }
            107 = @{
                WMIName         = "TS_LaunchMode"
                TSVariableName  = "_SMSTSLaunchMode"
                DataType        = "String"
                Value           = ""
            }
            108 = @{
                WMIName         = "OS_PackageId"
                TSVariableName  = "_OSDOSImagePackageId"
                DataType        = "String"
                Value           = ""
            }
            109 = @{
                WMIName         = "OS_VersionNumber"
                TSVariableName  = "OSVersionNumber"
                DataType        = "String"
                Value           = ""
            }
            110 = @{
                WMIName         = "OS_Architecture"
                TSVariableName  = "OSArchitecture"
                DataType        = "String"
                Value           = ""
            }
            111 = @{
                WMIName         = "OS_StepName"
                TSVariableName  = "vr_OperatingSystem_StepName"
                DataType        = "String"
                Value           = ""
            }
            112 = @{
                WMIName         = "Boot_UEFI"
                TSVariableName  = "_SMSTSBootUEFI"
                DataType        = "String"
                Value           = ""
            }
            113 = @{
                WMIName         = "Boot_DiskLabel"
                TSVariableName  = "_SMSTSDiskLabel1"
                DataType        = "String"
                Value           = ""
            }
            114 = @{
                WMIName         = "Boot_MediaType"
                TSVariableName  = "_SMSTSMediaType"
                DataType        = "String"
                Value           = ""
            }
            115 = @{
                WMIName         = "Boot_ImageID"
                TSVariableName  = "_SMSTSBootImageID"
                DataType        = "String"
                Value           = ""
            }
            116 = @{
                WMIName         = "Boot_MediaSourceVersion"
                TSVariableName  = "_SMSTSBootMediaSourceVersion"
                DataType        = "String"
                Value           = ""
            }
            117 = @{
                WMIName         = "Net_IPAddresses"
                TSVariableName  = "vr_Network_IPAddress"
                DataType        = "String"
                Value           = ""
            }
            118 = @{
                WMIName         = "Net_DefaultGateways"
                TSVariableName  = "vr_Network_DefaultIPGateway"
                DataType        = "String"
                Value           = ""
            }
            119 = @{
                WMIName         = "Net_MacAddress"
                TSVariableName  = "vr_Network_MACAddress"
                DataType        = "String"
                Value           = ""
            }
            120 = @{
                WMIName         = "Net_DHCPServer"
                TSVariableName  = "vr_Network_DHCPServer"
                DataType        = "String"
                Value           = ""
            }
            121 = @{
                WMIName         = "Net_DNSDomain"
                TSVariableName  = "vr_Network_DNSDomain"
                DataType        = "String"
                Value           = ""
            }
            122 = @{
                WMIName         = "Net_DNSServers"
                TSVariableName  = "vr_Network_DNSServerSearchOrder"
                DataType        = "String"
                Value           = ""
            }
            130 = @{
                WMIName         = "TS_RebootCount"
                TSVariableName  = "_OSDRebootCount"
                DataType        = "String"
                Value           = ""
            }

            <# VividRock - MECM Toolkit Values #>
            201 = @{
                WMIName         = "Status_Start_DateTimeUTC"
                TSVariableName  = "vr_Meta_DateStartObject"
                DataType        = "String"
                Value           = ""
            }
            202 = @{
                WMIName         = "Status_Stop_DateTimeUTC"
                TSVariableName  = "vr_Meta_DateStopObject"
                DataType        = "String"
                Value           = ""
            }
            203 = @{
                WMIName         = "Status_Total_ImageTime"
                TSVariableName  = "vr_Meta_TotalImageTime"
                DataType        = "String"
                Value           = ""
            }
            204 = @{
                WMIName         = "Status_Start_DateUTC"
                TSVariableName  = "vr_Meta_DateStartUTC"
                DataType        = "String"
                Value           = ""
            }
            205 = @{
                WMIName         = "Status_Stop_DateUTC"
                TSVariableName  = "vr_Meta_DateStopUTC"
                DataType        = "String"
                Value           = ""
            }
            206 = @{
                WMIName         = "Status_Start_TimeUTC"
                TSVariableName  = "vr_Meta_TimeStartUTC"
                DataType        = "String"
                Value           = ""
            }
            207 = @{
                WMIName         = "Status_Stop_TimeUTC"
                TSVariableName  = "vr_Meta_TimeStopUTC"
                DataType        = "String"
                Value           = ""
            }
            208 = @{
                WMIName         = "Device_ChassisType"
                TSVariableName  = "vr_Device_ChassisType"
                DataType        = "String"
                Value           = ""
            }
            209 = @{
                WMIName         = "Device_DeviceType"
                TSVariableName  = "vr_Device_DeviceType"
                DataType        = "String"
                Value           = ""
            }
            210 = @{
                WMIName         = "Device_Virtual"
                TSVariableName  = "vr_Device_Virtual"
                DataType        = "String"
                Value           = ""
            }
            211 = @{
                WMIName         = "Status_Result"
                TSVariableName  = "vr_ImageStatus"
                DataType        = "String"
                Value           = ""
            }
            212 = @{
                WMIName         = "Validation_WindowsLicenseActivation"
                TSVariableName  = "vr_Validation_WindowsLicenseActivation"
                DataType        = "String"
                Value           = ""
            }
            213 = @{
                WMIName         = "Validation_HardwareErrors"
                TSVariableName  = "vr_Validation_HardwareErrors"
                DataType        = "String"
                Value           = ""
            }
            214 = @{
                WMIName         = "Validation_HardwareTotal"
                TSVariableName  = "vr_Validation_HardwareTotal"
                DataType        = "String"
                Value           = ""
            }
            215 = @{
                WMIName         = "Validation_HardwareStatus"
                TSVariableName  = "vr_Validation_HardwareStatus"
                DataType        = "String"
                Value           = ""
            }
            216 = @{
                WMIName         = "Logging_NetworkRepository"
                TSVariableName  = "vr_Logging_NetworkRepository"
                DataType        = "String"
                Value           = ""
            }

            <# VividRock - Light Touch Interface (LTI) Values #>
            301 = @{
                WMIName         = "LTI_ComputerName"
                TSVariableName  = "vr_LTI_ComputerName"
                DataType        = "String"
                Value           = ""
            }
            302 = @{
                WMIName         = "LTI_BuildType"
                TSVariableName  = "vr_LTI_BuildType"
                DataType        = "String"
                Value           = ""
            }
            303 = @{
                WMIName         = "LTI_OperatingSystem"
                TSVariableName  = "vr_LTI_OperatingSystem"
                DataType        = "String"
                Value           = ""
            }
            304 = @{
                WMIName         = "LTI_AssignedUser"
                TSVariableName  = "vr_LTI_AssignedUser"
                DataType        = "String"
                Value           = ""
            }
            305 = @{
                WMIName         = "LTI_Site"
                TSVariableName  = "vr_LTI_Site"
                DataType        = "String"
                Value           = ""
            }
            306 = @{
                WMIName         = "LTI_ActiveDirectoryOU"
                TSVariableName  = "vr_LTI_ActiveDirectoryOU"
                DataType        = "String"
                Value           = ""
            }
            307 = @{
                WMIName         = "LTI_TimeZone"
                TSVariableName  = "vr_LTI_TimeZone"
                DataType        = "String"
                Value           = ""
            }
        }

    # Arrays

    # Registry

    # WMI
        $WMI_01 = @{
            "Namespace"     = "root\CIMv2"
            "RootName"      = $Param_NamespaceRoot
            "ChildName"     = $Param_NamespaceChild
            "ClassName"     = $Param_Prefix + "_" + $Param_ClassName
            "Path"          = "root\CIMv2" + "\" + $Param_NamespaceRoot + "\" + $Param_NamespaceChild
        }

    # Datasets

    # Temporary

    # Output to Log
        Write-Host "    - Parameters"
        foreach ($Item in (Get-Variable -Name "Param_*")) {
            Write-Host "        $(($Item.Name) -replace 'Param_',''): $($Item.Value)"
        }

        Write-Host "    - Tattoo Properties"
        foreach ($Item in $HashTable_TattooProperties.GetEnumerator()) {
            Write-Host "        WMIName: $($Item.Value.WMIName)"
            Write-Host "        TSVariableName: $($Item.Value.TSVariableName)"
            Write-Host "        DataType: $($Item.Value.DataType)"
            Write-Host "        Value: $($Item.Value.Value)"
            Write-Host ""
        }

        Write-Host "    - WMI"
        foreach ($Item in (Get-Variable -Name "WMI_0*")) {
            Write-Host "        Namespace: $($Item.Value.Namespace)"
            Write-Host "        RootName: $($Item.Value.RootName)"
            Write-Host "        ChildName: $($Item.Value.ChildName)"
            Write-Host "        ClassName: $($Item.Value.ClassName)"
            Write-Host "        ConstructedPath: $($Item.Value.ConstructedPath)"
            Write-Host ""
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

    # Gather Property Values
        Write-Host "    - Gather Property Values"

        try {
            foreach ($Item in $HashTable_TattooProperties.GetEnumerator()) {
                Write-Host "        WMIName: $($Item.Value.WMIName)"

                # Determine Value if from Task Sequence Variable or Defined Above
                    if (($Item.Value.TSVariableName -notin "",$null) -and ([bool]$Object_MECM_TSEnvironment -eq $true)) {
                        $Item.Value.Value = $Object_MECM_TSEnvironment.Value("$($Item.Value.TSVariableName)")

                        # Write-Host "            TSVariableName: $($Item.Value.TSVariableName)"
                        # Write-Host "            Value: $($Item.Value.Value)"
                        # Write-Host ""
                    }
                    elseif (($Item.Value.TSVariableName -notin "",$null) -and ([bool]$Object_MECM_TSEnvironment -eq $false)) {
                        $Item.Value.Value = "Error - MECM Task Sequence Environment Not Running"

                        # Write-Host "            TSVariableName: $($Item.Value.TSVariableName)"
                        # Write-Host "            Value: $($Item.Value.Value)"
                        # Write-Host ""
                    }
                    else {
                        # Write-Host "            Value: $($Item.Value.Value)"
                        # Write-Host ""
                    }
            }

            Write-Host "        Status: Success"
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

    # Create Root Namespace
        Write-Host "    - Create Root Namespace"

        try {
            Write-Host "        Namespace: $($WMI_01.Namespace)"
            Write-Host "        RootName: $($WMI_01.RootName)"

            if (Get-WMIObject -Class __Namespace -Namespace $WMI_01.Namespace -Filter "name=`"$($WMI_01.RootName)`"" -ErrorAction Stop) {
                Write-Host "        Status: Already Exists"
            }
            else {
                $Namespace_Class        = [wmiclass]"$($WMI_01.Namespace):__namespace"
                $Namespace_Root        = $Namespace_Class.CreateInstance()
                $Namespace_Root.Name   = $WMI_01.RootName
                $Temp_Result            = $Namespace_Root.Put()

                Write-Host "        Path: $($Temp_Result.NamespacePath)"
                Write-Host "        Status: Success"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
        }

    # Create Child Namespace
        Write-Host "    - Create Child Namespace"

        try {
            Write-Host "        Namespace: $($WMI_01.RootName)"
            Write-Host "        ChildName: $($WMI_01.ChildName)"

            if (Get-CimInstance -Namespace $($WMI_01.Namespace + "\" + $WMI_01.RootName) -ClassName __Namespace -Filter "Name=`"$($WMI_01.ChildName)`"" -ErrorAction Stop) {
                Write-Host "        Status: Already Exists"
            }
            else {
                $Namespace_Class        = [wmiclass]"$($WMI_01.Namespace + "\" + $WMI_01.RootName):__namespace"
                $Namespace_Child        = $Namespace_Class.CreateInstance()
                $Namespace_Child.Name   = $WMI_01.ChildName
                $Temp_Result            = $Namespace_Child.Put()

                Write-Host "        Path: $($Temp_Result.NamespacePath)"
                Write-Host "        Status: Success"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1702 -Exit $true -Object $PSItem
        }

    # Remove Existing Class
        Write-Host "    - Remove Existing Class"

        try {
            Write-Host "        ClassName: $($WMI_01.ClassName)"

            if (Get-CimInstance -Namespace $WMI_01.Path -ClassName $WMI_01.ClassName -ErrorAction SilentlyContinue) {
                Remove-WmiObject -Namespace $WMI_01.Path -Class $WMI_01.ClassName -ErrorAction Stop

                Write-Host "        Status: Success"
            }
            else {
                Write-Host "        Status: Not Exists"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1703 -Exit $true -Object $PSItem
        }

    # Create Class
        Write-Host "    - Create Class"

        try {
            Write-Host "        ClassName: $($WMI_01.ClassName)"
            $Namespace_Class        = [wmiclass]"$($WMI_01.Namespace + "\" + $WMI_01.RootName):__namespace"
            $Namespace_Child        = $Namespace_Class.CreateInstance()
            $Namespace_Child.Name   = $WMI_01.ChildName
            $Temp_Result            = $Namespace_Child.Put()

            Write-Host "        Path: $($Temp_Result.NamespacePath)"
            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1704 -Exit $true -Object $PSItem
        }

    # Configure Class
        Write-Host "    - Configure Class"

        # Initialize Class Object
            Write-Host "        Initialize Class Object"

            try {
                $Object_WMI_Class = New-Object System.Management.ManagementClass ($WMI_01.Path, [String]::Empty, $null) -ErrorAction Stop
                $Object_WMI_Class["__Class"] = $WMI_01.ClassName

                Write-Host "            Status: Success"
            }
            catch {
                Write-vr_ErrorCode -Code 1705 -Exit $true -Object $PSItem
            }

        # Add Properties to Class Object
            Write-Host "        Add Properties to Class Object"

            try {
                $Object_WMI_Class.Qualifiers.Add("Static", $true)

                foreach ($Item in $HashTable_TattooProperties.GetEnumerator()) {
                    $Object_WMI_Class.Properties.Add("$($Item.Value.WMIName)", [System.Management.CimType]::$($Item.Value.DataType), $false)
                    Write-Host "            $($Item.Value.WMIName)"
                }

                Write-Host "            Status: Success"
            }
            catch {
                Write-vr_ErrorCode -Code 1706 -Exit $true -Object $PSItem
            }

        # Declare Key(s) in Class Object
            Write-Host "        Declare Key(s) in Class Object"

            try {
                $Object_WMI_Class.Properties["Name"].Qualifiers.Add("Key", $true)

                Write-Host "            Status: Success"
            }
            catch {
                Write-vr_ErrorCode -Code 1707 -Exit $true -Object $PSItem
            }

        # Put WMI Class Object
            Write-Host "        Put WMI Class Object"

            try {
                $Object_WMI_Class.Put() | Out-Null

                Write-Host "            Status: Success"
            }
            catch {
                Write-vr_ErrorCode -Code 1708 -Exit $true -Object $PSItem
            }

    # Remove Duplicate Instance
        Write-Host "    - Remove Duplicate Instance"

        try {
            $Temp_WMI_Instance_Duplicates = Get-CimInstance -Namespace $WMI_01.Path -Query "SELECT * FROM $($WMI_01.ClassName) WHERE Name = '$($HashTable_TattooProperties."Key".Value)'" -ErrorAction Stop
            if ($Temp_WMI_Instance_Duplicates) {
                $Temp_WMI_Instance_Duplicates | Remove-CimInstance -ErrorAction Stop
                Write-Host "        Status: Success"
            }
            else {
                Write-Host "        Status: Not Exists"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1709 -Exit $true -Object $PSItem
        }

    # Construct Splatting Table
        Write-Host "    - Construct Splatting Table"

        try {
            $Temp_SplatTable_Properties = @{}

            foreach ($Item in $HashTable_TattooProperties.GetEnumerator()) {
                $Temp_SplatTable_Properties += @{$($Item.Value.WMIName) = $($Item.Value.Value)}

                $Object_WMI_Class.Properties.Add("$($Item.Value.WMIName)", [System.Management.CimType]::$($Item.Value.DataType), $false)
            }

            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1710 -Exit $true -Object $PSItem
        }

    # Write Instance
        Write-Host "    - Write Instance"

        try {
            Set-WmiInstance -Namespace $WMI_01.Path -Class $WMI_01.ClassName -Argument $Temp_SplatTable_Properties -ErrorAction Stop | Out-Null

            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1711 -Exit $true -Object $PSItem
        }

    # Determine Script Execution
        $Meta_Script_Success = $true

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

    # Property/Value Pairs
        Write-Host "    - Property/Value Pairs"

        try {
            foreach ($Item in $HashTable_TattooProperties.GetEnumerator()) {
                Write-Host "            $($Item.Value.WMIName) = $($Item.Value.Value)"
            }

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

    # # Remove WMI Entries (Testing Only)
    #     Write-Host "    - Remove WMI Entries (Testing Only)"

    #     try {
    #         if ($Temp_Cleanup_UserInput -in "Y", "Yes") {
    #             # Remove All Instances
    #                 Get-CimInstance -Namespace $WMI_01.Path -ClassName $WMI_01.ClassName | Remove-CimInstance

    #             # Remove Child Namespace
    #                 Get-WMIObject -Query "Select * From __Namespace Where Name='$($WMI_01.ChildName)'" -Namespace $($WMI_01.Namespace + "\" + $WMI_01.RootName) | Remove-WmiObject

    #             # Remove Root Namespace
    #                 Get-WmiObject -Query "Select * From __Namespace Where Name='$($WMI_01.RootName)'" -Namespace $WMI_01.Namespace | Remove-WmiObject
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
        Write-Host "  Script Result: $($Meta_Script_Success)"
        Write-Host "  Script Started: $($Meta_Script_Start_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
        Write-Host "  Script Completed: $($Meta_Script_Complete_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
        Write-Host "  Total Time: $($Meta_Script_Complete_TimeSpan.Days) days, $($Meta_Script_Complete_TimeSpan.Hours) hours, $($Meta_Script_Complete_TimeSpan.Minutes) minutes, $($Meta_Script_Complete_TimeSpan.Seconds) seconds, $($Meta_Script_Complete_TimeSpan.Milliseconds) milliseconds"
        Write-Host "------------------------------------------------------------------------------"
        Write-Host "  End of Script"
        Write-Host "------------------------------------------------------------------------------"

#EndRegion Footer
#--------------------------------------------------------------------------------------------

Return $Meta_Script_Success
Stop-Transcript