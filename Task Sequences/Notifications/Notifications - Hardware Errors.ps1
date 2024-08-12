Bin\ServiceUI_x64.exe -process:TsProgressUI.exe %SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -noexit -command (New-Object -ComObject Microsoft.SMS.TsProgressUI).CloseProgressDialog() ;
Invoke-Command -ScriptBlock { ;
    $Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment ;
    Clear-Host ;
    write-host "----------------------------------------------------------------------------------------------" ;
    write-host "$([char]32)$([char]32)MECM - Task Sequence - Hardware Status: Error" ;
    write-host "----------------------------------------------------------------------------------------------" ;
    write-host "$([char]32)$([char]32)There were errors found with one or more pieces of hardware on this device." ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Hardware Status:   $($Object_MECM_TSEnvironment.Value('vr_Hardware_ValidationStatus'))" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Total Hardware: $($Object_MECM_TSEnvironment.Value('vr_Hardware_TotalHardware'))" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Total Errors:     $($Object_MECM_TSEnvironment.Value('vr_Hardware_TotalErrors'))" ;
    write-host "$([char]32)" ;
    write-host "$([char]32)$([char]32)What Next" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Restart the device and boot into windows" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Inspect Device Manager to determine what drivers are not being installed" ;
    write-host "$([char]32)$([char]32)$([char]32)$([char]32)- Resolve the issue with the driver installation steps in the Task Sequence and try again" ;
    write-host "$([char]32)" ;
    write-host "----------------------------------------------------------------------------------------------" ;
    write-host "$([char]32)" ;
    $msg = 'Are you ready to quit the Task Sequence? [Y/N]' ;
    do { $response = Read-Host -Prompt $msg ; if ($response -eq 'n') {} ; }
    until ($response -eq 'y') ; write-host "Exiting Task Sequence..." ;

    Exit 1001 }