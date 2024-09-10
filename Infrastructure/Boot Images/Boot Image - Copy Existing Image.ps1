#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
  [string]$SiteCode,                  # 'ABC'
  [string]$SMSProvider,               # '[ServerFQDN]'
  [string]$SourceName,                # 'VR - Boot - Win11 - 1.0'
  [string]$TargetName,                # 'VR - Boot - Win11 - 1.1'
  [string]$TargetWIM                  # \\[ServerFQDN]\[Share]\[Filename].wim
)

#--------------------------------------------------------------------------------------------
Start-Transcript -Path "C:\VividRock\MECM Toolkit\Logs\Infrastructure\Boot Image - Copy Existing Image.log"  -Append -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

  Write-Host "------------------------------------------------------------------------------"
  Write-Host "  MECM Toolkit - Infrastructure - Boot Image - Copy Existing Image"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host "    Author:     Dustin Estes"
  Write-Host "    Company:    VividRock"
  Write-Host "    Date:       2024-05-09"
  Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
  Write-Host "    Purpose:    This script will mirror the settings of a source Boot Image to"
  Write-Host "                a target Boot Image. This wil include drivers, optional"
  Write-Host "                components, and settings. If the Target Boot Image does not exist"
  Write-Host "                then it will be created."
  Write-Host "    Links:      None"
  Write-Host "    Template:   1.1"
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
    $Param_SourceName       = $SourceName
    $Param_TargetName       = $TargetName
    $Param_TargetWIM        = $TargetWIM

  # Metadata
    $Meta_Script_Start_DateTime     = Get-Date
    $Meta_Script_Complete_DateTime  = $null
    $Meta_Script_Complete_TimeSpan  = $null
    $Meta_Script_Execution_User     = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $Meta_Script_Result = $false,"Failure"

  # Preferences
    $ErrorActionPreference        = "Stop"
    $CMPSSuppressFastNotUsedCheck = $true

  # Names
    $Name_BootImage_Target = "$($Param_TargetName).wim"

  # Paths
    $Path_AdminService_ODataRoute = "https://$($Param_SMSProvider)/AdminService/v1.0/"
    $Path_AdminService_WMIRoute   = "https://$($Param_SMSProvider)/AdminService/wmi/"

  # Files

  # Hashtables
    $Hashtable_BootImage_OptionalComponents = @{
      # UniqueID = Name                 Architecture,ComponentID,MsiComponentID,Size,IsRequired,IsManageable
      "1" = "WinPE-DismCmdlets"           # x86,1,{72BF9B2E-32B2-ED9A-2A97-628597F4FC91},36698,0,1
      "2" = "WinPE-Dot3Svc"               # x86,2,{243F6A24-7A6B-35E4-01FD-13C6644E4216},2014250,0,1
      "3" = "WinPE-EnhancedStorage"       # x86,3,{5E610D7A-4DC4-1325-B18F-9C10A1CF2E9F},73162,0,1
      "4" = "WinPE-FMAPI"                 # x86,4,{1D7E6EFD-B249-8A16-8A84-F0EE9EC9FD23},34409,0,1
      "5" = "WinPE-FontSupport-JA-JP"     # x86,5,{28418ED5-10EB-F0D4-BDFC-45BE8FDB8DC9},9948551,0,1
      "6" = "WinPE-FontSupport-KO-KR"     # x86,6,{6B8E1A8E-5D6E-E13A-2E19-A043F69E9DD0},9074170,0,1
      "7" = "WinPE-FontSupport-ZH-CN"     # x86,7,{0596E0B2-E13B-0F22-214F-4638C051B0D0},34203154,0,1
      "8" = "WinPE-FontSupport-ZH-HK"     # x86,8,{1434430A-83D9-EDB9-2F94-E2DC41578AFF},34469028,0,1
      "9" = "WinPE-FontSupport-ZH-TW"     # x86,9,{B846DE46-A54C-AAE2-D586-E26328763913},34471838,0,1
      "10" = "WinPE-HTA"                  # x86,10,{3A96A4AE-37B2-D6A6-2B94-D42E1126DDE0},16176034,0,1
      "11" = "WinPE-StorageWMI"           # x86,11,{6A6ED63F-4D74-9CE4-F837-E4739078929F},658901,0,1
      "12" = "WinPE-LegacySetup"          # x86,12,{09738FD6-54D3-D564-ED61-BD664CC47377},8690987,0,1
      "13" = "WinPE-MDAC"                 # x86,13,{DD7BC9BA-D17F-471A-0A84-F7B1A23CD173},7485163,0,1
      "14" = "WinPE-NetFx"                # x86,14,{5CFD65BB-E857-3E47-6887-D5DEC46794D4},48743987,0,1
      "15" = "WinPE-PowerShell"           # x86,15,{822D6597-8C61-2739-4EC7-615239CC7CAD},2477671,0,1
      "16" = "WinPE-PPPoE"                # x86,16,{B073CABA-6889-F6C2-069F-7579FD402011},340362,0,1
      "17" = "WinPE-RNDIS"                # x86,17,{3F41F3CD-E8EA-CB5A-22ED-A21D7CF8D1D5},53432,0,1
      "18" = "WinPE-Scripting"            # x86,18,{B8F9E5F3-4E61-55D1-293E-4BE32343C2F1},1643306,1,1
      "19" = "WinPE-SecureStartup"        # x86,19,{AB289C01-3011-2940-5086-196BFB78D7E5},324174,1,1
      "20" = "WinPE-Setup"                # x86,20,{04B1AB1E-59B4-4289-D412-F8A4000D454C},5057400,0,1
      "21" = "WinPE-Setup-Client"         # x86,21,{9852CE41-DB19-E30D-9EFD-26BF061FFA4E},340728,0,1
      "22" = "WinPE-Setup-Server"         # x86,22,{587C3C78-1A07-60E5-EF69-1BC0A7DDA13E},313178,0,1
      "24" = "WinPE-WDS-Tools"            # x86,24,{0D457803-61E3-086D-D845-9DAF751D344A},714289,1,1
      "25" = "WinPE-WinReCfg"             # x86,25,{134498DE-4815-E451-CE55-489019AE2D8E},141201,0,1
      "26" = "WinPE-WMI"                  # x86,26,{26B001FA-1882-2B2E-E681-4ADF5F3A8F9D},5057946,1,1
      "27" = "WinPE-DismCmdlets"          # x64,1,{62931F4E-3F1F-1B7C-8F83-4FFC4D1CEBCC},36646,0,1
      "28" = "WinPE-Dot3Svc"              # x64,2,{ECB8D6D9-34FB-005B-25B0-0A1A89340D08},2187280,0,1
      "29" = "WinPE-EnhancedStorage"      # x64,3,{57FB09F5-D906-D0CA-E2B1-47BD9C13C686},82868,0,1
      "30" = "WinPE-FMAPI"                # x64,4,{085214B8-5B97-5002-476F-233DDA3708AF},40445,0,1
      "31" = "WinPE-FontSupport-JA-JP"    # x64,5,{7A697ABB-4476-0F2D-E035-61E0BF828D6C},9952081,0,1
      "32" = "WinPE-FontSupport-KO-KR"    # x64,6,{B4B33C99-6BE4-6AE6-2C9C-DE6D150C0276},9075188,0,1
      "33" = "WinPE-FontSupport-ZH-CN"    # x64,7,{8AE02513-7D17-D24D-0D4E-540F85DC70A5},34209064,0,1
      "34" = "WinPE-FontSupport-ZH-HK"    # x64,8,{4574D6FF-D7E1-B546-8929-1035A7D5C0ED},34464544,0,1
      "35" = "WinPE-FontSupport-ZH-TW"    # x64,9,{86CFAC3B-224C-A45F-D77D-09225DDBECAE},34465138,0,1
      "36" = "WinPE-HTA"                  # x64,10,{11C412FB-F8A6-79D5-78D4-81382E4FEC08},17557652,0,1
      "37" = "WinPE-StorageWMI"           # x64,11,{3C9A7965-2B54-E080-0153-0BB3AB236F1B},730857,0,1
      "38" = "WinPE-LegacySetup"          # x64,12,{73688532-B276-1ECD-1CA3-A0C4369F0987},9249253,0,1
      "39" = "WinPE-MDAC"                 # x64,13,{85E22609-5679-0229-E579-806C25209373},6764682,0,1
      "40" = "WinPE-NetFx"                # x64,14,{B06FDA9B-1B4B-392D-0E35-C7B958511C7F},95885913,0,1
      "41" = "WinPE-PowerShell"           # x64,15,{502F1BDF-450B-3984-9760-00CCB00BE5D4},2494662,0,1
      "42" = "WinPE-PPPoE"                # x64,16,{4476EA7D-5E3C-FBA6-B958-3CE328A2A0C9},368912,0,1
      "43" = "WinPE-RNDIS"                # x64,17,{10E2D895-3D0F-3D94-AF3A-5D6656BC1BAB},58762,0,1
      "44" = "WinPE-Scripting"            # x64,18,{38098938-CE09-1840-EAA3-41B03E695FE0},1885924,1,1
      "45" = "WinPE-SecureStartup"        # x64,19,{510411DA-AA23-9E33-5CFD-504ED7FFA601},353092,1,1
      "46" = "WinPE-Setup"                # x64,20,{39B49063-502A-EA03-B893-00FE8E254ACA},5867382,0,1
      "47" = "WinPE-Setup-Client"         # x64,21,{39876CB5-BC0D-9C80-82FD-632378FB89E7},340734,0,1
      "48" = "WinPE-Setup-Server"         # x64,22,{0CF121EE-1BCE-412E-929E-5502A16A174C},313478,0,1
      "50" = "WinPE-WDS-Tools"            # x64,24,{17E3D294-6E5A-9648-549E-49DAB99D40D2},850043,1,1
      "51" = "WinPE-WinReCfg"             # x64,25,{E523FD39-D3C8-472E-F9EB-01ADAC7DA244},161101,0,1
      "52" = "WinPE-WMI"                  # x64,26,{B8EAEE82-43F0-D406-42DE-F467974EB651},5942808,1,1
      "53" = "WinPE-NetFx4"               # x86,14,{5CFD65BB-E857-3E47-6887-D5DEC46794D4},48743987,0,1
      "54" = "WinPE-PowerShell3"          # x86,15,{822D6597-8C61-2739-4EC7-615239CC7CAD},2477671,0,1
      "55" = "WinPE-NetFx4"               # x64,14,{B06FDA9B-1B4B-392D-0E35-C7B958511C7F},95885913,0,1
      "56" = "WinPE-PowerShell3"          # x64,15,{502F1BDF-450B-3984-9760-00CCB00BE5D4},2494662,0,1
      "57" = "WinPE-SecureBootCmdlets"    # x86,16,{26EC396C-4C75-46E1-8818-C647231140FA},23391,0,1
      "58" = "WinPE-SecureBootCmdlets"    # x64,16,{C031D6AB-E1F3-4E71-B039-34BA5C83999D},23377,0,1
      "59" = "WinPE-DismCmdlets"          # arm64,1,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},57676,0,1
      "60" = "WinPE-Dot3Svc"              # arm64,2,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},1090934,0,1
      "61" = "WinPE-EnhancedStorage"      # arm64,3,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},84733,0,1
      "62" = "WinPE-FMAPI"                # arm64,4,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},37607,0,1
      "63" = "WinPE-FontSupport-JA-JP"    # arm64,5,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},20986042,0,1
      "64" = "WinPE-FontSupport-KO-KR"    # arm64,6,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},10430335,0,1
      "65" = "WinPE-FontSupport-ZH-CN"    # arm64,7,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},35624514,0,1
      "66" = "WinPE-FontSupport-ZH-HK"    # arm64,8,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},30754509,0,1
      "67" = "WinPE-FontSupport-ZH-TW"    # arm64,9,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},30755277,0,1
      "68" = "WinPE-StorageWMI"           # arm64,11,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},705326,0,1
      "69" = "WinPE-LegacySetup"          # arm64,12,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},8132234,0,1
      "70" = "WinPE-MDAC"                 # arm64,13,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},5344330,0,1
      "71" = "WinPE-NetFx"                # arm64,14,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},220919,0,1
      "72" = "WinPE-PowerShell"           # arm64,15,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},3075217,0,1
      "73" = "WinPE-PPPoE"                # arm64,16,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},363822,0,1
      "74" = "WinPE-RNDIS"                # arm64,17,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},38594,0,1
      "75" = "WinPE-Scripting"            # arm64,18,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},4786733,1,1
      "76" = "WinPE-SecureStartup"        # arm64,19,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},693453,1,1
      "77" = "WinPE-Setup"                # arm64,20,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},11429565,0,1
      "78" = "WinPE-Setup-Client"         # arm64,21,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},136402,0,1
      "79" = "WinPE-Setup-Server"         # arm64,22,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},142074,0,1
      "80" = "WinPE-WDS-Tools"            # arm64,24,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},947553,1,1
      "81" = "WinPE-WinReCfg"             # arm64,25,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},218323,0,1
      "82" = "WinPE-WMI"                  # arm64,26,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},5605477,1,1
      "83" = "WinPE-SecureBootCmdlets"    # arm64,16,{BBF9430A-E5BF-47BE-A57D-A97905FE91F6},23111,0,1
    }

    $Hashtable_BootImage_Languages = @{
      "1025" = "ar-SA"
      "1026" = "bg-BG"
      "1027" = "ca-ES"
      "1028" = "zh-TW"
      "1029" = "cs-CZ"
      "1030" = "da-DK"
      "1031" = "de-DE"
      "1032" = "el-GR"
      "1033" = "en-US"
      "1034" = "es-ES"
      "1035" = "fi-FI"
      "1036" = "fr-FR"
      "1037" = "he-IL"
      "1038" = "hu-HU"
      "1039" = "is-IS"
      "1040" = "it-IT"
      "1041" = "ja-JP"
      "1042" = "ko-KR"
      "1043" = "nl-NL"
      "1044" = "nb-NO"
      "1045" = "pl-PL"
      "1046" = "pt-BR"
      "1047" = "rm-CH"
      "1048" = "ro-RO"
      "1049" = "ru-RU"
      "1050" = "hr-HR"
      "1051" = "sk-SK"
      "1052" = "sq-AL"
      "1053" = "sv-SE"
      "1054" = "th-TH"
      "1055" = "tr-TR"
      "1056" = "ur-PK"
      "1057" = "id-ID"
      "1058" = "uk-UA"
      "1059" = "be-BY"
      "1060" = "sl-SI"
      "1061" = "et-EE"
      "1062" = "lv-LV"
      "1063" = "lt-LT"
      "1064" = "tg-Cyrl-TJ"
      "1065" = "fa-IR"
      "1066" = "vi-VN"
      "1067" = "hy-AM"
      "1068" = "az-Latn-AZ"
      "1069" = "eu-ES"
      "1070" = "wen-DE"
      "1071" = "mk-MK"
      "1072" = "st-ZA"
      "1073" = "ts-ZA"
      "1074" = "tn-ZA"
      "1075" = "ven-ZA"
      "1076" = "xh-ZA"
      "1077" = "zu-ZA"
      "1078" = "af-ZA"
      "1079" = "ka-GE"
      "1080" = "fo-FO"
      "1081" = "hi-IN"
      "1082" = "mt-MT"
      "1083" = "se-NO"
      "1084" = "gd-GB"
      "1085" = "yi"
      "1086" = "ms-MY"
      "1087" = "kk-KZ"
      "1088" = "ky-KG"
      "1089" = "sw-KE"
      "1090" = "tk-TM"
      "1091" = "uz-Latn-UZ"
      "1092" = "tt-RU"
      "1093" = "bn-IN"
      "1094" = "pa-IN"
      "1095" = "gu-IN"
      "1096" = "or-IN"
      "1097" = "ta-IN"
      "1098" = "te-IN"
      "1099" = "kn-IN"
      "1100" = "ml-IN"
      "1101" = "as-IN"
      "1102" = "mr-IN"
      "1103" = "sa-IN"
      "1104" = "mn-MN"
      "1105" = "bo-CN"
      "1106" = "cy-GB"
      "1107" = "km-KH"
      "1108" = "lo-LA"
      "1109" = "my-MM"
      "1110" = "gl-ES"
      "1111" = "kok-IN"
      "1112" = "mni"
      "1113" = "sd-IN"
      "1114" = "syr-SY"
      "1115" = "si-LK"
      "1116" = "chr-US"
      "1117" = "iu-Cans-CA"
      "1118" = "am-ET"
      "1119" = "tmz"
      "1120" = "ks-Arab-IN"
      "1121" = "ne-NP"
      "1122" = "fy-NL"
      "1123" = "ps-AF"
      "1124" = "fil-PH"
      "1125" = "dv-MV"
      "1126" = "bin-NG"
      "1127" = "fuv-NG"
      "1128" = "ha-Latn-NG"
      "1129" = "ibb-NG"
      "1130" = "yo-NG"
      "1131" = "quz-BO"
      "1132" = "nso-ZA"
      "1136" = "ig-NG"
      "1137" = "kr-NG"
      "1138" = "gaz-ET"
      "1139" = "ti-ER"
      "1140" = "gn-PY"
      "1141" = "haw-US"
      "1142" = "la"
      "1143" = "so-SO"
      "1144" = "ii-CN"
      "1145" = "pap-AN"
      "1152" = "ug-Arab-CN"
      "1153" = "mi-NZ"
      "2049" = "ar-IQ"
      "2052" = "zh-CN"
      "2055" = "de-CH"
      "2057" = "en-GB"
      "2058" = "es-MX"
      "2060" = "fr-BE"
      "2064" = "it-CH"
      "2067" = "nl-BE"
      "2068" = "nn-NO"
      "2070" = "pt-PT"
      "2072" = "ro-MD"
      "2073" = "ru-MD"
      "2074" = "sr-Latn-CS"
      "2077" = "sv-FI"
      "2080" = "ur-IN"
      "2092" = "az-Cyrl-AZ"
      "2108" = "ga-IE"
      "2110" = "ms-BN"
      "2115" = "uz-Cyrl-UZ"
      "2117" = "bn-BD"
      "2118" = "pa-PK"
      "2128" = "mn-Mong-CN"
      "2129" = "bo-BT"
      "2137" = "sd-PK"
      "2143" = "tzm-Latn-DZ"
      "2144" = "ks-Deva-IN"
      "2145" = "ne-IN"
      "2155" = "quz-EC"
      "2163" = "ti-ET"
      "3073" = "ar-EG"
      "3076" = "zh-HK"
      "3079" = "de-AT"
      "3081" = "en-AU"
      "3082" = "es-ES"
      "3084" = "fr-CA"
      "3098" = "sr-Cyrl-CS"
      "3179" = "quz-PE"
      "4097" = "ar-LY"
      "4100" = "zh-SG"
      "4103" = "de-LU"
      "4105" = "en-CA"
      "4106" = "es-GT"
      "4108" = "fr-CH"
      "4122" = "hr-BA"
      "5121" = "ar-DZ"
      "5124" = "zh-MO"
      "5127" = "de-LI"
      "5129" = "en-NZ"
      "5130" = "es-CR"
      "5132" = "fr-LU"
      "5146" = "bs-Latn-BA"
      "6145" = "ar-MO"
      "6153" = "en-IE"
      "6154" = "es-PA"
      "6156" = "fr-MC"
      "7169" = "ar-TN"
      "7177" = "en-ZA"
      "7178" = "es-DO"
      "7180" = "fr-029"
      "8193" = "ar-OM"
      "8201" = "en-JM"
      "8202" = "es-VE"
      "8204" = "fr-RE"
      "9217" = "ar-YE"
      "9225" = "en-029"
      "9226" = "es-CO"
      "9228" = "fr-CG"
      "10241" = "ar-SY"
      "10249" = "en-BZ"
      "10250" = "es-PE"
      "10252" = "fr-SN"
      "11265" = "ar-JO"
      "11273" = "en-TT"
      "11274" = "es-AR"
      "11276" = "fr-CM"
      "12289" = "ar-LB"
      "12297" = "en-ZW"
      "12298" = "es-EC"
      "12300" = "fr-CI"
      "13313" = "ar-KW"
      "13321" = "en-PH"
      "13322" = "es-CL"
      "13324" = "fr-ML"
      "14337" = "ar-AE"
      "14345" = "en-ID"
      "14346" = "es-UY"
      "14348" = "fr-MA"
      "15361" = "ar-BH"
      "15369" = "en-HK"
      "15370" = "es-PY"
      "15372" = "fr-HT"
      "16385" = "ar-QA"
      "16393" = "en-IN"
      "16394" = "es-BO"
      "17417" = "en-MY"
      "17418" = "es-SV"
      "18441" = "en-SG"
      "18442" = "es-HN"
      "19466" = "es-NI"
      "20490" = "es-PR"
      "21514" = "es-US"
      "58378" = "es-419"
      "58380" = "fr-015"
    }

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
    Write-Host "    - Paths"
    foreach ($Item in (Get-Variable -Name "Path_*")) {
      Write-Host "        $(($Item.Name) -replace 'Path_',''): $($Item.Value)"
    }
    Write-Host "    - Names"
    foreach ($Item in (Get-Variable -Name "Name_*")) {
      Write-Host "        $(($Item.Name) -replace 'Name_',''): $($Item.Value)"
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

	# # Create Client COM Object
	# 	Write-Host "    - Create Client COM Object"

	# 	try {
	# 		$Object_MECM_Client = New-Object -ComObject Microsoft.SMS.Client
	# 		Write-Host "        Status: Success"
	# 	}
	# 	catch {
	# 		Write-vr_ErrorCode -Code 1401 -Exit $true -Object $PSItem
	# 	}

	# # Create TSEnvironment COM Object
	# 	Write-Host "    - Create TSEnvironment COM Object"

	# 	try {
	# 		$Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment
	# 		Write-Host "        Status: Success"
	# 	}
	# 	catch {
	# 		Write-vr_ErrorCode -Code 1402 -Exit $true -Object $PSItem
	# 	}

	# Connect to MECM Infrastructure
		Write-Host "    - Connect to MECM Infrastructure"

		try {
			if (Test-Connection -ComputerName $Param_SMSProvider -Count 2 -Quiet) {
				# Import the PowerShell Module
					Write-Host "        Import the PowerShell Module"

					if((Get-Module ConfigurationManager) -in $null,"") {
						Import-Module -Name "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"
						Write-Host "            Status: Success"
					}
					else {
						Write-Host "            Status: Already Imported"
					}

				# Create the Site Drive
					Write-Host "        Create the Site Drive"

					if((Get-PSDrive -Name $Param_SiteCode -PSProvider CMSite) -in $null,"") {
						New-PSDrive -Name $Param_SiteCode -PSProvider CMSite -Root $Param_SMSProvider
						Write-Host "            Status: Success"
					}
					else {
						Write-Host "            Status: Already Exists"
					}

				# Set the Location
					Write-Host "        Set the Location"

					if ((Get-Location).Path -ne "$($Param_SiteCode):\") {
						Set-Location "$($Param_SiteCode):\"
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
			Write-vr_ErrorCode -Code 1403 -Exit $true -Object $PSItem
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

	# API Routes
		Write-Host "    - API Routes"

		try {
			foreach ($Item in (Get-Variable -Name "Path_AdminService_*")) {
				Write-Host "        Route: $($Item.Value)"

				$Temp_API_Result = Invoke-RestMethod -Uri $Item.Value -Method Get -ContentType "Application/Json" -UseDefaultCredentials
				if ($Temp_API_Result) {
					Write-Host "            Status: Success"
				}
				else {
					Write-Host "            Status: Error"
					Throw
				}
			}
		}
		catch {
			Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
		}

  # Source Boot Image
    Write-Host "    - Source Boot Image"

    try {
      Write-Host "        Name: $($Param_SourceName)"
      $Temp_BootImage_Source = Get-CMBootImage -Name $Param_SourceName

      if ($Temp_BootImage_Source) {
        Write-Host "        Path: $($Temp_BootImage_Source.ImagePath)"
        Write-Host "        Package ID: $($Temp_BootImage_Source.PackageID)"
        Write-Host "        OS Version: $($Temp_BootImage_Source.ImageOSVersion)"
        Write-Host "        Language: $($Temp_BootImage_Source.Language)"
        Write-Host "        Client Version: $($Temp_BootImage_Source.ProductionClientVersion)"
        Write-Host "        Optional Components: $($Temp_BootImage_Source.OptionalComponents.Count)"
        Write-Host "        Referenced Drivers: $($Temp_BootImage_Source.ReferencedDrivers.Count)"
        Write-Host "        Scratch Space: $($Temp_BootImage_Source.ScratchSpace)"
      }
      else {
        throw "A Boot Image with that name does not exist."
      }
    }
    catch {
      Write-vr_ErrorCode -Code 1502 -Exit $true -Object $PSItem
    }

  # Target Boot Image
    Write-Host "    - Target Boot Image"

    try {
      Write-Host "        Name: $($Param_TargetName)"
      $Temp_BootImage_Target = Get-CMBootImage -Name $Param_TargetName

      if ($Temp_BootImage_Target) {
        Write-Host "        Status: Exists"
        Throw "A Boot Image alread exists with the specified target name"
      }
      else {
        Write-Host "        Status: Not Exists"
      }
    }
    catch {
      Write-vr_ErrorCode -Code 1503 -Exit $true -Object $PSItem
    }

  # Source Boot WIM File
    Write-Host "    - Source Boot WIM File"

    try {
      Write-Host "        Path: $($Temp_BootImage_Source.ImagePath)"

      # Create PSDrive
        if ((Get-PSDrive -Name "vr_BootImages" -ErrorAction SilentlyContinue) -in "", $null) {
          New-PSDrive -Name "vr_BootImages" -PSProvider FileSystem -Root ($Temp_BootImage_Source.ImagePath | Split-Path) | Out-Null
        }

      # Check for File Existence
        if (Test-Path -Path "vr_BootImages:\$($Temp_BootImage_Source.ImagePath | Split-Path -Leaf)") {
          Write-Host "        Status: Exists"
        }
        else {
          throw "A Boot WIM was not found at the above path."
        }
    }
    catch {
      Write-vr_ErrorCode -Code 1504 -Exit $true -Object $PSItem
    }

  # Target Boot WIM File
    Write-Host "    - Target Boot WIM File"

    try {
      if ($Param_TargetWIM -in "",$null) {
        # Create PSDrive
          if ((Get-PSDrive -Name "vr_BootImages" -ErrorAction SilentlyContinue) -in "", $null) {
            New-PSDrive -Name "vr_BootImages" -PSProvider FileSystem -Root ($Temp_BootImage_Source.ImagePath | Split-Path) | Out-Null
          }

        # Check for File Existence
          Write-Host "        Path: $(($Dataset_BootImage_Source_REST.value.ImagePath | Split-Path) + `"\`" + $Name_BootImage_Target)"

          if (Test-Path -Path "vr_BootImages:\$($Name_BootImage_Target)") {
            Write-Host "        Status: Exists"
          }
          else {
            Write-Host "        Status: Not Exists"
          }
      }
      else {
        # Check for File Existence
          Write-Host "        Path: $($Param_TargetWIM)"

          if (Test-Path -Path "filesystem::$Param_TargetWIM") {
            Write-Host "        Status: Exists"
          }
          else {
            Write-Host "        Status: Not Exists"
            Throw "Target Boot WIM was not found at the path provided"
          }
      }
    }
    catch {
      Write-vr_ErrorCode -Code 1505 -Exit $true -Object $PSItem
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

  # Source Boot Image (REST)
    Write-Host "    - Source Boot Image (REST)"

    try {
      $Dataset_BootImage_Source_REST = Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute)SMS_BootImagePackage?`$filter=Name eq `'$($Param_SourceName)`'" -Method Get -ContentType "Application/Json" -UseDefaultCredentials
      Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
    }

  # Source Boot Image (Cmdlet)
    Write-Host "    - Source Boot Image (Cmdlet)"

    try {
      $Dataset_BootImage_Source_Cmdlet = Get-CMBootImage -Name $Param_SourceName
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

  # Create Target If Not Using Existing
    if ($Param_TargetWIM -in "",$null) {
      # Copy Source Boot WIM
        Write-Host "    - Copy Source Boot WIM"

        try {
          # Create PSDrive
            if ((Get-PSDrive -Name "vr_BootImages" -ErrorAction SilentlyContinue) -in "", $null) {
              New-PSDrive -Name "vr_BootImages" -PSProvider FileSystem -Root ($Dataset_BootImage_Source_REST.value.ImagePath | Split-Path) | Out-Null
            }

          # Copy File
            $Temp_File_Source   = "vr_BootImages:\$($Dataset_BootImage_Source_REST.value.ImagePath | Split-Path -Leaf)"
            $Temp_File_Target   = "vr_BootImages:\$($Name_BootImage_Target)"
            $Temp_Properties_ImagePath = ($Dataset_BootImage_Source_REST.value.ImagePath | Split-Path) + "\" + $Name_BootImage_Target

            Write-Host "        Source: $($Temp_File_Source)"
            Write-Host "        Target: $($Temp_File_Target)"

            Copy-Item -Path $Temp_File_Source -Destination $Temp_File_Target

          Write-Host "        Status: Success"
        }
        catch {
          Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
        }
    }

	# Copy Boot Image
    Write-Host "    - Copy Boot Image"

    try {
      # Create Editable Properties Object
        $Temp_BootImage_Configuration = $Dataset_BootImage_Source_REST.value[0] | ConvertTo-Json | ConvertFrom-Json

      # Remove Properties
        $Temp_Properties_ToKeep = @('BackgroundBitmapPath','Description','ImagePath','ImageProperty','InputLocale','Language','Name','OptionalComponents','PkgFlags','PreExecCommandLine','PreExecSourceDirectory','ReferencedDrivers','RefreshSchedule','Version')

        foreach ($Item in $Temp_BootImage_Configuration.PSObject.Properties) {
          if ($Temp_Properties_ToKeep -notcontains $Item.Name) {
            $Temp_BootImage_Configuration.PSObject.Properties.Remove($Item.Name)
          }
        }

      # Modify Properties
        $Temp_BootImage_Configuration.Name      = $Param_TargetName

        if ($Param_TargetWIM -notin "",$null) {
          $Temp_BootImage_Configuration.ImagePath = $Param_TargetWIM
        }
        else {
          $Temp_BootImage_Configuration.ImagePath = $Temp_Properties_ImagePath
        }

      # Put Data
        $Object_BootImage_New = Invoke-RestMethod -Uri "$($Path_AdminService_WMIRoute)SMS_BootImagePackage?`$filter=Name eq `'$($Param_TargetName)`'" -Method Put -ContentType "Application/Json" -UseDefaultCredentials -Body $($Temp_BootImage_Configuration | ConvertTo-Json)

      Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1703 -Exit $true -Object $PSItem
    }

  # Add Drivers
    Write-Host "    - Add Drivers"

    try {
      # Set Counters
        $Counter_Processed = 0
        $Counter_Total = ($Dataset_BootImage_Source_Cmdlet.ReferencedDrivers | Measure-Object).Count
        $Counter_PercentComplete = 0
        Write-Host "        Count: $($Counter_Total)"

      # Add the Drivers
        foreach ($Item in $Dataset_BootImage_Source_Cmdlet.ReferencedDrivers) {
          Write-Progress -Id 0 -Activity "Add Drivers to Boot Image" -Status "Status: $($Counter_Processed) / $($Counter_Total)" -CurrentOperation "Driver ID: $($Item.ID)" -PercentComplete $Counter_PercentComplete
          Set-CMDriverBootImage -BootImageName $Param_TargetName -DriverId $Item.ID -SetDriveBootImageAction AddDriverToBootImage

          $Counter_Processed += 1
          $Counter_PercentComplete = [math]::Ceiling(($Counter_Processed / $Counter_Total) * 100)
        }

      # Complete Progress Output
        Write-Progress -Id 0 -Activity "Completed" -Completed
        Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1704 -Exit $true -Object $PSItem
    }

  # Add Optional Components
    Write-Host "    - Add Optional Components"

    try {
      # Set Counters
        $Counter_Processed = 0
        $Counter_Total = ($Dataset_BootImage_Source_Cmdlet.OptionalComponents | Measure-Object).Count
        $Counter_PercentComplete = 0
        Write-Host "        Count: $($Counter_Total)"

      # Get Properties
        foreach ($Item in ([xml]$Dataset_BootImage_Source_Cmdlet.ImageProperty).wim.IMAGE.Property) {
          if ($Item.Name -eq "Language") {
            $Temp_BootImage_Language = $Item.'#text'
            $Temp_BootImage_LanguageID = @($Hashtable_BootImage_Languages.GetEnumerator() | Where-Object -FilterScript { $_.Value -eq $Temp_BootImage_Language })[0].name
            Write-Host "        Language: $($Temp_BootImage_Language) ($($Temp_BootImage_LanguageID))"
          }

          if (($Item.Name -eq "Image description") -and ($Item.'#text' -like "*64*")) {
            $Temp_BootImage_Architecture = "X64"
            Write-Host "        Architecture: $($Temp_BootImage_Architecture)"
          }
          elseif (($Item.Name -eq "Image description") -and ($Item.'#text' -like "*86*")) {
            $Temp_BootImage_Architecture = "X86"
            Write-Host "        Architecture: $($Temp_BootImage_Architecture)"
          }
        }

      # Add the Components
        foreach ($Item in $Dataset_BootImage_Source_Cmdlet.OptionalComponents) {
          Write-Host "          $($Hashtable_BootImage_OptionalComponents.`"$Item`")"

          $Temp_BootImage_OptionalComponent = Get-CMWinPEOptionalComponentInfo -Architecture $Temp_BootImage_Architecture -Name $Hashtable_BootImage_OptionalComponents."$($Item)" -LanguageId $Temp_BootImage_LanguageID
          Write-Progress -Id 0 -Activity "Add Optional Components" -Status "Status: $($Counter_Processed) / $($Counter_Total)" -CurrentOperation "Component: $($Temp_BootImage_OptionalComponent)" -PercentComplete $Counter_PercentComplete
          Set-CMBootImage -Name $Param_TargetName -AddOptionalComponent $Temp_BootImage_OptionalComponent

          $Counter_Processed += 1
          $Counter_PercentComplete = [math]::Ceiling(($Counter_Processed / $Counter_Total) * 100)
        }

      # Complete Progress Output
        Write-Progress -Id 0 -Activity "Completed" -Completed
        Write-Host "        Status: Success"
      }
      catch {
        Write-vr_ErrorCode -Code 1705 -Exit $true -Object $PSItem
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
  #   Write-Host "    - [StepName]"

  #   try {

  #     Write-Host "        Status: Success"
  #   }
  #   catch {
  #     Write-vr_ErrorCode -Code 1801 -Exit $true -Object $PSItem
  #   }

  # Write-Host "    - Complete"
  # Write-Host ""

#EndRegion Output
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Cleanup
#   Error Range: 1900 - 1999
#--------------------------------------------------------------------------------------------
#Region Cleanup

  Write-Host "  Cleanup"

  # # Confirm Cleanup
  #   Write-Host "    - Confirm Cleanup"

  #   do {
  #     $Temp_Cleanup_UserInput = Read-Host -Prompt "        Do you want to automatically clean up the unecessary content from this script? [Y]es or [N]o"
  #   } until (
  #     $Temp_Cleanup_UserInput -in "Y","Yes","N","No"
  #   )

  # Remove PSDrives
    Write-Host "    - Remove PSDrives"

    try {
      Remove-PSDrive -Name "vr_BootImages" -Force
      Write-Host "        Status: Success"
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
