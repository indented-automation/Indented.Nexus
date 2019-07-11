InModuleScope Indented.Nexus {
    Describe NexusRealm {
        BeforeAll {
            Mock Connect-NexusServer
            Mock Get-NexusRealm {
                'NexusAuthenticatingRealm'
                'NexusAuthorizingRealm'
            }
            Mock Set-NexusRealm
        }

        BeforeEach {
            $class = [NexusRealm]@{
                Realm      = 'NexusAuthenticatingRealm, NexusAuthorizingRealm'
                Credential = [PSCredential]::new('fake', (ConvertTo-SecureString -String 'password' -AsPlainText -Force))
            }
        }

        Context Get {
            It 'Gets the list of enabled realms' {
                $instance = $class.Get()

                $instance.Realm | Should -Be 'NexusAuthenticatingRealm, NexusAuthorizingRealm'
            }
        }

        Context Set {
            It 'Sets the list of realms' {
                $class.Set()

                Assert-MockCalled Set-NexusRealm -Scope It
            }
        }

        Context Test {
            It 'When the list of realms matches, returns true' {
                $class.Test() | Should -BeTrue
            }

            It 'When the list of realms does not match, returns false' {
                $class.Realm = 'NuGetApiKey, NexusAuthenticatingRealm, NexusAuthorizingRealm'

                $class.Test() | Should -BeFalse
            }

            It 'When the list of realms is ordered differently, returns false' {
                $class.Realm = 'NexusAuthorizingRealm, NexusAuthenticatingRealm'

                $class.Test() | Should -BeFalse
            }
        }
    }
}