#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

# param (
    [string]$ParamName                # [ExampleInputValues]
# )

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  Task Sequence Toolkit - Tattoo - WMI Method"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       October 07, 2017"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    Tattoos the WMI/CIM of a Windows device for easy reporting."
    Write-Host "    Links:      None"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""

#EndRegion Header
#--------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------
# Create COM Objects
#--------------------------------------------------------------------------------------------
#Region

    Write-Host "  Create COM Objects"

    # Create TS Environment COM Object
        Write-Host "    - MECM Task Sequence Environment: " -NoNewline
        if (Get-Process -Name TSManager -ErrorAction SilentlyContinue) {
            try {
                $Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
                Write-Host "Success" -ForegroundColor Green
            }
            catch {
                Write-Host "Error: Could not create COM Object" -ForegroundColor Red
                Write-Host "          $($PSItem.Exception)"
                Exit 1000
            }
            $TSEnvironment_Exists = $true
        }
        else {
            Write-Host "Skipped: Not Running in Task Sequence" -ForegroundColor DarkGray
            $TSEnvironment_Exists = $false
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Create COM Objects


#--------------------------------------------------------------------------------------------
# Variables
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Variables

    Write-Host "  Variables"

    # WMI Structure Hash Table
        Write-Host "    - WMI Structure Hash Table: " -NoNewline
        $HashTable_WMIStructure = @{
            "Namespace"     = "root\CIMv2"
            "RootName"      = "VividRock"
            "ChildName"     = "TaskSequenceToolkit"
            "ClassName"     = "WindowsImage"
            "Path"          = ""
        }

        # Load TS Environment Values if Exist
            if ($TSEnvironment_Exists -eq $true) {
                # Update RootName if Value Defined
                    if (($Object_MECM_TSEnvironment.Value("vr_Organization_Name")) -notin "",$null) {
                        $HashTable_WMIStructure.RootName = $Object_MECM_TSEnvironment.Value("vr_Organization_Name")
                    }

                # Update Child Namespace Nam if Exist
                    if (($Object_MECM_TSEnvironment.Value("vr_Organization_CustomWMINamespace")) -notin "",$null) {
                        $HashTable_WMIStructure.ChildName = $Object_MECM_TSEnvironment.Value("vr_Organization_CustomWMINamespace")
                    }
            }

        # Construct Path from Values
            $HashTable_WMIStructure.Path = $($HashTable_WMIStructure.Namespace) + "\" + $($HashTable_WMIStructure.RootName) + "\" + $($HashTable_WMIStructure.ChildName)

            Write-Host "Success" -ForegroundColor Green

    # Tattoo Properties Hash Table
        Write-Host "    - Tattoo Properties Hash Table" -NoNewline
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
                TSVariableName  = "_SMSTSIPAddresses"
                DataType        = "String"
                Value           = ""
            }
            118 = @{
                WMIName         = "Net_DefaultGateways"
                TSVariableName  = "_SMSTSDefaultGateways"
                DataType        = "String"
                Value           = ""
            }
            119 = @{
                WMIName         = "Net_MacAddresses"
                TSVariableName  = "_SMSTSMacAddresses"
                DataType        = "String"
                Value           = ""
            }
            120 = @{
                WMIName         = "TS_RebootCount"
                TSVariableName  = "_OSDRebootCount"
                DataType        = "String"
                Value           = ""
            }

            <# VvividRock - Task Sequence Toolkit Values #>
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

            <# VvividRock - Light Touch Interface (LTI) Values #>
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
        Write-Host "          Success" -ForegroundColor Green

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



    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Validation
#--------------------------------------------------------------------------------------------



#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1600 - 1699
#--------------------------------------------------------------------------------------------
#Region Execution

    Write-Host "  Create WMI Structure"

    # Create Root Namespace
        Write-Host "    - Create Root Namespace: " -NoNewline
        if (Get-WMIObject -Class __Namespace -Namespace $HashTable_WMIStructure.Namespace -Filter "name=`"$($HashTable_WMIStructure.RootName)`"") {
            Write-Host "Already Exists" -ForegroundColor DarkGray
        }
        else {
            try {
                $Namespace_Class        = [wmiclass]"$($HashTable_WMIStructure.Namespace):__namespace"
                $Namespace_Root         = $Namespace_Class.CreateInstance()
                $Namespace_Root.Name    = $HashTable_WMIStructure.RootName
                $Result = $Namespace_Root.Put()
                Write-Host "Success" -ForegroundColor Green
                Write-Host "          Name: $($HashTable_WMIStructure.RootName)"
                Write-Host "          Path: "$Result.NamespacePath
            }
            catch {
                Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
            }
        }

    # Create Child Namespace
        Write-Host "    - Create Child Namespace: " -NoNewline
        if (Get-CimInstance -Namespace $($HashTable_WMIStructure.Namespace + "\" + $HashTable_WMIStructure.RootName) -ClassName __Namespace -Filter "Name = '$($HashTable_WMIStructure.ChildName)'") {
            Write-Host "Already Exists" -ForegroundColor DarkGray
        }
        else {
            try {
                $Namespace_Class        = [wmiclass]"$($HashTable_WMIStructure.Namespace + "\" + $HashTable_WMIStructure.RootName):__namespace"
                $Namespace_Child        = $Namespace_Class.CreateInstance()
                $Namespace_Child.Name   = $HashTable_WMIStructure.ChildName
                $Result                 = $Namespace_Child.Put()
                Write-Host "Success" -ForegroundColor Green
                Write-Host "          Name: $($HashTable_WMIStructure.ChildName)"
                Write-Host "          Path: "$Result.NamespacePath
            }
            catch {
                Write-vr_ErrorCode -Code 1602 -Exit $true -Object $PSItem
            }
        }

        Write-Host "    - Complete"
        Write-Host ""

    Write-Host "  Create WMI Class"

    # Check if Exists
        Write-Host "    - Check if Exists: " -NoNewline
        if (Get-WmiObject -Namespace $HashTable_WMIStructure.Path -Class $HashTable_WMIStructure.ClassName -List) {
            Write-Host "Found" -ForegroundColor DarkGray
            $Class_Exists = $true

            # Remove Class
                try {
                    Write-Host "          Remove Class: " -NoNewline
                    Remove-WmiObject -Namespace $HashTable_WMIStructure.Path -Class $HashTable_WMIStructure.ClassName -ErrorAction SilentlyContinue
                    Write-Host "Success" -ForegroundColor Green
                    $Class_Exists = $false
                }
                catch {
                    Write-vr_ErrorCode -Code 1603 -Exit $true -Object $PSItem
                }
        }
        else {
            Write-Host "Not Found" -ForegroundColor Green
            $Class_Exists = $false
        }

    # Create Class
        if ($Class_Exists -eq $false) {
            Write-Host "    - Create Class: " -NoNewline
            try {
                $Namespace_Class        = [wmiclass]"$($HashTable_WMIStructure.Namespace + "\" + $HashTable_WMIStructure.RootName):__namespace"
                $Namespace_Child        = $Namespace_Class.CreateInstance()
                $Namespace_Child.Name   = $HashTable_WMIStructure.ChildName
                $Result                 = $Namespace_Child.Put()
                Write-Host "Success" -ForegroundColor Green
                Write-Host "          Name: $($HashTable_WMIStructure.ClassName)"
            }
            catch {
                Write-vr_ErrorCode -Code 1604 -Exit $true -Object $PSItem
            }
        }

    # Configure Class
        if ($Class_Exists -eq $false) {
            Write-Host "    - Configure Class"

        # Initialize Class Object
            Write-Host "          Initialize Class Object: " -NoNewline
            try {
                $Class_NewObject = New-Object System.Management.ManagementClass ($HashTable_WMIStructure.Path, [String]::Empty, $null) -ErrorAction Stop
                $Class_NewObject["__Class"] = $HashTable_WMIStructure.ClassName
                Write-Host "Success" -ForegroundColor Green
            }
            catch {
                Write-vr_ErrorCode -Code 1605 -Exit $true -Object $PSItem
            }

        # Add Properties to Class Object
            Write-Host "          Add Properties to Class Object " #-NoNewline
            try {
                $Class_NewObject.Qualifiers.Add("Static", $true)

                foreach ($Key in $HashTable_TattooProperties.Keys) {
                    foreach ($SubHashTable in ($HashTable_TattooProperties[$Key])) {
                        $Class_NewObject.Properties.Add("$($SubHashTable.WMIName)", [System.Management.CimType]::$($SubHashTable.DataType), $false)
                        Write-Host "             "$SubHashTable.WMIName
                    }
                }
                #Write-Host "Success" -ForegroundColor Green
            }
            catch {
                Write-vr_ErrorCode -Code 1606 -Exit $true -Object $PSItem
            }

        # Declare Key(s) in Class Object
            Write-Host "          Declare Key(s) in Class Object: " -NoNewline
            try {
                $Class_NewObject.Properties["Name"].Qualifiers.Add("Key", $true)
                Write-Host "Success" -ForegroundColor Green
            }
            catch {
                Write-vr_ErrorCode -Code 1607 -Exit $true -Object $PSItem
            }

        # Put WMI Class Object
            Write-Host "          Put WMI Class Object: " -NoNewline
            try {
                $Class_NewObject.Put() | Out-Null
                Write-Host "Success" -ForegroundColor Green
            }
            catch {
                Write-vr_ErrorCode -Code 1608 -Exit $true -Object $PSItem
            }
        }

    Write-Host "  Remove Duplicate Instance"

    # Check if Exists
        Write-Host "    - Check if Exists: " -NoNewline
        if (Get-CimInstance -Namespace $HashTable_WMIStructure.Path -Query "SELECT * FROM $($HashTable_WMIStructure.ClassName) WHERE Name = '$($HashTable_TattooProperties."Key".Value)'") {
            Write-Host "Found" -ForegroundColor DarkGray
            $Instance_Exists = $true
        }
        else {
            Write-Host "Not Found" -ForegroundColor Green
            $Instance_Exists = $false
        }

    # Remove Existing Instance
        if ($Instance_Exists -eq $true) {
            Write-Host "    - Remove Existing Instance: " -NoNewline
            try {
                Get-CimInstance -Namespace $HashTable_WMIStructure.Path -Query "SELECT * FROM $($HashTable_WMIStructure.ClassName) WHERE Name = '$($HashTable_TattooProperties."Key".Value)'" | Remove-CimInstance -ErrorAction Stop
                Write-Host "Success" -ForegroundColor Green
            }
            catch {
                Write-vr_ErrorCode -Code 1609 -Exit $true -Object $PSItem
            }
        }

    Write-Host "    - Complete"
    Write-Host ""

    Write-Host "  Add Instance to WMI"

    # Gather Data
        Write-Host "    - Gather Data " #-NoNewline
        foreach ($Key in $HashTable_TattooProperties.Keys) {
            foreach ($SubHashTable in ($HashTable_TattooProperties[$Key])) {
                try {
                    # Determine if Value is from Task Sequence Variable
                        if (($SubHashTable.TSVariableName -notin "",$null) -and ($TSEnvironment_Exists -eq $true)) {
                            $HashTable_TattooProperties[$Key].Value = $Object_MECM_TSEnvironment.Value("$($SubHashTable.TSVariableName)")
                            Write-Host "          $($HashTable_TattooProperties[$Key].WMIName) = $($Object_MECM_TSEnvironment.Value("$($SubHashTable.TSVariableName)"))"
                        }
                        elseif (($SubHashTable.TSVariableName -notin "",$null) -and ($TSEnvironment_Exists -eq $false)) {
                            Write-Host "          $($HashTable_TattooProperties[$Key].WMIName) = " -NoNewline
                            Write-Host " TS Environment Not Running. Can't Retrieve Value." -ForegroundColor DarkGray
                        }
                        else {
                            # Do nothing, the value should already be defined within the hashtable
                        }
                }
                catch {
                    Write-vr_ErrorCode -Code 1610 -Exit $true -Object $PSItem
                }
            }
        }
        #Write-Host "Success" -ForegroundColor Green

    # Construct Property Hashtable
        Write-Host "    - Construct Property Hashtable: " -NoNewline
        $Array_Properties = @{}

        foreach ($Key in $HashTable_TattooProperties.Keys) {
            foreach ($SubHashTable in ($HashTable_TattooProperties[$Key])) {
                try {
                    $Array_Properties += @{$($SubHashTable.WMIName) = $($SubHashTable.Value)}
                }
                catch {
                    Write-vr_ErrorCode -Code 1611 -Exit $true -Object $PSItem
                }
            }
        }
        Write-Host "Success" -ForegroundColor Green

    # Write Instance
        Write-Host "    - Write Instance: " -NoNewline
        try {
            Set-WmiInstance -Namespace $HashTable_WMIStructure.Path -Class $HashTable_WMIStructure.ClassName -Argument $Array_Properties -ErrorAction Stop | Out-Null
            Write-Host "Success" -ForegroundColor Green
        }
        catch {
            Write-vr_ErrorCode -Code 1612 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Write to WMI


<# ---------------------------------------------------------------------------------------------
    Remove WMI Entries (Testing)
------------------------------------------------------------------------------------------------
    Remove the WMI entries and structure. For use when developing or testing.
    COMMENT OUT this section prior to using in production otherwise the tattoo will be removed
------------------------------------------------------------------------------------------------ #>
#Region

    # Write-Host "  Remove WMI Entries (Testing)"

    # # Remove All Instances
    #     # Get-CimInstance -Namespace $HashTable_WMIStructure.Path -ClassName $HashTable_WMIStructure.ClassName | Remove-CimInstance

    # # Remove Child Namespace
    #     Get-WMIObject -Query "Select * From __Namespace Where Name='$($HashTable_WMIStructure.ChildName)'" -Namespace "root\CIMv2\VividRock" | Remove-WmiObject

    # # Remove Root Namespace
    #     Get-WmiObject -Query "Select * From __Namespace Where Name='$($HashTable_WMIStructure.RootName)'" -Namespace "root\CIMv2" | Remove-WmiObject

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Remove WMI Entries (Testing)