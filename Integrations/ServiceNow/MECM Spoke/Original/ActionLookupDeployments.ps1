Param([string]$properties)

# Import Microsoft Endpoint Manager module
Import-Module "$executingScriptDirectory\MicrosoftEndpointConfigurationManagerSpoke\MicrosoftEndpointManagerMain" -DisableNameChecking;

# Copy the environment variables to their parameters
if (test-path env:\SNC_properties) {
  $properties  = $env:SNC_properties;
}

SNCLog-ParameterInfo @("Running GetDeployments", $properties);

function Get-Deployments() {
   Import-Module -Name "$(split-path $Env:SMS_ADMIN_UI_PATH)\ConfigurationManager.psd1";
   Set-Location -path "$(Get-PSDrive -PSProvider CMSite):\";

   #getting list of all properties associated with deployments
   $allPropsArray = @();
   $allDeployments = Get-CMDeployment;
   $allDeployments | Select * | ForEach-Object {
      $_ | Get-Member -MemberType "NoteProperty" | Select-Object "Name" | ForEach-Object {
         $allPropsArray += $_.name;
      }
   }

   #the array with list of properties displayed by default
   $searchFilterDefault =  "DeploymentID,CI_ID,SoftwareName,CollectionID,CollectionName,DesiredConfigType,DeploymentIntent,NumberSuccess,NumberErrors";
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

   $allDeployments | Select $searchFilterArray | ForEach-Object {
      $deploymentInfo = @{};
      $deployment = $_;
      
      $deployment | Get-Member -MemberType Properties  | ForEach-Object {
         $key = $_.name;
         if($allPropsArray.Contains($key)) {
            $deploymentInfo.Add($key, $deployment.$key);
         } else {
            return "invalid property $key";
         }
      }

      $resultArray += $deploymentInfo;
   }

   ConvertTo-Json $resultArray;
}

function Get-AllDeployments() {
   Import-Module -Name "$(split-path $Env:SMS_ADMIN_UI_PATH)\ConfigurationManager.psd1";
   Set-Location -path "$(Get-PSDrive -PSProvider CMSite):\";

   $resultArray = @();

   Get-CMDeployment | ForEach-Object {
      $deploymentInfo = @{};
      $deployment = $_;

      $deployment | Get-Member -MemberType Properties  | ForEach-Object {
         $key = $_.name;
         $deploymentInfo.Add($key, $deployment.$key);
      }
         
      $resultArray += $deploymentInfo;
   }
   ConvertTo-Json $resultArray;
}

try {
    $session = Create-PSSession -sccmServerName $computer -credential $cred;

   if($properties -match "^[a-zA-Z,*?\[\]\-_]+$" -or $properties -eq "" -or $properties -eq $null -and  $properties -ne "*") {
      SNCLog-DebugInfo "`tInvoking Invoke-Command -ScriptBlock `$'{function:Get-Deployments}' -ArgumentList $properties";
       Invoke-Command -Session $session -ScriptBlock ${function:Get-Deployments} -ArgumentList $properties;
   } elseif($properties -eq "*") {
      SNCLog-DebugInfo "`tInvoking Invoke-Command -ScriptBlock `$'{function:Get-AllDeployments}' -ArgumentList $properties";
       Invoke-Command -Session $session -ScriptBlock ${function:Get-AllDeployments} -ArgumentList $properties;
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