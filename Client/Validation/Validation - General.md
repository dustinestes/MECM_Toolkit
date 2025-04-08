# VividRock - MECM Toolkit - Client - Validation

[Text]

## Check MP HTTP[S] Pages

1. Open Internet browser on client
2. Attempt to connect to each of the following links

> Note: You should see pages resolve for the HTTP attempts. You should not see pages reslve for the HTTPS? Need to check.

```html
http[s]://<servername>/sms_mp/.sms_aut?mplist
http[s]://<servername>/sms_mp/.sms_aut?mpcert
http[s]://<servername>/sms_mp/.sms_aut?MPKEYINFORMATION
```

<br>

## Check Client Shares

When using the Client Push Installation method, the Site Server will need to be able to connect to client devices in order to push the content and initiate the installation. To do this, the Site Server will first test to ensure the client is reachable and that the two shares are accessible.

1. Log onto the Site Server
2. Open VSCode
3. Copy the snippet into VSCode
  ```powershell
  $Computers = @("[ComputerFQDN]","[ComputerFQDN]")
  $Dataset = @()

  foreach ($Computer in $Computers) {
    $Temp_Obj = [PSCustomObject]@{
      Name        = $Computer
      IPAddress   = (Test-Connection -ComputerName $Computer -Count 1).IPV4Address.IPAddressToString[0]
      'C$'        = Test-Path -Path "filesystem::\\$($Computer)\C$"
      'Admin$'    = Test-Path -Path "filesystem::\\$($Computer)\Admin$"
    }

    $Dataset += $Temp_Obj
  }

  $Dataset | FT
  ```
4. Replace the placeholder text
5. Execute
6. Analyze the output
7. Done

<br>

## Check BITS Download Jobs

### Snippet

```powershell
$Command = {
    $BitsJobs = Get-BitsTransfer -AllUsers
    Write-Host "Total Jobs: $($BitsJobs.Count)"
    $BitsJobs | Select-Object -Property JobID,JobState,BytesTotal,BytesTransferred,@{name='Percentage';expr={[math]::Round(($_.BytesTransferred / $_.BytesTotal)*100,2)}},FilesTotal,FilesTransferred,FileList | Sort-Object -Property Percentage | Format-Table
}

Invoke-Command -ComputerName "servername.domain.com" -ScriptBlock $Command
```

### Output

```powershell
Total Jobs: 49

JobId                                    JobState  BytesTotal BytesTransferred Percentage FilesTotal FilesTransferred FileList
-----                                    --------  ---------- ---------------- ---------- ---------- ---------------- --------
c408138f-d367-43c9-a1af-b9c2adbfcd6b       Queued   112247072                0          0          1                0 {https://servername.domain.com...
4b08956c-3a47-4a1c-a01e-351aca1691f2        Error   181168421                0          0          9                0 {https://servername.domain.com...
6347c691-70ee-4647-a430-b4b35df4f193       Queued   133299046         59440934      44.59          1                0 {https://servername.domain.com...
2872f642-bc45-4378-a8c4-2b25b8177a63        Error   469005888        209495342      44.67          1                0 {https://servername.domain.com...
4d0cb864-65fb-4c20-b55e-5be1c5caf3d7       Queued   225735176        104531097      46.31          1                0 {https://servername.domain.com...
0fff9c42-33ea-4a7f-8cc4-ce5c6ce251cb       Queued    57646751         55174270      95.71          1                0 {https://servername.domain.com...
5a559cf3-92e3-4ded-8155-b97e763057fc  Transferred 10458658137      10458658137        100         14               14 {https://servername.domain.com...
3fe2ceb0-b1cd-4d38-961a-cfab75299073  Transferred   125630741        125630741        100          9                9 {https://servername.domain.com...
b23ebb3d-ac44-4a57-966e-c88f79fd8666  Transferred  3506365835       3506365835        100         13               13 {https://servername.domain.com...
530114be-aed8-4d4a-ab8f-c5aadb45a20b  Transferred  3281242891       3281242891        100         14               14 {https://servername.domain.com...
cf29dfad-9e32-4cd4-8bbb-2de98c9fc46c  Transferred  2917096870       2917096870        100         14               14 {https://servername.domain.com...
```