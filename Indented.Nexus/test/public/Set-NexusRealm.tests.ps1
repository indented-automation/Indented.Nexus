InModuleScope Indented.Nexus {
    Describe Set-NexusRealm {
        BeforeAll {
            Mock Get-NexusServer
            Mock Install-NexusScript -ParameterFilter { $Name -eq 'psSetRealm' }
            Mock Invoke-NexusScript -ParameterFilter { $Name -eq 'psSetRealm' }

            $defaultParams = @{
                Realm = 'LdapRealm', 'NuGetApiKey', 'NexusAuthenticatingRealm', 'NexusAuthorizingRealm'
            }
        }

        It 'Installs and invokes a nexus script' {
            Set-NexusRealm @defaultParams

            Assert-MockCalled Install-NexusScript -ParameterFilter { $Name -eq 'psSetRealm' }
            Assert-MockCalled Invoke-NexusScript -ParameterFilter { $Name -eq 'psSetRealm' }
        }
    }
}