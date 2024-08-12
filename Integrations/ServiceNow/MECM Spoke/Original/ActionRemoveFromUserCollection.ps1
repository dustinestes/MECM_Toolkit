Param([string]$collection, [string]$user)

# Import Microsoft Endpoint Manager module
Import-Module "$executingScriptDirectory\MicrosoftEndpointConfigurationManagerSpoke\MicrosoftEndpointManagerMain" -DisableNameChecking

# Copy the environment variables to their parameters
if (test-path env:\SNC_collection) {
   $collection  = $env:SNC_collection
   $user = $env:SNC_user
}
SNCLog-ParameterInfo @("Running RemoveFromUserCollection", $collection, $user)

function Remove-FromUserCollection() {
   Import-Module -Name "$(split-path $Env:SMS_ADMIN_UI_PATH)\ConfigurationManager.psd1"
   Set-Location -path "$(Get-PSDrive -PSProvider CMSite):\"

   $collection = $args[0]
   $username = "*\" + $args[1] + " *"

   $id = (Get-CMUser -Name $username).ResourceID
   Remove-CMUserCollectionDirectMembershipRule -CollectionName $collection -ResourceId $id -Force
}

try {
    $session = Create-PSSession -sccmServerName $computer -credential $cred

    SNCLog-DebugInfo "`tInvoking Invoke-Command -ScriptBlock `$'{function:Remove-FromUserCollection}' -ArgumentList $collection, $user"

    if(($collection -eq $null) -or ($collection -eq "")) {
        Write-Host "Empty collection name"
    } elseif(($user -eq $null) -or ($user -eq "")) {
        Write-Host "Empty user name"
    } else {
        Invoke-Command -Session $session -ScriptBlock ${function:Remove-FromUserCollection} -ArgumentList $collection, $user
    }
} catch {
    Write-Host $error
} finally {
    if($session -ne $null) {
        Remove-PSSession -session $session
    } 
}