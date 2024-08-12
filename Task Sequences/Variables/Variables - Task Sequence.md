# MECM Toolkit - Task Sequences - Variables - Task Sequence Variables

&nbsp;

## References

The following items are referenced in the code within this document. Familiarize yourself with them before moving on.

| Name                  | Type                        | Description                                                                                                       | Link |
|-----------------------|-----------------------------|-------------------------------------------------------------------------------------------------------------------|------|
| None | | | |

&nbsp;

## Table of Contents

- [MECM Toolkit - Task Sequences - Variables - Task Sequence Variables](#mecm-toolkit---task-sequences---variables---task-sequence-variables)
  - [References](#references)
  - [Table of Contents](#table-of-contents)
- [Basic Snippets](#basic-snippets)
  - [Output Variables to Console](#output-variables-to-console)
- [Advanced Functions](#advanced-functions)
  - [\[Title\]](#title)
- [Appendices](#appendices)
  - [Apdx A: \[Name\]](#apdx-a-name)

&nbsp;

# Basic Snippets

These are quick, simple snippets of code to reference for a basic understanding and inclusion within larger scripts or codebases. When a more fully developed function or operation is created using these, that block of code can be added to the Advanced Function section below.

> Note: These snippets tend to focus simply on the basic function at hand and should not incorporate other Basic Snippets or Advanced Functions. That is what the Advanced Functions section is for.

## Output Variables to Console

With a Task Sequence running, you can run the below snippet to quickly output all of the key/value pairs of the variables at the time of execution.

```powershell
# Create ComObject to Environment
    $Object_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment

# Write out every variable to the console window
    $Object_TSEnvironment.GetVariables() | ForEach-Object { Write-Host "$_ = $($Object_TSEnvironment.Value($_))" }
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
