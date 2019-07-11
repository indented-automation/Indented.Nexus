function Get-NexusScript {
    <#
    .SYNOPSIS
        Get the scripts installed on the Nexus server.
    .DESCRIPTION
        Get the scripts installed on the Nexus server.
    #>

    [CmdletBinding()]
    [OutputType('Indented.Nexus.Script')]
    param (
        # The name of a script.
        [Parameter(Position = 1, ValueFromPipeline)]
        [String]$Name,

        # The Nexus server used to perform this action.
        [PSTypeName('Indented.Nexus.Server')]
        [PSObject]$Connection = (Get-NexusServer)
    )

    process {
        $params = @{
            RestMethod = 'script'
            Connection = $Connection
        }
        if ($Name) {
            $params.RestMethod = '{0}/{1}' -f $params.RestMethod, $Name
        }
        InvokeNexusRestMethod @params | ForEach-Object { $_ } | ForEach-Object {
            [PSCustomObject]@{
                Name       = $_.Name
                Content    = $_.Content
                PSTypeName = 'Indented.Nexus.Script'
            }
        }
    }
}