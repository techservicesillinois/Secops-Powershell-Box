<#
.SYNOPSIS
Creates a Box API session.

.DESCRIPTION
Authenticates to the Box API using client credentials and stores
the access token for use with other functions in the module.

.PARAMETER Credential
Credential containing the Box Client ID and Client Secret.

.PARAMETER EnterpriseId
Box enterprise ID.

.EXAMPLE
$Credential = Get-Credential
New-BoxSession -Credential $Credential -EnterpriseId "123456"
#>

function New-BoxSession {

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    "PSUseShouldProcessForStateChangingFunctions",
    "")]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [PSCredential]$Credential,

        [Parameter(Mandatory)]
        [string]$EnterpriseId
    )

    $Body = @{
        grant_type       = "client_credentials"
        client_id        = $Credential.UserName
        client_secret    = $Credential.GetNetworkCredential().Password
        box_subject_type = "enterprise"
        box_subject_id   = $EnterpriseId
    }

    $TokenRequest = @{
        Method      = "POST"
        Uri         = "https://api.box.com/oauth2/token"
        Body        = $Body
        ContentType = "application/x-www-form-urlencoded"
    }

    Write-Verbose "Authenticating to Box API"

    $Response = Invoke-RestMethod @TokenRequest

    if ($Response.access_token) {

        $Script:BoxSession = [PSCustomObject]@{
            AccessToken = $Response.access_token
            Created     = Get-Date
            ExpiresIn   = $Response.expires_in
        }

        Write-Verbose "Box session created."
    }
    else {
        throw "$_"
    }
}
