<#
.SYNOPSIS
Deletes a Box folder.

.DESCRIPTION
Deletes the specified folder and its contents from Box.

.PARAMETER FolderId
ID of the folder to delete.

.EXAMPLE
Remove-BoxFolder -FolderId "123456789"
#>

function Remove-BoxFolder {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FolderId
    )

    Invoke-BoxRestCall `
        -RelativeURI "folders/$FolderId?recursive=true" `
        -Method DELETE
}