<#
.SYNOPSIS
Uploads a file to Box.

.DESCRIPTION
Uploads a local file to a specified Box folder.

.PARAMETER FilePath
Local path of the file to upload.

.PARAMETER ParentFolderId
Box folder ID where the file will be uploaded.

.EXAMPLE
Send-BoxFile -FilePath "C:\Temp\report.pdf" -ParentFolderId "123456"
#>

function Send-BoxFile {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FilePath,

        [Parameter(Mandatory)]
        [string]$ParentFolderId
    )

    if ($null -eq $Script:BoxSession) {
        throw "No Box session established. Run New-BoxSession first."
    }

    $Attributes = @{
        name   = [System.IO.Path]::GetFileName($FilePath)
        parent = @{
            id = $ParentFolderId
        }
    } | ConvertTo-Json -Compress

    $Headers = @{
        Authorization = "Bearer $($Script:BoxSession.AccessToken)"
    }

    $Form = @{
        attributes = $Attributes
        file = Get-Item $FilePath
    }

    Invoke-RestMethod `
        -Method POST `
        -Uri "$($Script:Settings.UploadBaseURI)files/content" `
        -Headers $Headers `
        -Form $Form
}
