#--------------------------------------------------------------------------------------------
# Notes
#--------------------------------------------------------------------------------------------
#Region Notes

# RunAs: System

#EndRegion Notes
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input

  # MECM Settings
    $Name_ConfigurationItem = "CI - IIS - Log File Cleanup"
    $Operation_Type         = "Discovery" # "Discovery","Remediation"
    $Path_Log_Directory     = "$($env:vr_Directory_Logs)\ConfigurationBaselines\$($Operation_Type)"

  # Scheduled Task
    $ScheduledTask = @{
      Name        = "IIS - Log File Cleanup"
      Path        = "\VividRock\MECM\IIS\"
      Author      = "VividRock"
      Description = "A task that runs a PowerShell script that utilizes a trailing period of time to identify and remove obsolete log files to reduce disk space usage and prevent runaway consumption."
      Command     = "powershell.exe"
      Arguments   = '-NoProfile -NoLogo -WindowStyle Hidden -ExecutionPolicy Bypass -File "\\[Path]\Repo\Scripts\Maintenance Tasks\IIS\Maintenance Task - IIS - Log File Cleanup.ps1" -RetentionDays "30" -Criteria "CreationTimeUtc" -OutputDir "\\[Path]\Repo\Logging\Maintenance Tasks\IIS" -OutputName "Maintenance Task - IIS - Log File Cleanup"'
    }



#EndRegion Input
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Builtin (Do Not Edit)
#--------------------------------------------------------------------------------------------
#Region Builtin

  # Metadata
    $Meta_Script_Execution_Context  = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $Meta_Script_Start_DateTime     = Get-Date
    $Meta_Script_Complete_DateTime  = $null
    $Meta_Script_Complete_TimeSpan  = $null
    $Meta_Result                    = $null
    $Meta_Result_Successes          = 0
    $Meta_Result_Failures           = 0

  # Preferences
    $ErrorActionPreference          = "Stop"

  # Logging
    if ($Meta_Script_Execution_Context.Name -eq "NT AUTHORITY\SYSTEM") {
      $Path_Log_File      = $Path_Log_Directory + "\" + $Name_ConfigurationItem + ".log"
    }
    else {
      $Path_Log_File      = $Path_Log_Directory + "\" + $Name_ConfigurationItem + "_" + $(($Meta_Script_Execution_Context.Name -split "\\")[1]) + ".log"
    }

#EndRegion Builtin
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

  Out-File -InputObject "-----------------------------------------------------------------------------------" -FilePath $Path_Log_File
  Out-File -InputObject "  $($Name_ConfigurationItem)" -FilePath $Path_Log_File -Append
  Out-File -InputObject "-----------------------------------------------------------------------------------" -FilePath $Path_Log_File -Append
  Out-File -InputObject "  Author:      Dustin Estes" -FilePath $Path_Log_File -Append
  Out-File -InputObject "  Company:     VividRock" -FilePath $Path_Log_File -Append
  Out-File -InputObject "  Date:        February 17, 2024" -FilePath $Path_Log_File -Append
  Out-File -InputObject "  Copyright:   VividRock LLC - All Rights Reserved" -FilePath $Path_Log_File -Append
  Out-File -InputObject "  Purpose:     Perform operations of a Configuration Item and return boolean results." -FilePath $Path_Log_File -Append
  Out-File -InputObject "-----------------------------------------------------------------------------------" -FilePath $Path_Log_File -Append
  Out-File -InputObject "  Script Name: $($MyInvocation.MyCommand.Name)" -FilePath $Path_Log_File -Append
  Out-File -InputObject "  Script Path: $($PSScriptRoot)" -FilePath $Path_Log_File -Append
  Out-File -InputObject "  Execution Context: $($Meta_Script_Execution_Context.Name)" -FilePath $Path_Log_File -Append
  Out-File -InputObject "-----------------------------------------------------------------------------------" -FilePath $Path_Log_File -Append

#EndRegion Header
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Execution

  # Scheduled Task
    Out-File -InputObject "Scheduled Task" -FilePath $Path_Log_File -Append

    # Define Body of Task
    [string]$ScheduledTask_Body  = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.3" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
    <RegistrationInfo>
        <Author>$($ScheduledTask.Author)</Author>
        <Description>$($ScheduledTask.Description)</Description>
        <URI>$($ScheduledTask.Path + $ScheduledTask.Name)</URI>
        <SecurityDescriptor></SecurityDescriptor>
    </RegistrationInfo>
    <Triggers>
        <CalendarTrigger>
            <StartBoundary>2025-02-01T06:00:00</StartBoundary>
            <ExecutionTimeLimit>PT1H</ExecutionTimeLimit>
            <Enabled>true</Enabled>
            <ScheduleByWeek>
                <DaysOfWeek>
                    <Saturday />
                </DaysOfWeek>
                <WeeksInterval>1</WeeksInterval>
            </ScheduleByWeek>
        </CalendarTrigger>
    </Triggers>
    <Principals>
        <Principal id="Author">
            <UserId>S-1-5-18</UserId>
            <RunLevel>LeastPrivilege</RunLevel>
        </Principal>
    </Principals>
    <Settings>
        <MultipleInstancesPolicy>StopExisting</MultipleInstancesPolicy>
        <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
        <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
        <AllowHardTerminate>true</AllowHardTerminate>
        <StartWhenAvailable>true</StartWhenAvailable>
        <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
        <IdleSettings>
            <Duration>PT10M</Duration>
            <WaitTimeout>PT1H</WaitTimeout>
            <StopOnIdleEnd>true</StopOnIdleEnd>
            <RestartOnIdle>false</RestartOnIdle>
        </IdleSettings>
        <AllowStartOnDemand>true</AllowStartOnDemand>
        <Enabled>true</Enabled>
        <Hidden>false</Hidden>
        <RunOnlyIfIdle>false</RunOnlyIfIdle>
        <DisallowStartOnRemoteAppSession>false</DisallowStartOnRemoteAppSession>
        <UseUnifiedSchedulingEngine>true</UseUnifiedSchedulingEngine>
        <WakeToRun>false</WakeToRun>
        <ExecutionTimeLimit>PT1H</ExecutionTimeLimit>
        <Priority>7</Priority>
    </Settings>
    <Actions>
        <Exec>
            <Command>$($ScheduledTask.Command)</Command>
            <Arguments>$($ScheduledTask.Arguments)</Arguments>
        </Exec>
    </Actions>
</Task>
"@

    try {
      Out-File -InputObject "  - $($ScheduledTask.Name)" -FilePath $Path_Log_File -Append
      Out-File -InputObject "      Path: $($ScheduledTask.Path)" -FilePath $Path_Log_File -Append
      Out-File -InputObject "      Author: $($ScheduledTask.Author)" -FilePath $Path_Log_File -Append
      Out-File -InputObject "      Description: $($ScheduledTask.Description)" -FilePath $Path_Log_File -Append

      # Get Task State
        $Temp_ScheduledTask = Get-ScheduledTask -TaskName $ScheduledTask.Name -ErrorAction SilentlyContinue

      # Make Arrays
        $ScheduledTask_Array = $ScheduledTask_Body -split "\n"
        $Temp_ScheduledTask_Array = ($Temp_ScheduledTask | Export-ScheduledTask) -split "\n"
        Out-File -InputObject "      Desired XML Line Count: $($ScheduledTask_Array.Count)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      Existing XML Line Count: $($Temp_ScheduledTask_Array.Count)" -FilePath $Path_Log_File -Append

      # Perform Operation Type
        # Not Exist
        if ($Temp_ScheduledTask -in "",$null) {
          if ($Operation_Type -eq "Discovery") {
            $Meta_Result_Failures ++
            Out-File -InputObject "      Result: Failure, Scheduled Task Not Found" -FilePath $Path_Log_File -Append
          }
          elseif ($Operation_Type -eq "Remediation") {
            $Temp_Result = Register-ScheduledTask -TaskPath $ScheduledTask.Path -TaskName $ScheduledTask.Name -Xml $ScheduledTask_Body
            $Meta_Result_Successes ++
            Out-File -InputObject "      Result: Success, Scheduled Task Created" -FilePath $Path_Log_File -Append
          }
        }
        # Incorrect Path
        elseif ($Temp_ScheduledTask.TaskPath -ne $ScheduledTask.Path) {
          if ($Operation_Type -eq "Discovery") {
            $Meta_Result_Failures ++
            Out-File -InputObject "      Existing Path: $($Temp_ScheduledTask.TaskPath)" -FilePath $Path_Log_File -Append
            Out-File -InputObject "      Result: Failure, Scheduled Task Found in Wrong Path" -FilePath $Path_Log_File -Append
          }
          elseif ($Operation_Type -eq "Remediation") {
            $Temp_ScheduledTask | Unregister-ScheduledTask -Confirm:$false
            $Temp_Result = Register-ScheduledTask -TaskPath $ScheduledTask.Path -TaskName $ScheduledTask.Name -Xml $ScheduledTask_Body
            $Meta_Result_Successes ++
            Out-File -InputObject "      Existing Path: $($Temp_ScheduledTask.TaskPath)" -FilePath $Path_Log_File -Append
            Out-File -InputObject "      New Path: $($ScheduledTask.Path)" -FilePath $Path_Log_File -Append
            Out-File -InputObject "      Result: Success, Scheduled Task Moved to Correct Path" -FilePath $Path_Log_File -Append
          }

        }
        # Compare Existing State to Desired State
        else {
          $Count_Mismatches = 0
          $Index = 0

          foreach ($Line in $ScheduledTask_Array) {
            switch ($Line) {
              {$_.Trim() -eq $Temp_ScheduledTask_Array[$Index].Trim()} {Continue}
              {$_.Trim() -ne $Temp_ScheduledTask_Array[$Index].Trim()} {
                $Count_Mismatches ++
                Out-File -InputObject "      Line: $($Index), Expected: $($Line.Trim()), Found: $($Temp_ScheduledTask_Array[$Index].Trim())" -FilePath $Path_Log_File -Append
                Continue
              }
              Default {
                $Count_Mismatches ++
                Out-File -InputObject "      Line: $($Index), Expected: $($Line.Trim()), Found: $($Temp_ScheduledTask_Array[$Index].Trim())" -FilePath $Path_Log_File -Append
                Continue
              }
            }

            # Increment Indexer
              $Index ++
          }

          # Process Mismatches
            if ($Count_Mismatches -gt 0) {
              if ($Operation_Type -eq "Discovery") {
                $Meta_Result_Failures ++
                Out-File -InputObject "      Result: Failure, Scheduled Task is Not a Match" -FilePath $Path_Log_File -Append
              }
              elseif ($Operation_Type -eq "Remediation") {
                $Temp_ScheduledTask | Unregister-ScheduledTask -Confirm:$false
                $Temp_Result = Register-ScheduledTask -TaskPath $ScheduledTask.Path -TaskName $ScheduledTask.Name -Xml $ScheduledTask_Body
                $Meta_Result_Successes ++
                Out-File -InputObject "      Result: Success, Scheduled Task Recreated" -FilePath $Path_Log_File -Append
              }
            }
            else {
              if ($Operation_Type -eq "Discovery") {
                $Meta_Result_Successes ++
                Out-File -InputObject "      Result: Success, Scheduled Task is a Match" -FilePath $Path_Log_File -Append
              }
              elseif ($Operation_Type -eq "Remediation") {
                $Meta_Result_Successes ++
                Out-File -InputObject "      Result: Success, Scheduled Task is a Match" -FilePath $Path_Log_File -Append
              }
            }
        }
    }
    catch {
      # Increment Failure Count
        $Meta_Result_Failures ++
        Out-File -InputObject "      Result: Failure, Unknown Error" -FilePath $Path_Log_File -Append
    }

#EndRegion Execution
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Evaluate
#   Error Range: 1300 - 1399
#--------------------------------------------------------------------------------------------
#Region Evaluate

  # Determine Script Result
    if (($Meta_Result_Successes -gt 0) -and ($Meta_Result_Failures -eq 0)) {
      $Meta_Result = $true,"Success"
    }
    else {
      $Meta_Result = $false,"Failure"
    }

#EndRegion Evaluate
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Footer
#--------------------------------------------------------------------------------------------
#Region Footer

	# Gather Data
    $Meta_Script_Complete_DateTime  = Get-Date
    $Meta_Script_Complete_TimeSpan  = New-TimeSpan -Start $Meta_Script_Start_DateTime -End $Meta_Script_Complete_DateTime

  # Output
    Out-File -InputObject "" -FilePath $Path_Log_File -Append
    Out-File -InputObject "------------------------------------------------------------------------------" -FilePath $Path_Log_File -Append
    Out-File -InputObject "  Script Result: $($Meta_Result[1])" -FilePath $Path_Log_File -Append
    Out-File -InputObject "  Script Started: $($Meta_Script_Start_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)" -FilePath $Path_Log_File -Append
    Out-File -InputObject "  Script Completed: $($Meta_Script_Complete_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)" -FilePath $Path_Log_File -Append
    Out-File -InputObject "  Total Time: $($Meta_Script_Complete_TimeSpan.Days) days, $($Meta_Script_Complete_TimeSpan.Hours) hours, $($Meta_Script_Complete_TimeSpan.Minutes) minutes, $($Meta_Script_Complete_TimeSpan.Seconds) seconds, $($Meta_Script_Complete_TimeSpan.Milliseconds) milliseconds" -FilePath $Path_Log_File -Append
    Out-File -InputObject "------------------------------------------------------------------------------" -FilePath $Path_Log_File -Append
    Out-File -InputObject "  End of Script" -FilePath $Path_Log_File -Append
    Out-File -InputObject "------------------------------------------------------------------------------" -FilePath $Path_Log_File -Append

#EndRegion Footer
#--------------------------------------------------------------------------------------------

# Return Value to MECM
  Return $Meta_Result[0]
