# MECM Toolkit - Maintenance Tasks - Readme

## Table of Contents

- [MECM Toolkit - Maintenance Tasks - Readme](#mecm-toolkit---maintenance-tasks---readme)
  - [Table of Contents](#table-of-contents)
  - [Configure Maintenance Task Host Device](#configure-maintenance-task-host-device)
    - [Basic Configuration](#basic-configuration)
  - [Setup Automated Tasks](#setup-automated-tasks)
    - [Create Service Account](#create-service-account)
    - [Configure Task Runner Host](#configure-task-runner-host)
      - [Add Service Account to Security Groups](#add-service-account-to-security-groups)
    - [Configure Scheduled Tasks](#configure-scheduled-tasks)
    - [Configure Share Directory Access Permissions](#configure-share-directory-access-permissions)

&nbsp;

## Configure Maintenance Task Host Device

The host device will be the device where the maintenance tasks are configured to run as scheduled tasks.

> Recommendation
>
> This should be the Primary Site Server as this server will have adequate access to perform the tasks needed.

### Basic Configuration

- 

## Setup Automated Tasks

### Create Service Account

Create the Service Account that will run the Scheduled Tasks

> Note
>
> Not necessary if you are going to run the Maintenance Tasks as the SYSTEM account on the Primary Site Server

[Content]

&nbsp;

### Configure Task Runner Host

Configure the Server/Workstation that will run the Scheduled Tasks.

#### Add Service Account to Security Groups

The service account you create needs to have local permissions in order to execute the Scheduled Task.

Minimum Rights: Log on as a batch job

Maximum Rights: Local Administrator group membership

&nbsp;

### Configure Scheduled Tasks

Configure the Scheduled Tasks on the Task Runner Host device.

[Content]

### Configure Share Directory Access Permissions

Configure the Share Directory access permissions that will host the PowerShell maintenance task scripts.

> Note:
>
> Only necessary if you are storing the maintenance task scripts on a network share and not locally on the Task Runner Host device.

| Run As                    | Permissions               |
|---------------------------|---------------------------|
| SYSTEM                    | Read/Write Permissions    |