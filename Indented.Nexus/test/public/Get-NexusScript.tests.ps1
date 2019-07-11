InModuleScope Indented.Nexus {
    Describe Get-NexusScript {
        BeforeAll {
            Mock Get-NexusServer {
                [PSCustomObject]@{
                    PSTypeName = 'Indented.Nexus.Server'
                }
            }
            Mock InvokeNexusRestMethod {
                [PSCustomObject]@{
                    name    = 'script'
                    content = 'content'
                }
            }
        }

        It 'Invokes the script rest method' {
            $script = Get-NexusScript

            $script.Name | Should -Be 'script'
            $script.Content | Should -Be 'content'
            $script.PSTypeNames | Should -contain 'Indented.Nexus.Script'

            Assert-MockCalled InvokeNexusRestMethod
        }
    }
}