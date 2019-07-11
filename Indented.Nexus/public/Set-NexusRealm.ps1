function Set-NexusRealm {
    <#
    .SYNOPSIS
        Get the blob stores configured on the Nexus server.
    .DESCRIPTION
        Get the blob stores configured on the Nexus server.

        Blob stores information is returned using the script API.
    #>

    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Void])]
    param (
        [Parameter(Mandatory)]
        [Realm[]]$Realm,

        # The Nexus server used to perform this action.
        [PSTypeName('Indented.Nexus.Server')]
        [PSObject]$Connection = (Get-NexusServer)
    )

    $scriptName = 'psSetRealm'
    [String[]]$realmList = $Realm -split ', ' -replace 'RutAuthRealm', 'rutauth-realm'

    $params = @{
        Name       = $scriptName
        Content    = @(
            'def realms = args.tokenize(";")'
            ''
            'def realmManager = container.lookup(org.sonatype.nexus.security.realm.RealmManager.class.name)'
            'def config = realmManager.getConfiguration()'
            'config.setRealmNames(realms)'
            'realmManager.setConfiguration(config)'
        )
        Connection = $Connection
    }
    Install-NexusScript @params

    $params = @{
        Name         = $scriptName
        Connection   = $Connection
        ArgumentList = $realmList
    }
    if ($pscmdlet.ShouldProcess(('Setting realms to {0}' -f ($realmList -join ',')))) {
        $null = Invoke-NexusScript @params
    }
}