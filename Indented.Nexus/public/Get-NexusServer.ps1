using namespace System.Management.Automation

function Get-NexusServer {
    <#
    .SYNOPSIS
        Get the default Nexus server connection.
    .DESCRIPTION
        Get the default Nexus server connection.
    #>

    [CmdletBinding()]
    [OutputType('Indented.Nexus.Server')]
    param ( )

    if ($Script:nexusServer) {
        $Script:nexusServer
    } else {
        $errorRecord = [ErrorRecord]::new(
            [InvalidOperationException]::new('Not connected to a Nexus server'),
            'NexusEndPointNotDefined',
            'OperationStopped',
            $null
        )
        $pscmdlet.ThrowTerminatingError($errorRecord)
    }
}