<#
.SYNOPSIS
Removes a collaborator from a Box folder.

.DESCRIPTION
Deletes a collaboration by Collaboration ID. Supports pipeline input
from Get-BoxCollaboration.

.PARAMETER CollaborationId
ID of the collaboration to remove.

.EXAMPLE
Remove-BoxCollaboration -FolderId 123456 -CollaborationId 123456

.EXAMPLE
Get-BoxCollaboration -FolderId 123456 |
    Where-Object Role -eq "viewer" |
    Remove-BoxCollaboration -WhatIf
#>

function Remove-BoxCollaboration {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [Alias("Id")]
        [string]$CollaborationId
    )

    process {

        if (-not $CollaborationId) {
            throw "CollaborationId cannot be null or empty."
        }

        $Target = "Collaboration ID: $CollaborationId"

        if ($PSCmdlet.ShouldProcess($Target, "Remove collaborator")) {

            $Call = @{
                RelativeURI = "collaborations/$CollaborationId"
                Method      = "DELETE"
            }

            Invoke-BoxRestCall @Call
        }
    }
}
