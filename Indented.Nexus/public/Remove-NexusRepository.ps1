function Remove-NexusRepository {
    <#
    .SYNOPSIS
        Remove a repository.
    .DESCRIPTION
        Remove a repository.
    #>

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ByName')]
    [OutputType([Void])]
    param (
        # The name of the repository to remove.
        [Parameter(Mandatory, Position = 1, ParameterSetName = 'ByName')]
        [String]$Name,

        # A script object passed from Get-NexusRepository.
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'FromPipeline')]
        [PSTypeName('Indented.Nexus.Repository')]
        [PSObject]$InputObject,

        # The Nexus server used to perform this action.
        [PSTypeName('Indented.Nexus.Server')]
        [PSObject]$Connection = (Get-NexusServer)
    )

    begin {
        $scriptName = 'psRemoveRepository'

        $params = @{
            Name       = $scriptName
            Content    = 'repository.repositoryManager.delete(args)'
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
        if ($pscmdlet.ShouldProcess(('Removing respository {0}' -f $Name))) {
            $null = Invoke-NexusScript @params
        }
    }
}