Param([string]$collection, [string]$device)

# Import Microsoft Endpoint Manager module
Import-Module "$executingScriptDirectory\MicrosoftEndpointConfigurationManagerSpoke\MicrosoftEndpointManagerMain" -DisableNameChecking


# Copy the environment variables to their parameters
if (test-path env:\SNC_collection) {
  $collection = $env:SNC_collection
  $device        = $env:SNC_device
}

SNCLog-ParameterInfo @("Running IsDeviceInCollection", $collection, $device)

function TestDeviceInCollection() {
   Import-Module -Name "$(split-path $Env:SMS_ADMIN_UI_PATH)\ConfigurationManager.psd1"
   Set-Location -path "$(Get-PSDrive -PSProvider CMSite):\"

   $collectionName = $args[0];
   $deviceName     = $args[1];

   $collection = Get-CMDeviceCollection -Name $collectionName;
   if($collection -eq $null  -or  $collection.CollectionType -ne 2) {   #device collection type is 2
      return "invalid collection name"
   }

   if($collection.MemberCount -lt 1) { #there are no members in collection
      return $false;
   }

   $device = Get-CMDevice -Name $deviceName;
   if($device -eq $null) {
       return "invalid device name"
   }

   $deviceId = $device.ResourceID;

   $devices = Get-CMDeviceCollectionDirectMembershipRule -CollectionName $collectionName;
   ForEach($device in $devices) {
       if ($deviceId -eq $device.ResourceID) {
          return $true;
        }
   }
   
   return $false;
}

try {
    $session = Create-PSSession -sccmServerName $computer -credential $cred

    SNCLog-DebugInfo "`tInvoking Invoke-Command -ScriptBlock `$'{function:TestDeviceInCollection}' -ArgumentList $collection, $device"

    if(($collection -eq $null) -or ($collection -eq "")) {
        Write-Host "Empty collection name"
    } elseif(($device -eq $null) -or ($device -eq "")) {
        Write-Host "Empty device name"
    } else {
        Invoke-Command -Session $session -ScriptBlock ${function:TestDeviceInCollection} -ArgumentList $collection, $device
    }
} catch {
    Write-Host $error
} finally {
    if($session -ne $null) {
        Remove-PSSession -session $session
    }
}