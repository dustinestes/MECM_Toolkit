Bin\ServiceUI_x64.exe -process:TsProgressUI.exe %SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -noexit -command (New-Object -ComObject Microsoft.SMS.TsProgressUI).CloseProgressDialog() ;
Invoke-Command -ScriptBlock { ;
    $Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment ;
    Clear-Host ;
    write-host "----------------------------------------------------------------------------------------------" ;
    write-host "$([char]32)$([char]32)MECM - Task Sequence - Execution Status: Failure" ;
    write-host "----------------------------------------------------------------------------------------------" ;
    write-host "$([char]32)$([char]32)The Task Sequence experienced an error during execution." ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Step Name:   $($Object_MECM_TSEnvironment.Value('vr_TS_Status_ActionName'))" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Return Code: $($Object_MECM_TSEnvironment.Value('vr_TS_Status_ReturnCode'))" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Success:     $($Object_MECM_TSEnvironment.Value('vr_TS_Status_Success'))" ;
    write-host "$([char]32)" ;
    write-host "$([char]32)$([char]32)Troubleshooting Information" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Computer Name: $($Object_MECM_TSEnvironment.Value('OSDComputerName'))" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Serial `#: $($Object_MECM_TSEnvironment.Value('vr_Device_SerialNumber'))" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Local Log Repo: $($Object_MECM_TSEnvironment.Value('vr_Directory_TaskSequences'))" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Network Log Repo: $($Object_MECM_TSEnvironment.Value('vr_Logging_NetworkRepository'))" ;
    write-host "$([char]32)" ;
    write-host "$([char]32)$([char]32)Next Steps" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Analyze output logs and data to determine if the issue is easily identifed and resolved" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Retry the imaging process on the device" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- If failure persists, notify the MECM team" ;
    write-host "$([char]32)" ;
    write-host "----------------------------------------------------------------------------------------------" ;
    write-host "$([char]32)" ;
    $msg = 'Are you ready to quit the Task Sequence? [Y/N]' ;
    do { $response = Read-Host -Prompt $msg ; if ($response -eq 'n') {} ; }
    until ($response -eq 'y') ; write-host "Exiting Task Sequence..." ;

    $Files_Log_SMSTS = Get-ChildItem -Path "C:\Windows\CCM\Logs\smsts*" ;
    Start-Process -FilePath "C:\Windows\CCM\CMTrace.exe" -ArgumentList $Files_Log_SMSTS.FullName ;
    Pause



    Exit 0 }