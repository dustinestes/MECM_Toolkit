Param([string]$collection, [string]$device)

# Import Microsoft Endpoint Manager module
Import-Module "$executingScriptDirectory\MicrosoftEndpointConfigurationManagerSpoke\MicrosoftEndpointManagerMain" -DisableNameChecking

# Copy the environment variables to their parameters
if (test-path env:\SNC_collection) {       
  $collection = $env:SNC_collection
  $device     = $env:SNC_device
}

SNCLog-ParameterInfo @("Running AddToDeviceCollection", $collection, $device)

function Add-ToDeviceCollection() {
   Import-Module -Name "$(split-path $Env:SMS_ADMIN_UI_PATH)\ConfigurationManager.psd1"
   Set-Location -path "$(Get-PSDrive -PSProvider CMSite):\"

   $collection = $args[0]; 
   $device     = $args[1];

   $id = (Get-CMDevice -Name $device).ResourceID
   Add-CMDeviceCollectionDirectMembershipRule -CollectionName $collection -ResourceId $id
}

try {
    $session = Create-PSSession -sccmServerName $computer -credential $cred

    SNCLog-DebugInfo "`tInvoking Invoke-Command -ScriptBlock `$'{function:Add-ToDeviceCollection}' -ArgumentList $collection, $device"

    if(($collection -eq $null) -or ($collection -eq "")) {
        Write-Host "Empty collection name"
    } elseif(($device -eq $null) -or ($device -eq "")) {
        Write-Host "Empty device name"
    } else {
        Invoke-Command -Session $session -ScriptBlock ${function:Add-ToDeviceCollection} -ArgumentList $collection, $device
    } 
} catch {
    Write-Host $error
} finally {
    if($session -ne $null) {
        Remove-PSSession -session $session
    } 
}