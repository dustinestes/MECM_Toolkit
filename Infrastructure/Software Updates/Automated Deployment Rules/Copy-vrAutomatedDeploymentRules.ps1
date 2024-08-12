$MECM_SiteCode = "[SiteCode]"
$MECM_SMSProvider = "[ServerFQDN]"
$MECM_ADRName = "SU - Testing"

$CMPSSuppressFastNotUsedCheck = $true
$Object_ADR = Get-CMSoftwareUpdateAutoDeploymentRule -Name $MECM_ADRName


$XML_ADR_AutoDeploymentProperties   = $([xml]$Object_ADR.AutoDeploymentProperties).AutoDeploymentRule
$XML_ADR_ContentTemplate            = $([xml]$Object_ADR.ContentTemplate).ContentActionXML
$XML_ADR_DeploymentTemplate         = $([xml]$Object_ADR.DeploymentTemplate).DeploymentCreationActionXML
$XML_ADR_UpdateRuleXML              = $([xml]$Object_ADR.UpdateRuleXML).UpdateXML.UpdateXMLDescriptionItems

$XML_ADR_UpdateRuleXML_LocalizedDisplayName0    = (Select-Xml -Xml $([xml]$Object_ADR.UpdateRuleXML).UpdateXML.UpdateXMLDescriptionItems -XPath "//UpdateXMLDescriptionItem[@PropertyName=`"LocalizedDisplayName`"]")[0]
$XML_ADR_UpdateRuleXML_ArticleID        = Select-Xml -Xml $([xml]$Object_ADR.UpdateRuleXML).UpdateXML.UpdateXMLDescriptionItems -XPath "//UpdateXMLDescriptionItem[@PropertyName=`"ArticleID`"]"
$XML_ADR_UpdateRuleXML_BulletinID       = Select-Xml -Xml $([xml]$Object_ADR.UpdateRuleXML).UpdateXML.UpdateXMLDescriptionItems -XPath "//UpdateXMLDescriptionItem[@PropertyName=`"BulletinID`"]"
$XML_ADR_UpdateRuleXML_ContentSize      = Select-Xml -Xml $([xml]$Object_ADR.UpdateRuleXML).UpdateXML.UpdateXMLDescriptionItems -XPath "//UpdateXMLDescriptionItem[@PropertyName=`"ContentSize`"]"
$XML_ADR_UpdateRuleXML_CustomSeverity   = Select-Xml -Xml $([xml]$Object_ADR.UpdateRuleXML).UpdateXML.UpdateXMLDescriptionItems -XPath "//UpdateXMLDescriptionItem[@PropertyName=`"CustomSeverity`"]"
$XML_ADR_UpdateRuleXML_DateRevised      = Select-Xml -Xml $([xml]$Object_ADR.UpdateRuleXML).UpdateXML.UpdateXMLDescriptionItems -XPath "//UpdateXMLDescriptionItem[@PropertyName=`"DateRevised`"]"
$XML_ADR_UpdateRuleXML_LocalizedDescription     = Select-Xml -Xml $([xml]$Object_ADR.UpdateRuleXML).UpdateXML.UpdateXMLDescriptionItems -XPath "//UpdateXMLDescriptionItem[@PropertyName=`"LocalizedDescription`"]"
$XML_ADR_UpdateRuleXML_NumMissing       = Select-Xml -Xml $([xml]$Object_ADR.UpdateRuleXML).UpdateXML.UpdateXMLDescriptionItems -XPath "//UpdateXMLDescriptionItem[@PropertyName=`"NumMissing`"]"
$XML_ADR_UpdateRuleXML_UpdateLocales    = Select-Xml -Xml $([xml]$Object_ADR.UpdateRuleXML).UpdateXML.UpdateXMLDescriptionItems -XPath "//UpdateXMLDescriptionItem[@PropertyName=`"UpdateLocales`"]"
$XML_ADR_UpdateRuleXML_Product          = Select-Xml -Xml $([xml]$Object_ADR.UpdateRuleXML).UpdateXML.UpdateXMLDescriptionItems -XPath "//UpdateXMLDescriptionItem[@PropertyName=`"_Product`"]"
$XML_ADR_UpdateRuleXML_Severity         = Select-Xml -Xml $([xml]$Object_ADR.UpdateRuleXML).UpdateXML.UpdateXMLDescriptionItems -XPath "//UpdateXMLDescriptionItem[@PropertyName=`"Severity`"]"
$XML_ADR_UpdateRuleXML_IsSuperseded     = Select-Xml -Xml $([xml]$Object_ADR.UpdateRuleXML).UpdateXML.UpdateXMLDescriptionItems -XPath "//UpdateXMLDescriptionItem[@PropertyName=`"IsSuperseded`"]"
$XML_ADR_UpdateRuleXML_LocalizedDisplayName1    = (Select-Xml -Xml $([xml]$Object_ADR.UpdateRuleXML).UpdateXML.UpdateXMLDescriptionItems -XPath "//UpdateXMLDescriptionItem[@PropertyName=`"LocalizedDisplayName`"]")[1]
$XML_ADR_UpdateRuleXML__UpdateClassification    = Select-Xml -Xml $([xml]$Object_ADR.UpdateRuleXML).UpdateXML.UpdateXMLDescriptionItems -XPath "//UpdateXMLDescriptionItem[@PropertyName=`"_UpdateClassification`"]"
$XML_ADR_UpdateRuleXML__Company         = Select-Xml -Xml $([xml]$Object_ADR.UpdateRuleXML).UpdateXML.UpdateXMLDescriptionItems -XPath "//UpdateXMLDescriptionItem[@PropertyName=`"_Company`"]"

$Parameters = @{
    # ADR Settings
        # General Tab
            Enable = $Object_ADR.AutoDeploymentEnabled
            Name = "COPY_" + $Object_ADR.Name
            Description = $Object_ADR.Description
            CollectionID = $Object_ADR.CollectionID
            AddToExistingSoftwareUpdateGroup = [bool]$XML_ADR_AutoDeploymentProperties.UseSameDeployment

        # Deployment Settings Tab
            DeployWithoutLicense = $(if ([bool]$XML_ADR_AutoDeploymentProperties.NoEULAUpdates -eq $true){$false} elseif ([bool]$XML_ADR_AutoDeploymentProperties.NoEULAUpdates -eq $false){$true})

        # Software Updates Tab
            Architecture = $XML_ADR_UpdateRuleXML_LocalizedDisplayName0.Node.MatchRules.string
            ArticleId = $XML_ADR_UpdateRuleXML_ArticleID.Node.MatchRules.string
            BulletinId  = $XML_ADR_UpdateRuleXML_BulletinID.Node.MatchRules.string
            ContentSize = $XML_ADR_UpdateRuleXML_ContentSize.Node.MatchRules.string
            CustomSeverity = $XML_ADR_UpdateRuleXML_CustomSeverity.Node.MatchRules.string
            DateReleasedOrRevised = $XML_ADR_UpdateRuleXML_DateRevised.Node.MatchRules.string
            UpdateDescription = $XML_ADR_UpdateRuleXML_LocalizedDescription.Node.MatchRules.string
            # IsDeployed = Not defined in PowerShell cmdlet
            Language = $XML_ADR_UpdateRuleXML_UpdateLocales.Node.MatchRules.string
            Product = $XML_ADR_UpdateRuleXML_Product.Node.MatchRules.string
            Required = $XML_ADR_UpdateRuleXML_NumMissing.Node.MatchRules.string
            Severities = $XML_ADR_UpdateRuleXML_Severity.Node.MatchRules.string
            Superseded = [bool]$XML_ADR_UpdateRuleXML_IsSuperseded.Node.MatchRules.string
            Title = $XML_ADR_UpdateRuleXML_LocalizedDisplayName1.Node.MatchRules.string
            UpdateClassification = $XML_ADR_UpdateRuleXML__UpdateClassification.Node.MatchRules.string
            # UUPPreference = Not defined in PowerShell cmdlet
            Vendor = $XML_ADR_UpdateRuleXML__Company.Node.MatchRules.string

        # Evaluation Schedule Tab
            # RunType     =
            # Schedule    =

        # Alerts Tab
            # GenerateFailureAlert = [bool]$XML_ADR_AutoDeploymentProperties.EnableFailureAlert

        # Language Selection Tab
            # LanguageSelection = $XML_ADR_ContentTemplate.ContentLocales.Locale
            # O365LanguageSelection = $XML_ADR_ContentTemplate.O365ContentLocales.Locale

        # DeploymentPackage Tab
            # DeploymentPackage = $null
            # DeploymentPackageName = $null

    # Deployment Settings
        # Collection Tab
            # CollectionName = $Object_ADR.CollectionID
            # EnabledAfterCreate = [bool]$XML_ADR_DeploymentTemplate.EnableDeployment

        # Deployment Settings Tab

        # Deployment Schedule

        # User Experience

        # Alerts

        # Download Settings

        # SoftDeadlineEnabled = [bool]$XML_ADR_DeploymentTemplate.SoftDeadlineEnabled



    # AlertTime 4
    # AlertTimeUnit Weeks
    # AllowRestart $True
    # AllowSoftwareInstallationOutsideMaintenanceWindow $True
    # AllowUseMeteredNetwork $True
    # ArticleId "test"
    # AvailableImmediately $False
    # AvailableTime 5
    # AvailableTimeUnit Months
    # CustomSeverity Critical
    # DateReleasedOrRevised Last1day
    # DeadlineImmediately $False
    # DeadlineTime $True
    # DeadlineTimeUnit Hours

    # Description "Standard updates for our laptop systems."
    # DisableOperationManager $True
    # DownloadFromInternet $False
    # DownloadFromMicrosoftUpdate $True
    # EnabledAfterCreate $False
    # GenerateOperationManagerAlert $True
    # GenerateSuccessAlert $True
    # Location "\\k\aS_O15_Client_Dev_1"
    # NoInstallOnRemote $False
    # NoInstallOnUnprotected $True
    # RunType RunTheRuleOnSchedule
    # Schedule $Schedule
    # SendWakeUpPacket $True
    # SuccessPercent 99
    # Superseded $True
    # SuppressRestartServer $True
    # SuppressRestartWorkstation $True
    # UpdateClassification "Critical Updates"
    # UseBranchCache $False
    # UserNotification DisplayAll
    # UseUtc $True
    # VerboseLevel AllMessages
    # WriteFilterHandling $True


    WhatIf = $false
}

# Architecture Translation
    [System.Collections.ArrayList]$Translation_Architecture = "Arm64","Itanium", "X64", "X86"

    foreach ($Item in $Parameters.Architecture) {
        switch ($Item) {
            "-ARM64" { $Translation_Architecture.Remove("Arm64"); Break }
            "-Itanium" { $Translation_Architecture.Remove("Itanium"); Break }
            "-IA64" { $Translation_Architecture.Remove("Itanium"); Break }
            "-x64" { $Translation_Architecture.Remove("X64"); Break }
            "-AMD64" { $Translation_Architecture.Remove("X64"); Break }
            "-64-Bit" { $Translation_Architecture.Remove("X64"); Break }
            "-x86" { $Translation_Architecture.Remove("X86"); Break }
            "-32-Bit" { $Translation_Architecture.Remove("X86"); Break }
            Default { }
        }
    }

    $Parameters.Architecture = $Translation_Architecture

# Custom Severity Translation
    foreach ($Item in $Parameters.CustomSeverity) {
        switch ($Item) {
            "'0'" { [array]$Translation_CustomSeverity += "None" }
            # "'1'" { [array]$Translation_CustomSeverity += "" }
            "'2'" { [array]$Translation_CustomSeverity += "Low" }
            # "'3'" { [array]$Translation_CustomSeverity += "" }
            # "'4'" { [array]$Translation_CustomSeverity += "" }
            # "'5'" { [array]$Translation_CustomSeverity += "" }
            "'6'" { [array]$Translation_CustomSeverity += "Moderate" }
            # "'7'" { [array]$Translation_CustomSeverity += "" }
            "'8'" { [array]$Translation_CustomSeverity += "Important" }
            # "'9'" { [array]$Translation_CustomSeverity += "" }
            "'10'" { [array]$Translation_CustomSeverity += "Critical" }
            Default {}
        }
    }

    $Parameters.CustomSeverity = $Translation_CustomSeverity

# DateReleasedOrRevised Translation
    foreach ($Item in $Parameters.DateReleasedOrRevised) {
        switch ($Item) {
            "" { $Translation_DateReleasedOrRevised += "LastHour" }
            "0:0:0:1" { $Translation_DateReleasedOrRevised += "Last1Hour" }
            "0:0:0:2" { $Translation_DateReleasedOrRevised += "Last2Hours" }
            "0:0:0:3" { $Translation_DateReleasedOrRevised += "Last3Hours" }
            "0:0:0:4" { $Translation_DateReleasedOrRevised += "Last4Hours" }
            "0:0:0:8" { $Translation_DateReleasedOrRevised += "Last8Hours" }
            "0:0:0:12" { $Translation_DateReleasedOrRevised += "Last12Hours" }
            "0:0:0:16" { $Translation_DateReleasedOrRevised += "Last16Hours" }
            "0:0:0:20" { $Translation_DateReleasedOrRevised += "Last20Hours" }
            "" { $Translation_DateReleasedOrRevised += "LastDay" }
            "0:0:1:0" { $Translation_DateReleasedOrRevised += "Last1Day" }
            "0:0:2:0" { $Translation_DateReleasedOrRevised += "Last2Days" }
            "0:0:3:0" { $Translation_DateReleasedOrRevised += "Last3Days" }
            "0:0:4:0" { $Translation_DateReleasedOrRevised += "Last4Days" }
            "0:0:5:0" { $Translation_DateReleasedOrRevised += "Last5Days" }
            "0:0:6:0" { $Translation_DateReleasedOrRevised += "Last6Days" }
            "0:0:7:0" { $Translation_DateReleasedOrRevised += "Last7Days" }
            "0:0:14:0" { $Translation_DateReleasedOrRevised += "Last14Days" }
            "0:0:21:0" { $Translation_DateReleasedOrRevised += "Last21Days" }
            "0:0:28:0" { $Translation_DateReleasedOrRevised += "Last28Days" }
            "" { $Translation_DateReleasedOrRevised += "LastMonth" }
            "0:1:0:0" { $Translation_DateReleasedOrRevised += "Last1Month" }
            "0:2:0:0" { $Translation_DateReleasedOrRevised += "Last2Months" }
            "0:3:0:0" { $Translation_DateReleasedOrRevised += "Last3Months" }
            "0:4:0:0" { $Translation_DateReleasedOrRevised += "Last4Months" }
            "0:5:0:0" { $Translation_DateReleasedOrRevised += "Last5Months" }
            "0:6:0:0" { $Translation_DateReleasedOrRevised += "Last6Months" }
            "0:7:0:0" { $Translation_DateReleasedOrRevised += "Last7Months" }
            "0:8:0:0" { $Translation_DateReleasedOrRevised += "Last8Months" }
            "0:9:0:0" { $Translation_DateReleasedOrRevised += "Last9Months" }
            "0:10:0:0" { $Translation_DateReleasedOrRevised += "Last10Months" }
            "0:11:0:0" { $Translation_DateReleasedOrRevised += "Last11Months" }
            "" { $Translation_DateReleasedOrRevised += "Last12Months" }
            "" { $Translation_DateReleasedOrRevised += "LastYear" }
            "1:0:0:0" { $Translation_DateReleasedOrRevised += "Last1Year" }

            Default { $Translation_DateReleasedOrRevised += "Any" }
        }
    }

    $Parameters.DateReleasedOrRevised = $Translation_DateReleasedOrRevised

# Language Translation
    foreach ($Item in $Parameters.Language) {
        switch ($Item) {
            "'Locale:1'" { [array]$Translation_Language += "Arabic" }
            "'Locale:2'" { [array]$Translation_Language += "Bulgarian" }
            "'Locale:2052'" { [array]$Translation_Language += "Chinese (Simplified, PRC)" }
            "'Locale:3076'" { [array]$Translation_Language += "Chinese (Traditional, Hong Kong S.A.R.)" }
            "'Locale:1028'" { [array]$Translation_Language += "Chinese (Traditional, Taiwan)" }
            "'Locale:26'" { [array]$Translation_Language += "Croatian" }
            "'Locale:5'" { [array]$Translation_Language += "Czech" }
            "'Locale:6'" { [array]$Translation_Language += "Danish" }
            "'Locale:19'" { [array]$Translation_Language += "Dutch" }
            "'Locale:9'" { [array]$Translation_Language += "English" }
            "'Locale:37'" { [array]$Translation_Language += "Estonian" }
            "'Locale:11'" { [array]$Translation_Language += "Finnish" }
            "'Locale:12'" { [array]$Translation_Language += "French" }
            "'Locale:7'" { [array]$Translation_Language += "German" }
            "'Locale:8'" { [array]$Translation_Language += "Greek" }
            "'Locale:13'" { [array]$Translation_Language += "Hebrew" }
            "'Locale:57'" { [array]$Translation_Language += "Hindi" }
            "'Locale:14'" { [array]$Translation_Language += "Hungarian" }
            "'Locale:16'" { [array]$Translation_Language += "Italian" }
            "'Locale:17'" { [array]$Translation_Language += "Japanese" }
            "'Locale:1041'" { [array]$Translation_Language += "Japanese (Japan)" }
            "'Locale:18'" { [array]$Translation_Language += "Korean" }
            "'Locale:38'" { [array]$Translation_Language += "Latvian" }
            "'Locale:39'" { [array]$Translation_Language += "Lithuanian" }
            "'Locale:20'" { [array]$Translation_Language += "Norwegian" }
            "'Locale:21'" { [array]$Translation_Language += "Polish" }
            "'Locale:22'" { [array]$Translation_Language += "Portuguese" }
            "'Locale:1046'" { [array]$Translation_Language += "Portuguese (Brazil)" }
            "'Locale:24'" { [array]$Translation_Language += "Romanian" }
            "'Locale:25'" { [array]$Translation_Language += "Russian" }
            "'Locale:31770'" { [array]$Translation_Language += "Serbian" }
            "'Locale:27'" { [array]$Translation_Language += "Slovak" }
            "'Locale:36'" { [array]$Translation_Language += "Slovenian" }
            "'Locale:10'" { [array]$Translation_Language += "Spanish" }
            "'Locale:29'" { [array]$Translation_Language += "Swedish" }
            "'Locale:30'" { [array]$Translation_Language += "Thai" }
            "'Locale:31'" { [array]$Translation_Language += "Turkish" }
            "'Locale:34'" { [array]$Translation_Language += "Ukrainian" }
            Default {}
        }
    }

    $Parameters.Language = $Translation_Language

# Product Translation
    foreach ($Item in $Parameters.Product) {
        switch ($Item) {
            "'Product:00b2d754-4512-4278-b50b-d073efb27f37'" { [array]$Translation_Product += "Microsoft Application Virtualization 4.5"; Break }
            "'Product:01030579-66d2-446e-8c65-538df07e0e44'" { [array]$Translation_Product += "Windows 8.1 Language Packs"; Break }
            "'Product:0155e143-c152-4b30-8fae-00865b9f1336'" { [array]$Translation_Product += "AksEdge Category"; Break }
            "'Product:01ce995b-6e10-404b-8511-08142e6b814e'" { [array]$Translation_Product += "Microsoft Lync Server 2013"; Break }
            "'Product:021e9016-4b20-4c24-bc42-4cdd11cefc32'" { [array]$Translation_Product += "System Center 2022 - Operations Manager"; Break }
            "'Product:02d92e8c-e777-490f-bf34-e767150195f5'" { [array]$Translation_Product += "Windows Live OneCare V3.0 (Signatures Only)"; Break }
            "'Product:032e3af5-1ac5-4205-9ae5-461b4e8cd26d'" { [array]$Translation_Product += "Windows Small Business Server 2003"; Break }
            "'Product:035c286a-16a5-4e93-81b4-9038ce52c845'" { [array]$Translation_Product += "System Center 2022 - Virtual Machine Manager"; Break }
            "'Product:041e4f9f-3a3d-4f58-8b2f-5e6fe95c4591'" { [array]$Translation_Product += "Office 2007"; Break }
            "'Product:04d85ac2-c29f-4414-9cb6-5bcd6c059070'" { [array]$Translation_Product += "Microsoft Lync Server 2010"; Break }
            "'Product:05baacdd-c45a-4e37-b95c-ee0453061d89'" { [array]$Translation_Product += "Microsoft SQL Server Management Studio v18"; Break }
            "'Product:05d9f254-88be-4293-8d10-2ddd42982e39'" { [array]$Translation_Product += "Windows 10 S, version 1903 and later, Upgrade & Servicing Drivers"; Break }
            "'Product:05eebf61-148b-43cf-80da-1c99ab0b8699'" { [array]$Translation_Product += "Windows 10 and later drivers"; Break }
            "'Product:0615f4e3-10a6-4a88-831f-8ed17ec27d97'" { [array]$Translation_Product += "Kernel Updates"; Break }
            "'Product:06bdf56c-1360-4bb9-8997-6d67b318467c'" { [array]$Translation_Product += "Forefront TMG MBE"; Break }
            "'Product:06da2f0c-7937-4e28-b46c-a37317eade73'" { [array]$Translation_Product += "Windows 10 Creators Update and Later Upgrade & Servicing Drivers"; Break }
            "'Product:07e016ee-95e2-4a4b-a98c-392b6269b51d'" { [array]$Translation_Product += "Windows Server, version 1903 and later"; Break }
            "'Product:08db04e7-75f3-4c57-90ee-b6311de7f44b'" { [array]$Translation_Product += "Azure Stack HCI"; Break }
            "'Product:0a07aea1-9d09-4c1e-8dc7-7469228d8195'" { [array]$Translation_Product += "Windows RT"; Break }
            "'Product:0a487050-8b0f-4f81-b401-be4ceacd61cd'" { [array]$Translation_Product += "Forefront Client Security"; Break }
            "'Product:0b378f2d-bff3-47dd-9b7f-5c9f966bdd81'" { [array]$Translation_Product += "Windows Server Technical Preview Language Packs"; Break }
            "'Product:0ba562e6-a6ba-490d-bdce-93a770ba8d21'" { [array]$Translation_Product += "Windows 10 Anniversary Update and Later Upgrade & Servicing Drivers"; Break }
            "'Product:0bbd2260-7478-4553-a791-21ab88e437d2'" { [array]$Translation_Product += "Device Health"; Break }
            "'Product:0c6af366-17fb-4125-a441-be87992b953a'" { [array]$Translation_Product += "Host Integration Server 2000"; Break }
            "'Product:0e297a89-e334-4987-827b-370a429083b9'" { [array]$Translation_Product += "Windows 10, version 1903 and later, Servicing Drivers"; Break }
            "'Product:0ea196ba-7a32-4e76-afd8-46bd54ecd3c6'" { [array]$Translation_Product += "Windows Live"; Break }
            "'Product:10b00347-cd06-41fd-b7ba-32200693e114'" { [array]$Translation_Product += "Windows Azure Pack: Monitoring Extension"; Break }
            "'Product:11723676-6eb1-4cf6-b86a-6fae8e2d5f1e'" { [array]$Translation_Product += "Windows - Server, version 21H2 and later, Servicing Drivers"; Break }
            "'Product:12c24e87-bd40-451b-9477-2c2bf501e0d7'" { [array]$Translation_Product += "Visual Studio 2022"; Break }
            "'Product:13610e13-fac1-4017-b703-82062db96be4'" { [array]$Translation_Product += "Windows 10, version 1809 and later, Upgrade & Servicing Drivers"; Break }
            "'Product:1403f223-a63f-f572-82ba-c92391218055'" { [array]$Translation_Product += "Office 2003"; Break }
            "'Product:1406b1b4-5441-408f-babc-9dcb5501f46f'" { [array]$Translation_Product += "Microsoft Application Virtualization 5.0"; Break }
            "'Product:14a011c7-d17b-4b71-a2a4-051807f4f4c6'" { [array]$Translation_Product += "Windows 8.1 Language Interface Packs"; Break }
            "'Product:1556fc1d-f20e-4790-848e-90b7cdbedfda'" { [array]$Translation_Product += "Windows Small Business Server 2011 Standard"; Break }
            "'Product:1731f839-8830-4b9c-986e-82ee30b24120'" { [array]$Translation_Product += "Visual Studio 2015"; Break }
            "'Product:18a2cff8-9fd2-487e-ac3b-f490e6a01b2d'" { [array]$Translation_Product += "Expression Design 3"; Break }
            "'Product:18c7899c-6e9a-41f5-8f49-376322504aec'" { [array]$Translation_Product += "Windows 8.1 Embedded"; Break }
            "'Product:18e5ea77-e3d1-43b6-a0a8-fa3dbcd42e93'" { [array]$Translation_Product += "Windows 8.1 Dynamic Update"; Break }
            "'Product:19243b1e-a4c1-4e87-80f4-fa8546ce4489'" { [array]$Translation_Product += "Windows Azure Pack: PowerShell API"; Break }
            "'Product:1aea70f3-d989-4f89-9055-b0bc9945b75f'" { [array]$Translation_Product += "Windows Azure Pack: Admin API"; Break }
            "'Product:21210d67-50bc-4254-a695-281765e10665'" { [array]$Translation_Product += "Windows Server, version 1903 and later"; Break }
            "'Product:2176218a-eab3-4d43-b8c8-e7d121fa21d2'" { [array]$Translation_Product += "System Center 2019 - Orchestrator"; Break }
            "'Product:21f5b60b-b3b8-401e-a56f-2d96a1ea6015'" { [array]$Translation_Product += "Windows 10 S, Vibranium and later, Upgrade & Servicing Drivers"; Break }
            "'Product:22bf57a8-4fe1-425f-bdaa-32b4f655284b'" { [array]$Translation_Product += "Office Communications Server 2007 R2"; Break }
            "'Product:236c566b-aaa6-482c-89a6-1e6c5cac6ed8'" { [array]$Translation_Product += "Category for System Center Online Client"; Break }
            "'Product:23d91a24-ac95-4e5d-b621-52c5bec08e66'" { [array]$Translation_Product += "System Center 2022 - Orchestrator"; Break }
            "'Product:24c467b8-2fec-4f6c-bf32-d8f623b00b37'" { [array]$Translation_Product += "System Center Data Protection Manager"; Break }
            "'Product:25aed893-7c2d-4a31-ae22-28ff8ac150ed'" { [array]$Translation_Product += "Office 2016"; Break }
            "'Product:25af568d-88b3-4cad-b694-07bc7f6adf24'" { [array]$Translation_Product += "Microsoft Dynamics CRM 2016 SHS"; Break }
            "'Product:260d4ca6-768f-4e3e-9285-c30693bb7bc1'" { [array]$Translation_Product += "Microsoft Dynamics CRM 2013"; Break }
            "'Product:26997d30-08ce-4f25-b2de-699c36a8033a'" { [array]$Translation_Product += "Windows Vista"; Break }
            "'Product:26bb6be1-37d1-4ca6-baee-ec00b2f7d0f1'" { [array]$Translation_Product += "Exchange Server 2007"; Break }
            "'Product:26cbba0f-45de-40d5-b94a-3cbe5b761c9d'" { [array]$Translation_Product += "Windows Server 2012 Language Packs"; Break }
            "'Product:29dc13a9-6953-4edc-8df4-7eeaf8e37243'" { [array]$Translation_Product += "StorSimple Virtual Array Regular Updates"; Break }
            "'Product:29e060d2-aa33-4784-9b50-2021bb84cc18'" { [array]$Translation_Product += "Windows 10 Version 1803 and Later Upgrade   & Servicing Drivers"; Break }
            "'Product:29fd8922-db9e-4a97-aa00-ca980376b738'" { [array]$Translation_Product += "Microsoft System Center Virtual Machine Manager 2007"; Break }
            "'Product:2a29bb74-e93b-4f03-9b7f-750ef71a6dd0'" { [array]$Translation_Product += "Windows Server 2019 Datacenter: Azure Edition Hotpatch"; Break }
            "'Product:2a9170d5-3434-4820-885c-61a4f3fc6f84'" { [array]$Translation_Product += "System Center 2012 R2 - Operations Manager"; Break }
            "'Product:2bb652d0-9b84-46c6-8cd5-642e281a6f61'" { [array]$Translation_Product += "Azure IoT Edge for Linux on Windows Category"; Break }
            "'Product:2c25d763-d623-433f-b956-0de582e32b19'" { [array]$Translation_Product += "Windows Azure Pack: Tenant API"; Break }
            "'Product:2c62603e-7a60-4832-9a14-cfdfd2d71b9a'" { [array]$Translation_Product += "Windows RT 8.1"; Break }
            "'Product:2c7888b6-f9e9-4ee9-87af-a77705193893'" { [array]$Translation_Product += "Microsoft Server Operating System-22H2"; Break }
            "'Product:2cdbfa44-e2cb-4455-b334-fce74ded8eda'" { [array]$Translation_Product += "Internet Security and Acceleration Server 2006"; Break }
            "'Product:2d2a68ab-50ca-4d80-b96c-757bc32024c7'" { [array]$Translation_Product += "Windows Security platform"; Break }
            "'Product:2e068336-2ead-427a-b80d-5b0fffded7e7'" { [array]$Translation_Product += "HealthVault Connection Center"; Break }
            "'Product:2ee2ad83-828c-4405-9479-544d767993fc'" { [array]$Translation_Product += "Windows 8"; Break }
            "'Product:2f1d3c10-1e92-487b-baba-2c1c645367b9'" { [array]$Translation_Product += "Windows Azure Pack: Admin Site"; Break }
            "'Product:2f3d1aba-2192-47b4-9c8d-87b41f693af4'" { [array]$Translation_Product += "Microsoft Dynamics CRM 2011"; Break }
            "'Product:2ff883b0-b409-4328-ab13-ec77f5bdb864'" { [array]$Translation_Product += "PowerShell - x64"; Break }
            "'Product:30eb551c-6288-4716-9a78-f300ec36d72b'" { [array]$Translation_Product += "Microsoft 365 Apps/Office 2019/Office LTSC"; Break }
            "'Product:316e4db1-d534-45ca-8a9d-562af54e5bd3'" { [array]$Translation_Product += "System Center 2019 Data Protection Manager"; Break }
            "'Product:323cceaf-b60b-4a0d-8a8a-3069efde76bf'" { [array]$Translation_Product += "Windows Server Drivers"; Break }
            "'Product:34aae785-2ae3-446d-b305-aec3770edcef'" { [array]$Translation_Product += "BizTalk Server 2002"; Break }
            "'Product:34eedeb0-8174-4cc2-8f3b-3f47e0ab9c6c'" { [array]$Translation_Product += "Skype for Business Server 2019, SmartSetup"; Break }
            "'Product:34f268b4-7e2d-40e1-8966-8bb6ea3dad27'" { [array]$Translation_Product += "Windows 10 and later upgrade & servicing drivers"; Break }
            "'Product:393789f5-61c1-4881-b5e7-c47bcca90f94'" { [array]$Translation_Product += "Windows 8 Dynamic Update"; Break }
            "'Product:39d54f77-4f1f-4e46-9752-c2de4cf2244d'" { [array]$Translation_Product += "Windows 10 S, version 1809 and later, Servicing Drivers"; Break }
            "'Product:3a78cd53-79b0-43a6-82f6-d9d6b9eec011'" { [array]$Translation_Product += "Microsoft Dynamics CRM 2015"; Break }
            "'Product:3a8f2a23-211a-4969-9f10-50ee09f0a2db'" { [array]$Translation_Product += ".NET 6.0"; Break }
            "'Product:3b1e1746-d99b-42d4-91fd-71d794f97a4d'" { [array]$Translation_Product += "Expression Web 4"; Break }
            "'Product:3b4b8621-726e-43a6-b43b-37d07ec7019f'" { [array]$Translation_Product += "Windows 2000"; Break }
            "'Product:3c54bb6c-66d1-4a79-884c-8a0c96fa20d1'" { [array]$Translation_Product += "Windows Server 2016 and Later Servicing Drivers"; Break }
            "'Product:3c9e83e3-614d-4670-9205-cfcf3ea62a29'" { [array]$Translation_Product += "Windows Azure Pack: Web Sites"; Break }
            "'Product:3cf32f7c-d8ee-43f8-a0da-8b88a6f8af1a'" { [array]$Translation_Product += "Exchange Server 2003"; Break }
            "'Product:3e5cc385-f312-4fff-bd5e-b88dcf29b476'" { [array]$Translation_Product += "Windows 8 Language Interface Packs"; Break }
            "'Product:3efabf46-3037-4c85-a752-3189e574b621'" { [array]$Translation_Product += "Windows 10 GDR-DU FOD"; Break }
            "'Product:3f3b071e-c4a6-4bcc-b6c1-27122b235949'" { [array]$Translation_Product += "Host Integration Server 2010"; Break }
            "'Product:3f50dcc0-6199-4ae0-a166-6d87d4e6f83e'" { [array]$Translation_Product += "Windows Azure Pack: Tenant Public API"; Break }
            "'Product:405706ed-f1d7-47ea-91e1-eb8860039715'" { [array]$Translation_Product += "Windows 8.1 and later drivers"; Break }
            "'Product:4217668b-66f0-42a0-911e-a334a5e4dbad'" { [array]$Translation_Product += "Network Monitor 3"; Break }
            "'Product:428977de-d1ea-4aea-85ae-20988beefb14'" { [array]$Translation_Product += "Microsoft Purview Client Service"; Break }
            "'Product:42b678ae-2b57-4251-ae57-efbd35e7ae96'" { [array]$Translation_Product += "Host Integration Server 2009"; Break }
            "'Product:45afcceb-93c4-4ac3-909c-ca349acbc264'" { [array]$Translation_Product += "Windows Azure Pack: Tenant Authentication Site"; Break }
            "'Product:470bd53a-c36a-448f-b620-91feede01946'" { [array]$Translation_Product += "Windows GDR-Dynamic Update"; Break }
            "'Product:49114095-a4ab-4aa2-9ad1-59e851fcb53a'" { [array]$Translation_Product += ".NET 7.0"; Break }
            "'Product:49c3ddde-4df2-4534-980c-83f4e27b23b5'" { [array]$Translation_Product += "Exchange Server 2016"; Break }
            "'Product:4a6d718b-bd08-4748-9dd5-c8cc2b1de451'" { [array]$Translation_Product += "Windows 10, Vibranium and later, Upgrade & Servicing Drivers"; Break }
            "'Product:4cb6ebd5-e38a-4826-9f76-1416a6f563b0'" { [array]$Translation_Product += "Windows XP x64 Edition"; Break }
            "'Product:4e487029-f550-4c22-8b31-9173f3f95786'" { [array]$Translation_Product += "Windows Server Manager - Windows Server Update Services (WSUS) Dynamic Installer"; Break }
            "'Product:4ea8aeaf-1d28-463e-8179-af9829f81212'" { [array]$Translation_Product += "EU Browser Choice Update-For Europe Only"; Break }
            "'Product:50bb1d21-f01a-451c-9b1f-6c41e3c43ee7'" { [array]$Translation_Product += "Service Bus for Windows Server 1.1"; Break }
            "'Product:50c04525-9b15-4f7c-bed4-87455bcd7ded'" { [array]$Translation_Product += "Windows Dictionary Updates"; Break }
            "'Product:50d71efd-1e60-4898-9ef5-f31a77bde4b0'" { [array]$Translation_Product += "System Center 2012 SP1 - App Controller"; Break }
            "'Product:5108d510-e169-420c-9a4d-618bdb33c480'" { [array]$Translation_Product += "Expression Media 2"; Break }
            "'Product:52561474-cdfa-4717-8692-bf8d58abc425'" { [array]$Translation_Product += "Microsoft Defender for Endpoint"; Break }
            "'Product:5312e4f1-6372-442d-aeb2-15f2132c9bd7'" { [array]$Translation_Product += "Windows Internet Explorer 8 Dynamic Installer"; Break }
            "'Product:558f4bc3-4827-49e1-accf-ea79fd72d4c9'" { [array]$Translation_Product += "Windows XP"; Break }
            "'Product:5669bd12-c6ab-4831-8643-0d5f6638228f'" { [array]$Translation_Product += "Max"; Break }
            "'Product:56750722-19b4-4449-a547-5b68f19eee38'" { [array]$Translation_Product += "Microsoft SQL Server 2012"; Break }
            "'Product:569e8e8f-c6cd-42c8-92a3-efbb20a0f6f5'" { [array]$Translation_Product += "Windows Server 2016"; Break }
            "'Product:575d68e2-7c94-48f9-a04f-4b68555d972d'" { [array]$Translation_Product += "Windows Small Business Server 2008"; Break }
            "'Product:57869cb9-cd47-4ce4-acd5-caf49a0c713f'" { [array]$Translation_Product += "Windows Azure Pack: Configuration Site"; Break }
            "'Product:587f7961-187a-4419-8972-318be1c318af'" { [array]$Translation_Product += "Microsoft Dynamics CRM 2011 SHS"; Break }
            "'Product:589db546-7849-47f5-bbc0-1f66cf12f5c2'" { [array]$Translation_Product += "Windows 8 Embedded"; Break }
            "'Product:589e5715-19b7-44c2-a532-5775dea30c0f'" { [array]$Translation_Product += "Azure Connected Machine Agent 3"; Break }
            "'Product:58de46e5-6ccb-4154-91c1-73f8f4b84ce8'" { [array]$Translation_Product += "System Center 1801 - Orchestrator"; Break }
            "'Product:5964c9f1-8e72-4891-a03a-2aed1c4115d2'" { [array]$Translation_Product += "HPC Pack 2008"; Break }
            "'Product:59f07fb7-a6a1-4444-a9a9-fb4b80138c6d'" { [array]$Translation_Product += "Forefront TMG"; Break }
            "'Product:5a456666-3ac5-4162-9f52-260885d6533a'" { [array]$Translation_Product += "Systems Management Server 2003"; Break }
            "'Product:5c635fb6-323f-4131-a951-7f5fbcaa781a'" { [array]$Translation_Product += "Forefront code named Stirling Beta version"; Break }
            "'Product:5c91542d-b573-44e9-a86d-b13b27cd98db'" { [array]$Translation_Product += "Windows Azure Pack: Web App Gallery Extension"; Break }
            "'Product:5ca5303e-220e-4e91-a758-b67ece7f0e67'" { [array]$Translation_Product += "Windows - Client S, version 21H2 and later, Servicing Drivers"; Break }
            "'Product:5cc25303-143f-40f3-a2ff-803a1db69955'" { [array]$Translation_Product += "Locally published packages"; Break }
            "'Product:5d6a452a-55ba-4e11-adac-85e180bda3d6'" { [array]$Translation_Product += "Antigen for Exchange/SMTP"; Break }
            "'Product:5e870422-bd8f-4fd2-96d3-9c5d9aafda22'" { [array]$Translation_Product += "Microsoft Lync 2010"; Break }
            "'Product:5ea45628-0257-499b-9c23-a6988fc5ea85'" { [array]$Translation_Product += "Windows Live Toolbar"; Break }
            "'Product:5f21acd2-d667-44f9-8d5e-485433e4d25c'" { [array]$Translation_Product += "System Center Operations Manager 1807"; Break }
            "'Product:5f4177e2-ad09-4066-9050-b7466ad5b078'" { [array]$Translation_Product += "Visual Studio 2019"; Break }
            "'Product:607efb8d-feed-48a0-930e-14d0cf2da71f'" { [array]$Translation_Product += "Microsoft Server Operating System-23H2"; Break }
            "'Product:60916385-7546-4e9b-836e-79d65e517bab'" { [array]$Translation_Product += "SQL Server 2005"; Break }
            "'Product:6102ab07-dd96-4407-8c82-2f2db7022248'" { [array]$Translation_Product += "Windows Azure Pack: Microsoft Best Practice Analyzer"; Break }
            "'Product:6111a83d-7a6b-4a2c-a7c2-f222eebcabf4'" { [array]$Translation_Product += "Windows 10 GDR-DU LP"; Break }
            "'Product:6126d650-7850-48fa-858e-a5256f1e92c4'" { [array]$Translation_Product += "Windows - Client, version 21H2 and later, Servicing Drivers"; Break }
            "'Product:61487ade-9a4e-47c9-baa5-f1595bcdc5c5'" { [array]$Translation_Product += "BizTalk Server 2013"; Break }
            "'Product:6248b8b1-ffeb-dbd9-887a-2acf53b09dfe'" { [array]$Translation_Product += "Office 2002/XP"; Break }
            "'Product:6407468e-edc7-4ecd-8c32-521f64cee65e'" { [array]$Translation_Product += "Windows 8.1"; Break }
            "'Product:649f3e94-ed2f-42e8-a4cd-e81489af357c'" { [array]$Translation_Product += "Windows Essential Business Server Preinstallation Tools"; Break }
            "'Product:64ccdfc7-8e8c-4404-a572-a3daf7dff673'" { [array]$Translation_Product += ".NET 8.0"; Break }
            "'Product:682005f1-54fd-440f-b3b3-b9c652351d01'" { [array]$Translation_Product += "Visual Studio 2017"; Break }
            "'Product:69010383-ff55-4227-bd6c-d91c26f2643b'" { [array]$Translation_Product += "Microsoft Edge"; Break }
            "'Product:692a70df-adea-4e6a-b3a7-d6eb6738075d'" { [array]$Translation_Product += "Remote help"; Break }
            "'Product:6966a762-0c7c-4261-bd07-fb12b4673347'" { [array]$Translation_Product += "Windows Essential Business Server 2008 Setup Updates"; Break }
            "'Product:6ac905a5-286b-43eb-97e2-e23b3848c87d'" { [array]$Translation_Product += "Microsoft Advanced Threat Analytics"; Break }
            "'Product:6b6f55fa-c7f1-45d9-8e40-a64a4ac0097c'" { [array]$Translation_Product += "System Center 2022 - Data Protection Manager"; Break }
            "'Product:6b9e8b26-8f50-44b9-94c6-7846084383ec'" { [array]$Translation_Product += "MS Security Essentials"; Break }
            "'Product:6c5f2e66-7dbc-4c59-90a7-849c4c649d7a'" { [array]$Translation_Product += "SharePoint Server 2019/Office Online Server"; Break }
            "'Product:6cf036b9-b546-4694-885a-938b93216b66'" { [array]$Translation_Product += "Security Essentials"; Break }
            "'Product:6d76a2a5-81fe-4829-b268-6eb307e40ef3'" { [array]$Translation_Product += "Windows 7 Language Packs"; Break }
            "'Product:6ddf2e90-4b40-471c-a664-6cd6b7e0d0a7'" { [array]$Translation_Product += "System Center 2012 R2 - Orchestrator"; Break }
            "'Product:6e56e6da-f22f-47c9-97b4-510153a06740'" { [array]$Translation_Product += "Windows Server 2019"; Break }
            "'Product:6ed4a93e-e443-4965-b666-5bc7149f793c'" { [array]$Translation_Product += "System Center 2012 - Virtual Machine Manager"; Break }
            "'Product:704a0a4a-518f-4d69-9e03-10ba44198bd5'" { [array]$Translation_Product += "Office 2013"; Break }
            "'Product:7145181b-9556-4b11-b659-0162fa9df11f'" { [array]$Translation_Product += "SQL Server 2000"; Break }
            "'Product:71718f13-7324-4b0f-8f9e-2ca9dc978e53'" { [array]$Translation_Product += "Microsoft Server operating system-21H2"; Break }
            "'Product:71debf20-7fce-4e93-8a6c-4a3fad0313ec'" { [array]$Translation_Product += "Windows Azure Pack: MySQL Extension"; Break }
            "'Product:72e7624a-5b00-45d2-b92f-e561c0a6a160'" { [array]$Translation_Product += "Windows 11"; Break }
            "'Product:734658e2-c499-46ac-953f-287b14deeb44'" { [array]$Translation_Product += "Microsoft Dynamics CRM 2016"; Break }
            "'Product:761370fd-6dbb-427f-899e-c19d56e22a9b'" { [array]$Translation_Product += "Windows 10 S Version 1803 and Later Upgrade & Servicing Drivers"; Break }
            "'Product:784c9f6d-959a-433f-b7a3-b2ace1489a18'" { [array]$Translation_Product += "Host Integration Server 2004"; Break }
            "'Product:79adaa30-d83b-4d9c-8afd-e099cf34855f'" { [array]$Translation_Product += "Report Viewer 2008"; Break }
            "'Product:7cf56bdd-5b4e-4c04-a6a6-706a2199eff7'" { [array]$Translation_Product += "Report Viewer 2005"; Break }
            "'Product:7d247b99-caa2-45e4-9c8f-6d60d0aae35c'" { [array]$Translation_Product += "Windows 10 Language Interface Packs"; Break }
            "'Product:7d6b797d-392c-45ee-a22f-4082b66212a0'" { [array]$Translation_Product += ".NET Core 3.1"; Break }
            "'Product:7d9ae321-5221-46d8-9614-5302f044cfb1'" { [array]$Translation_Product += ".NET Core 2.1"; Break }
            "'Product:7dd9959a-e808-477a-ab89-b2e3d3ed1f65'" { [array]$Translation_Product += "Windows 11 Client, version 22H2 and later, Servicing Drivers"; Break }
            "'Product:7ddc06c4-f2ff-4bb0-bc87-17b385c89a63'" { [array]$Translation_Product += "Windows 10, version 1809 and later, Servicing Drivers"; Break }
            "'Product:7e5d0309-78dd-4f52-a756-0259f88b634b'" { [array]$Translation_Product += "Microsoft System Center Virtual Machine Manager 2008"; Break }
            "'Product:7e903438-3690-4cf0-bc89-2fc34c26422b'" { [array]$Translation_Product += "Microsoft BitLocker Administration and Monitoring v1"; Break }
            "'Product:7f44c2a7-bc36-470b-be3b-c01b6dc5dd4e'" { [array]$Translation_Product += "Windows Server 2003, Datacenter Edition"; Break }
            "'Product:7fe4630a-0330-4b01-a5e6-a77c7ad34eb0'" { [array]$Translation_Product += "SQL Server 2012 Product Updates for Setup"; Break }
            "'Product:7ff1d901-fd38-441b-aaba-36d7b0ebf264'" { [array]$Translation_Product += "Azure File Sync agent updates for Windows Server 2016"; Break }
            "'Product:7fff3336-2479-4623-a697-bcefcf1b9f92'" { [array]$Translation_Product += "Windows Small Business Server 2008 Migration Preparation Tool"; Break }
            "'Product:80d30b43-f814-41fd-b7c5-85c91ea66c45'" { [array]$Translation_Product += "System Center 2012 SP1 - Operation Manager"; Break }
            "'Product:8184d953-8366-4e13-8566-df0e15aca108'" { [array]$Translation_Product += "Skype for Business Server 2015"; Break }
            "'Product:81b8c03b-9743-44b1-8c78-25e750921e36'" { [array]$Translation_Product += "Works 6-9 Converter"; Break }
            "'Product:83a83e29-7d55-44a0-afed-aea164bc35e6'" { [array]$Translation_Product += "Exchange 2000 Server"; Break }
            "'Product:83aed513-c42d-4f94-b4dc-f2670973902d'" { [array]$Translation_Product += "CAPICOM"; Break }
            "'Product:84a044f8-631c-4eb5-90be-9f1d127d6cc2'" { [array]$Translation_Product += "Azure File Sync agent updates for Windows Server 2019"; Break }
            "'Product:84a54ea9-e574-457a-a750-17164c1d1679'" { [array]$Translation_Product += "Forefront Threat Management Gateway, Definition Updates for HTTP Malware Inspection"; Break }
            "'Product:84f5f325-30d7-41c4-81d1-87a0e6535b66'" { [array]$Translation_Product += "Office 2010"; Break }
            "'Product:8508af86-b85e-450f-a518-3b6f8f204eea'" { [array]$Translation_Product += "New Dictionaries for Microsoft IMEs"; Break }
            "'Product:8516af00-35dc-4fd6-af4f-e1a9f117a882'" { [array]$Translation_Product += "Windows Azure Pack: SQL Server Extension"; Break }
            "'Product:8570b1a2-0551-42c8-a3e7-d3783c3d36d4'" { [array]$Translation_Product += "Windows 10 version 1803 and Later Servicing Drivers"; Break }
            "'Product:86134b1c-cf56-4884-87bf-5c9fe9eb526f'" { [array]$Translation_Product += "Forefront Identity Manager 2010 R2"; Break }
            "'Product:86b9f801-b8ec-4d16-b334-08fba8567c17'" { [array]$Translation_Product += "BizTalk Server 2006R2"; Break }
            "'Product:874a7757-3a13-43b2-a7f2-cf2ff43dd6bf'" { [array]$Translation_Product += "Windows XP Embedded"; Break }
            "'Product:876ad18f-f41d-442a-ac64-f5c5ce74cc83'" { [array]$Translation_Product += "Windows 10 Fall Creators Update and Later Servicing Drivers"; Break }
            "'Product:892c0584-8b03-428f-9a74-224fcd6887c0'" { [array]$Translation_Product += "SQL Server 2014-2016 Product Updates for Setup"; Break }
            "'Product:89ae07ca-6b57-48da-ac7e-607da1f2de96'" { [array]$Translation_Product += "System Center 2019 - Operations Manager"; Break }
            "'Product:8a3485af-4301-43e1-b2d9-f9ddb7576125'" { [array]$Translation_Product += "System Center 2012 R2 - Virtual Machine Manager"; Break }
            "'Product:8a3cbc4a-5334-40d4-a06e-6da96022ae3b'" { [array]$Translation_Product += "Windows 10, version 1903 and later"; Break }
            "'Product:8b4e84f6-595f-41ed-854f-4ca886e317a5'" { [array]$Translation_Product += "Windows Server 2012 R2 Language Packs"; Break }
            "'Product:8bc19572-a4b6-4910-b70d-716fecffc1eb'" { [array]$Translation_Product += "Office Communicator 2007 R2"; Break }
            "'Product:8c27cdba-6a1c-455e-af20-46b7771bbb96'" { [array]$Translation_Product += "Windows Next Graphics Driver Dynamic update"; Break }
            "'Product:8c3fcc84-7410-4a95-8b89-a166a0190486'" { [array]$Translation_Product += "Microsoft Defender Antivirus"; Break }
            "'Product:8c96b6ab-0271-430e-ac76-0d8b771952dd'" { [array]$Translation_Product += "Windows 11 Client S, version 22H2 and later, Servicing Drivers"; Break }
            "'Product:90e135fb-ef48-4ad0-afb5-10c4ceb4ed16'" { [array]$Translation_Product += "Windows Vista Dynamic Installer"; Break }
            "'Product:9119fae9-3fdd-4c06-bde7-2cbbe2cf3964'" { [array]$Translation_Product += "Expression Design 4"; Break }
            "'Product:93c78d3e-8953-4e45-86a6-015763389bba'" { [array]$Translation_Product += "Microsoft Azure Backup Server V4 - Data Protection Manager"; Break }
            "'Product:93f0b0bc-9c20-4ca5-b630-06eb4706a447'" { [array]$Translation_Product += "Microsoft SQL Server 2016"; Break }
            "'Product:95a5f8e0-f2ab-4be6-bc4a-34d4b790192f'" { [array]$Translation_Product += "Windows Azure Pack: Tenant Site"; Break }
            "'Product:97b08ca0-db59-468d-8c47-0ecaad647997'" { [array]$Translation_Product += "Server 2022 Hotpatch Category"; Break }
            "'Product:97b8b817-fce1-44e4-ac26-61127d4604c0'" { [array]$Translation_Product += "Microsoft SQL Server 2019"; Break }
            "'Product:97c4cee8-b2ae-4c43-a5ee-08367dab8796'" { [array]$Translation_Product += "Windows 8 Language Packs"; Break }
            "'Product:983dabe5-e68d-4cb3-ae5e-6da88e66783f'" { [array]$Translation_Product += "Windows Azure Pack: Admin Authentication Site"; Break }
            "'Product:9b135dd5-fc75-4609-a6ae-fb5d22333ef0'" { [array]$Translation_Product += "Exchange Server 2010"; Break }
            "'Product:9db738b6-9853-40c2-bc43-20b61cf33816'" { [array]$Translation_Product += "Microsoft Azure Backup Server V3 - Data Protection Manager"; Break }
            "'Product:9e185861-6465-41db-83c4-bb1480a55851'" { [array]$Translation_Product += "Windows Azure Pack: Usage Extension"; Break }
            "'Product:9f3dd20a-1004-470e-ba65-3dc62d982958'" { [array]$Translation_Product += "Silverlight"; Break }
            "'Product:9f9a6cb8-a74e-4a72-8133-ab941bdb9d8c'" { [array]$Translation_Product += "Windows - Client S, version 21H2 and later, Upgrade & Servicing Drivers"; Break }
            "'Product:a011d83e-195d-467c-95d7-14b0dd6ea4c8'" { [array]$Translation_Product += "Windows 10 S, version 1903 and later, Servicing Drivers"; Break }
            "'Product:a0dd7e72-90ec-41e3-b370-c86a245cd44f'" { [array]$Translation_Product += "Visual Studio 2005"; Break }
            "'Product:a105a108-7c9b-4518-bbbe-73f0fe30012b'" { [array]$Translation_Product += "Windows Server 2012"; Break }
            "'Product:a13d331b-ce8f-40e4-8a18-227bf18f22f3'" { [array]$Translation_Product += "Writer Installation and Upgrades"; Break }
            "'Product:a33f42ac-b33f-4fd2-80a8-78b3bfa6a142'" { [array]$Translation_Product += "Expression Web 3"; Break }
            "'Product:a38c835c-2950-4e87-86cc-6911a52c34a3'" { [array]$Translation_Product += "System Center Endpoint Protection"; Break }
            "'Product:a3c2375d-0c8a-42f9-bce0-28333e198407'" { [array]$Translation_Product += "Windows 10"; Break }
            "'Product:a4bedb1d-a809-4f63-9b49-3fe31967b6d0'" { [array]$Translation_Product += "Windows XP 64-Bit Edition Version 2003"; Break }
            "'Product:a5515156-b69c-47cc-9dc5-0942be6b3086'" { [array]$Translation_Product += "Windows - Server, version 21H2 and later, Upgrade & Servicing Drivers"; Break }
            "'Product:a6432e15-a446-44af-8f96-0475c472aef6'" { [array]$Translation_Product += "Forefront Protection Category"; Break }
            "'Product:a73eeffa-5729-48d4-8bf4-275132338629'" { [array]$Translation_Product += "Microsoft StreamInsight V1.0"; Break }
            "'Product:a8f50393-2e42-43d1-aaf0-92bec8b60775'" { [array]$Translation_Product += "Microsoft Research AutoCollage 2008"; Break }
            "'Product:a901c1bd-989c-45c6-8da0-8dde8dbb69e0'" { [array]$Translation_Product += "Windows Vista Ultimate Language Packs"; Break }
            "'Product:ab1852d6-15fd-4bf0-acd1-d276a5ea82fb'" { [array]$Translation_Product += "Windows 11 Dynamic Update"; Break }
            "'Product:ab62c5bd-5539-49f6-8aea-5a114dd42314'" { [array]$Translation_Product += "Exchange Server 2007 and Above Anti-spam"; Break }
            "'Product:ab8df9b9-8bff-4999-aee5-6e4054ead976'" { [array]$Translation_Product += "System Center 2012 - Orchestrator"; Break }
            "'Product:abc45868-0c9c-4bc0-a36d-03d54113baf4'" { [array]$Translation_Product += "Windows 10 and later GDR-DU"; Break }
            "'Product:abddd523-04f4-4f8e-b76f-a6c84286cc67'" { [array]$Translation_Product += "Visual Studio 2012"; Break }
            "'Product:ac615cb5-1c12-44be-a262-fab9cd8bf523'" { [array]$Translation_Product += "Compute Cluster Pack"; Break }
            "'Product:ae4483f4-f3ce-4956-ae80-93c18d8886a6'" { [array]$Translation_Product += "Threat Management Gateway Definition Updates for Network Inspection System"; Break }
            "'Product:ae4500e9-17b0-4a78-b088-5b056dbf452b'" { [array]$Translation_Product += "System Center Advisor"; Break }
            "'Product:aeefa997-63b8-4c01-b19c-c19e1081b4ce'" { [array]$Translation_Product += "Microsoft SQL Server 2022"; Break }
            "'Product:afd77d9e-f05a-431c-889a-34c23c9f9af5'" { [array]$Translation_Product += "Windows Live"; Break }
            "'Product:b0247430-6f8d-4409-b39b-30de02286c71'" { [array]$Translation_Product += "Microsoft Online Services Sign-In Assistant"; Break }
            "'Product:b0c3b58d-1997-4b68-8d73-ab77f721d099'" { [array]$Translation_Product += "System Center 2012 - Data Protection Manager"; Break }
            "'Product:b11fe74f-46dc-4cd9-82db-76fd4b8956a0'" { [array]$Translation_Product += "Windows 11 Client S, version 22H2 and later, Upgrade & Servicing Drivers"; Break }
            "'Product:b1b8f641-1ff2-4ae6-b247-4fe7503787be'" { [array]$Translation_Product += "Windows Admin Center"; Break }
            "'Product:b2b5aff0-734b-44e7-9934-48467fcae134'" { [array]$Translation_Product += "Surface Hub 2S drivers"; Break }
            "'Product:b3c75dc1-155f-4be4-b015-3f1a91758e52'" { [array]$Translation_Product += "Windows 10, version 1903 and later"; Break }
            "'Product:b488e84c-6d2c-4170-b915-c36f9bbcf6e7'" { [array]$Translation_Product += "Windows 10, version 1903 and later, Upgrade & Servicing Drivers"; Break }
            "'Product:b61793e6-3539-4dc8-8160-df71054ea826'" { [array]$Translation_Product += "BizTalk Server 2009"; Break }
            "'Product:b627a8ff-19cd-45f5-a938-32879dd90123'" { [array]$Translation_Product += "Internet Security and Acceleration Server 2004"; Break }
            "'Product:b645dd0f-2965-43e8-b055-8ea47e2d71d7'" { [array]$Translation_Product += "Windows Server 2019 and later, Servicing Drivers"; Break }
            "'Product:b6ea7c03-5339-4d45-a215-314a05fe37e0'" { [array]$Translation_Product += "Windows 11 GDR-DU"; Break }
            "'Product:b790e43b-f4e4-48b4-9f0c-499194f00841'" { [array]$Translation_Product += "Microsoft Works 8"; Break }
            "'Product:b7f52cfb-c9e9-4481-9bc0-c8b4e208ba39'" { [array]$Translation_Product += "Windows 10 S Version 1709 and Later Upgrade & Servicing Drivers for testing"; Break }
            "'Product:b8267fae-89ab-4540-b17d-21ffd5986e3a'" { [array]$Translation_Product += ".NET 5.0"; Break }
            "'Product:b86cf33d-92ac-43d2-886b-be8a12f81ee1'" { [array]$Translation_Product += "Bing Bar"; Break }
            "'Product:ba0ae9cc-5f01-40b4-ac3f-50192b5d6aaf'" { [array]$Translation_Product += "Windows Server 2008"; Break }
            "'Product:ba649061-a2bd-42a9-b7c3-825ce12c3cd6'" { [array]$Translation_Product += "System Center 2012 SP1 - Virtual Machine Manager"; Break }
            "'Product:bab879a4-c1af-4b52-9617-0f9ae1286fb6'" { [array]$Translation_Product += "Windows 10 Anniversary Update and Later Servicing Drivers"; Break }
            "'Product:bb06ba08-3df8-4221-8794-18effb79156a'" { [array]$Translation_Product += "Windows 10 S Version 1709 and Later Servicing Drivers for testing"; Break }
            "'Product:bb0dab86-78bd-4561-a71c-fb0071efd262'" { [array]$Translation_Product += "Windows 10 S, version 1809 and later, Upgrade & Servicing Drivers"; Break }
            "'Product:bb7bc3a7-857b-49d4-8879-b639cf5e8c3c'" { [array]$Translation_Product += "SQL Server 2008 R2"; Break }
            "'Product:bc0fee21-742f-4d06-8b37-4fd520873c74'" { [array]$Translation_Product += "SharePoint Server Subscription Edition"; Break }
            "'Product:bc48031f-9353-4db2-a305-541e324374e2'" { [array]$Translation_Product += "System Center 2016 - Data Protection Manager"; Break }
            "'Product:bcc7f992-8328-4e5f-b7bb-50d9a77d2343'" { [array]$Translation_Product += "System Center Version 1801 - Virtual Machine Manager"; Break }
            "'Product:bec76be5-7aa9-497f-b70b-5fd1cfd1e3b1'" { [array]$Translation_Product += "Skype for Business Server 2015, SmartSetup"; Break }
            "'Product:bf05abfb-6388-4908-824e-01565b05e43a'" { [array]$Translation_Product += "System Center 2012 - Operations Manager"; Break }
            "'Product:bf6a6018-83f0-45a6-b9bf-074a78ec9c82'" { [array]$Translation_Product += "Microsoft System Center DPM 2010"; Break }
            "'Product:bfd3e48c-c96b-43fd-8b09-98cdc89dc77e'" { [array]$Translation_Product += "Windows Server 2012 R2 Drivers"; Break }
            "'Product:bfe5b177-a086-47a0-b102-097e4fa1f807'" { [array]$Translation_Product += "Windows 7"; Break }
            "'Product:bfeb1830-4b34-40d0-a2d7-8d6f994ddb58'" { [array]$Translation_Product += "Windows 11 Client, version 22H2 and later, Upgrade & Servicing Drivers"; Break }
            "'Product:c1006636-eab4-4b0b-b1b0-d50282c0377e'" { [array]$Translation_Product += "Windows 10 S and Later Servicing Drivers"; Break }
            "'Product:c34286fc-0dd4-426e-afe1-81771b7a2243'" { [array]$Translation_Product += "Windows 10 S, Vibranium and later, Servicing Drivers"; Break }
            "'Product:c5f0b23c-e990-4b71-9808-718d353f533a'" { [array]$Translation_Product += "SQL Server 2008"; Break }
            "'Product:c70f1038-66ac-443d-9e58-ac22e891e4fb'" { [array]$Translation_Product += "Windows 10 Fall Creators Update and Later Upgrade & Servicing Drivers"; Break }
            "'Product:c72a8930-b7e7-42ae-8dda-36223b9b006b'" { [array]$Translation_Product += "Azure File Sync agent updates for Windows Server 2022"; Break }
            "'Product:c755e211-dc2b-45a7-be72-0bdc9015a63b'" { [array]$Translation_Product += "Microsoft Application Virtualization 4.6"; Break }
            "'Product:c85cdf84-6e40-4758-a6b0-fde1a4ca3a0d'" { [array]$Translation_Product += "Microsoft Azure Edge Appliance"; Break }
            "'Product:c8a4436c-1043-4288-a065-0f37e9640d60'" { [array]$Translation_Product += "Virtual PC"; Break }
            "'Product:c90a4362-d2b6-4bb4-b316-76d14fed63a5'" { [array]$Translation_Product += "PowerShell Preview - x64"; Break }
            "'Product:c96c35fc-a21f-481b-917c-10c4f64792cb'" { [array]$Translation_Product += "SQL Server Feature Pack"; Break }
            "'Product:c9834186-a976-472b-8384-6bb8f2aa43d9'" { [array]$Translation_Product += "Visual Studio 2010"; Break }
            "'Product:ca006cfb-49eb-439b-880a-1312e1fc9713'" { [array]$Translation_Product += "Windows Insider Pre-Release"; Break }
            "'Product:ca6616aa-6310-4c2d-a6bf-cae700b85e86'" { [array]$Translation_Product += "Microsoft SQL Server 2017"; Break }
            "'Product:caab596c-64f2-4aa9-bbe3-784c6e2ccf9c'" { [array]$Translation_Product += "Microsoft SQL Server 2014"; Break }
            "'Product:cb263e3f-6c5a-4b71-88fa-1706f9549f51'" { [array]$Translation_Product += "Windows Internet Explorer 7 Dynamic Installer"; Break }
            "'Product:cbfd1e71-9d9e-457e-a8c5-500c47cfe9f3'" { [array]$Translation_Product += "Visual Studio 2010 Tools for Office Runtime"; Break }
            "'Product:cc4ab3ac-9d9a-4f53-97d3-e0d6de39d119'" { [array]$Translation_Product += "System Center 2016 - Operations Manager"; Break }
            "'Product:cd2f1c8f-8e60-4789-9366-d9c14b9dd3f5'" { [array]$Translation_Product += "System Center 2019 - Virtual Machine Manager"; Break }
            "'Product:cd8d80fe-5b55-48f1-b37a-96535dca6ae7'" { [array]$Translation_Product += "TMG Firewall Client"; Break }
            "'Product:ce62f77a-28f3-4d4b-824f-0f9b53461d67'" { [array]$Translation_Product += "Search Enhancement Pack"; Break }
            "'Product:cf4aa0fc-119d-4408-bcba-181abb69ed33'" { [array]$Translation_Product += "Visual Studio 2013"; Break }
            "'Product:cfe7182c-14a0-4d7e-9f5e-505d5c3a66f6'" { [array]$Translation_Product += "Windows 10 Creators Update and Later Servicing Drivers"; Break }
            "'Product:d06f861b-2952-4063-bad5-ae8212746a61'" { [array]$Translation_Product += "System Center 2016 - Virtual Machine Manager"; Break }
            "'Product:d123907b-ba63-40cb-a954-9b8a4481dded'" { [array]$Translation_Product += "OneCare Family Safety Installation"; Break }
            "'Product:d2085b71-5f1f-43a9-880d-ed159016d5c6'" { [array]$Translation_Product += "Windows 10 LTSB"; Break }
            "'Product:d22b3d16-bc75-418f-b648-e5f3d32490ee'" { [array]$Translation_Product += "System Center Configuration Manager 2007"; Break }
            "'Product:d31bd4c3-d872-41c9-a2e7-231f372588cb'" { [array]$Translation_Product += "Windows Server 2012 R2"; Break }
            "'Product:d3d7c7a6-3e2f-4029-85bf-b59796b82ce7'" { [array]$Translation_Product += "Exchange Server 2013"; Break }
            "'Product:d72155f3-8aa8-4bf7-9972-0a696875b74e'" { [array]$Translation_Product += "Firewall Client for ISA Server"; Break }
            "'Product:d7d32245-1064-4edf-bd09-0218cfb6a2da'" { [array]$Translation_Product += "Forefront Identity Manager 2010"; Break }
            "'Product:d84d138e-8423-4102-b317-91b1339aa9c9'" { [array]$Translation_Product += "HealthVault Connection Center Upgrades"; Break }
            "'Product:d8584b2b-3ac5-4201-91cb-caf6d240dc0b'" { [array]$Translation_Product += "Expression Media V1"; Break }
            "'Product:d964a0e3-4646-46f5-9b31-b1aa3dcb5246'" { [array]$Translation_Product += "Windows 10, Vibranium and later, Servicing Drivers"; Break }
            "'Product:daa70353-99b4-4e04-b776-03973d54d20f'" { [array]$Translation_Product += "System Center 2012 - App Controller"; Break }
            "'Product:db2680cc-4207-46d2-8d6e-6d5b57e6110b'" { [array]$Translation_Product += "Microsoft Azure Information Protection Unified Labeling Client"; Break }
            "'Product:dbf57a08-0d5a-46ff-b30c-7715eb9498e9'" { [array]$Translation_Product += "Windows Server 2003"; Break }
            "'Product:dd1aa213-54e7-4173-8456-b278964a26b6'" { [array]$Translation_Product += "Windows Safe OS Dynamic Update"; Break }
            "'Product:dd6318d7-1cff-44ed-a0b1-9d410c196792'" { [array]$Translation_Product += "System Center 2012 SP1 - Data Protection Manager"; Break }
            "'Product:dd78b8a1-0b20-45c1-add6-4da72e9364cf'" { [array]$Translation_Product += "OOBE ZDP"; Break }
            "'Product:dee854fd-e9d2-43fd-bbc3-f7568e3ce324'" { [array]$Translation_Product += "Microsoft SQL Server Management Studio v17"; Break }
            "'Product:e104dd76-2895-41c4-9eb5-c483a61e9427'" { [array]$Translation_Product += "Windows 10 Feature On Demand"; Break }
            "'Product:e164fc3d-96be-4811-8ad5-ebe692be33dd'" { [array]$Translation_Product += "Office Communications Server 2007"; Break }
            "'Product:e1c753f2-9f79-4577-b75b-913f4230feee'" { [array]$Translation_Product += "Visual Studio 2010 Tools for Office Runtime"; Break }
            "'Product:e1e98a63-714b-44dd-8699-48021d0183ef'" { [array]$Translation_Product += "Windows Server 2016 for RS4"; Break }
            "'Product:e26d4a30-aba6-4616-a890-011970d93636'" { [array]$Translation_Product += "Windows Server 2016"; Break }
            "'Product:e28b050c-ddb8-47cd-ac7c-0df3ee5fc51c'" { [array]$Translation_Product += "Visual Studio 2015 Update 3"; Break }
            "'Product:e3fde9f8-14d6-4b5c-911c-fba9e0fc9887'" { [array]$Translation_Product += "Visual Studio 2008"; Break }
            "'Product:e49d9f1a-c900-4503-ea91-283000d6b09c'" { [array]$Translation_Product += "SCUP Updates"; Break }
            "'Product:e4b04398-adbd-4b69-93b9-477322331cd3'" { [array]$Translation_Product += "Windows 10 and later Dynamic Update"; Break }
            "'Product:e505a854-6941-484f-a107-ebf0d1b64820'" { [array]$Translation_Product += "System Center 2016 - Orchestrator"; Break }
            "'Product:e54f3c9b-eec3-48f4-a791-ef1e2b0586d0'" { [array]$Translation_Product += "System Center 2012 R2 - Data Protection Manager"; Break }
            "'Product:e727f134-a089-4b23-83f1-3004e054f658'" { [array]$Translation_Product += "Windows 10 S Version 1803 and Later Servicing Drivers"; Break }
            "'Product:e7441a84-4561-465f-9e0e-7fc16fa25ea7'" { [array]$Translation_Product += "Windows Ultimate Extras"; Break }
            "'Product:e88a19fb-a847-4e3d-9ae2-13c2b84f58a6'" { [array]$Translation_Product += "Windows Media Dynamic Installer"; Break }
            "'Product:e903c733-c905-4b1c-a5c4-3528b6bbc746'" { [array]$Translation_Product += "Microsoft Azure Site Recovery Provider"; Break }
            "'Product:e9b56b9a-0ca9-4b3e-91d4-bdcf1ac7d94d'" { [array]$Translation_Product += "Windows Essential Business Server 2008"; Break }
            "'Product:e9c87080-a759-475a-a8fa-55552c8cd3dc'" { [array]$Translation_Product += "Microsoft Works 9"; Break }
            "'Product:e9ece729-676d-4b57-b4d1-7e0ab0589707'" { [array]$Translation_Product += "Microsoft SQL Server 2008 R2 - PowerPivot for Microsoft Excel 2010"; Break }
            "'Product:eac7e88b-d8d4-4158-a828-c8fc1325a816'" { [array]$Translation_Product += "Host Integration Server 2006"; Break }
            "'Product:eb658c03-7d9f-4bfa-8ef3-c113b7466e73'" { [array]$Translation_Product += "Data Protection Manager 2006"; Break }
            "'Product:ec231084-85c2-4daf-bfc4-50bbe4022257'" { [array]$Translation_Product += "Office Live Add-in"; Break }
            "'Product:ec9aaca2-f868-4f06-b201-fb8eefd84cef'" { [array]$Translation_Product += "Windows Server 2008 Server Manager Dynamic Installer"; Break }
            "'Product:ecf560de-38d7-4aa0-beef-e74041c581a4'" { [array]$Translation_Product += "Windows Server 2019 and later, Upgrade & Servicing Drivers"; Break }
            "'Product:eef074e9-61d6-4dac-b102-3dbe15fff3ea'" { [array]$Translation_Product += "Windows Server Solutions Best Practices Analyzer 1.0"; Break }
            "'Product:f0474daf-de38-4b6e-9ad6-74922f6f539d'" { [array]$Translation_Product += "Photo Gallery Installation and Upgrades"; Break }
            "'Product:f14be400-6024-429b-9459-c438db2978d4'" { [array]$Translation_Product += "Windows Embedded Developer Update"; Break }
            "'Product:f3869cc3-897b-4339-bb10-32ab2c765862'" { [array]$Translation_Product += "Microsoft Monitoring Agent"; Break }
            "'Product:f3b1d39b-6871-4b51-8b8c-6eb556c8eee1'" { [array]$Translation_Product += "Expression Design 2"; Break }
            "'Product:f3c2263d-b256-4c49-a246-973c0e366449'" { [array]$Translation_Product += "Windows Server 2012 R2  and later drivers"; Break }
            "'Product:f4b9c883-f4db-4fb5-b204-3343c11fa021'" { [array]$Translation_Product += "Windows Embedded Standard 7"; Break }
            "'Product:f4bde1e9-cf13-4fe4-8416-a28b255defb8'" { [array]$Translation_Product += "Microsoft SQL Server Management Studio v19"; Break }
            "'Product:f54d8a80-c7e1-476c-9995-3d6aee4bfb58'" { [array]$Translation_Product += "Forefront Server Security Category"; Break }
            "'Product:f5b5092c-d05e-4eb1-8a6a-919770378ff6'" { [array]$Translation_Product += "Windows 10 Creators Update and Later Servicing Drivers"; Break }
            "'Product:f61ce0bd-ba78-4399-bb1c-098da328f2cc'" { [array]$Translation_Product += "Virtual Server"; Break }
            "'Product:f6858123-8fe9-4e4a-b1cb-008ef0514e51'" { [array]$Translation_Product += "Windows - Client, version 21H2 and later, Upgrade & Servicing Drivers"; Break }
            "'Product:f702a48c-919b-45d6-9aef-ca4248d50397'" { [array]$Translation_Product += "Windows Server 2019"; Break }
            "'Product:f76b7f51-b762-4fd0-a35c-e04f582acf42'" { [array]$Translation_Product += "Dictionary Updates for Microsoft IMEs"; Break }
            "'Product:f7b29b7a-086b-43f9-9cc8-e1a2f8a31e08'" { [array]$Translation_Product += "Windows 8.1 Drivers"; Break }
            "'Product:f7f096c9-9293-422d-9be8-9f6e90c2e096'" { [array]$Translation_Product += "Report Viewer 2010"; Break }
            "'Product:f7fcd7d7-a163-4b27-970a-48bc02023df1'" { [array]$Translation_Product += "Exchange Server 2019"; Break }
            "'Product:fa5ef799-b817-439e-abf7-c76ba0cacb75'" { [array]$Translation_Product += "ASP.NET Web Frameworks"; Break }
            "'Product:fa9ff215-cfe0-4d57-8640-c65f24e6d8e0'" { [array]$Translation_Product += "Expression Design 1"; Break }
            "'Product:fb08c71c-dbe9-40ab-8302-fb0231b1c814'" { [array]$Translation_Product += "Azure File Sync agent updates for Windows Server 2012 R2"; Break }
            "'Product:fc7c9913-7a1e-4b30-b602-3c62fffd9b1a'" { [array]$Translation_Product += "Windows 10 Language Packs"; Break }
            "'Product:fdcfda10-5b1f-4e57-8298-c744257e30db'" { [array]$Translation_Product += "Active Directory Rights Management Services Client 2.0"; Break }
            "'Product:fdfe8200-9d98-44ba-a12a-772282bf60ef'" { [array]$Translation_Product += "Windows Server 2008 R2"; Break }
            Default {}
        }
    }

    $Parameters.Product = $Translation_Product


# Severities Translation
    foreach ($Item in $Parameters.Severities) {
        switch ($Item) {
            "'0'" { [array]$Translation_Severities += "None" }
            # "'1'" { [array]$Translation_Severities += "" }
            "'2'" { [array]$Translation_Severities += "Low" }
            # "'3'" { [array]$Translation_Severities += "" }
            # "'4'" { [array]$Translation_Severities += "" }
            # "'5'" { [array]$Translation_Severities += "" }
            "'6'" { [array]$Translation_Severities += "Moderate" }
            # "'7'" { [array]$Translation_Severities += "" }
            "'8'" { [array]$Translation_Severities += "Important" }
            # "'9'" { [array]$Translation_Severities += "" }
            "'10'" { [array]$Translation_Severities += "Critical" }
            Default {}
        }
    }

    $Parameters.Severities = $Translation_Severities

# UpdateClassification Translation
    foreach ($Item in $Parameters.UpdateClassification) {
        switch ($Item) {
            "'UpdateClassification:051f8713-e600-4bee-b7b7-690d43c78948'" { [array]$Translation_UpdateClassification += "WSUS Infrastructure Updates"; Break }
            "'UpdateClassification:0fa1201d-4330-4fa8-8ae9-b877473b6441'" { [array]$Translation_UpdateClassification += "Security Updates"; Break }
            "'UpdateClassification:28bc880e-0592-4cbf-8f95-c79b17911d5f'" { [array]$Translation_UpdateClassification += "Update Rollups"; Break }
            "'UpdateClassification:3689bdc8-b205-4af4-8d4a-a63924c5e9d5'" { [array]$Translation_UpdateClassification += "Upgrades"; Break }
            "'UpdateClassification:5c9376ab-8ce6-464a-b136-22113dd69801'" { [array]$Translation_UpdateClassification += "Applications"; Break }
            "'UpdateClassification:68c5b0a3-d1a6-4553-ae49-01d3a7827828'" { [array]$Translation_UpdateClassification += "Service Packs"; Break }
            "'UpdateClassification:77835c8d-62a7-41f5-82ad-f28d1af1e3b1'" { [array]$Translation_UpdateClassification += "Driver Sets"; Break }
            "'UpdateClassification:b4832bd8-e735-4761-8daf-37f882276dab'" { [array]$Translation_UpdateClassification += "Tools"; Break }
            "'UpdateClassification:b54e7d24-7add-428f-8b75-90a396fa584f'" { [array]$Translation_UpdateClassification += "Feature Packs"; Break }
            "'UpdateClassification:cd5ffd1e-e932-4e3a-bf74-18bf0b1bbd83'" { [array]$Translation_UpdateClassification += "Updates"; Break }
            "'UpdateClassification:e0789628-ce08-4437-be74-2495b842f43b'" { [array]$Translation_UpdateClassification += "Definition Updates"; Break }
            "'UpdateClassification:e6cf1350-c01b-414d-a61f-263d14d133b4'" { [array]$Translation_UpdateClassification += "Critical Updates"; Break }
            "'UpdateClassification:ebfc1fc5-71a4-4f7b-9aca-3b9a503104a0'" { [array]$Translation_UpdateClassification += "Drivers"; Break }
            Default {}
        }
    }

    $Parameters.UpdateClassification = $Translation_UpdateClassification

# Vendor Translation
    foreach ($Item in $Parameters.Vendor) {
        switch ($Item) {
            "'Company:510a93c7-9415-599a-77ab-ad27ceebb380'" { [array]$Translation_Vendor += "Patch My PC"; Break }
            "'Company:56309036-4c77-4dd9-951a-99ee9c246a94'" { [array]$Translation_Vendor += "Microsoft"; Break }
            "'Company:7c40e8c2-01ae-47f5-9af2-6e75a0582518'" { [array]$Translation_Vendor += "Local Publisher"; Break }
            Default {}
        }
    }

    $Parameters.Vendor = $Translation_Vendor


# ---------------------------------------------------------------------------------------------------

# function Get-VR_ADRInfo {
#    $Object_ADR = Get-CMSoftwareUpdateAutoDeploymentRule -Name $MECM_ADRName

#    $XML_ADR_AutoDeploymentProperties   = $([xml]$Object_ADR.AutoDeploymentProperties).AutoDeploymentRule
#    $XML_ADR_ContentTemplate            = $([xml]$Object_ADR.ContentTemplate).ContentActionXML
#    $XML_ADR_DeploymentTemplate         = $([xml]$Object_ADR.DeploymentTemplate).DeploymentCreationActionXML
#    $XML_ADR_UpdateRuleXML              = $([xml]$Object_ADR.UpdateRuleXML).UpdateXML.UpdateXMLDescriptionItems

#    $XML_ADR_UpdateRuleXML_DateRevised      = Select-Xml -Xml $([xml]$Object_ADR.UpdateRuleXML).UpdateXML.UpdateXMLDescriptionItems -XPath "//UpdateXMLDescriptionItem[@PropertyName=`"DateRevised`"]"

#    Write-Host "  Value: $($XML_ADR_UpdateRuleXML_DateRevised.Node.MatchRules.string)"
#    Write-Host ""
#    Write-Host "-------------------------------------"
#    Write-Host ""
# }

# ---------------------------------------------------------------------------------------------------






# $Schedule = New-CMSchedule -DayOfWeek Wednesday

New-CMSoftwareUpdateAutoDeploymentRule @Parameters


# Cleanup
    # Get-Variable -Name "Temp_*" | Remove-Variable
    # Get-Variable -Name "Translation_*" | Remove-Variable
    # Get-Variable -Name "Parameters" | Remove-Variable
    # Get-Variable -Name "Translation_*" | Remove-Variable
    # Get-Variable -Name "XML_ADR_*" | Remove-Variable
    # Get-Variable -Name "Object_ADR" | Remove-Variable
    # Get-Variable -Name "MECM_*" | Remove-Variable