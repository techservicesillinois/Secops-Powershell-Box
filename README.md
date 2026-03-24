![Pester Tests](https://github.com/techservicesillinois/Secops-Powershell-Box/workflows/Pester%20Tests/badge.svg)
![ScriptAnalyzer](https://github.com/techservicesillinois/Secops-Powershell-Box/workflows/ScriptAnalyzer/badge.svg)

# What is This?

This is a PowerShell module for automating interactions with the Box API. It provides a clean, reusable set of functions for managing folders, files, and user access within Box.

The module is designed for automation scenarios such as:

Ticket-driven provisioning

Scheduled jobs

Azure Automation runbooks

Security and compliance workflows

It simplifies Box API usage by handling authentication, REST calls, and common operations behind easy-to-use PowerShell functions.

# How do I install it?

The latest stable release is always available via the PSGallery.

This will install on the local machine:

Install-Module -Name 'UofIBox'

### Prerequisites

PowerShell 7+

A Box application configured for Client Credentials Grant

Box Client ID, Client Secret, and Enterprise ID

# How does it work?

The module is built around two core components:

Authentication

New-BoxSession authenticates to Box using OAuth Client Credentials and stores the access token for reuse.

$Credential = Get-Credential
New-BoxSession -Credential $Credential
REST Wrapper

Invoke-BoxRestCall is a centralized wrapper for all API calls. It handles:

Authentication headers

Base URI construction

JSON conversion

Error handling

File downloads

Key Functions
Folder Management

New-BoxFolderWithCollaboration – Create folders and assign users/roles

Get-BoxFolder – Retrieve folder metadata

Remove-BoxFolder – Delete folders

File Management

Upload-BoxFile – Upload files

Get-BoxFile – Retrieve file metadata

Remove-BoxFile – Delete files

Receive-BoxFile – Download files

Folder Download

Receive-BoxFolder – Recursively downloads a folder and recreates the structure locally

Example Workflow
$Credential = Get-Credential
New-BoxSession -Credential $Credential

New-BoxFolderWithCollaboration `
    -FolderName "SecurityProject" `
    -Login user@company.com `
    -Role editor

#End-of-Life and End-of-Support Dates

As of the last update to this README, the expected End-of-Life and End-of-Support dates of this product are November 2026.

End-of-Life was decided upon based on these dependencies and their End-of-Life dates:

Powershell 7.4 (November 2026)

# How do I help?

Contributions are welcome. You can help by:

Reporting bugs or issues

Suggesting new features

Improving documentation

Refactoring functions for performance or readability

If contributing:

Follow existing function structure and naming conventions

Ensure all functions use Invoke-BoxRestCall

Include comment-based help for all functions

# To Do
