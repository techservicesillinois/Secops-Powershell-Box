<#
.SYNOPSIS
Adds collaborators to a Box folder.

.DESCRIPTION
Assigns one or more users to a folder with specified roles.

.PARAMETER FolderId
ID of the folder.

.PARAMETER Login
User email(s).

.PARAMETER Role
Role(s) assigned to users.

.EXAMPLE
New-BoxCollaboration -FolderId 123456 -Login user@company.com -Role editor

.EXAMPLE
New-BoxCollaboration `
    -FolderId 123456 `
    -Login user1@company.com,user2@company.com `
    -Role editor,viewer
#>

function New-BoxCollaboration {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$FolderId,

        [Parameter(Mandatory)]
        [string[]]$Login,

        [Parameter(Mandatory)]
        [string[]]$Role
    )

    if ($Login.Count -ne $Role.Count) {
        throw "Login and Role counts must match."
    }

    for ($i = 0; $i -lt $Login.Count; $i++) {

        $Target = "$($Login[$i]) as $($Role[$i]) on folder $FolderId"

        if ($PSCmdlet.ShouldProcess("Box", "Add collaborator $Target")) {

            $Body = @{
                item = @{
                    type = "folder"
                    id   = $FolderId
                }
                accessible_by = @{
                    type  = "user"
                    login = $Login[$i]
                }
                role = $Role[$i]
            }

            $Call = @{
                RelativeURI = "collaborations"
                Method      = "POST"
                Body        = $Body
            }

            Invoke-BoxRestCall @Call
        }
    }
}