$updates = Get-WmiObject -Namespace Root\ccm\clientSDK -Class CCM_softwareupdate

If ($updates -ne $null){

$dead = $updates.deadline[0]

$UTC = [System.Management.ManagementDateTimeConverter]::ToDateTime($dead)

$Timespan = New-TimeSpan -Start $utc -End (get-date)

$countdown = ($Timespan.Days.ToString()).TrimStart('-')

Set-Location $env:windir\CCM

.\SCToastNotification.exe "Notice: Pending Updates" "You have Software Updates available to be installed.  You have $countdown days until the updates will install automatically"
}



#------------------------------------------------------------------------------------------------
 get-wmiobject -query "SELECT * FROM CCM_UpdateStatus" -namespace "root\ccm\SoftwareUpdates\UpdatesStore" | where {$_.status -eq "Missing"}



#------------------------------------------------------------------------------------------------
# This will show the updates pending installation
#------------------------------------------------------------------------------------------------
$updates = gwmi -namespace root\ccm\clientsdk -class ccm_softwareupdate -filter ComplianceState=0

$updates | select Name, ArticleID, EvaluationState, ErrorCode, Deadline










<# ---------------------------------------------------------------------------------------------
        MECM - Software Updates Management
------------------------------------------------------------------------------------------------
        Script Name:  Get-PendingSoftwareUpdates
        Purpose:      Gather a list of all the pending Software Updates the device is waiting to

        Team:         Windows Infrastructure Group
        Author:       Dustin Estes
        Date Created: November 09, 2021


--------------------------------------------------------------------------------------------- #>


# Gather updates from WMI
$Updates = Get-WmiObject -Namespace root\ccm\clientsdk -Class ccm_softwareupdate -Filter ComplianceState=0

# Define array
    $Output = @()

# Iterate through each returned update
    foreach ($Update in $Updates) {
        # Convert the StartTime string to a usable format
            $StartTime_TrimmedString = $Update.StartTime -replace '\..*',''
            $StartTime = ([System.DateTime]::ParseExact($StartTime_TrimmedString,'yyyyMMddHHmmss',$null)).ToString("yyyy-MM-dd HH:mm:ss")

        # Convert the Deadline string to a usable format
            $Deadline_TrimmedString = $Update.Deadline -replace '\..*',''
            $Deadline = ([System.DateTime]::ParseExact($Deadline_TrimmedString,'yyyyMMddHHmmss',$null)).ToString("yyyy-MM-dd HH:mm:ss")

        # Create new object
            $Object = New-Object psobject

        # Set property values
            Add-Member -InputObject $Object -MemberType NoteProperty -Name Name -Value $Update.Name
            Add-Member -InputObject $Object -MemberType NoteProperty -Name ArticleID -Value $Update.ArticleID
            Add-Member -InputObject $Object -MemberType NoteProperty -Name ErrorCode  -Value $Update.ErrorCode
            Add-Member -InputObject $Object -MemberType NoteProperty -Name Available -Value $StartTime
            Add-Member -InputObject $Object -MemberType NoteProperty -Name Required -Value $Deadline
            Add-Member -InputObject $Object -MemberType NoteProperty -Name RestartDeadline -Value $Update.RestartDeadline

        #Add object to array
            $Output += $Object
    }

# Write output to console
    $Output