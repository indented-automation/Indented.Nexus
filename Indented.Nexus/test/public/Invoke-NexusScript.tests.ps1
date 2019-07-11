InModuleScope Indented.Nexus {
    Describe Invoke-NexusScript {
        BeforeAll {
            Mock Get-NexusServer {
                [PSCustomObject]@{
                    PSTypeName = 'Indented.Nexus.Server'
                }
            }
            Mock Write-Debug
            Mock InvokeNexusRestMethod {
                [PSCustomObject]@{
                    Result = '{"name":"value"}'
                }
            }

            $defaultParams = @{
                Name = 'script'
            }
        }

        Context 'Response is valid JSON' {
            It 'Returns parsed json content' {
                $result = Invoke-NexusScript @defaultParams

                $result | Should -Not -BeNullOrEmpty
                $result.Name | Should -Be 'value'

                Assert-MockCalled InvokeNexusRestMethod -Times 1 -Scope It
            }
        }

        Context 'Response is not valid JSON' {
            BeforeAll {
                Mock InvokeNexusRestMethod {
                    [PSCustomObject]@{
                        Result = 'InvalidLeadIn{"name":"value"}'
                    }
                }
            }

            It 'Writes debug output' {
                Invoke-NexusScript @defaultParams | Should -BeNullOrEmpty

                Assert-MockCalled InvokeNexusRestMethod -Times 1 -Scope It
                Assert-MockCalled Write-Debug -Times 1 -Scope It
            }
        }
    }
}