<#
.SYNOPSIS
Creates a Box folder and assigns collaborators.

.DESCRIPTION
Creates a new folder and assigns users with the specified roles.

.PARAMETER FolderName
Name of the folder to create.

.PARAMETER ParentFolderId
Parent folder ID.

.PARAMETER Login
User email(s) to grant access.

.PARAMETER Role
Array of roles corresponding to each login.

.PARAMETER ReturnFolderLink
Returns a link to the folder.

.EXAMPLE
New-BoxFolderCollaboration -FolderName "Finance" -Collaborators $Users
#>
function New-BoxFolderCollaboration {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$FolderName,

        [string]$ParentFolderId = "0",

        [Parameter(Mandatory)]
        [string[]]$Login,

        [Parameter(Mandatory)]
        [string[]]$Role,

        [switch]$ReturnFolderLink
    )

    if ($Login.Count -ne $Role.Count) {
        throw "Login and Role counts must match."
    }

    if ($PSCmdlet.ShouldProcess("Box", "Create folder '$FolderName'")) {

        $FolderBody = @{
            name = $FolderName
            parent = @{
                id = $ParentFolderId
            }
        }

        $CreateFolder = @{
            RelativeURI = "folders"
            Method      = "POST"
            Body        = $FolderBody
        }

        $FolderResponse = Invoke-BoxRestCall @CreateFolder
        $FolderId = $FolderResponse.id

        for ($i = 0; $i -lt $Login.Count; $i++) {

            $Target = "$($Login[$i]) as $($Role[$i])"

            if ($PSCmdlet.ShouldProcess("Box Folder $FolderId", "Add collaborator $Target")) {

                $CollabBody = @{
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

                $CollabCall = @{
                    RelativeURI = "collaborations"
                    Method      = "POST"
                    Body        = $CollabBody
                }

                Invoke-BoxRestCall @CollabCall
            }
        }
    }

    if ($ReturnFolderLink) {
        return [PSCustomObject]@{
            FolderName = $FolderName
            FolderId   = $FolderId
            FolderUrl  = "https://app.box.com/folder/$FolderId"
        }
    }

    return $FolderResponse
}
