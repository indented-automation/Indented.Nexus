function Get-NexusBlobStore {
    <#
    .SYNOPSIS
        Get the blob stores configured on the Nexus server.
    .DESCRIPTION
        Get the blob stores configured on the Nexus server.

        Blob stores information is returned using the script API.
    #>

    [CmdletBinding()]
    [OutputType('Indented.Nexus.BlobStore')]
    param (
        # The name of a blob store.
        [Parameter(Position = 1, ValueFromPipeline)]
        [String]$Name,

        # The Nexus server used to perform this action.
        [PSTypeName('Indented.Nexus.Server')]
        [PSObject]$Connection = (Get-NexusServer)
    )

    begin {
        $scriptName = 'psGetBlobStore'

        $params = @{
            Name       = $scriptName
            Content    = @(
                'def blob_stores = []'
                'if (args) {'
                '    blob_stores << blobStore.blobStoreManager.get(args)'
                '} else {'
                '    blob_stores = blobStore.blobStoreManager.browse()'
                '}'
                'def blob_store_configuration = []'
                'blob_stores.each {'
                '    def config = it.getBlobStoreConfiguration()'
                '    blob_store_configuration << ['
                '        Name: config.name,'
                '        Path: config.attributes.file.path,'
                '        Type: config.type'
                '    ]'
                '}'
                'return groovy.json.JsonOutput.toJson(blob_store_configuration)'
            )
            Connection = $Connection
        }
        Install-NexusScript @params
    }

    process {
        $params = @{
            Name       = $scriptName
            Connection = $Connection
        }
        if ($Name) {
            $params.Add('ArgumentList', $Name)
        }
        Invoke-NexusScript @params | Add-Member -TypeName 'Indented.Nexus.BlobStore' -PassThru
    }
}