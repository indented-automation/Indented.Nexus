function Get-NexusRepository {
    <#
    .SYNOPSIS
        Get the repositories on a Nexus server.
    .DESCRIPTION
        Get the repositories on a Nexus server.
    #>

    [CmdletBinding()]
    [OutputType('Indented.Nexus.Repository')]
    param (
        # The name of a repository.
        [Parameter(Position = 1, ValueFromPipeline)]
        [String]$Name,

        # The Nexus server used to perform this action.
        [PSTypeName('Indented.Nexus.Server')]
        [PSObject]$Connection = (Get-NexusServer)
    )

    begin {
        $scriptName = 'psGetRepository'

        $params = @{
            Name       = $scriptName
            Content    = @(
                'def repositories = []'
                'if (args) {'
                '    repositories << repository.repositoryManager.get(args)'
                '} else {'
                '    repositories = repository.repositoryManager.browse()'
                '}'
                'def repository_configuration = []'
                'repositories.each {'
                '    def config = it.getConfiguration()'
                '    def (format, type) = config.recipeName.split("-")'
                '    def storage = config.attributes("storage")'
                '    repository_configuration << ['
                '        Name:                    config.repositoryName,'
                '        Type:                    type,'
                '        Format:                  format,'
                '        BlobStoreName:           storage.get("blobStoreName"),'
                '        WritePolicy:             storage.get("writePolicy"),'
                '        StrictContentValidation: storage.get("strictContentTypeValidation"),'
                '    ]'
                '}'
                'return groovy.json.JsonOutput.toJson(repository_configuration)'
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
        Invoke-NexusScript @params |
            Add-Member -TypeName 'Indented.Nexus.Repository' -PassThru
    }
}