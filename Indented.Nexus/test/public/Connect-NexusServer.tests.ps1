InModuleScope Indented.Nexus {
    Describe Connect-NexusServer {
        BeforeAll {
            Mock InvokeNexusRestMethod

            $defaultParams = @{
                Credential = [PSCredential]::new('fake', (ConvertTo-SecureString -String 'password' -AsPlainText -Force))
            }
        }

        BeforeEach {
            $Script:nexusServer = $null
        }

        Context 'Connection succeeds' {
            It 'Uses the repository list to test a connection' {
                Connect-NexusServer @defaultParams

                Assert-MockCalled InvokeNexusRestMethod
                $Script:nexusServer | Should -Not -BeNullOrEmpty
            }

            It 'When PassThru is used, returns an object describing the connection details' {
                Connect-NexusServer @defaultParams -PassThru | Should -Not -BeNullOrEmpty
            }
        }

        Context 'Connection fails' {
            BeforeAll {
                Mock InvokeNexusRestMethod {
                    throw 'SomeError'
                }
            }

            It 'Uses the repository list to test a connection' {
                { Connect-NexusServer @defaultParams } | Should -Throw

                Assert-MockCalled InvokeNexusRestMethod
                $Script:nexusServer | Should -BeNullOrEmpty
            }
        }
    }
}