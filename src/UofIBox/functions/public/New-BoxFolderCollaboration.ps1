<#
.SYNOPSIS
Creates a Box folder and assigns collaborators.

.DESCRIPTION
Creates a new folder and assigns users with the specified roles.

.PARAMETER FolderName
Name of the folder to create.

.PARAMETER ParentFolderId
Parent folder ID.

.PARAMETER Collaborators
Array of collaborator objects containing login and role.

.PARAMETER ReturnFolderLink
Returns a link to the folder.

.EXAMPLE
New-BoxFolderCollaboration -FolderName "Finance" -Collaborators $Users
#>
function New-BoxFolderCollaboration {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FolderName,

        [string]$ParentFolderId = "0",

        [Parameter(Mandatory)]
        [array]$Collaborators,

        [switch]$ReturnFolderLink
    )

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

    foreach ($User in $Collaborators) {

        $CollabBody = @{
            item = @{
                type = "folder"
                id   = $FolderId
            }
            accessible_by = @{
                type  = "user"
                login = $User.login
            }
            role = $User.role
        }

        $CollabCall = @{
            RelativeURI = "collaborations"
            Method      = "POST"
            Body        = $CollabBody
        }

        Invoke-BoxRestCall @CollabCall
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