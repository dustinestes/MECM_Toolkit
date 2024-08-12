# MECM Toolkit - Client - References - Processes & Services



# Service Reference


## WinPE

This is the Get-Service output from a device that has simply booted into the WinPE environment, prior to pressing next on the Task Sequence Wizard.

- Boot to WinPE
- Run Code
- Done

### Code

```powerrshell
Get-Service | ConvertTo-Csv | Out-File -FilePath "Service_01_WinPE.csv"
```

### Output

| Name                  | Display Name                        | Execution Condition                               |
|-----------------------|-------------------------------------|---------------------------------------------------|
|

### Difference

None. First run of code.

&nbsp;

## Task Sequence Resolution

This is the Get-Service output from a device after booting into the WinPE environment and pressing next on the Task Sequence Wizard and the device is trying to resolve its available Task Sequences.

- Boot to WinPE
- Click Next on Task Sequence Wizard
- Run Code
- Done

### Code

```powerrshell
Get-Service | ConvertTo-Csv | Out-File -FilePath "Service_02_ResolvingTS.csv"
```

### Output

| Name                  | Display Name                        | Execution Condition                               |
|-----------------------|-------------------------------------|---------------------------------------------------|
|

### Difference

[Text]

&nbsp;

## Task Sequence Initiating

This is the Get-Service output from a device after booting into the WinPE environment and pressing next on the Task Sequence Wizard and the device is trying to.

- Boot to WinPE
- Click Next on Task Sequence Wizard
- Select and Run an OSD Task Sequence
- Run Code
- Done

### Code

```powerrshell
Get-Service | ConvertTo-Csv | Out-File -FilePath "Service_03_WinPE.csv"
```

### Output

| Name                  | Display Name                        | Execution Condition                               |
|-----------------------|-------------------------------------|---------------------------------------------------|
|

### Difference

[Text]



















# Process Reference


## WinPE

This is the Get-Process output from a device that has simply booted into the WinPE environment, prior to pressing next on the Task Sequence Wizard.

- Boot to WinPE
- Run Code
- Done

### Code

```powerrshell
Get-Process | ConvertTo-Csv | Out-File -FilePath "Process_01_WinPE.csv"
```

### Output

| Name                  | Display Name                        | Execution Condition                               |
|-----------------------|-------------------------------------|---------------------------------------------------|
|

### Difference

None. First run of code.

&nbsp;

## Task Sequence Resolution

This is the Get-Process output from a device after booting into the WinPE environment and pressing next on the Task Sequence Wizard and the device is trying to resolve its available Task Sequences.

- Boot to WinPE
- Click Next on Task Sequence Wizard
- Run Code
- Done

### Code

```powerrshell
Get-Process | ConvertTo-Csv | Out-File -FilePath "Process_02_ResolvingTS.csv"
```

### Output

| Name                  | Display Name                        | Execution Condition                               |
|-----------------------|-------------------------------------|---------------------------------------------------|
|

### Difference

[Text]

&nbsp;

## Task Sequence Initiating

This is the Get-Process output from a device after booting into the WinPE environment and pressing next on the Task Sequence Wizard and the device is trying to.

- Boot to WinPE
- Click Next on Task Sequence Wizard
- Select and Run an OSD Task Sequence
- Run Code
- Done

### Code

```powerrshell
Get-Process | ConvertTo-Csv | Out-File -FilePath "Process_03_RunningTS.csv"
```

### Output

| Name                  | Display Name                        | Execution Condition                               |
|-----------------------|-------------------------------------|---------------------------------------------------|
|

### Difference

[Text]
