InModuleScope Indented.Nexus {
    Describe Get-NexusRealm {
        BeforeAll {
            Mock Get-NexusServer
            Mock Install-NexusScript -ParameterFilter { $Name -eq 'psGetRealm' }
            Mock Invoke-NexusScript -ParameterFilter { $Name -eq 'psGetRealm' } {
                [PSCustomObject]@{
                    Names = 'LdapRealm', 'NuGetApiKey', 'NexusAuthenticatingRealm', 'NexusAuthorizingRealm'
                }
            }
        }

        It 'Installs and invokes a nexus script' {
            Get-NexusRealm

            Assert-MockCalled Install-NexusScript -ParameterFilter { $Name -eq 'psGetRealm' }
            Assert-MockCalled Invoke-NexusScript -ParameterFilter { $Name -eq 'psGetRealm' }
        }
    }
}