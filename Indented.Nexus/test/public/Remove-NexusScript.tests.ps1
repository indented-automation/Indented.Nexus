InModuleScope Indented.Nexus {
    Describe Remove-NexusScript {
        BeforeAll {
            Mock Get-NexusServer {
                [PSCustomObject]@{
                    PSTypeName = 'Indented.Nexus.Server'
                }
            }
            Mock InvokeNexusRestMethod

            $defaultParams = @{
                Name = 'Name'
            }
        }

        It 'Uses the script API to delete a script' {
            Remove-NexusScript @defaultParams

            Assert-MockCalled InvokeNexusRestMethod -Times 1 -Scope It
        }
    }
}