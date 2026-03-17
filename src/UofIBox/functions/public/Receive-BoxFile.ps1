<#
.SYNOPSIS
Downloads a file from Box.

.DESCRIPTION
Downloads the specified Box file to a local path.

.PARAMETER FileId
The ID of the Box file.

.PARAMETER OutputPath
Local file path where the file will be saved.

.EXAMPLE
Receive-BoxFile -FileId "123456" -OutputPath "C:\Downloads\file.pdf"
#>

function Receive-BoxFile {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FileId,

        [Parameter(Mandatory)]
        [string]$OutputPath
    )

    $DownloadCall = @{
        Method      = "GET"
        RelativeURI = "files/$FileId/content"
        OutFile     = $OutputPath
    }

    Invoke-BoxRestCall @DownloadCall
}