function New-NexusBlobStore {
    <#
    .SYNOPSIS
        Create a new file blob store.
    .DESCRIPTION
        Create a new file blob store on a Nexus server.
    #>

    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Void])]
    param (
        # The name of the blob store to create.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
        [String]$Name,

        # The path the blob store should use.
        [Parameter(Mandatory, Position = 2, ValueFromPipelineByPropertyName)]
        [String]$Path,

        # The Nexus server used to perform this action.
        [PSTypeName('Indented.Nexus.Server')]
        [PSObject]$Connection = (Get-NexusServer)
    )

    begin {
        $scriptName = 'psNewBlobStore'

        $params = @{
            Name       = $scriptName
            Content    = @(
                'def (name, path) = args.tokenize(";")'
                'blobStore.createFileBlobStore(name, path)'
            )
            Connection = $Connection
        }
        Install-NexusScript @params
    }

    process {
        $params = @{
            Name         = $scriptName
            Connection   = $Connection
            ArgumentList = $Name, $Path
        }
        if ($pscmdlet.ShouldProcess(('Creating blob store {0}' -f $Name))) {
            $null = Invoke-NexusScript @params
        }
    }
}