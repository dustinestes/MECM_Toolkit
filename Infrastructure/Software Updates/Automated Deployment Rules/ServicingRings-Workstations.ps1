
# Variables
    $Splat_UpdatePackage = @{
        Name = "SU - Workstations - Windows 10 (Test)"
        Description = "A package for storing and distributing all of the update content from the Automatic Deployment Rule with the same name."
        Path = "\\vividrock.com\Repo\Software Updates\MECM\SU - Workstations - Windows 10 (Test)"
        Priority = "Normal"
    }

    $Schedule_ADR = New-CMSchedule -IsUtc -Start (Get-Date -Date "01/01/2020" -Hour "08" -Minute "00" -Second "00" -Format o) -DayOfWeek Wednesday -WeekOrder Second -RecurCount 1
    $Splat_ADR = @{
        # Rule Information
            # General
                Name = "SU - Workstations - Windows 10 (Test)"
                Description = "Standard update rule for the Windows 10 devices."
                AddToExistingSoftwareUpdateGroup = $False
                Enable = $False
            # Deployment Settings
                DeployWithoutLicense = $True
            # Software Updates
                #ArticleId = "test"
                #CustomSeverity = Critical
                #DateReleasedOrRevised = Last1day
                #Product = ""
                #Required = ""
                #Severity = ""
                Superseded = $False
                #Title = ""
                #UpdateClassification = "Critical Updates"
                #UpdateDescription = ""
                #Vendor = ""
            # Evaluation Schedule
                RunType = "RunTheRuleOnSchedule"
                Schedule = $Schedule_ADR
            # Alerts
                GenerateFailureAlert = $True
            # Language Selection
                LanguageSelection = "English"
                O365LanguageSelection = "English (United States)"
            # Deployment Package
                DeploymentPackageName = $Splat_UpdatePackage.Name

        # Deployment Configuration
            # Collection
                CollectionName = "SU - Workstations - Windows 10 - Wave 0"
                EnabledAfterCreate = $True
            # Deployment Settings
                SendWakeUpPacket = $True
                VerboseLevel = "OnlyErrorMessages"
            # Deployment Schedule
                UseUtc = $False
                AvailableImmediately = $True
                #AvailableTime = "5"
                #AvailableTimeUnit = "Months"
                DeadlineImmediately = $True
                #DeadlineTime = "$True"
                #DeadlineTimeUnit = "Hours"
                SoftDeadlineEnable = $False
            # User Experience
                UserNotification = "DisplayAll"
                AllowSoftwareInstallationOutsideMaintenanceWindow = $True
                AllowRestart = $True
                SuppressRestartServer = $True
                SuppressRestartWorkstation = $false
                WriteFilterHandling = $True
                RequirePostRebootFullScan = $True
            # Alerts
                GenerateSuccessAlert = $True
                SuccessPercent = "99"
                AlertTime = 2
                AlertTimeUnit = "Weeks"
                DisableOperationManager = $True
                GenerateOperationManagerAlert = $False
            # Download Settings
                NoInstallOnRemote = $False
                NoInstallOnUnprotected = $True
                DownloadFromMicrosoftUpdate = $False
                AllowUseMeteredNetwork = $False
                DownloadFromInternet = $True
                #Location = "\\k\aS_O15_Client_Dev_1"
                UseBranchCache = $False
    }

# Create Software Update Package
    if ((Get-CMSoftwareUpdateDeploymentPackage -Name $Splat_UpdatePackage.Name) -in "",$null) {
        New-Item -Path $("filesystem::" + $Splat_UpdatePackage.Path) -ItemType Directory -Force
        New-CMSoftwareUpdateDeploymentPackage @Splat_UpdatePackage
    }

# Create ADR
    New-CMSoftwareUpdateAutoDeploymentRule @Splat_ADR

