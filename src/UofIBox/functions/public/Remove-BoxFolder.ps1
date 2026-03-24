<#
.SYNOPSIS
Deletes a Box folder.

.DESCRIPTION
Deletes the specified folder and its contents from Box.

.PARAMETER FolderId
ID of the folder to delete.

.PARAMETER Recursive
If set, deletes the folder and all of its contents. If not set, the folder must be empty to be deleted.

.EXAMPLE
Remove-BoxFolder -FolderId "123456789"
#>

function Remove-BoxFolder {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$FolderId,

        [switch]$Recursive
    )

    $Uri = "folders/$FolderId"

    if ($Recursive) {
        $Uri += "?recursive=true"
    }

    if ($PSCmdlet.ShouldProcess("Folder $FolderId", "Delete")) {

        $Call = @{
            RelativeURI = $Uri
            Method      = "DELETE"
        }

        Invoke-BoxRestCall @Call
    }
}
