<#
.SYNOPSIS
Retrieves collaborators for a Box folder.

.DESCRIPTION
Gets all collaborators assigned to a folder, including their roles and status.
Supports pagination to return all collaborators.

.PARAMETER FolderId
ID of the folder.

.EXAMPLE
Get-BoxCollaboration -FolderId 123456

.EXAMPLE
Get-BoxCollaboration -FolderId 123456 | Select-Object login, role
#>

function Get-BoxCollaboration {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FolderId
    )

    $Limit  = 100
    $Offset = 0
    $Results = @()

    do {

        $Call = @{
            RelativeURI = "folders/$FolderId/collaborations?limit=$Limit&offset=$Offset"
            Method      = "GET"
        }

        $Response = Invoke-BoxRestCall @Call

        if ($Response.entries) {
            $Results += $Response.entries
        }

        $Offset += $Limit

    } while ($Response.entries.Count -eq $Limit)

    # Clean output
    $Results | ForEach-Object {
        [PSCustomObject]@{
            Id           = $_.id
            Login        = $_.accessible_by.login
            Name         = $_.accessible_by.name
            Role         = $_.role
            Status       = $_.status
            CreatedAt    = $_.created_at
            ModifiedAt   = $_.modified_at
        }
    }
}
