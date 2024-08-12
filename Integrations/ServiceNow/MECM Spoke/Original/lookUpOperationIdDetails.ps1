Param([string]$operationId);

# Import Microsoft Endpoint Manager module
Import-Module "$executingScriptDirectory\MicrosoftEndpointConfigurationManagerSpoke\MicrosoftEndpointManagerMain" -DisableNameChecking;

if (test-path env:\SNC_operationId) {
    $operationId  = $env:SNC_operationId;
}

SNCLog-ParameterInfo @("lookUpOperationIdDetails  ", $operationId);

function lookUpOperation() {
    Import-Module -Name "$(split-path $Env:SMS_ADMIN_UI_PATH)\ConfigurationManager.psd1";
    Set-Location -path "$(Get-PSDrive -PSProvider CMSite):\";
    $SiteCode = Get-PSDrive -PSProvider CMSite;
    $CMPSSuppressFastNotUsedCheck = $true;

    $operation_id = $args[0];

    $Operation = (Get-CimInstance -Namespace root\SMS\Site_$SiteCode -ClassName SMS_ScriptsExecutionStatus -Filter "ClientOperationID = '$operation_id'")[0];
    return $Operation.ScriptOutputHash + "," + $Operation.ScriptGuid + "," + $Operation.TaskID;
}

try {
    $session = Create-PSSession -sccmServerName $computer -credential $cred;
    SNCLog-DebugInfo "`Invoking Invoke-Command -ScriptBlock `$'{function:lookUpOperation}' -ArgumentList $operationId";
    Invoke-Command -Session $session -ScriptBlock ${function:lookUpOperation} -ArgumentList $operationId;
} catch {
    Write-Host $error;
} finally {
    if($session -ne $null) {
        Remove-PSSession -session $session;
    } 
}