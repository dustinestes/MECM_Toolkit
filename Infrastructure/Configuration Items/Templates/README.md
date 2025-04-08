# MECM Toolkit - Infrastructure - Configuration Items - Template Modules

<br>

## Table of Contents

- [MECM Toolkit - Infrastructure - Configuration Items - Template Modules](#mecm-toolkit---infrastructure---configuration-items---template-modules)
  - [Table of Contents](#table-of-contents)
  - [How to Use](#how-to-use)
    - [Best Practices](#best-practices)
  - [Modules](#modules)
    - [File \& Directory](#file--directory)
      - [Discovery](#discovery)
      - [Remediation](#remediation)
    - [Registry](#registry)
      - [System / Current User](#system--current-user)
      - [All Users](#all-users)
      - [Discovery](#discovery-1)
      - [Remediation](#remediation-1)
    - [Scheduled Task](#scheduled-task)
      - [Input Section](#input-section)
      - [Execution Section](#execution-section)
    - [User Shell](#user-shell)
      - [Input Section](#input-section-1)
      - [Execution Section](#execution-section-1)
- [Appendices](#appendices)
  - [Apdx A: \[Name\]](#apdx-a-name)
  - [Apdx X: Templates](#apdx-x-templates)
    - [\[ModuleName\]](#modulename)
      - [Discovery](#discovery-2)
      - [Remediation](#remediation-2)

<br>

## How to Use

The modules within this document add functionality to the Discovery and Remediation templates so you can quickly build and validate new CIs.

1. Copy the Discovery and Remediation templates
2. Rename the files to the format standard you have defined (i.e. [Product] - [Purpose] - [Discovery/Remediation])
3. Locate the module you wish to use from the list below
4. Copy the code to the template by matching the corresponding section in the comment in the module to the corresponding section within the template.
5. DO NOT edit the other sections of the code as they are necessary to support this universal, modular, templated logic structure
6. Save and test both manually and as a configured CI in MECM

### Best Practices

These are some items to consider when utilizing these templates or customizing to make them your own

- Ensure your MECM Client Policy settings is configured so that the Compliance
- Your inputs on both discovery and remediation should be identical. This pervents confusion or accidentally discovering something different than you are remediating on which would cause a remediation loop

## Modules

This is a list of the developed modules thus far along with any variations to them that were identified


### File & Directory

TODO

#### Discovery

Copy this code, including comments, to the Input section of the Template

```powershell
  # File & Directory
    $File_01 = @{
      "Path" = "[PathToFile]"
    }

```

Copy this code, including comments, to the Execution section of the Template

```powershell
  # File & Directory
    Out-File -InputObject "File & Directory" -FilePath $Path_Log_File -Append
    foreach ($Item in $(Get-Variable -Name "File_*")) {
      try {
        Out-File -InputObject "  - $($Item.Name)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      Path: $($Item.Value.Path)" -FilePath $Path_Log_File -Append

        # Get Current State
          $Temp_File_Exists = Test-Path -Path $Item.Value.Path

        # Process Based on Current State
          if ($Temp_File_Exists -eq $false) {
            $Meta_Result_Failures ++
            Out-File -InputObject "      Result: Failure, File Not Exists" -FilePath $Path_Log_File -Append
          }
          elseif ($Temp_File_Exists -eq $true) {
            $Meta_Result_Successes ++
            Out-File -InputObject "      Result: Success, File Exists" -FilePath $Path_Log_File -Append
          }
          else {
            $Meta_Result_Failures ++
            Out-File -InputObject "      Result: Failure, Unknown Error" -FilePath $Path_Log_File -Append
          }
      }
      catch {
        # Increment Failure Count
          $Meta_Result_Failures ++
          Out-File -InputObject "      Result: Failure, Unknown Error" -FilePath $Path_Log_File -Append
      }
    }

```

#### Remediation

Copy this code, including comments, to the Input section of the Template

```powershell
  # [ModuleName]

```

Copy this code, including comments, to the Execution section of the Template

```powershell
  # [ModuleName]

```

### Registry

TODO

#### System / Current User

Copy this code, including comments, to the Input section of the Template

```powershell
  # Registry - System / Current User
    $Registry_Online_01 = @{
      "Path"          = "HKLM:\SOFTWARE\VividRock"
      "Name"          = "Version"
      "PropertyType"  = "String"
      "Value"         = "1.0"
    }
    $Registry_Online_02 = @{
      "Path"          = "HKLM:\SOFTWARE\VividRock"
      "Name"          = "Enabled"
      "PropertyType"  = "Dword"
      "Value"         = 1
    }
```

Copy this code, including comments, to the Execution section of the Template

```powershell
  # Registry - System / Current User
    Out-File -InputObject "Registry - System / Current User" -FilePath $Path_Log_File -Append

    foreach ($Item in (Get-Variable -Name "Registry_Online_*")) {
      try {
        Out-File -InputObject "  - $($Item.Name)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      Path: $($Item.Value.Path)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      Name: $($Item.Value.Name)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      Type: $($Item.Value.PropertyType)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      Desired Value: $($Item.Value.Value)" -FilePath $Path_Log_File -Append

        # Get Current State
          $Temp_Registry_Current = Get-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -ErrorAction SilentlyContinue
          Out-File -InputObject "      Actual Value: $($Temp_Registry_Current.$($Item.Value.Name))" -FilePath $Path_Log_File -Append

        if ($Operation_Type -eq "Discovery") {
          # Process Based on Current State
            if ($Temp_Registry_Current -in "",$null) {
              $Meta_Result_Failures ++
              Out-File -InputObject "      Result: Failure, Object Not Found" -FilePath $Path_Log_File -Append
            }
            elseif ($Temp_Registry_Current.$($Item.Value.Name) -eq $Item.Value.Value) {
              $Meta_Result_Successes ++
              Out-File -InputObject "      Result: Skipped, Value Already Matches" -FilePath $Path_Log_File -Append
            }
            else {
              $Meta_Result_Failures ++
              Out-File -InputObject "      Result: Failure, Value Mismatch" -FilePath $Path_Log_File -Append
            }
        }
        elseif ($Operation_Type -eq "Remediation") {
          # Process Based on Current State
            if ($Temp_Registry_Current -in "",$null) {
              # Create Path if Not Exist
                if ((Test-Path -Path $Item.Value.Path) -in "",$false) {
                  $Temp_PathRecurse = $null

                  foreach ($Item_2 in ($Item.Value.Path -split "\\")) {
                    $Temp_PathRecurse += $Item_2 + "\"
                    if (Test-Path -Path $Temp_PathRecurse) {
                    }
                    else {
                      New-Item -Path $Temp_PathRecurse | Out-Null
                      Out-File -InputObject "      Created Path: $($Temp_PathRecurse)" -FilePath $Path_Log_File -Append
                    }
                  }
                }

              # Create Registry Item
                New-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -PropertyType $Item.Value.PropertyType -Value $Item.Value.Value | Out-Null

              $Meta_Result_Successes ++
              Out-File -InputObject "      Result: Success, Created Property/Value Pair" -FilePath $Path_Log_File -Append
            }
            elseif ($Temp_Registry_Current.$($Item.Value.Name) -eq $Item.Value.Value) {
              $Meta_Result_Successes ++
              Out-File -InputObject "      Result: Skipped, Value Already Matches" -FilePath $Path_Log_File -Append
            }
            else {
              Set-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -Type $Item.Value.PropertyType -Value $Item.Value.Value | Out-Null
              $Meta_Result_Successes ++
              Out-File -InputObject "      Result: Success, Updated Property/Value Pair" -FilePath $Path_Log_File -Append
            }
          }
      }
      catch {
        # Increment Failure Count
          $Meta_Result_Failures ++
          Out-File -InputObject "      Result: Failure, Unknown Error" -FilePath $Path_Log_File -Append
      }
    }
```


#### All Users

TODO: Add All User Profiles Logic

Copy this code, including comments, to the Input section of the Template

```powershell
  # Registry - All Users
    $Registry_Offline_01 = @{
      "Path"          = "SOFTWARE\VividRock"
      "Name"          = "Version"
      "PropertyType"  = "String"
      "Value"         = "1.0"
    }
    $Registry_Offline_02 = @{
      "Path"          = "SOFTWARE\VividRock"
      "Name"          = "Enabled"
      "PropertyType"  = "Dword"
      "Value"         = 1
    }
```

Copy this code, including comments, to the Execution section of the Template

```powershell
  # Registry - All Users
    Out-File -InputObject "Registry - All Users" -FilePath $Path_Log_File -Append

    # Get Each User Profile SID and Path to the Profile
      $User_Profiles = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*" | Where-Object {$_.PSChildName -match "S-1-5-21-(\d+-?){4}$"} | Select-Object @{Name="SID"; Expression={$_.PSChildName}}, @{Name="Hive"; Expression={"$($_.ProfileImagePath)\NTuser.dat"}}

    # Add the .DEFAULT User Profile
      [array]$User_Profiles += [pscustomobject] @{
        SID = "USERTEMPLATE"
        Hive = "C:\Users\Default\NTUSER.dat"
      }

    # Loop Through Each Profile on the Machine
      foreach ($Profile in $User_Profiles) {
        Out-File -InputObject "  - SID: $($Profile.SID)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      Hive: $($Profile.Hive)" -FilePath $Path_Log_File -Append

        # Load if Not Already Loaded
          if ((Test-Path -Path "Registry::HKEY_USERS\$($Profile.SID)") -eq $false) {
            Start-Process -FilePath "cmd.exe" -ArgumentList "/c reg.exe load HKU\$($Profile.SID) $($Profile.Hive)" -Wait -WindowStyle Hidden
          }

        foreach ($Item in (Get-Variable -Name "Registry_Offline_*")) {
          try {
            # Construct the Registry Path
              $Item.Value.Path = "Registry::HKEY_Users\$($Profile.SID)\$($Item.Value.Path)"

            Out-File -InputObject "      $($Item.Name)" -FilePath $Path_Log_File -Append
            Out-File -InputObject "        Path: $($Item.Value.Path)" -FilePath $Path_Log_File -Append
            Out-File -InputObject "        Name: $($Item.Value.Name)" -FilePath $Path_Log_File -Append
            Out-File -InputObject "        Type: $($Item.Value.PropertyType)" -FilePath $Path_Log_File -Append
            Out-File -InputObject "        Desired Value: $($Item.Value.Value)" -FilePath $Path_Log_File -Append

            # Get Current State
              $Temp_Registry_Current = Get-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -ErrorAction SilentlyContinue
              Out-File -InputObject "        Actual Value: $($Temp_Registry_Current.$($Item.Value.Name))" -FilePath $Path_Log_File -Append

            if ($Operation_Type -eq "Discovery") {
              # Process Based on Current State
                if ($Temp_Registry_Current -in "",$null) {
                  $Meta_Result_Failures ++
                  Out-File -InputObject "        Result: Failure, Object Not Found" -FilePath $Path_Log_File -Append
                }
                elseif ($Temp_Registry_Current.$($Item.Value.Name) -eq $Item.Value.Value) {
                  $Meta_Result_Successes ++
                  Out-File -InputObject "        Result: Skipped, Value Already Matches" -FilePath $Path_Log_File -Append
                }
                else {
                  $Meta_Result_Failures ++
                  Out-File -InputObject "        Result: Failure, Value Mismatch" -FilePath $Path_Log_File -Append
                }
            }
            elseif ($Operation_Type -eq "Remediation") {
              # Process Based on Current State
                if ($Temp_Registry_Current -in "",$null) {
                  # Create Path if Not Exist
                    if ((Test-Path -Path $Item.Value.Path) -in "",$false) {
                      $Temp_PathRecurse = $null

                      foreach ($Item_2 in ($Item.Value.Path -split "\\")) {
                        $Temp_PathRecurse += $Item_2 + "\"
                        if (Test-Path -Path $Temp_PathRecurse) {
                        }
                        else {
                          New-Item -Path $Temp_PathRecurse | Out-Null
                          Out-File -InputObject "        Created Path: $($Temp_PathRecurse)" -FilePath $Path_Log_File -Append
                        }
                      }
                    }

                  # Create Registry Item
                    New-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -PropertyType $Item.Value.PropertyType -Value $Item.Value.Value | Out-Null

                  $Meta_Result_Successes ++
                  Out-File -InputObject "        Result: Success, Created Property/Value Pair" -FilePath $Path_Log_File -Append
                }
                elseif ($Temp_Registry_Current.$($Item.Value.Name) -eq $Item.Value.Value) {
                  $Meta_Result_Successes ++
                  Out-File -InputObject "        Result: Skipped, Value Already Matches" -FilePath $Path_Log_File -Append
                }
                else {
                  Set-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -Type $Item.Value.PropertyType -Value $Item.Value.Value | Out-Null
                  $Meta_Result_Successes ++
                  Out-File -InputObject "        Result: Success, Updated Property/Value Pair" -FilePath $Path_Log_File -Append
                }
              }

            # Clean the Registry Path
              $Temp_CleanupString = [regex]::Escape("Registry::HKEY_Users\$($Profile.SID)\")
              $Item.Value.Path = $Item.Value.Path -replace $Temp_CleanupString,""
          }
          catch {
            # Increment Failure Count
              $Meta_Result_Failures ++
              Out-File -InputObject "        Result: Failure, Unknown Error" -FilePath $Path_Log_File -Append
          }
        }

        # Run Garbage Collector
          [gc]::Collect()
          Start-Sleep -Seconds 2

        # Unload Hive
          Start-Process -FilePath "cmd.exe" -ArgumentList "/c reg.exe unload HKU\$($Profile.SID)" -Wait -WindowStyle Hidden | Out-Null
      }
```

#### Discovery

Copy this code, including comments, to the Input section of the Template

```powershell
  # Registry
    $Registry_01 = @{
      "Path"          = "HKLM:\SOFTWARE\VividRock"
      "Name"          = "Version"
      "PropertyType"  = "String"
      "Value"         = "1.0"
    }
    $Registry_02 = @{
      "Path"          = "HKLM:\SOFTWARE\VividRock"
      "Name"          = "Enabled"
      "PropertyType"  = "Dword"
      "Value"         = 1
    }
```

Copy this code, including comments, to the Execution section of the Template

```powershell
  # Registry
    Out-File -InputObject "Registry" -FilePath $Path_Log_File -Append
    foreach ($Item in (Get-Variable -Name "Registry_*")) {
      try {
        Out-File -InputObject "  - $($Item.Name)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      Path: $($Item.Value.Path)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      Name: $($Item.Value.Name)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      Type: $($Item.Value.PropertyType)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      Desired Value: $($Item.Value.Value)" -FilePath $Path_Log_File -Append

        # Get Current State
          $Temp_Registry_Current = Get-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -ErrorAction SilentlyContinue
          Out-File -InputObject "      Actual Value: $($Temp_Registry_Current.$($Item.Value.Name))" -FilePath $Path_Log_File -Append

        # Process Based on Current State
          if ($Temp_Registry_Current -in "",$null) {
            $Meta_Result_Failures ++
            Out-File -InputObject "      Result: Failure, Object Not Found" -FilePath $Path_Log_File -Append
          }
          elseif ($Temp_Registry_Current.$($Item.Value.Name) -eq $Item.Value.Value) {
            $Meta_Result_Successes ++
            Out-File -InputObject "      Result: Skipped, Value Already Matches" -FilePath $Path_Log_File -Append
          }
          else {
            $Meta_Result_Failures ++
            Out-File -InputObject "      Result: Failure, Value Mismatch" -FilePath $Path_Log_File -Append
          }
      }
      catch {
        # Increment Failure Count
          $Meta_Result_Failures ++
          Out-File -InputObject "      Result: Failure, Unknown Error" -FilePath $Path_Log_File -Append
      }
    }

```

#### Remediation

Copy this code, including comments, to the Input section of the Template

```powershell
  # Registry
    $Registry_01 = @{
      "Path"          = "HKLM:\SOFTWARE\VividRock"
      "Name"          = "Version"
      "PropertyType"  = "String"
      "Value"         = "1.0"
    }
    $Registry_02 = @{
      "Path"          = "HKLM:\SOFTWARE\VividRock"
      "Name"          = "Enabled"
      "PropertyType"  = "Dword"
      "Value"         = 1
    }

```

Copy this code, including comments, to the Execution section of the Template

```powershell
  # Registry
    Out-File -InputObject "Registry" -FilePath $Path_Log_File -Append
    foreach ($Item in (Get-Variable -Name "Registry_*")) {
      try {
        Out-File -InputObject "  - $($Item.Name)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      Path: $($Item.Value.Path)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      Name: $($Item.Value.Name)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      Type: $($Item.Value.PropertyType)" -FilePath $Path_Log_File -Append
        Out-File -InputObject "      Desired Value: $($Item.Value.Value)" -FilePath $Path_Log_File -Append

        # Get Current State
          $Temp_Registry_Current = Get-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -ErrorAction SilentlyContinue
          Out-File -InputObject "      Actual Value: $($Temp_Registry_Current.$($Item.Value.Name))" -FilePath $Path_Log_File -Append

        # Process Based on Current State
          if ($Temp_Registry_Current -in "",$null) {
            # Create Path if Not Exist
              if ((Test-Path -Path $Item.Value.Path) -in "",$false) {
                $Temp_PathRecurse = $null

                foreach ($Item_2 in ($Item.Value.Path -split "\\")) {
                  $Temp_PathRecurse += $Item_2 + "\"
                  if (Test-Path -Path $Temp_PathRecurse) {
                  }
                  else {
                    New-Item -Path $Temp_PathRecurse | Out-Null
                    Out-File -InputObject "      Created Path: $($Temp_PathRecurse)" -FilePath $Path_Log_File -Append
                  }
                }
              }

            # Create Registry Item
              New-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -PropertyType $Item.Value.PropertyType -Value $Item.Value.Value

            $Meta_Result_Successes ++
            Out-File -InputObject "      Result: Success, Created Property/Value Pair" -FilePath $Path_Log_File -Append
          }
          elseif ($Temp_Registry_Current.$($Item.Value.Name) -eq $Item.Value.Value) {
            $Meta_Result_Successes ++
            Out-File -InputObject "      Result: Skipped, Value Already Matches" -FilePath $Path_Log_File -Append
          }
          else {
            Set-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -Type $Item.Value.PropertyType -Value $Item.Value.Value
            $Meta_Result_Successes ++
            Out-File -InputObject "      Result: Success, Updated Property/Value Pair" -FilePath $Path_Log_File -Append
          }
      }
      catch {
        # Increment Failure Count
          $Meta_Result_Failures ++
          Out-File -InputObject "      Result: Failure, Unknown Error" -FilePath $Path_Log_File -Append
      }
    }

```

<br>

### Scheduled Task

Create a Configuration Item that will create a Scheduled Task and monitor it's XML content to ensure the Task maintains its desired configuration state. If it does not, the script will recreate the Scheduled Task.

#### Input Section

Copy this code, including comments, to the Input section of the Template

```powershell
# Scheduled Task
  $ScheduledTask = @{
    Name        = "[Function] - [Name]"
    Path        = "\VividRock\MECM\[Function]\"
    Author      = "VividRock"
    Description = "A task that runs a PowerShell script [Description]."
    Command     = "powershell.exe"
    Arguments   = '-NoProfile -NoLogo -WindowStyle Hidden -ExecutionPolicy Bypass -File "$($env:vr_Directory_Cache)\Cache\Scripts\Maintenance Tasks\[Function]\Maintenance Task - [Function] - [Name].ps1" -RetentionDays "30" -Criteria "CreationTimeUtc" -OutputDir $Path_Log_Directory -OutputName "Maintenance Task - [Function] - [Name]"'
  }
```

#### Execution Section

Copy this code, including comments, to the Execution section of the Template

```powershell
  # Scheduled Task

```

<br>

### User Shell

TODO

#### Input Section

Copy this code, including comments, to the Input section of the Template

```powershell
  # Refresh User Shell
    $Shell_User_Refresh = $true

```

#### Execution Section

Copy this code, including comments, to the Execution section of the Template

```powershell
  # Refresh User Shell
    if ($Shell_User_Refresh -eq $true) {
      Out-File -InputObject "Registry" -FilePath $Path_Log_File -Append
      $code = @'
using System.Runtime.InteropServices;
public class Wallpaper {
  [DllImport("user32.dll", CharSet=CharSet.Auto)]
  public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
'@
      Add-Type $code
      $Temp_Result = [Wallpaper]::SystemParametersInfo(0x0014, 0, $File_01.Path, 0x01 -bor 0x02)
    }
```

<br>

# Appendices

A collection of sections that provide detailed explanation or understanding to the above topic but are not necessary within the main body of the topic.

## Apdx A: [Name]

[Text]

## Apdx X: Templates

### [ModuleName]

[Description]

#### Discovery

Copy this code, including comments, to the Input section of the Template

```powershell
  # [ModuleName]

```

Copy this code, including comments, to the Execution section of the Template

```powershell
  # [ModuleName]

```

#### Remediation

Copy this code, including comments, to the Input section of the Template

```powershell
  # [ModuleName]

```

Copy this code, including comments, to the Execution section of the Template

```powershell
  # [ModuleName]

```