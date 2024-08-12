# MECM Toolkit - Applications - Icon - General

&nbsp;

## References

The following items are referenced in the code within this document. Familiarize yourself with them before moving on.

| Name                  | Type                        | Description                                                                                                       | Link |
|-----------------------|-----------------------------|-------------------------------------------------------------------------------------------------------------------|------|
| Icon                  | .NET Class                  | Documentation for the class                                                                                       | [Micrsoft Learn](https://learn.microsoft.com/en-us/dotnet/api/system.drawing.icon?view=net-8.0) |

&nbsp;

## Table of Contents

- [MECM Toolkit - Applications - Icon - General](#mecm-toolkit---applications---icon---general)
  - [References](#references)
  - [Table of Contents](#table-of-contents)
- [Basic Snippets](#basic-snippets)
  - [Extract from a Web Source](#extract-from-a-web-source)
  - [Extract from a Single File](#extract-from-a-single-file)
  - [Extract from Multiple Files](#extract-from-multiple-files)
  - [Convert to Base64](#convert-to-base64)
- [Advanced Functions](#advanced-functions)
  - [\[Title\]](#title)
- [Appendices](#appendices)
  - [Apdx A: \[Name\]](#apdx-a-name)

&nbsp;

# Basic Snippets

These are quick, simple snippets of code to reference for a basic understanding and inclusion within larger scripts or codebases. When a more fully developed function or operation is created using these, that block of code can be added to the Advanced Function section below.

> Note: These snippets tend to focus simply on the basic function at hand and should not incorporate other Basic Snippets or Advanced Functions. That is what the Advanced Functions section is for.

## Extract from a Web Source

This snippet can be used to extract an icon from a web source.

```powershell
$Web_Response = Invoke-WebRequest -Uri "[WebPathToFile]"
[System.IO.File]::WriteAllBytes("C:\Users\[UserName]\Downloads\Temp\[filename]",$Web_Response.Content)

```

## Extract from a Single File

This snippet can be used to extract the icon of a single file specified by the Path parameter.

```powershell
$Path = "C:\Program Files\VividRock\filename.exe"

Add-Type -AssemblyName System.Drawing
$Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($Path)
$Icon.ToBitmap().Save('C:\Users\[UserName]\Downloads\Temp\[filename].bmp')
```

## Extract from Multiple Files

This snippet can be used to extract the icon from all EXE files found recursively within a folder.

```powershell
$Path_AppInstall  = "C:\Program Files\VividRock"
$Path_ImageOutput = "C:\Users\[UserName]\Downloads\Temp\"
$Files = Get-ChildItem -Path $Path_AppInstall -Recurse -Filter "*.exe"

Add-Type -AssemblyName System.Drawing
foreach ($Item in ($Files | Select-Object -First 10)) {
    $Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($Item.FullName)
    $Icon.ToBitmap().Save($($Path_ImageOutput + $Item.BaseName + ".bmp"))
}
```

## Convert to Base64

This snippet can be used to convert an icon file (.ico) to Base64 for use within Windows Forms.

```powershell
# PowerShell v5.1
$Icon_Content = Get-Content -Path "[PathToFile].ico" -Encoding Byte -Raw
$Icon_Base64 = [System.Convert]::ToBase64String($Icon_Content)

# PowerShell v6.0 and Greater
$Content = Get-Content -Path "[PathToFile].ico" -AsByteStream
$Icon_Base64 = [System.Convert]::ToBase64String($Icon_Content)

# Can Be used for Windows Forms
$Form = [Windows.Forms.Form]::new()
$Form.Icon = [Drawing.Icon][IO.MemoryStream][Convert]::FromBase64String($Icon_Base64)
$Form.ShowDialog()
```

&nbsp;

# Advanced Functions

These are more advanced snippets and usages of the basic snippets above that provide even more functionality and capabilities. These might also incorporate other Basic Snippets or Advanced functions from other Collections and Topics.

## [Title]

[Text]

> Example:
>
> [Text]

```powershell
# Add Code Here
```

&nbsp;

# Appendices

A collection of sections that provide detailed explanation or understanding to the above topic but are not necessary within the main body of the topic.

## Apdx A: [Name]

[Text]



