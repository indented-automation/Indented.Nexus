function Update-NexusUserPassword {
    <#
    .SYNOPSIS
        Change the password for the authenticated user.
    .DESCRIPTION
        Change the password for the authenticated user.
    #>

    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Void])]
    param (
        [Parameter(Mandatory, Position = 1)]
        [String]$Username,

        # The name of the blob store to create.
        [Parameter(Mandatory)]
        [SecureString]$NewPassword,

        # The Nexus server used to perform this action.
        [PSTypeName('Indented.Nexus.Server')]
        [PSObject]$Connection = (Get-NexusServer)
    )

    $scriptName = 'psUpdateUserPassword'

    $params = @{
        Name       = $scriptName
        Content    = @(
            'def (username, password) = args.tokenize(";")'
            'security.securitySystem.changePassword(username, password)'
        )
        Connection = $Connection
    }
    Install-NexusScript @params

    $password = [PSCredential]::new('null', $NewPassword).GetNetworkCredential().Password
    $params = @{
        Name         = $scriptName
        Connection   = $Connection
        ArgumentList = $Username, $password -join ';'
    }
    if ($pscmdlet.ShouldProcess(('Updating password for {0}' -f $Username))) {
        Invoke-NexusScript @params
    }
}