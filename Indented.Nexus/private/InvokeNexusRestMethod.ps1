function InvokeNexusRestMethod {
    <#
    .SYNOPSIS
        Wrapper for Invoke-RestMethod. Simplifies Nexus API calls.
    .DESCRIPTION
        Wrapper for Invoke-RestMethod. Simplifies Nexus API calls.
    #>

    [CmdletBinding()]
    [OutputType([PSObject])]
    param (
        # The rest method to invoke. For example, 'repositories' will be used to construct the request GET /service/rest/v1/repositories.
        [Parameter(Mandatory)]
        [String]$RestMethod,

        # Request body which should be set with the request.
        [Object]$Body,

        # The content type. If the content type is application/json the body will be converted to JSON before sending the request.
        [String]$ContentType = 'application/json',

        # The web request method. For example, GET or POST.
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = 'GET',

        # The Nexus server used to perform this action.
        [PSTypeName('Indented.Nexus.Server')]
        [PSObject]$Connection = (Get-NexusServer)
    )

    $params = @{
        Uri     = '{0}/service/rest/v1/{1}' -f $Connection.BaseUri, $RestMethod
        Method  = $Method
        Headers = @{
            Authorization = 'Basic {0}' -f [Convert]::ToBase64String(
                [Byte[]][Char[]]('{0}:{1}' -f
                    $Connection.Credential.Username,
                    $Connection.Credential.GetNetworkCredential().Password
                )
            )
        }
    }
    if ($Body) {
        if ($ContentType -eq 'application/json') {
            $params.Add(
                'Body',
                ($Body | ConvertTo-Json)
            )
        } else {
            $params.Add('Body', $Body)
        }
    }
    $params.Add('ContentType', $ContentType)

    try {
        Invoke-RestMethod @params -ErrorAction Stop
    } catch {
        Write-Error -ErrorRecord $_
    }
}