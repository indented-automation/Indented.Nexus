InModuleScope Indented.Nexus {
    Describe NexusSyncNugetRepository {
        BeforeAll {
           Mock Sync-NexusNugetRepository
        }

        BeforeEach {
            $class = [NexusSyncNugetRepository]@{
                Source      = 'source'
                Destination = 'destination1', 'destination2'
            }
        }

        Context Get {
            It 'Does nothing' {
                $class.Get() | Should -Not -BeNullOrEmpty
            }
        }

        Context Set {
            It 'Starts synchronisation' {
                $class.Set()

                Assert-MockCalled Sync-NexusNugetRepository -Times 1 -Scope It
            }
        }

        Context Test {
            It 'Always returns false' {
                $class.Test() | Should -Be $false
            }
        }
    }
}