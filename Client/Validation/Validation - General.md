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
