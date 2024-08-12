# MECM Toolkit - Software Updates - Automatic Deployment Rules

```powershell
# Variables
$Splat_UpdatePackage = @{
    Name = "SU - Workstations - Windows 10 (Test)"
    Description = "A package for storing and distributing all of the update content from the Automatic Deployment Rule with the same name."
    Path = "\\vividrock.com\Repo\Software Updates\MECM\SU - Workstations - Windows 10 (Test)"
    Priority = "Normal"
}

$Schedule_ADR = New-CMSchedule -IsUtc -Start (Get-Date -Date "01/01/2020" -Hour "08" -Minute "00" -Second "00" -Format o) -DayOfWeek Wednesday -WeekOrder Second -RecurCount 1 -OffsetDay 0
$Splat_ADR = @{
    # Rule Information
        Name = "SU - Workstations - Windows 10 (Test)"
        Description = "Standard update rule for the Windows 10 devices."
        CollectionName = "SU - Workstations - Windows 10 - Ring 0"
        DeploymentPackageName = $Splat_UpdatePackage.Name

    # Update Filter Criteria
        #ArticleId = "test"
        #CustomSeverity = Critical
        #DateReleasedOrRevised = Last1day
        #Product = ""
        #Required = ""
        #Severity = ""
        #Title = ""
        #UpdateClassification = "Critical Updates"
        #UpdateDescription = ""
        #Vendor = ""

    # Rule Configuration
        AddToExistingSoftwareUpdateGroup = $False
        AlertTime = 2
        AlertTimeUnit = "Weeks"
        AllowRestart = $True
        AllowSoftwareInstallationOutsideMaintenanceWindow = $True
        AllowUseMeteredNetwork = $False
        AvailableImmediately = $True
        #AvailableTime = "5"
        #AvailableTimeUnit = "Months"
        DeadlineImmediately = $True
        #DeadlineTime = "$True"
        #DeadlineTimeUnit = "Hours"
        DeployWithoutLicense = $True
        DisableOperationManager = $True
        #DownloadFromInternet = $False
        DownloadFromMicrosoftUpdate = $False
        EnabledAfterCreate = $False
        GenerateFailureAlert = $True
        GenerateOperationManagerAlert = $False
        GenerateSuccessAlert = $True
        #Location = "\\k\aS_O15_Client_Dev_1"
        NoInstallOnRemote = $False
        NoInstallOnUnprotected = $True
        RequirePostRebootFullScan = $True
        RunType = "RunTheRuleOnSchedule"
        Schedule = $Schedule_ADR
        SendWakeUpPacket = $True
        SuccessPercent = "99"
        Superseded = $False
        SuppressRestartServer = $True
        SuppressRestartWorkstation = $false
        UseBranchCache = $False
        UserNotification = "DisplayAll"
        UseUtc = $True
        VerboseLevel = "OnlyErrorMessages"
        WriteFilterHandling = $True
}

# Create Software Update Package
    New-Item -Path $("filesystem::" + $Splat_UpdatePackage.Path) -ItemType Directory -Force
    New-CMSoftwareUpdateDeploymentPackage @Splat_UpdatePackage

# Create ADR
    New-CMSoftwareUpdateAutoDeploymentRule @Splat_ADR


```