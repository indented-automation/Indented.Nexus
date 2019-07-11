function Get-NexusRealm {
    <#
    .SYNOPSIS
        Get the list of realms allowed by the nexus server
    .DESCRIPTION
        Get the blob stores configured on the Nexus server.

        Blob stores information is returned using the script API.
    #>

    [CmdletBinding()]
    [OutputType([Realm], [Realm[]])]
    param (
        # The Nexus server used to perform this action.
        [PSTypeName('Indented.Nexus.Server')]
        [PSObject]$Connection = (Get-NexusServer)
    )

    begin {
        $scriptName = 'psGetRealm'

        $params = @{
            Name       = $scriptName
            Content    = @(
                'def realmManager = container.lookup(org.sonatype.nexus.security.realm.RealmManager.class.name)'
                'def config = realmManager.getConfiguration()'
                'return groovy.json.JsonOutput.toJson(['
                '    names : config.getRealmNames()'
                '])'
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
        [Realm[]]((Invoke-NexusScript @params).names -replace 'rutauth-realm', 'RutAuthRealm')
    }
}