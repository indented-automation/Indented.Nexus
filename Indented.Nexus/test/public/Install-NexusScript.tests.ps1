InModuleScope Indented.Nexus {
    Describe Install-NexusScript {
        BeforeAll {
            Mock Get-NexusServer {
                [PSCustomObject]@{
                    PSTypeName = 'Indented.Nexus.Server'
                }
            }
            Mock Get-NexusScript {
                [PSCustomObject]@{
                    Name       = 'script'
                    Content    = 'content'
                    PSTypeName = 'Indented.Nexus.Script'
                }
            }
            Mock Remove-NexusScript
            Mock InvokeNexusRestMethod

            $defaultParams = @{
                Name    = 'script'
                Content = 'content'
            }
        }

        Context 'Script exists' {
            It 'When the script content matches, does nothing' {
                Install-NexusScript @defaultParams

                Assert-MockCalled Get-NexusScript -Times 1 -Scope It
                Assert-MockCalled Remove-NexusScript -Times 0 -Scope It
                Assert-MockCalled InvokeNexusRestMethod -Times 0 -Scope It
            }

            It 'When the script content does not match, replaces the script' {
                $testParams = $defaultParams.Clone()
                $testParams.Content = 'new content'

                Install-NexusScript @testParams

                Assert-MockCalled Get-NexusScript -Times 1 -Scope It
                Assert-MockCalled Remove-NexusScript -Times 1 -Scope It
                Assert-MockCalled InvokeNexusRestMethod -Times 1 -Scope It
            }
        }

        Context 'Script does not exist' {
            BeforeAll {
                Mock Get-NexusScript
            }

            It 'When the script does not exist, adds a new script' {
                Install-NexusScript @defaultParams

                Assert-MockCalled Get-NexusScript -Times 1 -Scope It
                Assert-MockCalled Remove-NexusScript -Times 0 -Scope It
                Assert-MockCalled InvokeNexusRestMethod -Times 1 -Scope It
            }
        }
    }
}