function Remove-NexusBlobStore {
    <#
    .SYNOPSIS
        Remove a blob store.
    .DESCRIPTION
        Remove a blob store.
    #>

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ByName')]
    [OutputType([Void])]
    param (
        # The name of the blob store to remove.
        [Parameter(Mandatory, Position = 1, ParameterSetName = 'ByName')]
        [String]$Name,

        # A script object passed from Get-NexusBlobStore.
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'FromPipeline')]
        [PSTypeName('Indented.Nexus.BlobStore')]
        [PSObject]$InputObject,

        # The Nexus server used to perform this action.
        [PSTypeName('Indented.Nexus.Server')]
        [PSObject]$Connection = (Get-NexusServer)
    )

    begin {
        $scriptName = 'psRemoveBlobStore'

        $params = @{
            Name       = $scriptName
            Content    = 'blobStore.blobStoreManager.delete(args)'
            Connection = $Connection
        }
        Install-NexusScript @params
    }

    process {
        if ($pscmdlet.ParameterSetName -eq 'FromPipeline') {
            $Name = $InputObject.Name
        }
        $params = @{
            Name         = $scriptName
            Connection   = $Connection
            ArgumentList = $Name
        }
        if ($pscmdlet.ShouldProcess(('Removing blob store {0}' -f $Name))) {
            $null = Invoke-NexusScript @params
        }
    }
}