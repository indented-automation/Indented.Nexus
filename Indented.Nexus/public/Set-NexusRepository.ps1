function Set-NexusRepository {
    <#
    .SYNOPSIS
        Set repository configuration.
    .DESCRIPTION
        Set repository configuration.
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

        # The name of the blob store which should be used by this repository.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [String]$BlobStoreName,

        # Whether or not strict content validation should be enabled.
        [Boolean]$StrictContentValidation = $true,

        # The write policy for the repository.
        [WritePolicy]$WritePolicy = 'ALLOW_ONCE',

        # The Nexus server used to perform this action.
        [PSTypeName('Indented.Nexus.Server')]
        [PSObject]$Connection = (Get-NexusServer)
    )

    begin {
        $scriptName = 'psSetRepository'

        $params = @{
            Name       = $scriptName
            Content    = @(
                'import org.sonatype.nexus.repository.storage.WritePolicy'
                ''
                'def (name, blob_store_name, strict_content_validation, write_policy) = args.tokenize(";")'
                ''
                'switch (write_policy) {'
                '    case ~/^(?i)allowonce$/:'
                '        policy = WritePolicy.ALLOW_ONCE'
                '        break'
                '    case ~/^(?i)allow$/:'
                '        policy = WritePolicy.ALLOW'
                '        break'
                '    default:'
                '        policy = WritePolicy.DENY'
                '}'
                ''
                'repo = repository.repositoryManager.get(name)'
                'config = repo.getConfiguration()'
                'storage = config.attributes("storage")'
                ''
                'if (storage.get("blobStoreName") != blob_store_name) {'
                '    storage.set("blobStoreName", blob_store_name)'
                '}'
                'if (storage.get("writePolicy") != policy) {'
                '    storage.set("writePolicy", policy)'
                '}'
                'if (storage.get("strictContentTypeValidation") != strict_content_validation.toBoolean()) {'
                '    storage.set("strictContentTypeValidation", strict_content_validation.toBoolean())'
                '}'
                'repository.repositoryManager.update(config)'
            )
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
            ArgumentList = $Name, $BlobStoreName, $StrictContentValidation, $WritePolicy
        }
        if ($pscmdlet.ShouldProcess(('Setting repository {0}' -f $Name))) {
            $null = Invoke-NexusScript @params
        }
    }
}