Param([string]$deviceId, [string]$scriptGuid, [string]$scriptParams);

# Import Microsoft Endpoint Manager module
Import-Module "$executingScriptDirectory\MicrosoftEndpointConfigurationManagerSpoke\MicrosoftEndpointManagerMain" -DisableNameChecking;

if (test-path env:\SNC_device) {
    $deviceId  = $env:SNC_device;
    $scriptGuid  = $env:SNC_guid;
    $scriptParams  = $env:SNC_params;
}

SNCLog-ParameterInfo @("Running MECM Script", $deviceId, $scriptGuid, $scriptParams);

function RunMECMScript() {
    Import-Module -Name "$(split-path $Env:SMS_ADMIN_UI_PATH)\ConfigurationManager.psd1";
    Set-Location -path "$(Get-PSDrive -PSProvider CMSite):\";
    $CMPSSuppressFastNotUsedCheck = $true;

    $device_id = $args[0];
    $script_guid = $args[1];
    $script_parameter = $args[2];

    $paramsObj = $script_parameter | ConvertFrom-Json;
    $parameters = @{};
    foreach ($obj in $paramsObj.PsObject.Properties) {
        $parameters[$obj.Name] = $obj.Value;
    }

    $operation = (Invoke-CMScript -ScriptGuid $script_guid -Device (Get-CMDevice -ResourceId $device_id) -ScriptParameter $parameters -PassThru);
    return $operation.OperationID;
}

try {
    $session = Create-PSSession -sccmServerName $computer -credential $cred;
    SNCLog-DebugInfo "`Invoking Invoke-Command -ScriptBlock `$'{function:RunMECMScript}' -ArgumentList $deviceId, $scriptGuid, $scriptParams";
    Invoke-Command -Session $session -ScriptBlock ${function:RunMECMScript} -ArgumentList $deviceId, $scriptGuid, $scriptParams;
} catch {
    Write-Host $error;
} finally {
    if($session -ne $null) {
        Remove-PSSession -session $session;
    } 
}