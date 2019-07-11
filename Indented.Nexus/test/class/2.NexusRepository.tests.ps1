InModuleScope Indented.Nexus {
    Describe NexusRepository {
        BeforeAll {
            Mock Connect-NexusServer
            Mock Get-NexusRepository {
                [PSCustomObject]@{
                    Name                    = 'Repo'
                    Type                    = 'hosted'
                    Format                  = 'Nuget'
                    BlobStoreName           = 'Blob'
                    StrictContentValidation = $true
                    WritePolicy             = 'ALLOW_ONCE'
                    PSTypeName              = 'Indented.Nexus.Repository'
                }
            }
            Mock Remove-NexusRepository
            Mock Set-NexusRepository
            Mock New-NexusNugetRepository
            Mock New-NexusRubyGemRepository
        }

        BeforeEach {
            $class = [NexusRepository]@{
                Ensure                  = 'Present'
                Name                    = 'Repo'
                Format                  = 'Nuget'
                BlobStoreName           = 'Blob'
                StrictContentValidation = $true
                WritePolicy             = 'ALLOW_ONCE'
                Credential              = [PSCredential]::new('fake', (ConvertTo-SecureString -String 'password' -AsPlainText -Force))
            }
        }

        Context 'Get, repository present' {
            It 'Fills properties based on the output from Get-NexusRepository' {
                $instance = $class.Get()

                $instance.Ensure | Should -Be 'Present'
                $instance.Name | Should -Be 'Repo'
                $instance.StrictContentValidation | Should -Be $true
                $instance.WritePolicy | Should -Be 'ALLOW_ONCE'
            }
        }

        Context 'Get, repository absent' {
            BeforeAll {
                Mock Get-NexusRepository {
                    Write-Error 'Does not exist'
                }
            }

            It 'Fills properties based on the output from Get-NexusRepository' {
                $instance = $class.Get()

                $instance.Ensure | Should -Be 'Absent'
            }
        }

        Context 'Set, repository present' {
            It 'When ensure is present, updates repository settings' {
                $class.Set()

                Assert-MockCalled New-NexusNugetRepository -Times 0 -Scope It
                Assert-MockCalled New-NexusRubyGemRepository -Times 0 -Scope It
                Assert-MockCalled Remove-NexusRepository -Times 0 -Scope It
                Assert-MockCalled Set-NexusRepository -Times 1 -Scope It
            }

            It 'When ensure is present, and the requested format differs, removes and recreates the repository' {
                $class.Format = 'RubyGem'
                $class.Set()

                Assert-MockCalled New-NexusNugetRepository -Times 0 -Scope It
                Assert-MockCalled New-NexusRubyGemRepository -Times 1 -Scope It
                Assert-MockCalled Remove-NexusRepository -Times 1 -Scope It
                Assert-MockCalled Set-NexusRepository -Times 0 -Scope It
            }

            It 'When ensure is absent, removes the repository' {
                $class.Ensure = 'Absent'
                $class.Set()

                Assert-MockCalled New-NexusNugetRepository -Times 0 -Scope It
                Assert-MockCalled New-NexusRubyGemRepository -Times 0 -Scope It
                Assert-MockCalled Remove-NexusRepository -Times 1 -Scope It
                Assert-MockCalled Set-NexusRepository -Times 0 -Scope It
            }
        }

        Context 'Set, incorrect repository type' {
            BeforeAll {
                Mock Get-NexusRepository {
                    [PSCustomObject]@{
                        Name                    = 'Repo'
                        Type                    = 'group'
                        Format                  = 'Nuget'
                        BlobStoreName           = 'Blob'
                        StrictContentValidation = $true
                        WritePolicy             = 'ALLOW_ONCE'
                    }
                }
            }

            It 'When ensure is present, and the existing repository type is not hosted, removes and recreates the repository' {
                $class.Set()

                Assert-MockCalled New-NexusNugetRepository -Times 1 -Scope It
                Assert-MockCalled New-NexusRubyGemRepository -Times 0 -Scope It
                Assert-MockCalled Remove-NexusRepository -Times 1 -Scope It
                Assert-MockCalled Set-NexusRepository -Times 0 -Scope It
            }
        }

        Context 'Set, repository absent' {
            BeforeAll {
                Mock Get-NexusRepository {
                    Write-Error 'Does not exist'
                }
            }

            It 'When ensure is present, creates a repository' {
                $class.Set()

                Assert-MockCalled New-NexusNugetRepository -Times 1 -Scope It
                Assert-MockCalled New-NexusRubyGemRepository -Times 0 -Scope It
                Assert-MockCalled Remove-NexusRepository -Times 0 -Scope It
                Assert-MockCalled Set-NexusRepository -Times 0 -Scope It
            }

            It 'When ensure is absent, does nothing' {
                $class.Ensure = 'Absent'
                $class.Set()

                Assert-MockCalled New-NexusNugetRepository -Times 0 -Scope It
                Assert-MockCalled New-NexusRubyGemRepository -Times 0 -Scope It
                Assert-MockCalled Remove-NexusRepository -Times 0 -Scope It
                Assert-MockCalled Set-NexusRepository -Times 0 -Scope It
            }
        }

        Context 'Test, repository present' {
            It 'When ensure is present, and all settings match, returns true' {
                $class.Test() | Should -BeTrue
            }

            It 'When ensure is present, and one or more settings differs, returns false' {
                $class.WritePolicy = 'DENY'

                $class.Test() | Should -BeFalse
            }

            It 'When ensure is present, and the requested format differs, returns false' {
                $class.Format = 'RubyGem'

                $class.Test() | Should -BeFalse
            }

            It 'When ensure is absent, returns false' {
                $class.Ensure = 'Absent'

                $class.Test() | Should -BeFalse
            }
        }

        Context 'Test, incorrect repository type' {
            BeforeAll {
                Mock Get-NexusRepository {
                    [PSCustomObject]@{
                        Name                    = 'Repo'
                        Type                    = 'group'
                        Format                  = 'Nuget'
                        BlobStoreName           = 'Blob'
                        StrictContentValidation = $true
                        WritePolicy             = 'ALLOW_ONCE'
                    }
                }
            }

            It 'When ensure is present, and the existing repository type is not hosted, returns false' {
                $class.Test() | Should -BeFalse
            }
        }

        Context 'Test, repository absent' {
            BeforeAll {
                Mock Get-NexusRepository {
                    Write-Error 'Does not exist'
                }
            }

            It 'When ensure is present, returns false' {
                $class.Test() | Should -BeFalse
            }

            It 'When ensure is absent, returns true' {
                $class.Ensure = 'Absent'

                $class.Test() | Should -BeTrue
            }
        }
    }
}