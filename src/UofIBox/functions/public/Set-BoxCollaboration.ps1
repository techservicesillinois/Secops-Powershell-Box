<#
.SYNOPSIS
Updates a Box collaboration role.

.DESCRIPTION
Modifies an existing collaboration, typically to change the user's role.

.PARAMETER CollaborationId
ID of the collaboration.

.PARAMETER Role
New role to assign.

.EXAMPLE
Get-BoxCollaboration -FolderId 123456 |
    Where-Object Login -eq "user@company.com" |
    Set-BoxCollaboration -Role co-owner
#>

function Set-BoxCollaboration {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [Alias("Id")]
        [string]$CollaborationId,

        [Parameter(Mandatory)]
        [ValidateSet(
            "editor",
            "viewer",
            "previewer",
            "uploader",
            "previewer uploader",
            "viewer uploader",
            "co-owner",
            "owner"
        )]
        [string]$Role
    )

    process {

        if (-not $CollaborationId) {
            throw "CollaborationId cannot be null or empty."
        }

        $Target = "Collaboration ID: $CollaborationId"

        if ($PSCmdlet.ShouldProcess($Target, "Update role to '$Role'")) {

            $Body = @{
                role = $Role
            }

            $Call = @{
                RelativeURI = "collaborations/$CollaborationId"
                Method      = "PUT"
                Body        = $Body
            }

            Invoke-BoxRestCall @Call
        }
    }
}