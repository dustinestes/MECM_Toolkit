# MECM Toolkit - Infrastructure - Processes - Upgrade Site

This document provides a template for upgrading to the various versions of MECM. Each version will have a high-level process outline provided along with any version-specific notes or prerequisites necessary for upgrading to that version.

&nbsp;

## References

The following items are referenced in the code within this document. Familiarize yourself with them before moving on.

| Name                  | Type                        | Description                                                                                                       | Link |
|-----------------------|-----------------------------|-------------------------------------------------------------------------------------------------------------------|------|
| MECM Release Notes    | Reference                   | Provides documentation for each of the recent releases of the product.                                            | [Microsoft Learn](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/deploy/install/release-notes) |

&nbsp;

## Table of Contents

- [MECM Toolkit - Infrastructure - Processes - Upgrade Site](#mecm-toolkit---infrastructure---processes---upgrade-site)
  - [References](#references)
  - [Table of Contents](#table-of-contents)
- [Version 2403](#version-2403)
  - [Prerequisites](#prerequisites)
  - [Backup](#backup)
    - [Hardware Inventories](#hardware-inventories)
    - [Site \& Database](#site--database)
    - [Site Maintenance Tasks](#site-maintenance-tasks)
    - [Customizations](#customizations)
  - [Upgrade](#upgrade)
  - [Post-Upgrade](#post-upgrade)
    - [Enable Maintenance Tasks](#enable-maintenance-tasks)
    - [Enable Optional Features](#enable-optional-features)
    - [Update MECM Console Application Package](#update-mecm-console-application-package)
    - [Update Boot Image(s)](#update-boot-images)
    - [Update Clients](#update-clients)
    - [Update Collections](#update-collections)
  - [Validation](#validation)
    - [Built-In Operations](#built-in-operations)
    - [3rd Party Integrations](#3rd-party-integrations)
- [Appendices](#appendices)
  - [Apdx A: \[Name\]](#apdx-a-name)

&nbsp;

# Version 2403

Before implementing this upgrade, it is recommended that you review the Microsoft Learn document for [What's new in version 2403](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/changes/whats-new-in-version-2403).

&nbsp;

## Prerequisites

Download the following products:

- [ ] [Windows ADK 10.1.26100.1 (May 2024)](https://go.microsoft.com/fwlink/?linkid=2271337)
- [ ] [Windows PE add-on for the Windows ADK 10.1.26100.1 (May 2024)](https://go.microsoft.com/fwlink/?linkid=2271338)
  - Site Servers
- [ ] [Microsoft Visual C++ 2015-2019](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170)
  - Minimum Version: 14.28.29914.0
  - Both x64 & x86
  - All Site System Servers in Hierarchy
- [ ] [SQL ODBC Driver 18 for SQL Server](https://go.microsoft.com/fwlink/?linkid=2280794)
  - All Site System Servers in Hierarchy except the Distribution Points
- [ ] [SQL Server Native Client](https://www.microsoft.com/en-us/download/details.aspx?id=50402)
  - Minimum Version: SQL Server 2012 SP4 (11.*.7001.0)
  - All Site System Servers in Hierarchy except the Distribution Points
  - If you use the /passive, /qn, /qb, or /qr option with msiexec, you must also specify IACCEPTSQLNCLILICENSETERMS=YES, to explicitly indicate that you accept the terms of the end user license. This option must be specified in all capital letters.

Important to Note:

- Minimum MECM Version: 2211
- All updates should be installed on servers prior to performing upgrade
- In a multi-tier hierarchy, you must start at the CAS and then upgrade each child site fully before upgrading another site
- Supported SQL Version: 2017, 2019, 2022
- Remove the following roles: Enrollment Point, Enrollment Point Proxy, Device Management Point, Certificate Registration Point
- Co-Management workload slider for Resource Access must be set to Intune

Checklist

- [ ] Install all of the downloaded products from the above list to their respective endpoints
- [ ] Ensure there are no pending updates or reboots
- [ ] Run the prerequisite check in the MECM Console (ConfigMgrPreReq.log)

&nbsp;

## Backup

The following backup procedures should be followed to ensure you have rollback and restorative capabilities should an issue occur.

- [ ] Backup Hardware Inventories
- [ ] Backup Site & Database
- [ ] Site Maintenance Tasks
- [ ] Customizations

### Hardware Inventories

These need to be backed up just in case the upgrade overwrites your current configurations. You can simply import each MOF file back to its respective Client Setting and restore your previous configuration.

| Client Setting Name | Path to Backup File |
|-|-|
| [Name] | [Path] |

Process

1. Navigate to: \Administration\Overview\Client Settings
2. Open Client Setting
3. Click Hardware Inventory node
4. Click Set Classes...
5. Click Export
6. Define location and filename
7. Click Save

### Site & Database

The built-in maintenance task for MECM Site backup should be enabled and scheduled to run prior to upgrade to ensure you have the latest backup prior to the upgrade.

> Note: Ther are items that are not backed up with this method
> - SQL Server Reporting Services reports
> - Content Library or package source files
> - SCUP custom updates
> - USMT Data

| Backup Name | Path to Backup File |
|-|-|
| Site Backup | [Path] |
| SQL Backup | [Path] |

Process

1. Navigate to: \Administration\Overview\Site Configuration\Sites
2. Click Site Maintenance
3. Edit Backup Site Server maintenance task
4. Set the destinations for your backup files
5. Start the SMS_SITE_BACKUP service (services.msc or Configuration Manager Service Manager)
6. Monitor using the smsbkup.log file

### Site Maintenance Tasks

The following site maintenance tasks should be disabled if they are scheduled to run during the time that the update is meant to take place.

| Name | Schedule | Status |
|-|-|-|
| Backup Site Server | | |
| Delete Aged Client Operations | | |
| Delete Aged Discovery Data | | |

Process

1. Navigate to: \Administration\Overview\Site Configuration\Sites
2. Click Site Maintenance
3. Edit the maintenance task
4. Copy the schedule into the table above
5. Disable the maintenance task
6. Repeat for each aintenance task above

### Customizations

The following table just lists some possible customizations that you will want to make sure you backup prior to an upgrade.

| Name | Purpose | Location|
|-|-|-|
| osdinjection.xml | Allows injenction of files and configurations every time a Boot image is built. | \\[PrimarySiteServerFQDN]\SMS_[SiteCode]\bin\X64

Process

> Note Each of these customizations may require a different process so this section is left blank.

&nbsp;

## Upgrade

Once you have a clean, successful prerequisite check, the option to install the update will be enabled.

- [ ] Disable Database Replicas for Management Points
- [ ] Set SQL Server Always On Availability Groups to manual failover
- [ ] Disable antivirus software
- [ ] Upgrade the Site Version
- [ ] Verify the Site Upgrade

Monitor Using One of the Following:

- Console (\Monitoring\Overview\Updates and Servicing Status)
- CMUpdate.log (\\[PrimarySiteServer]\SMS_[SiteCode]\Logs)

Verify

1. Open the console to Administration\Site Configuration\Sites
2. Right click the site and click Properties
3. Check the Version and Build number: 5.00.9128.1000   |   9128

## Post-Upgrade

- [ ] Enable Maintenance Tasks
- [ ] Enable Optional Features
- [ ] Update MECM Console Application Package
- [ ] Update Boot Image(s)
- [ ] Update Clients
- [ ] Update Collections

### Enable Maintenance Tasks

1. Navigate to: \Administration\Overview\Site Configuration\Sites
2. Click Site Maintenance
3. Edit the maintenance task
4. Enable the maintenance task
5. Set the schedule according to the data recorded in the backup table above
6. Repeat for each aintenance task in the table

### Enable Optional Features

1. Navigate to: \Administration\Overview\Updates and Servicing\Features
2. Enable any desired features with a status of Off

### Update MECM Console Application Package

> Optional: Only necessary if you have packaged the console for deployment via MECM

> Note: This will differ per organization so this is provided here as a placeholder and reminder that you will want to fill this out with your specific requirements.

### Update Boot Image(s)

> Note: This will differ per organization so this is provided here as a placeholder and reminder that you will want to fill this out with your specific requirements.

### Update Clients

> Note: This will differ per organization so this is provided here as a placeholder and reminder that you will want to fill this out with your specific requirements.

### Update Collections

You will want to find the collections you have that use the MECM client version and determine if any of them need to be modified.

- [ ] Update Collection: [CollectionNameHere]

&nbsp;

MECM Toolkit Collections

> Note: If you utilize the MECM Toolkit's collection hydration, then you will likely have the below collections in your environment.

| Collection Name                                   | Change Description                                                                                                                                |
|---------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| LIE - MECM - Client Health - Version Current      | This does not need to be updated because it simply compares the client version to the site version so is dynamically updated with every upgrade.  |
| LIE - MECM - Client Health - Version Out of Date  | This does not need to be updated because it simply grabs the inverse of the above collection so it is dynamically updated.                        |

&nbsp;

## Validation

### Built-In Operations

- [ ] Application Deployment Successful
- [ ] Operating System Deployment Successful
- [ ] Client Settings Hardware Inventory Unchanged
- [ ] Report Execution Successful
- [ ] CMG Client Communication Successful

### 3rd Party Integrations

> Note: This will differ per organization so this is provided here as a placeholder and reminder that you will want to fill this out with your specific requirements.

&nbsp;

# Appendices

A collection of sections that provide detailed explanation or understanding to the above topic but are not necessary within the main body of the topic.

## Apdx A: [Name]

[Text]