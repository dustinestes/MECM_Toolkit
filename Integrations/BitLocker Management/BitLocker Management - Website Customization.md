# MBAM Websites

This document provides the steps and code snippets necessary to fix issues with the MBAM websites as well as customize them to better align with your Organization's branding.

## Table of Contents

- [MBAM Websites](#mbam-websites)
  - [Table of Contents](#table-of-contents)
  - [SelfService Website Configuration](#selfservice-website-configuration)
    - [IIS Application Settings](#iis-application-settings)
    - [Backup](#backup)
    - [Fix Elements](#fix-elements)
      - [Change Footer Text](#change-footer-text)
      - [Change Gradient Background](#change-gradient-background)
      - [Match Security Message Font Size](#match-security-message-font-size)
    - [Brand the Page](#brand-the-page)
      - [Colors](#colors)
      - [Browser Title Bar (Tab)](#browser-title-bar-tab)
      - [Header](#header)
      - [Icons](#icons)
- [Change Log](#change-log)
  - [\[DateTime\]](#datetime)

&nbsp;

## SelfService Website Configuration

The below are customizations made to the codebase/files in order to brand, customize, or further extend the capabilities of this solution.

| Detail                  | Note                                                                                                                                    |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| Directory               | C:\inetpub\Microsoft Bitlocker Management Solution\Self Service Website                                                                 |

&nbsp;

### IIS Application Settings

These are the officially supported customizations that you can make to the SelfService website without modifying any underlying code.

| Property Name                 | Default Value                                | Recommended Value        |
|-------------------------------|----------------------------------------------|--------------------------|
| ClientValidationEnabled       | true                                         | -                        |
| CompanyName                   | Contoso                                      | [OrganizationName]       |
| DisplayNotice                 | true                                         | false                    |
| HelpdeskText                  | [Unknown]                                    | Contact the Service Desk |
| HelpdeskUrl                   | [Unknown]                                    | [URIToTicketingSystem]   |
| jQueryPath                    | ~/Scripts/jquery-1.10.2.min.js               | -                        |
| jQueryValidatePath            | ~/Scripts/jquery.validate.min.js             | -                        |
| jQueryValidateUnobtrusivePath | ~/Scripts/jquery.validate.unobtrusive.min.js | -                        |
| NoticeTextPath                | notice.txt                                   | -                        |
| UnobtrusiveJavaScriptEnabled  | true                                         | -                        |

### Backup

First, backup the default files to ensure a rollback option is possible.

1. Copy contents from above location to backup location
   - \\[servershare]\Backups\BitLocker Management\Websites\Self Service Website

### Fix Elements

There are some items within the site that give it an outdated look and feel or need to be fixed. If you do nothing else, do these to at least make the site seem more legitimate to potential users.

1. Open the Self Service Website folder in VS Code

#### Change Footer Text

1. Open the file: .\Views\Shared\Site.Master
2. Edit Line 48 to the desired value (see examples below)

> Examples

| Description                           | Line Value                                                                                | Result                                                |
|---------------------------------------|-------------------------------------------------------------------------------------------|-------------------------------------------------------|
| Default                               | <li><%= Html.Encode(LocalizableResources.Footer_Copyright)%></li>                         | (C)2015 Microsoft. All rights reserved.               |
| Dynamic copyright year with org name  | <li>&#169; <%= DateTime.Now.ToString("yyyy")%> [OrgName] &#124; All Rights Reserved</li>  | (C)2024 [OrgName] [VerticalLine] All Rights Reserved  |

#### Change Gradient Background

1. Open the file: .\Content\Site.css
2. Edit Line 13 to the desired value (see examples below)

> Examples

| Description                           | Line Value                                                                    | Result                                          |
|---------------------------------------|-------------------------------------------------------------------------------|-------------------------------------------------|
| Default                               | background: #DFF2F9 url(images/BrowsersBkgd_repeat-x.jpg) top left repeat-x;  | Blue vertical gradient is applied horizontally  |
| No Background                         | Comment Out the Line:   /* [Content] */                                       | White Background                                |

#### Match Security Message Font Size


1. Open the file: .\Content\site.css
2. Edit Line 24 to have the matching font size for the rest of the text in its sentence

```css
  font-size: 11px
```

&nbsp;

### Brand the Page

To add some on-brand elements to the page, make the following changes.

#### Colors

Change Header Bottom Border Color

1. Open the file: .\Content\site.css
2. Edit Line 117 with the new color hex code

```css
  border-bottom: 1px solid #007398
```

Update Step Number Colors

1. Open the file: .\Content\Recovery\custom.css
2. Edit Line 28 with the new color hex code

```css
  color: #007398
```

#### Browser Title Bar (Tab)

Change the Titlebar Text

1. Open the file: .\Views\Shared\Site.Master
2. Add the "Visible" constructor to the ContentPlaceHolder element to hide the default title
3. Add your custom Title below

> Example

```html
  <title>
      <asp:ContentPlaceHolder ID="TitleContent" runat="server" Visible="False"/>
      Encryption Management | [OrgName]
  </title>
```

Add a Favicon

1. Copy your favicon file to: .\Content\Images
2. Add the below snippet on Line 09 of: .\Views\Shared\Site.Master
   - Choose the one based on your image file type

> Snippet

```html
    <link rel="icon" type="image/x-icon" href="<%= Url.Content("~/Content/images/favicon.ico") %>">
    <link rel="icon" type="image/png" href="<%= Url.Content("~/Content/images/favicon.png") %>">
```

#### Header

Change the Text Header

1. Open the file: .\Content\Site.css
2. Edit the "#header h1" element starting on Line 75

Add an Image Header

1. Copy your logo/header file to: .\Content\Images
2. Add the below snippet to the "h1" element of: .\View\Shared\Site.Master

> Snippet

```html
  <h1 role="banner">
      <img src="<%= Url.Content("~/Content/images/logo.png") %>" style="height:100px" />
      <!-- <asp:Literal runat="server" Mode="Encode" Text="<%$appSettings:CompanyName %>" /> -->
  </h1>
```

#### Icons

Change the Keys Icon

> Note: recommended size is 64px x 64 px

1. Copy your keys icon file to: .\Contents\Images
2. Open the file: .\Views\Recovery\RecoveryControl.ascx
3. Modify Line 7 so the source Url points to the file you copied

> Example

```html
  <img src="<%= Url.Content("~/Content/imges/keys.png") %>" alt="keys" />
```

Change the Warning Icon

> Note: recommended size is 64px x 64 px

1. Copy your warning icon file to: .\Contents\Images
2. Open the file: .\Views\Recovery\Index.aspx
3. Modify Line 83 so the source Url points to the file you copied

> Example

```html
  <img src="<%= Url.Content("~/Content/imges/warning.png") %>" alt="warning" />
```

&nbsp;

# Change Log

## [DateTime]