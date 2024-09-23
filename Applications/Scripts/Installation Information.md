
-----------------------------------------------------------------------------------------------

[Publisher]
[DisplayName]
[Version]
[ProductCode]
[RegistryHive]

Deployment Name
    [Publisher] - [DisplayName] - [Version] (Silent x86/64)

Log Name
    [Publisher]_[DisplayName]_[Version]

MsiExec.exe /i "[FileName].msi" /qn /l*v "%vr_Directory_Logs%\Applications\Install\[LogName]_Install.log" TRANSFORMS=""
MsiExec.exe /x [ProductCode] /qn /l*v "%vr_Directory_Logs%\Applications\Uninstall\[LogName]_Uninstall.log"













-----------------------------------------------------------------------------------------------

[Publisher]
[DisplayName]
[Version]
[ProductCode]
[RegistryHive]

[Publisher] - [DisplayName] - [Version] (Silent x86/64)
[Publisher]_[DisplayName]_[Version]

MsiExec.exe /i "[FileName].msi" /qn /l*v "%vr_Directory_Logs%\Applications\Install\[LogName]_Install.log" TRANSFORMS=""
MsiExec.exe /x [ProductCode] /qn /l*v "%vr_Directory_Logs%\Applications\Uninstall\[LogName]_Uninstall.log"

-----------------------------------------------------------------------------------------------

Oracle Corporation
Java 8 Update 171 (64-bit)
8.0.1710.11
{26A24AE4-039D-4CA4-87B4-2F64180171F0}
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{26A24AE4-039D-4CA4-87B4-2F64180171F0}

Oracle Corporation - Java 8 Update 171 (64-bit) - 8.0.1710.11 (Silent x64)
OracleCorporation_Java8Update171(64-bit)_8.0.1710.11

"jre-8u171-windows-x64.exe" WEB_JAVA=Enable AUTO_UPDATE=Disable REBOOT=Disable REMOVEOUTOFDATEJRES=1 INSTALL_SILENT=Enable

MsiExec.exe /x {26A24AE4-039D-4CA4-87B4-2F64180171F0} /qn /l*v "%vr_Directory_Logs%\Applications\Uninstall\OracleCorporation_Java8Update171(64-bit)_8.0.1710.11_Uninstall.log"


-----------------------------------------------------------------------------------------------

Scooter Software
Beyond Compare 4.1.9
4.1.9.21719
None
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\BeyondCompare4_is1

Scooter Software - Beyond Compare 4.1.9 - 4.1.9.21719 (Silent x64)
ScooterSoftware_BeyondCompare4.1.9_4.1.9.21719

"BCompare-4.1.9.21719.exe" /VERYSILENT /LOG="%vr_Directory_Logs%\Applications\Install\ScooterSoftware_BeyondCompare4.1.9_4.1.9.21719_Install.log" /NOICONS /TASKS="shellextension"

"C:\Program Files\Beyond Compare 4\unins000.exe" /VERYSILENT /NORESTART /LOG="%vr_Directory_Logs%\Applications\Uninstall\ScooterSoftware_BeyondCompare4.1.9_4.1.9.21719_Uninstall.log"

-----------------------------------------------------------------------------------------------

Dassault Systèmes SolidWorks Corp
SOLIDWORKS eDrawings 2017 SP03
17.3.0034
{004F702B-4455-4132-9DC2-2E82263A3E06}
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{004F702B-4455-4132-9DC2-2E82263A3E06}

Dassault Systèmes SolidWorks Corp - SOLIDWORKS eDrawings 2017 SP03 - 17.3.0034 (Silent x64)
DassaultSystèmesSolidWorksCorp_SOLIDWORKSeDrawings2017SP03_17.3.0034

MsiExec.exe /i "eDrawings.msi" /qn /l*v "%vr_Directory_Logs%\Applications\Install\DassaultSystèmesSolidWorksCorp_SOLIDWORKSeDrawings2017SP03_17.3.0034_Install.log" INSTALLDIR="C:\Program Files\SolidWorks Corp\eDrawings" ADDLOCAL=ALL
MsiExec.exe /x {004F702B-4455-4132-9DC2-2E82263A3E06} /qn /l*v "%vr_Directory_Logs%\Applications\Uninstall\DassaultSystèmesSolidWorksCorp_SOLIDWORKSeDrawings2017SP03_17.3.0034_Uninstall.log"

-----------------------------------------------------------------------------------------------

CADSoftTools ®.
ABViewer 11 x64
11.1.0.2
None
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ABViewer 11_is1

CADSoftTools - ABViewer 11 x64 - 11.1.0.2 (Silent x64)
CADSoftTools_ABViewer11x64_11.1.0.2

"setupen_x64.exe" /VERYSILENT /LOG="%vr_Directory_Logs%\Applications\Install\CADSoftTools_ABViewer11x64_11.1.0.2_Install.log"
"C:\Program Files\CADSoftTools\ABViewer 11\unins000.exe" /VERYSILENT /LOG="%vr_Directory_Logs%\Applications\Uninstall\CADSoftTools_ABViewer11x64_11.1.0.2_Uninstall.log"

-----------------------------------------------------------------------------------------------

Artifex Software Inc.
GPL Ghostscript
9.23
None
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\GPL Ghostscript 9.23

Artifex Software Inc. - GPL Ghostscript - 9.23 (Silent x64)
ArtifexSoftwareInc._GPLGhostscript_9.23

"gs923w64.exe" /S
"C:\Program Files\gs\gs9.23\uninstgs.exe" /S

-----------------------------------------------------------------------------------------------

Igor Pavlov
7-Zip 9.38 (x64 edition)
9.38.00.0
{23170F69-40C1-2702-0938-000001000000}
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{23170F69-40C1-2702-0938-000001000000}

Igor Pavlov - 7-Zip 9.38 (x64 edition) - 9.38.00.0 (Silent x64)
IgorPavlov_7-Zip9.38(x64edition)_9.38.00.0

MsiExec.exe /i "7z938-x64.msi" /qn /l*v "%vr_Directory_Logs%\Applications\Install\IgorPavlov_7-Zip9.38(x64edition)_9.38.00.0_Install.log"
MsiExec.exe /x {23170F69-40C1-2702-0938-000001000000} /qn /l*v "%vr_Directory_Logs%\Applications\Uninstall\IgorPavlov_7-Zip9.38(x64edition)_9.38.00.0_Uninstall.log"


-----------------------------------------------------------------------------------------------

VideoLAN
VLC Media Player
3.0.11
None
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\VLC media player

VideoLAN - VLC Media Player - 3.0.11 (Silent x64)
VideoLAN_VLCMediaPlayer_3.0.11

vlc-3.0.11-win64.exe /L=1033 /S
"C:\Program Files\VideoLAN\VLC\uninstall.exe" /S

-----------------------------------------------------------------------------------------------

uvnc bvba
UltraVnc
1.2.0.5
None
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Ultravnc2_is1

uvnc bvba - UltraVnc - 1.2.0.5 (Silent x64)
uvncbvba_UltraVnc_1.2.0.5

UltraVNC_1_2_05_X64_Setup.exe /VERYSILENT /LOADINF=".\VR_InstallSettings.inf" /LOG="%vr_Directory_Logs%\Applications\Install\uvncbvba_UltraVnc_1.2.0.5_Install.log"
"C:\Program Files\UltraVNC\unins000.exe" /VERYSILENT /LOG="%vr_Directory_Logs%\Applications\Uninstall\uvncbvba_UltraVnc_1.2.0.5_Uninstall.log"

-----------------------------------------------------------------------------------------------

Notepad++ Team
Notepad++ (64-bit x64)
8.5
{Unknown}
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Notepad++

Notepad++ Team - Notepad++ (64-bit x64) - 8.5 (Silent)
Notepad++ Team_Notepad++ (64-bit x64)_8.5

"npp.8.5.Installer.x64.exe" /S
"C:\Program Files\Notepad++\uninstall.exe" /S

-----------------------------------------------------------------------------------------------

Microsoft Corporation
Microsoft Visual Studio Code
1.76.2
{EA457B21-F73E-494C-ACAB-524FDE069978}
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{EA457B21-F73E-494C-ACAB-524FDE069978}_is1

Microsoft Corporation - Microsoft Visual Studio Code - 1.76.2 (Silent)
MicrosoftCorporation_MicrosoftVisualStudioCode_1.76.2

"VSCodeSetup-x64-1.76.2.exe" /VERYSILENT /LOG="%vr_Directory_Logs%\Applications\Install\MicrosoftCorporation_MicrosoftVisualStudioCode_1.76.2_Install.log" /NORESTART /MERGETASKS=!runcode

"C:\Program Files\Microsoft VS Code\unins000.exe" /VERYSILENT /LOG="%vr_Directory_Logs%\Applications\Install\MicrosoftCorporation_MicrosoftVisualStudioCode_1.76.2_Uninstall.log" /NORESTART

-----------------------------------------------------------------------------------------------

CrowdStrike, Inc.
CrowdStrike Windows Sensor
6.38.15205.0
{9f78a181-96dd-4f01-b933-1c85d40bb3d2}
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{9f78a181-96dd-4f01-b933-1c85d40bb3d2}

CrowdStrike, Inc. - CrowdStrike Windows Sensor - 6.38.15205.0 (Silent x86)
CrowdStrikeInc_CrowdStrikeWindowsSensor_6.38.15205.0

WindowsSensor.GovLaggar.exe /install /quiet /norestart CID=1D260EBFD5E94A2990A87F0A9336CCC5-A4 ProvNoWait=1 /log "%vr_Directory_Logs%\Applications\Install\CrowdStrikeInc_CrowdStrikeWindowsSensor_6.38.15205.0_Install.log"

"C:\ProgramData\Package Cache\{9f78a181-96dd-4f01-b933-1c85d40bb3d2}\WindowsSensor.GovLaggar.exe" /uninstall /quiet /norestart /log "%vr_Directory_Logs%\Applications\Uninstall\CrowdStrikeInc_CrowdStrikeWindowsSensor_6.38.15205.0_Uninstall.log"


-----------------------------------------------------------------------------------------------

Pulse Secure, LLC
Pulse Secure Installer Service
8.3.60519
{A024BA7D-7796-48D5-A2A2-D36E9C429CA3}
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{A024BA7D-7796-48D5-A2A2-D36E9C429CA3}

Pulse Secure, LLC - Pulse Secure Installer Service - 8.3.60519 (Silent x86)
PulseSecureLLC_PulseSecureInstallerService_8.3.60519

MsiExec.exe /i "PulseSecureInstallerService.msi" /m MSIYUWLB /qn /l*v "%vr_Directory_Logs%\Applications\Install\PulseSecureLLC_PulseSecureInstallerService_8.3.60519_Install.log"
MsiExec.exe /x {A024BA7D-7796-48D5-A2A2-D36E9C429CA3} /qn /l*v "%vr_Directory_Logs%\Applications\Uninstall\PulseSecureLLC_PulseSecureInstallerService_8.3.60519_Uninstall.log"



-----------------------------------------------------------------------------------------------

Bomgar
Bomgar Jump Client
18.2.7
{875918F5-0097-4857-B784-4701E40097C1}
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{875918F5-0097-4857-B784-4701E40097C1}

Bomgar - Bomgar Jump Client - 18.2.7 (Silent x86)
Bomgar_BomgarJumpClient_18.2.7

MsiExec.exe /i "bomgar-scc-win64.msi" /qn /l*v "%vr_Directory_Logs%\Applications\Install\Bomgar_BomgarJumpClient_18.2.7_Install.log" KEY_INFO=w0edc30jyhhii6yxzyiie6dg65ydz1i51ewggz6c40hc90
MsiExec.exe /x {875918F5-0097-4857-B784-4701E40097C1} /qn /l*v "%vr_Directory_Logs%\Applications\Uninstall\Bomgar_BomgarJumpClient_18.2.7_Uninstall.log"




-----------------------------------------------------------------------------------------------

DLS Systems, LLC
Orion Visual Tools Support 2.0.4
2.0.4
{E3DEF587-6572-4C79-BBAA-8D78C111B6A5}
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{E3DEF587-6572-4C79-BBAA-8D78C111B6A5}

DLS Systems, LLC - Orion Visual Tools Support 2.0.4 - 2.0.4 (Silent x86)
DLSSystemsLLC_OrionVisualToolsSupport2.0.4_2.0.4

MsiExec.exe /i "orionvt5vt6_WiX.msi" /qn /l*v "%vr_Directory_Logs%\Applications\Install\DLSSystemsLLC_OrionVisualToolsSupport2.0.4_2.0.4_Install.log" TRANSFORMS="orionvt5vt6_WiX.mst"
MsiExec.exe /x {E3DEF587-6572-4C79-BBAA-8D78C111B6A5} /qn /l*v "%vr_Directory_Logs%\Applications\Uninstall\DLSSystemsLLC_OrionVisualToolsSupport2.0.4_2.0.4_Uninstall.log"




-----------------------------------------------------------------------------------------------

Microsoft Corporation
Microsoft 365 Apps for enterprise - en-us
16.0.14326.20962
[ProductCode]
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\O365ProPlusRetail - en-us

Microsoft Corporation - Microsoft 365 Apps for enterprise - en-us - 16.0.14326.20962 (Silent x64)
MicrosoftCorporation_Microsoft365Appsforenterprise-en-us_16.0.14326.20962

setup.exe /configure configuration.xml
"C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe" scenario=install scenariosubtype=ARP sourcetype=None productstoremove=O365ProPlusRetail.16_en-us_x-none culture=en-us version.16=16.0


-----------------------------------------------------------------------------------------------

IBM
IBM i Access for Windows 7.1
07.01.0001
{31E11496-1F84-4DCC-B07A-369B40B8B4A7}
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{31E11496-1F84-4DCC-B07A-369B40B8B4A7}

IBM - IBM i Access for Windows 7.1 - 07.01.0001 (Silent x64)
IBM_IBMiAccessforWindows7.1_07.01.0001

MsiExec.exe /i "image64a\cwbinstall.msi" /qn /l*v "%vr_Directory_Logs%\Applications\Install\IBM_IBMiAccessforWindows7.1_07.01.0001_Install.log" TRANSFORMS="image64a\IBM_iAccessforWindows_7.1_x86.mst"
MsiExec.exe /x {31E11496-1F84-4DCC-B07A-369B40B8B4A7} /qn /l*v "%vr_Directory_Logs%\Applications\Uninstall\IBM_IBMiAccessforWindows7.1_07.01.0001_Uninstall.log"


IBM
IBM i Access for Windows 7.1
07.01.0800
{31E11496-1F84-4DCC-B07A-369B40B8B4A7}
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{31E11496-1F84-4DCC-B07A-369B40B8B4A7}

IBM - IBM i Access for Windows 7.1 - 07.01.0800 (Silent x64)
IBM_IBMiAccessforWindows7.1_07.01.0800

MsiExec.exe /i "cwbinstall.msi" /qn /l*v "%vr_Directory_Logs%\Applications\Install\IBM_IBMiAccessforWindows7.1_07.01.0800_Install.log" TRANSFORMS="IBM_iAccessforWindowsServicePackSI49800_7.1_x86.mst" REINSTALL="ALL" REINSTALLMODE="vomus" IS_MINOR_UPGRADE="1" REBOOT=ReallySuppress
MsiExec.exe /x {31E11496-1F84-4DCC-B07A-369B40B8B4A7} /qn /l*v "%vr_Directory_Logs%\Applications\Uninstall\IBM_IBMiAccessforWindows7.1_07.01.0800_Uninstall.log"


-----------------------------------------------------------------------------------------------

Microsoft Corporation
Microsoft Visual C++ 2005 Redistributable
8.0.61001
{710f4c1c-cc18-4c49-8cbf-51240c89a1a2}
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{710f4c1c-cc18-4c49-8cbf-51240c89a1a2}

Microsoft Corporation - Microsoft Visual C++ 2005 Redistributable - 8.0.61001 (Silent x86)
MicrosoftCorporation_MicrosoftVisualC++2005Redistributable_8.0.61001_Install.log

MsiExec.exe /i "vcredist.msi" /qn /l*v "%vr_Directory_Logs%\Applications\Install\MicrosoftCorporation_MicrosoftVisualC++2005Redistributable_8.0.61001_Install.log" TRANSFORMS="Microsoft_VisualC++ Redistributable_8.0_x86.Mst"
MsiExec.exe /x {710f4c1c-cc18-4c49-8cbf-51240c89a1a2} /qn /l*v "%vr_Directory_Logs%\Applications\Uninstall\MicrosoftCorporation_MicrosoftVisualC++2005Redistributable_8.0.61001_Uninstall.log"


Microsoft Corporation
Microsoft Visual C++ 2005 Redistributable (x64)
8.0.61000
{ad8a2fa1-06e7-4b0d-927d-6e54b3d31028}
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{ad8a2fa1-06e7-4b0d-927d-6e54b3d31028}

Microsoft Corporation - Microsoft Visual C++ 2005 Redistributable (x64) - 8.0.61000 (Silent x64)
MicrosoftCorporation_MicrosoftVisualC++2005Redistributable_8.0.61000_Install.log

MsiExec.exe /i "vcredist.msi" /qn /l*v "%vr_Directory_Logs%\Applications\Install\MicrosoftCorporation_MicrosoftVisualC++2005Redistributable(x64)_8.0.61000_Install.log" TRANSFORMS="Microsoft_VisualC++ Redistributable_8.0_x64.mst"
MsiExec.exe /x {ad8a2fa1-06e7-4b0d-927d-6e54b3d31028} /qn /l*v "%vr_Directory_Logs%\Applications\Uninstall\MicrosoftCorporation_MicrosoftVisualC++2005Redistributable(x64_8.0.61000_Uninstall.log"


-----------------------------------------------------------------------------------------------

Mead & Co Ltd.
MeadCo ScriptX (v7.4.0.8 (x86))
7.4.0
{8DE5BF1E-6857-47C9-84FC-3DADF459493F}
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{8DE5BF1E-6857-47C9-84FC-3DADF459493F}

Mead & Co Ltd. - MeadCo ScriptX (v7.4.0.8 (x86)) - 7.4.0 (Silent x86)
Mead&CoLtd._MeadCoScriptX(v7.4.0.8(x86))_7.4.0_Install.log

MsiExec.exe /i "ScriptX.msi" /qn /l*v "%vr_Directory_Logs%\Applications\Install\Mead&CoLtd._MeadCoScriptX(v7.4.0.8(x86))_7.4.0_Install.log" TRANSFORMS="Meadco_ScriptX_7.4.0.8_x86.mst"
MsiExec.exe /x {8DE5BF1E-6857-47C9-84FC-3DADF459493F} /qn /l*v "%vr_Directory_Logs%\Applications\Uninstall\Mead&CoLtd._MeadCoScriptX(v7.4.0.8(x86))_7.4.0_Uninstall.log"


-----------------------------------------------------------------------------------------------

Adobe Systems Incorporated
Adobe Acrobat Reader DC
21.001.20155
{AC76BA86-7AD7-1033-7B44-AC0F074E4100}

Adobe Systems Incorporated - Adobe Acrobat Reader DC - 21.001.20155 (Silent x86)
AdobeSystemsIncorporated_AdobeAcrobatReaderDC_21.001.20155_Install.log

MsiExec.exe /p "AcroRdrDCUpd2100120155.msp" /qn /l*v "%vr_Directory_Logs%\Applications\Install\AdobeSystemsIncorporated_AdobeAcrobatReaderDC_21.001.20155_Install.log" REINSTALLMODE="ecmus" REINSTALL="ALL"
MsiExec.exe /x {AC76BA86-7AD7-1033-7B44-AC0F074E4100} /qn /l*v "%vr_Directory_Logs%\Applications\Uninstall\AdobeSystemsIncorporated_AdobeAcrobatReaderDC_21.001.20155_Uninstall.log"



Adobe Systems Incorporated
Adobe Acrobat Reader DC
19.010.20098
{AC76BA86-7AD7-1033-7B44-AC0F074E4100}

Adobe Systems Incorporated - Adobe Acrobat Reader DC - 19.010.20098 (Silent x86)
AdobeSystemsIncorporated_AdobeAcrobatReaderDC_19.010.20098_Install.log

MsiExec.exe /p "AcroRdrDCUpd1901020098.msp" /qn /l*v "%vr_Directory_Logs%\Applications\Install\AdobeSystemsIncorporated_AdobeAcrobatReaderDC_19.010.20098_Install.log" REINSTALLMODE="ecmus" REINSTALL="ALL"
MsiExec.exe /x {AC76BA86-7AD7-1033-7B44-AC0F074E4100} /qn /l*v "%vr_Directory_Logs%\Applications\Uninstall\AdobeSystemsIncorporated_AdobeAcrobatReaderDC_19.010.20098_Uninstall.log"



Adobe Systems Incorporated
Adobe Acrobat Reader DC
15.007.20033
{AC76BA86-7AD7-1033-7B44-AC0F074E4100}

Adobe Systems Incorporated - Adobe Acrobat Reader DC - 15.007.20033 (Silent x86)
AdobeSystemsIncorporated_AdobeAcrobatReaderDC_15.007.20033_Install.log

MsiExec.exe /i "AcroRead.msi" /qn /l*v "%vr_Directory_Logs%\Applications\Install\AdobeSystemsIncorporated_AdobeAcrobatReaderDC_15.007.20033_Install.log" /m MSIXMQCY TRANSFORMS="AcroRead_DC.mst"
MsiExec.exe /x {AC76BA86-7AD7-1033-7B44-AC0F074E4100} /qn /l*v "%vr_Directory_Logs%\Applications\Uninstall\AdobeSystemsIncorporated_AdobeAcrobatReaderDC_15.007.20033_Uninstall.log"


-----------------------------------------------------------------------------------------------

Oracle Corporation
Java 8 Update 121
8.0.1210.13

Oracle Corporation - Java 8 Update 121 - 8.0.1210.13 (Silent x86)

MsiExec.exe /i "jre1.8.0_121.msi" /qb /l*v "%vr_Directory_Logs%\Applications\Install\OracleCorporation_Java8Update121_8.0.1210.13_Install.log" JU=0 JAVAUPDATE=0 JAVAUPDATECHECK=0 RebootYesNo=No WEB_JAVA=1

MsiExec.exe /x {26A24AE4-039D-4CA4-87B4-2F32180121F0} /qn /l*v "%vr_Directory_Logs%\Applications\Uninstall\OracleCorporation_Java8Update121_8.0.1210.13_Uninstall.log"
