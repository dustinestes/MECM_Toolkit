# [Category] - [Purpose]

[Description]

## Table of Contents

- [\[Category\] - \[Purpose\]](#category---purpose)
  - [Table of Contents](#table-of-contents)
  - [Configuration Item](#configuration-item)
    - [Usage](#usage)
    - [Parameters](#parameters)
    - [Script](#script)
  - [Appendix A: \[Name\]](#appendix-a-name)


## Configuration Item

Use this snippet to perform discovery and remediation as part of a Configuration Item and Baseline to continually manage and cleanup the client cache on an interval.

### Usage

The script is written using the multipurpose template so you only have to change the Operation Type parameter to suit both the Discovery and Remediation scenarios.

1. Copy script to discovery/remediation section of Configuration Item
2. Change the parameter value of $Operation_Type to match the operation being performed
3. Do this for both types of operations
4. Save and test

### Parameters

There are other parameters in the script, but only the ones listed below should be modified to address your use-case.

| Name | Type | Description | Example Value |
|-|-|-|-|
| Operation_Type | String | Tells the script whether its performing discovery operations or remediation operations. | Discovery/Remediation |

### Script

```powershell

```

## Appendix A: [Name]

[Description]