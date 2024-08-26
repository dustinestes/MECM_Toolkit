# MECM Toolkit - Processes - Templates - Change Log

These can be stored in a number of ways for tracking versioning and change logs over the history of your Task Sequence(s):

- GitHub or similar repo
- SharePoint list or document
- Simple markdown file in the same folder structure where you backup your Task Sequences

```text
\\[servername]\MECM\Backups\Task Sequences
    ..\[Version]
        ..\[ExportedTaskSequenceFile].zip
        ..\ChangeLog.md
```

&nbsp;

## How to Use

Many organizations utilize ticketing systems in order to submit, approve, track, and audit changes. This is not meant to supersede or replace that. In fact, this should be used right along side that.

The same data populate within this document should be the data you populate within the ticket. As much detailed information about what changes you made, where, and why is the key to successful change management.

This document can simply be a shortcut to the information for your engineers and can sit alongside the versions in the raw file storage (illustrated above). This allows engineers to find the same data as change managers would in the ticketing system, without having to know how to search or filter tickets.

Sample Process:

- Create change ticket
- Create new version section in change log using template
- Update placeholder text with ticket data
- Create Improvement and Bug Fix section entries for each proposed change
- Update change ticket body with this proposed list of changes
- Backup current production Task Sequence
  - Export to backup folder
  - Create copy of Task Sequence in console and increment version
- Perform changes to new version of Task Sequence
  - Update change ticket and change log as necessary
- Deploy new Task Sequence version at approved change implementation [datetime]
- Update and close change ticket

&nbsp;

## Table of Contents

- [MECM - Processes - Templates - Change Log](#mecm---processes---templates---change-log)
  - [How to Use](#how-to-use)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
- [Template](#template)
  - [\[TaskSequenceName\] - \[Version\]](#tasksequencename---version)
    - [General](#general)
    - [Improvements](#improvements)
    - [Bug Fixes](#bug-fixes)
    - [Other](#other)
- [Apdx A: Example](#apdx-a-example)

&nbsp;

## Prerequisites

The following prerequisites are needed before performing any of the below processes.

1. [Text]
2. [Text]

&nbsp;

# Template

Use the below as a template for building new version entries into a Change Log for easy change tracking.

## [TaskSequenceName] - [Version]

[BriefDescription]

### General

| Property                      | Value                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| Change Ticket                 | [Ticket#ForChangeImplementation]                                                          |
| Associated Ticket(s)          | [Ticket#sOfAssociatedTickets]                                                             |
| Production Deployment         | [DateOfChangeImplementation]                                                              |
| Implementer                   | [ImplementerName]                                                                         |
| Change Type                   | [Improvement/BugFix/Both]                                                                 |
| Previous Version Backup Path  | [PathToExportedTaskSequenceFile]                                                          |

### Improvements

Items in this section describe changes made to the Task Sequence in order to improve upon it.

- [ChangeTitle]
  - Ticket: [Ticket#]
  - Type: [Create/Update/Delete]
  - Step Path: [PathToTaskSequenceStep]
  - Description: [Description]
- [ChangeTitle]
  - Ticket: [Ticket#]
  - Type: [Create/Update/Delete]
  - Step Path: [PathToTaskSequenceStep]
  - Description: [Description]

### Bug Fixes

Items in this section describe changes made to the Task Sequence in order fix some bug or issue that exists.

- [ChangeTitle]
  - Ticket: [Ticket#]
  - Type: [Create/Update/Delete]
  - Step Path: [PathToTaskSequenceStep]
  - Description: [Description]
- [ChangeTitle]
  - Ticket: [Ticket#]
  - Type: [Create/Update/Delete]
  - Step Path: [PathToTaskSequenceStep]
  - Description: [Description]

### Other

Provide any notes or other changes that were made that do not fit into the above categories but should be called out as part of this version of the Task Sequence.

[Text]

&nbsp;

# Apdx A: Example

Below is an example of what a change log entry might look like and helpful details it can contain.

[ProvideExampleFromTemplate]