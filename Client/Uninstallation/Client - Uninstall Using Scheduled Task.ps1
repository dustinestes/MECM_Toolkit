#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input

    # Scheduled Task Data
        $Name_ScheduledTask = "MECM Toolkit - Uninstall MECM Client"
        $Path_ScheduledTask = "\"

        [string]$XML_ScheduledTask_Content_Windows7 = @'
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>2024-08-07T14:07:42.5386334</Date>
    <Author>VividRock</Author>
    <Description>A task to remove the MECM client from devices after the imaging Task Sequence completes.</Description>
  </RegistrationInfo>
  <Triggers>
    <BootTrigger>
      <Enabled>true</Enabled>
    </BootTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>S-1-5-18</UserId>
      <RunLevel>LeastPrivilege</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <AllowHardTerminate>false</AllowHardTerminate>
    <StartWhenAvailable>false</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT0S</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>PowerShell.exe</Command>
      <Arguments>-NoProfile -NoLogo -WindowStyle Hidden -ExecutionPolicy Bypass -Command "&amp; Start-Transcript -Path 'C:\FSI\MECM\Logs\Scripts\MECM Toolkit - Uninstall MECM Client - Scheduled Task Output.log' ; $Count = 0 ; $Max = 60 ; do {$Count += 1 ; Write-Host `"Attempt $($Count)/$($Max)`" ; $A = $(Get-Process | Where-Object -Property Name -in TsBootShell,TsManager,TsmBootStrap,TsProgressUI) ; Write-Host `"- Processes Found: $($A.Name) `n- Sleeping 10 Seconds`" ;  Start-Sleep -Seconds 10 } until (($A -in '',$null) -or ($Count -eq $Max)) ; if ($Count -eq $Max) { Write-Host '- Timeout Reached' ; Exit 1000 } ; Write-Host 'Removing MECM Client' ; Start-Process -FilePath 'C:\Windows\ccmsetup\ccmsetup.exe' -ArgumentList '/uninstall' -Verb RunAs ;  Write-Host 'Removing Scheduled Task' ; $Object_Schedule = New-Object -ComObject Schedule.Service ; $Object_Schedule.connect() ; $Object_Schedule_FolderRoot = $Object_Schedule.GetFolder('\') ; $Object_Schedule_FolderRoot.DeleteTask('MECM Toolkit - Uninstall MECM Client',0) "</Arguments>
    </Exec>
  </Actions>
</Task>
'@

        [string]$XML_ScheduledTask_Content_Windows10 = @'
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>2024-08-07T14:05:02.4183397</Date>
    <Author>VividRock</Author>
    <Description>A task to remove the MECM client from devices after the imaging Task Sequence completes.</Description>
    <URI>\MECM Toolkit - Uninstall MECM Client</URI>
  </RegistrationInfo>
  <Triggers>
    <BootTrigger>
      <Enabled>true</Enabled>
    </BootTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>S-1-5-18</UserId>
      <RunLevel>LeastPrivilege</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <AllowHardTerminate>false</AllowHardTerminate>
    <StartWhenAvailable>false</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT0S</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>PowerShell.exe</Command>
      <Arguments>-NoProfile -NoLogo -WindowStyle Hidden -ExecutionPolicy Bypass -Command "&amp; Start-Transcript -Path 'C:\FSI\MECM\Logs\Scripts\MECM Toolkit - Uninstall MECM Client - Scheduled Task Output.log' ; $Count = 0 ; $Max = 60 ; do {$Count += 1 ; Write-Host `"Attempt $($Count)/$($Max)`" ; $A = $(Get-Process | Where-Object -Property Name -in TsBootShell,TsManager,TsmBootStrap,TsProgressUI) ; Write-Host `"- Processes Found: $($A.Name) `n- Sleeping 10 Seconds`" ;  Start-Sleep -Seconds 10 } until (($A -in '',$null) -or ($Count -eq $Max)) ; if ($Count -eq $Max) { Write-Host '- Timeout Reached' ; Exit 1000 } ; Write-Host 'Removing MECM Client' ; Start-Process -FilePath 'C:\Windows\ccmsetup\ccmsetup.exe' -ArgumentList '/uninstall' -Verb RunAs ;  Write-Host 'Removing Scheduled Task' ; $Object_Schedule = New-Object -ComObject Schedule.Service ; $Object_Schedule.connect() ; $Object_Schedule_FolderRoot = $Object_Schedule.GetFolder('\') ; $Object_Schedule_FolderRoot.DeleteTask('MECM Toolkit - Uninstall MECM Client',0) "</Arguments>
    </Exec>
  </Actions>
</Task>
'@

    # Metadata
        $Meta_Script_Result    = $false

    # Logging
        $Path_Log_Directory = "$($env:FSI_Directory_Logs)\Scripts"
        $Name_Log_File      = $Name_ScheduledTask
        $Path_Log_File      = $Path_Log_Directory + "\" + $Name_Log_File + ".log"

#EndRegion Input
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    # Write Log Header
        $Temp_Log_Header    = @"
-----------------------------------------------------------------------------------
$($Name_Log_File)
-----------------------------------------------------------------------------------
Author:      Dustin Estes
Company:     VividRock
Date:        February 03, 2024
Copyright:   VividRock LLC - All Rights Reserved
Purpose:     Create a scheduld task that will remove the MECM client after imaging.
-----------------------------------------------------------------------------------
Script Name: $($MyInvocation.MyCommand.Name)
Script Path: $($PSScriptRoot)
Executed:    $((Get-Date).ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss"))
-----------------------------------------------------------------------------------

"@

    Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Header -ErrorAction Stop

#EndRegion Header
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Environment
#   Error Range: 1100 - 1199
#--------------------------------------------------------------------------------------------
#Region Environment



#EndRegion Environment
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Execution

    # Create Scheduled Task
        try {
            # Creat COM Object
                $Object_Schedule = New-Object -ComObject Schedule.Service -ErrorAction Stop

            # Connect to COM Object
                $Object_Schedule.connect()

            # Get Task Folder
                $Object_Schedule_FolderRoot = $Object_Schedule.GetFolder($Path_ScheduledTask)

            # Create Task Based on OS for Correct XML
                switch ((Get-CimInstance -ClassName Win32_OperatingSystem).Caption) {
                    {$_ -like "*Windows 7*" } { $Object_Schedule_FolderRoot.RegisterTask($Name_ScheduledTask,$XML_ScheduledTask_Content_Windows7,2,"SYSTEM",$null,5,$null) }
                    Default { $Object_Schedule_FolderRoot.RegisterTask($Name_ScheduledTask,$XML_ScheduledTask_Content_Windows10,2,"SYSTEM",$null,5,$null) }
                }

            # Check for Newly Created Task
                $Object_ScheduledTask_Existing_Result = $Object_Schedule_FolderRoot.GetTasks(0) | Where-Object -Property Name -eq $Name_ScheduledTask -ErrorAction Stop

                if ($Object_ScheduledTask_Existing_Result -notin "",$null) {
                    $Meta_Script_Result = "Success"
                }
                else {
                    $Meta_Script_Result = "Failure"
                }
        }
        catch {
            $Temp_Log_Error    = @"

Error ID: 1201
Command:  $($PSItem.CategoryInfo.Activity)
Message:  $($PSItem.Exception.Message)

-----------------------------------------------------------------------------------
"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Error -Append -ErrorAction Stop
            Exit 1201
        }

#EndRegion Execution
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Output
#   Error Range: 1300 - 1399
#--------------------------------------------------------------------------------------------
#Region Output

    # Write Log Footer
        try {
            $Temp_XML = ([xml]$Object_ScheduledTask_Existing_Result.XML).Task
            $Temp_Log_Body    = @"

Name: $($Name_ScheduledTask)
Author: $($Temp_XML.RegistrationInfo.Author)
Description: $($Temp_XML.RegistrationInfo.Description)
Path: $($Path_ScheduledTask)
Execute: $($Temp_XML.Actions.Exec.Command)
Argument: $($Temp_XML.Actions.Exec.Arguments)

Script Result: $($Meta_Script_Result)

-----------------------------------------------------------------------------------
"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
        }
        catch {
            $Temp_Log_Error    = @"

Error ID: 1301
Command:  $($PSItem.CategoryInfo.Activity)
Message:  $($PSItem.Exception.Message)

-----------------------------------------------------------------------------------
"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Error -Append -ErrorAction Stop
            Exit 1301
        }

    # Return Value to MECM
        if ($Meta_Script_Result -eq "Success") {
            Exit 0
        }
        else {
            Exit 2000
        }

#EndRegion Output
#--------------------------------------------------------------------------------------------
