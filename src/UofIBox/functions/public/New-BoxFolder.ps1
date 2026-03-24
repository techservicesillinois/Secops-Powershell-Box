<#
.SYNOPSIS
Creates a new folder in Box.

.DESCRIPTION
Creates a folder in the specified parent folder.

.PARAMETER FolderName
Name of the folder to create.

.PARAMETER ParentFolderId
Parent folder ID. Defaults to root (0).

.EXAMPLE
New-BoxFolder -FolderName "Finance" -ParentFolderId 0
#>

function New-BoxFolder {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$FolderName,

        [string]$ParentFolderId = "0"
    )

    if ($PSCmdlet.ShouldProcess("Box", "Create folder '$FolderName'")) {

        $Body = @{
            name = $FolderName
            parent = @{
                id = $ParentFolderId
            }
        }

        $Call = @{
            RelativeURI = "folders"
            Method      = "POST"
            Body        = $Body
        }

        Invoke-BoxRestCall @Call
    }
}