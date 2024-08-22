# Construct Message
    $Message = @"
----------------------------------------------------------------------------------------------
  MECM - MECM Toolkit - Development Environment
----------------------------------------------------------------------------------------------
  Pausing Task Sequence Environment for development and troubleshooting.
    - Minimize this window until you are done testing

  Helpful Snippets
    - Get TS Variables
       `$MECM_Object = New-Object -ComObject Microsoft.SMS.TSEnvironme
       `$MECM_Object.GetVariables() | ForEach-Object { if (`$MECM_Object.Value(`$_).Length -le 100) { Write-Host `"`$(`$_): `$(`$MECM_Object.Value(`$_))`" }

----------------------------------------------------------------------------------------------
"@

# Close Progress Dialog UI
    (New-Object -ComObject Microsoft.SMS.TsProgressUI).CloseProgressDialog()

# Construct Expression
    $ServiceName = "TsProgressUI.exe"
    $Prompt = {
        $msg = 'Do you want to Quit the Task Sequence, or Continue? [Q/C]' ;
        do { $response = Read-Host -Prompt $msg ;
            switch ($response) {
                "Q" { Exit 1000 }
                "C" { Exit 0}
                Default { Exit 1001 }}
            }
        until ($response -in 'Q','C') ;
    }
    $Expression  = "$($env:SystemRoot)\System32\WindowsPowerShell\v1.0\powershell.exe -Command ( Write-Host $($Message); $Prompt )"

# Present Message to user
    Start-Process -FilePath ".\Bin\ServiceUI_x64.exe" -ArgumentList "-process:$($ServiceName) $($Expression)"