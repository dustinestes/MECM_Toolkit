# MECM Toolkit - Infrastructure - Configuration Items - Template Modules

<br>

## Table of Contents

- [MECM Toolkit - Infrastructure - Configuration Items - Template Modules](#mecm-toolkit---infrastructure---configuration-items---template-modules)
  - [Table of Contents](#table-of-contents)
  - [How to Use](#how-to-use)
    - [Best Practices](#best-practices)
  - [Modules](#modules)
    - [Registry](#registry)
      - [Discovery](#discovery)
      - [Remediation](#remediation)
- [Appendices](#appendices)
  - [Apdx A: \[Name\]](#apdx-a-name)
  - [Apdx X: Templates](#apdx-x-templates)
    - [\[ModuleName\]](#modulename)
      - [Discovery](#discovery-1)
      - [Remediation](#remediation-1)

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

### Registry

[Description]

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