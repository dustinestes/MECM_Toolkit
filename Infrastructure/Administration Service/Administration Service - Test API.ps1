$SMSProvider  = "[ServerFQDN]"
$LogFile      = "\\[ServerFQDN]\repo\Monitoring\MECM_API_$($SMSProvider).log"
$Dataset      = @()

for ($i = 1; $i -lt 1000; $i++) {
  # Initialize
  $Start = $((Get-Date).ToString("yyyy-MM-dd HH:mm:ssz"))
  Write-Host "Job #$($i)"
  Write-Host "  Started: $($Start)"

  # Execute Test
  $Measure = Measure-Command {
      $Odata_Root   = "https://$($SMSProvider)/AdminService/wmi/"
      $Odata_Resource = "SMS_Site"
      $Result = Invoke-RestMethod -Uri "$($Odata_Root + $Odata_Resource)" -Method Get -ContentType "application/json" -UseDefaultCredentials
  }

  # Construct Object
  $Temp_Object = [PSCustomObject]@{
      Job             = $i
      StartExecute    = $Start
      Requestor       = $($env:COMPUTERNAME)
      WebAPIURI       = "$($Odata_Root + $Odata_Resource)"
      DatabaseServer  = "0003wp-dbag-04v.flightsafety.com"
      ObjectsReturned = $($Result.Value.Count)
      ExecutionTime   = "$($Measure.Days):$($Measure.Hours):$($Measure.Minutes):$($Measure.Seconds):$($Measure.Milliseconds)"
  }

  # Append Dataset
  $Dataset += $Temp_Object

  # Output to Log
  $Dataset | Format-Table | Out-File -FilePath "Filesystem::$($LogFile)" -Append

  Write-Host "  Completed: $((Get-Date).ToString("yyyy-MM-dd HH:mm:ssz"))"

  # Sleep Timer
    Start-Sleep -Seconds 60
}