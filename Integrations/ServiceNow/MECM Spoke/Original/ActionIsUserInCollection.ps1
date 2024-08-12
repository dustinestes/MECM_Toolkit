Param([string]$collection, [string]$user)

# Import Microsoft Endpoint Manager module
Import-Module "$executingScriptDirectory\MicrosoftEndpointConfigurationManagerSpoke\MicrosoftEndpointManagerMain" -DisableNameChecking

# Copy the environment variables to their parameters
if (test-path env:\SNC_collection) {
  $collection = $env:SNC_collection
  $user = $env:SNC_user
}

SNCLog-ParameterInfo @("Running IsUserInCollection", $collection, $user)

function TestUserCollection() {
   Import-Module -Name "$(split-path $Env:SMS_ADMIN_UI_PATH)\ConfigurationManager.psd1"
   Set-Location -path "$(Get-PSDrive -PSProvider CMSite):\"

   $collectionName = $args[0]; 
   $username = "*\" + $args[1] + " *";

   $collection = Get-CMUserCollection -Name $collectionName;
   if($collection -eq $null  -or  $collection.CollectionType -ne 1) {   #user collection type is 1
      return "invalid collection name";
   }

   if($collection.MemberCount -lt 1) {   #there are no members in collection
      return $false;
   }

   $user = Get-CMUser -Name $userName;
   if($user -eq $null) {
       return "invalid user name";
   }

   $userId = $user.ResourceID; 

   $users = Get-CMUserCollectionDirectMembershipRule -CollectionName $collectionName;
   ForEach($user in $users) {
       if ($userId -eq $user.ResourceID) {
          return $true;
        }
   }
   
   return $false;
}

try {
    $session = Create-PSSession -sccmServerName $computer -credential $cred

    SNCLog-DebugInfo "`tInvoking Invoke-Command -ScriptBlock `$'{function:TestUserCollection}' -ArgumentList $collection, $user"
    if(($collection -eq $null) -or ($collection -eq "")) {
        Write-Host "Empty collection name"
    } elseif(($user -eq $null) -or ($user -eq "")) {
        Write-Host "Empty user name"
    } else {
         Invoke-Command -Session $session -ScriptBlock ${function:TestUserCollection} -ArgumentList $collection, $user
    }
} catch {
    Write-Host $error
} finally {
    if($session -ne $null) {
        Remove-PSSession -session $session
    }
}