function Connect-NexusServer {
    <#
    .SYNOPSIS
        Connect to a Nexus server.
    .DESCRIPTION
        Connect to a Nexus server. This command is used to validate connection information.
    #>

    [CmdletBinding()]
    [OutputType([PSObject])]
    param (
        # The name of the server to connect to. By default the local server is used.
        [String]$ComputerName = 'localhost',

        # The port the Nexus service is using. By default the port used is 8081.
        [UInt16]$Port = 8081,

        # The credential used to authenticate when using the REST service.
        [Parameter(Mandatory)]
        [PSCredential]$Credential,

        # Use HTTPS instead of HTTP.
        [Switch]$UseSSL,

        # Return the connection instead of setting the connection as the default.
        [Switch]$PassThru
    )

    try {
        $nexusServer = [PSCustomObject]@{
            BaseUri    = 'http{0}://{1}:{2}' -f
                @('','s')[$UseSSL.ToBool()],
                $ComputerName,
                $Port
            Credential = $Credential
            PSTypeName = 'Indented.Nexus.Server'
        }

        $params = @{
            RestMethod  = 'repositories'
            Connection  = $nexusServer
            ErrorAction = 'Stop'
        }
        $null = InvokeNexusRestMethod @params

        if ($PassThru) {
            $nexusServer
        } else {
            $Script:nexusServer = $nexusServer
        }
    } catch {
        $pscmdlet.ThrowTerminatingError($_)
    }
}