function Remove-NexusScript {
    <#
    .SYNOPSIS
        Get the scripts installed on the Nexus server.
    .DESCRIPTION
        Get the scripts installed on the Nexus server.
    #>

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ByName')]
    [OutputType([Void])]
    param (
        # The name of a script.
        [Parameter(Mandatory, Position = 1, ParameterSetName = 'ByName')]
        [String]$Name,

        # A script object passed from Get-NexusScript.
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'FromPipeline')]
        [PSTypeName('Indented.Nexus.Script')]
        [PSObject]$InputObject,

        # The Nexus server used to perform this action.
        [PSTypeName('Indented.Nexus.Server')]
        [PSObject]$Connection = (Get-NexusServer)
    )

    process {
        if ($pscmdlet.ParameterSetName -eq 'FromPipeline') {
            $Name = $InputObject.Name
        }
        $params = @{
            RestMethod = 'script/{0}' -f $Name
            Method     = 'DELETE'
            Connection = $Connection
        }
        if ($pscmdlet.ShouldProcess(('Removing script {0}' -f $Name))) {
            $null = InvokeNexusRestMethod @params
        }
    }
}