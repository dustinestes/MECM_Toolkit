Param([string]$properties)

# Import Microsoft Endpoint Manager module
Import-Module "$executingScriptDirectory\MicrosoftEndpointConfigurationManagerSpoke\MicrosoftEndpointManagerMain" -DisableNameChecking;

# Copy the environment variables to their parameters
if (test-path env:\SNC_properties) {
  $properties = $env:SNC_properties;
}

SNCLog-ParameterInfo @("Running GetApplications", $properties);

function Get-Applications() {
   Import-Module -Name "$(split-path $Env:SMS_ADMIN_UI_PATH)\ConfigurationManager.psd1";
   Set-Location -path "$(Get-PSDrive -PSProvider CMSite):\";

   #getting list of all properties associated with applications
   $allPropsArray = @();
   $allApplications = Get-CMApplication;
   $allApplications | Select * | ForEach-Object {
      $_ | Get-Member -MemberType "NoteProperty" | Select-Object "Name" | ForEach-Object {
         $allPropsArray += $_.name;
      }
   }

   #the array with list of properties displayed by default
   $searchFilterDefault =  "CI_ID,CI_UniqueID,LocalizedDisplayName,Manufacturer,SoftwareVersion,IsDeployable,IsDeployed,NumberOfUsersWithApp,NumberOfDevicesWithApp";
   $defaultFilterArray  = $searchFilterDefault -split ",";

   #the array with additional properties taken from input
   $properties = $args[0];
   $additionalFilterArray = $properties -split ",";

   $resultArray = @();

   if($properties -eq "" -or $properties -eq $null) {
      $searchFilterArray = $defaultFilterArray;
   } else {
      #concatenate default and valid input properties arrays
      $searchFilterArray = $defaultFilterArray + $additionalFilterArray | Select-Object -Unique;
   }

   $allApplications  | Select $searchFilterArray | ForEach-Object {
      $appInfo = @{};
      $app = $_;

      $app | Get-Member -MemberType Properties | ForEach-Object {
         $key = $_.name;
         if($allPropsArray.Contains($key)) {
               $appInfo.Add($key, $app.$key);
         } else {
            return "invalid property";
         }
      }

      $resultArray += $appInfo;
   }

   ConvertTo-Json $resultArray;
}

function Get-AllApplications() {
   Import-Module -Name "$(split-path $Env:SMS_ADMIN_UI_PATH)\ConfigurationManager.psd1";
   Set-Location -path "$(Get-PSDrive -PSProvider CMSite):\";

   $resultArray = @();

   Get-CMApplication | ForEach-Object {
      $appInfo = @{};
      $app = $_;

      $app | Get-Member -MemberType Properties  | ForEach-Object {
         $key = $_.name;
         $appInfo.Add($key, $app.$key);
      }
         
      $resultArray += $appInfo;
   }
   ConvertTo-Json $resultArray;
}

try {
    $session = Create-PSSession -sccmServerName $computer -credential $cred;

   if($properties -match "^[a-zA-Z,*?\[\]\-_]+$" -or $properties -eq "" -or $properties -eq $null -and  $properties -ne "*") {
      SNCLog-DebugInfo "`tInvoking Invoke-Command -ScriptBlock `$'{function:Get-Applications}' -ArgumentList $properties";
      Invoke-Command -Session $session -ScriptBlock ${function:Get-Applications} -ArgumentList $properties;
   } elseif($properties -eq "*") {
      SNCLog-DebugInfo "`tInvoking Invoke-Command -ScriptBlock `$'{function:Get-AllApplications}' -ArgumentList $properties";
       Invoke-Command -Session $session -ScriptBlock ${function:Get-AllApplications} -ArgumentList $properties;
   } else {
      Write-Host "invalid chars in property";
   }
} catch {
    Write-Host $error;
} finally {
    if($session -ne $null) {
        Remove-PSSession -session $session;
    }
}