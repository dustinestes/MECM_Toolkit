#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$Source="VR - Boot - Win11 - v1.3",                # 'VR - Boot - Win11 - 1.0'
    [string]$Target="VR - Boot - Win11 - v1.4"                 # 'VR - Boot - Win11 - 1.1'
)

#--------------------------------------------------------------------------------------------
# Start-Transcript -Path "C:\VividRock\MECM Toolkit\Logs\Task Sequences\Boot Images - Copy Boot Image.log"  -Append -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  VividRock - MECM Toolkit - Task Sequences - Boot Images - Copy Boot Image"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       May 09, 2024"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    This script will create a copy of an existing Boot Image and"
    Write-Host "                include drivers, optional components, and settings from source."
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
        $Param_Source = $Source
        $Param_Target = $Target

    # Metadata
        $Meta_Script_Start_DateTime     = Get-Date
        $Meta_Script_Complete_DateTime  = $null
        $Meta_Script_Complete_TimeSpan  = $null
        $Meta_Script_Result = $false,"Failure"

    # Names
        $Name_BootImage_Target      = "$($Param_Target).wim"

    # Paths

    # Files

    # Hashtables

    # Arrays

    # Registry

    # WMI

    # Datasets
        $Dataset_WinPE_OptionalComponents = @"
UniqueID,Architecture,ComponentID,Name,MsiComponentID,Size,IsRequired,IsManageable
1,x86,1,WinPE-DismCmdlets,{72BF9B2E-32B2-ED9A-2A97-628597F4FC91},36698,0,1
2,x86,2,WinPE-Dot3Svc,{243F6A24-7A6B-35E4-01FD-13C6644E4216},2014250,0,1
3,x86,3,WinPE-EnhancedStorage,{5E610D7A-4DC4-1325-B18F-9C10A1CF2E9F},73162,0,1
4,x86,4,WinPE-FMAPI,{1D7E6EFD-B249-8A16-8A84-F0EE9EC9FD23},34409,0,1
5,x86,5,WinPE-FontSupport-JA-JP,{28418ED5-10EB-F0D4-BDFC-45BE8FDB8DC9},9948551,0,1
6,x86,6,WinPE-FontSupport-KO-KR,{6B8E1A8E-5D6E-E13A-2E19-A043F69E9DD0},9074170,0,1
7,x86,7,WinPE-FontSupport-ZH-CN,{0596E0B2-E13B-0F22-214F-4638C051B0D0},34203154,0,1
8,x86,8,WinPE-FontSupport-ZH-HK,{1434430A-83D9-EDB9-2F94-E2DC41578AFF},34469028,0,1
9,x86,9,WinPE-FontSupport-ZH-TW,{B846DE46-A54C-AAE2-D586-E26328763913},34471838,0,1
10,x86,10,WinPE-HTA,{3A96A4AE-37B2-D6A6-2B94-D42E1126DDE0},16176034,0,1
11,x86,11,WinPE-StorageWMI,{6A6ED63F-4D74-9CE4-F837-E4739078929F},658901,0,1
12,x86,12,WinPE-LegacySetup,{09738FD6-54D3-D564-ED61-BD664CC47377},8690987,0,1
13,x86,13,WinPE-MDAC,{DD7BC9BA-D17F-471A-0A84-F7B1A23CD173},7485163,0,1
14,x86,14,WinPE-NetFx,{5CFD65BB-E857-3E47-6887-D5DEC46794D4},48743987,0,1
15,x86,15,WinPE-PowerShell,{822D6597-8C61-2739-4EC7-615239CC7CAD},2477671,0,1
16,x86,16,WinPE-PPPoE,{B073CABA-6889-F6C2-069F-7579FD402011},340362,0,1
17,x86,17,WinPE-RNDIS,{3F41F3CD-E8EA-CB5A-22ED-A21D7CF8D1D5},53432,0,1
18,x86,18,WinPE-Scripting,{B8F9E5F3-4E61-55D1-293E-4BE32343C2F1},1643306,1,1
19,x86,19,WinPE-SecureStartup,{AB289C01-3011-2940-5086-196BFB78D7E5},324174,1,1
20,x86,20,WinPE-Setup,{04B1AB1E-59B4-4289-D412-F8A4000D454C},5057400,0,1
21,x86,21,WinPE-Setup-Client,{9852CE41-DB19-E30D-9EFD-26BF061FFA4E},340728,0,1
22,x86,22,WinPE-Setup-Server,{587C3C78-1A07-60E5-EF69-1BC0A7DDA13E},313178,0,1
24,x86,24,WinPE-WDS-Tools,{0D457803-61E3-086D-D845-9DAF751D344A},714289,1,1
25,x86,25,WinPE-WinReCfg,{134498DE-4815-E451-CE55-489019AE2D8E},141201,0,1
26,x86,26,WinPE-WMI,{26B001FA-1882-2B2E-E681-4ADF5F3A8F9D},5057946,1,1
27,x64,1,WinPE-DismCmdlets,{62931F4E-3F1F-1B7C-8F83-4FFC4D1CEBCC},36646,0,1
28,x64,2,WinPE-Dot3Svc,{ECB8D6D9-34FB-005B-25B0-0A1A89340D08},2187280,0,1
29,x64,3,WinPE-EnhancedStorage,{57FB09F5-D906-D0CA-E2B1-47BD9C13C686},82868,0,1
30,x64,4,WinPE-FMAPI,{085214B8-5B97-5002-476F-233DDA3708AF},40445,0,1
31,x64,5,WinPE-FontSupport-JA-JP,{7A697ABB-4476-0F2D-E035-61E0BF828D6C},9952081,0,1
32,x64,6,WinPE-FontSupport-KO-KR,{B4B33C99-6BE4-6AE6-2C9C-DE6D150C0276},9075188,0,1
33,x64,7,WinPE-FontSupport-ZH-CN,{8AE02513-7D17-D24D-0D4E-540F85DC70A5},34209064,0,1
34,x64,8,WinPE-FontSupport-ZH-HK,{4574D6FF-D7E1-B546-8929-1035A7D5C0ED},34464544,0,1
35,x64,9,WinPE-FontSupport-ZH-TW,{86CFAC3B-224C-A45F-D77D-09225DDBECAE},34465138,0,1
36,x64,10,WinPE-HTA,{11C412FB-F8A6-79D5-78D4-81382E4FEC08},17557652,0,1
37,x64,11,WinPE-StorageWMI,{3C9A7965-2B54-E080-0153-0BB3AB236F1B},730857,0,1
38,x64,12,WinPE-LegacySetup,{73688532-B276-1ECD-1CA3-A0C4369F0987},9249253,0,1
39,x64,13,WinPE-MDAC,{85E22609-5679-0229-E579-806C25209373},6764682,0,1
40,x64,14,WinPE-NetFx,{B06FDA9B-1B4B-392D-0E35-C7B958511C7F},95885913,0,1
41,x64,15,WinPE-PowerShell,{502F1BDF-450B-3984-9760-00CCB00BE5D4},2494662,0,1
42,x64,16,WinPE-PPPoE,{4476EA7D-5E3C-FBA6-B958-3CE328A2A0C9},368912,0,1
43,x64,17,WinPE-RNDIS,{10E2D895-3D0F-3D94-AF3A-5D6656BC1BAB},58762,0,1
44,x64,18,WinPE-Scripting,{38098938-CE09-1840-EAA3-41B03E695FE0},1885924,1,1
45,x64,19,WinPE-SecureStartup,{510411DA-AA23-9E33-5CFD-504ED7FFA601},353092,1,1
46,x64,20,WinPE-Setup,{39B49063-502A-EA03-B893-00FE8E254ACA},5867382,0,1
47,x64,21,WinPE-Setup-Client,{39876CB5-BC0D-9C80-82FD-632378FB89E7},340734,0,1
48,x64,22,WinPE-Setup-Server,{0CF121EE-1BCE-412E-929E-5502A16A174C},313478,0,1
50,x64,24,WinPE-WDS-Tools,{17E3D294-6E5A-9648-549E-49DAB99D40D2},850043,1,1
51,x64,25,WinPE-WinReCfg,{E523FD39-D3C8-472E-F9EB-01ADAC7DA244},161101,0,1
52,x64,26,WinPE-WMI,{B8EAEE82-43F0-D406-42DE-F467974EB651},5942808,1,1
53,x86,14,WinPE-NetFx4,{5CFD65BB-E857-3E47-6887-D5DEC46794D4},48743987,0,1
54,x86,15,WinPE-PowerShell3,{822D6597-8C61-2739-4EC7-615239CC7CAD},2477671,0,1
55,x64,14,WinPE-NetFx4,{B06FDA9B-1B4B-392D-0E35-C7B958511C7F},95885913,0,1
56,x64,15,WinPE-PowerShell3,{502F1BDF-450B-3984-9760-00CCB00BE5D4},2494662,0,1
57,x86,16,WinPE-SecureBootCmdlets,{26EC396C-4C75-46E1-8818-C647231140FA},23391,0,1
58,x64,16,WinPE-SecureBootCmdlets,{C031D6AB-E1F3-4E71-B039-34BA5C83999D},23377,0,1
59,arm64,1,WinPE-DismCmdlets,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},57676,0,1
60,arm64,2,WinPE-Dot3Svc,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},1090934,0,1
61,arm64,3,WinPE-EnhancedStorage,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},84733,0,1
62,arm64,4,WinPE-FMAPI,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},37607,0,1
63,arm64,5,WinPE-FontSupport-JA-JP,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},20986042,0,1
64,arm64,6,WinPE-FontSupport-KO-KR,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},10430335,0,1
65,arm64,7,WinPE-FontSupport-ZH-CN,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},35624514,0,1
66,arm64,8,WinPE-FontSupport-ZH-HK,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},30754509,0,1
67,arm64,9,WinPE-FontSupport-ZH-TW,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},30755277,0,1
68,arm64,11,WinPE-StorageWMI,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},705326,0,1
69,arm64,12,WinPE-LegacySetup,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},8132234,0,1
70,arm64,13,WinPE-MDAC,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},5344330,0,1
71,arm64,14,WinPE-NetFx,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},220919,0,1
72,arm64,15,WinPE-PowerShell,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},3075217,0,1
73,arm64,16,WinPE-PPPoE,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},363822,0,1
74,arm64,17,WinPE-RNDIS,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},38594,0,1
75,arm64,18,WinPE-Scripting,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},4786733,1,1
76,arm64,19,WinPE-SecureStartup,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},693453,1,1
77,arm64,20,WinPE-Setup,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},11429565,0,1
78,arm64,21,WinPE-Setup-Client,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},136402,0,1
79,arm64,22,WinPE-Setup-Server,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},142074,0,1
80,arm64,24,WinPE-WDS-Tools,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},947553,1,1
81,arm64,25,WinPE-WinReCfg,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},218323,0,1
82,arm64,26,WinPE-WMI,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},5605477,1,1
83,arm64,16,WinPE-SecureBootCmdlets,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},23111,0,1
"@
    $Dataset_WinPE_OptionalComponents = $Dataset_WinPE_OptionalComponents | ConvertFrom-Csv

    # Temporary

    # Output to Log
        Write-Host "    - Parameters"
        foreach ($Item in (Get-Variable -Name "Param_*")) {
            Write-Host "        $(($Item.Name) -replace 'Param_',''): $($Item.Value)"
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

    # Write-Host "  Environment"

    # # Create TSEnvironment COM Object
    #     Write-Host "    - Create TSEnvironment COM Object"

    #     try {
    #         $Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
    #         Write-Host "        Status: Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1401 -Exit $true -Object $PSItem
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Environment
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validation
#   Error Range: 1500 - 1599
#--------------------------------------------------------------------------------------------
#Region Validation

    Write-Host "  Validation"

    # Source Boot Image
        Write-Host "    - Source Boot Image"

        try {
            Write-Host "        Name: $($Param_Source)"
            $Object_BootImage_Source = Get-CMBootImage -Name $Param_Source -ErrorAction Stop

            if ($Object_BootImage_Source) {
                Write-Host "        Path: $($Object_BootImage_Source.ImagePath)"
                Write-Host "        Package ID: $($Object_BootImage_Source.PackageID)"
                Write-Host "        OS Version: $($Object_BootImage_Source.ImageOSVersion)"
                Write-Host "        Language: $($Object_BootImage_Source.Language)"
                Write-Host "        Client Version: $($Object_BootImage_Source.ProductionClientVersion)"
                Write-Host "        Optional Components: $($Object_BootImage_Source.OptionalComponents.Count)"
                Write-Host "        Referenced Drivers: $($Object_BootImage_Source.ReferencedDrivers.Count)"
                Write-Host "        Scratch Space: $($Object_BootImage_Source.ScratchSpace)"
            }
            else {
                throw "A Boot Image with that name does not exist."
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
        }

    # Target Boot Image
        Write-Host "    - Target Boot Image"

        try {
            Write-Host "        Name: $($Param_Target)"
            $Object_BootImage_Target = Get-CMBootImage -Name $Param_Target -ErrorAction Stop

            if ($Object_BootImage_Target) {
                throw "A Boot Image with that name exists."
            }
            else {
                Write-Host "        Status: Not Exists"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1502 -Exit $true -Object $PSItem
        }

    # Source Boot WIM File
        Write-Host "    - Source Boot WIM File"

        try {
            Write-Host "        Path: $($Object_BootImage_Source.ImagePath)"

            # Create PSDrive
                if ((Get-PSDrive -Name "vr_BootImages" -ErrorAction SilentlyContinue) -in "", $null) {
                    New-PSDrive -Name "vr_BootImages" -PSProvider FileSystem -Root ($Object_BootImage_Source.ImagePath | Split-Path) -ErrorAction Stop | Out-Null
                }

            # Check for File Existence
                if (Test-Path -Path "vr_BootImages:\$($Object_BootImage_Source.ImagePath | Split-Path -Leaf)" -ErrorAction Stop) {
                    Write-Host "        Status: Exists"
                }
                else {
                    throw "A Boot WIM with that name exists."
                }
        }
        catch {
            Write-vr_ErrorCode -Code 1503 -Exit $true -Object $PSItem
        }
        finally {
            # Cleanup
                Remove-PSDrive -Name "vr_BootImages" -Force
        }

    # Target Boot WIM File
        Write-Host "    - Target Boot WIM File"

        try {
            Write-Host "        Path: $(($Object_BootImage_Source.ImagePath | Split-Path) + "\" + $Name_BootImage_Target)"

            # Create PSDrive
                if ((Get-PSDrive -Name "vr_BootImages" -ErrorAction SilentlyContinue) -in "", $null) {
                    New-PSDrive -Name "vr_BootImages" -PSProvider FileSystem -Root ($Object_BootImage_Source.ImagePath | Split-Path) -ErrorAction Stop | Out-Null
                }

            # Check for File Existence
                if (Test-Path -Path "vr_BootImages:\$($Param_Target)" -ErrorAction Stop) {
                    throw "A Boot WIM with that name exists."
                }
                else {
                    Write-Host "        Status: Not Exists"
                }
        }
        catch {
            Write-vr_ErrorCode -Code 1503 -Exit $true -Object $PSItem
        }
        finally {
            # Cleanup
                Remove-PSDrive -Name "vr_BootImages" -Force
        }





    # Sub Directories
        Write-Host "    - Sub Directories"

        try {
            foreach ($Item in (Get-Variable -Name "Path_Local_*")) {
                Write-Host "        Path: $($Item.Value)"
                if (Test-Path -Path $Item.Value) {
                    Write-Host "            Status: Exists"
                }
                else {
                    New-Item -Path $Item.Value -ItemType Directory -Force -ErrorAction Stop | Out-Null
                    Write-Host "            Status: Created"
                }
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
# Data Gather
#   Error Range: 1600 - 1699
#--------------------------------------------------------------------------------------------
#Region Data Gather

    Write-Host "  Data Gather"

    # [StepName]
        Write-Host "    - [StepName]"

        try {

            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
        }

    # [StepName]
        foreach ($Item in (Get-Variable -Name "Path_*")) {
            Write-Host "    - $($Item.Name)"

            try {

                Write-Host "        Status: Success"
            }
            catch {
                Write-vr_ErrorCode -Code 1602 -Exit $true -Object $PSItem
            }
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

    # [StepName]
        Write-Host "    - [StepName]"

        try {

            Write-Host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
        }

    # [StepName]
        foreach ($Item in (Get-Variable -Name "Path_*")) {
            Write-Host "    - $($Item.Name)"

            try {

                Write-Host "        Status: Success"
            }
            catch {
                Write-vr_ErrorCode -Code 1702 -Exit $true -Object $PSItem
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

    Write-Host "  Output"

    # [StepName]
        Write-Host "    - [StepName]"

        try {

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

    Write-Host "  Cleanup"

    # Confirm Cleanup
        Write-Host "    - Confirm Cleanup"

        do {
            $Temp_Cleanup_UserInput = Read-Host -Prompt "        Do you want to automatically clean up the unecessary content from this script? [Y]es or [N]o" -ErrorAction Stop
        } until (
            $Temp_Cleanup_UserInput -in "Y","Yes","N","No"
        )

    # [StepName]
        Write-Host "    - [StepName]"

        try {
            if ($Temp_Cleanup_UserInput -in "Y", "Yes") {

                Write-Host "        Status: Success"
            }
            else {
                Write-Host "            Status: Skipped"
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1901 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

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