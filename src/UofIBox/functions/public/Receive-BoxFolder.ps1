<#
.SYNOPSIS
Downloads an entire Box folder.

.DESCRIPTION
Recursively downloads all files and subfolders from a Box folder.

.PARAMETER FolderId
The ID of the Box folder to download.

.PARAMETER OutputDirectory
Local directory where files will be downloaded.

.EXAMPLE
Receive-BoxFolder -FolderId "123456" -OutputDirectory "C:\BoxDownloads"
#>

function Receive-BoxFolder {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FolderId,

        [Parameter(Mandatory)]
        [string]$OutputDirectory
    )

    # Get folder metadata
    $FolderCall = @{
        RelativeURI = "folders/$FolderId"
        Method      = "GET"
    }

    $Folder = Invoke-BoxRestCall @FolderCall

    $LocalFolder = Join-Path $OutputDirectory $Folder.name

    if (-not (Test-Path $LocalFolder)) {
        New-Item -ItemType Directory -Path $LocalFolder | Out-Null
    }

    # Get folder items
    $ItemsCall = @{
        RelativeURI = "folders/$FolderId/items"
        Method      = "GET"
    }

    $Items = Invoke-BoxRestCall @ItemsCall

    foreach ($Item in $Items.entries) {

        if ($Item.type -eq "file") {

            $DownloadPath = Join-Path $LocalFolder $Item.name

            $DownloadCall = @{
                FileId     = $Item.id
                OutputPath = $DownloadPath
            }

            Receive-BoxFile @DownloadCall
        }

        if ($Item.type -eq "folder") {

            $SubFolderCall = @{
                FolderId         = $Item.id
                OutputDirectory  = $LocalFolder
            }

            Receive-BoxFolder @SubFolderCall
        }
    }
}
