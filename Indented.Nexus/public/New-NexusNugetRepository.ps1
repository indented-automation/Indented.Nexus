function New-NexusNugetRepository {
    <#
    .SYNOPSIS
        Create a new hosted Nuget repository.
    .DESCRIPTION
        Create a new hosted Nuget repository.
    #>

    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Void])]
    param (
        # The name of the blob store to create.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
        [String]$Name,

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
        $scriptName = 'psNewNugetRepository'

        $params = @{
            Name       = $scriptName
            Content    = @(
                'import org.sonatype.nexus.repository.storage.WritePolicy'
                ''
                'def (name, blob_store_name, strict_content_validation, write_policy) = args.tokenize(";")'
                ''
                'def policy = WritePolicy.ALLOW_ONCE'
                'switch (write_policy) {'
                '    case ~/^(?i)allow$/:'
                '        policy = WritePolicy.ALLOW'
                '        break'
                '    case ~/^(?i)deny$/:'
                '        policy = WritePolicy.DENY'
                '        break'
                '}'
                'repository.createNugetHosted(name, blob_store_name, strict_content_validation.toBoolean(), policy)'
            )
            Connection = $Connection
        }
        Install-NexusScript @params
    }

    process {
        $params = @{
            Name         = $scriptName
            Connection   = $Connection
            ArgumentList = $Name, $BlobStoreName, $StrictContentValidation, $WritePolicy
        }
        if ($pscmdlet.ShouldProcess(('Creating Nuget respository {0}' -f $Name))) {
            $null = Invoke-NexusScript @params
        }
    }
}