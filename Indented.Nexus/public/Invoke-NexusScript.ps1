function Invoke-NexusScript {
    <#
    .SYNOPSIS
        Invoke an existing script on a Nexus server.
    .DESCRIPTION
        Invoke an existing script on a Nexus server.

        The script must already exist on the server. Output from the script is assumed to be JSON.
    #>

    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSObject])]
    param (
        # The name of the script to execute.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [String]$Name,

        # Arguments which should be passed to the executing script. Arguments are joined using a semi-colon and must be handled by the executing script.
        [String[]]$ArgumentList,

        # The Nexus server used to perform this action.
        [PSTypeName('Indented.Nexus.Server')]
        [PSObject]$Connection = (Get-NexusServer)
    )

    process {
        $params = @{
            RestMethod  = 'script/{0}/run' -f $Name
            Method      = 'POST'
            ContentType = 'text/plain'
            Connection  = $Connection
        }
        if ($ArgumentList) {
            $params.Body = $ArgumentList -join ';'
        }
        if ($pscmdlet.ShouldProcess(('Invoking script {0}' -f $Name))) {
            try {
                $response = InvokeNexusRestMethod @params
                if (-not [String]::IsNullOrWhiteSpace($response.Result)) {
                    try {
                        $response.Result | ConvertFrom-Json | ForEach-Object { $_ }
                    } catch {
                        Write-Debug ('JSON deserialization failed: {0}' -f $response.Result)
                    }
                }
            } catch {
                $pscmdlet.ThrowTerminatingError($_)
            }
        }
    }
}