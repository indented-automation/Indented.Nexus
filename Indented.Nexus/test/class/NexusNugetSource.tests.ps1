InModuleScope Indented.Nexus {
    Describe NexusNugetSource {
        BeforeAll {
            Mock Get-PackageSource {
                [PSCustomObject]@{
                    Name      = 'server'
                    Location  = 'http://server/repository/nuget/'
                    IsTrusted = $true
                }
            }
            Mock Set-PackageSource
            Mock Register-PackageSource
            Mock Unregister-PackageSource
            Mock InvokeNuget
            Mock GetNugetSource {
                [PSCustomObject]@{
                    Name     = 'server'
                    Location = 'http://server/repository/nuget/'
                }
            }
        }

        BeforeEach {
            $class = [NexusNugetSource]@{
                Ensure     = 'Present'
                Name       = 'server'
                Location   = 'http://server/repository/nuget/'
                Credential = [PSCredential]::new('fake', (ConvertTo-SecureString -String 'password' -AsPlainText -Force))
            }
        }

        Context 'Get, source present' {
            It 'Fills properties based on the output from Get-PackageSource' {
                $instance = $class.Get()

                $instance.Ensure | Should -Be 'Present'
                $instance.Name | Should -Be 'server'
            }
        }

        Context 'Get, source absent' {
            BeforeAll {
                Mock Get-PackageSource {
                    Write-Error 'Does not exist'
                }
            }

            It 'Fills properties based on the output from Get-PackageSource' {
                $instance = $class.Get()

                $instance.Ensure | Should -Be 'Absent'
            }
        }

        Context 'Set, both sources present' {
            It 'When ensure is present, recreates the repository' {
                $class.Set()

                Assert-MockCalled Register-PackageSource -Times 0 -Scope It
                Assert-MockCalled Set-PackageSource -Times 1 -Scope It
                Assert-MockCalled Unregister-PackageSource -Times 0 -Scope It
                Assert-MockCalled InvokeNuget -Times 2 -Scope It
            }

            It 'When ensure is present, and the location differs, updates the source' {
                $class.Location = 'http://newserver/repository/nuget/'
                $class.Set()

                Assert-MockCalled Register-PackageSource -Times 0 -Scope It
                Assert-MockCalled Set-PackageSource -Times 1 -Scope It
                Assert-MockCalled Unregister-PackageSource -Times 0 -Scope It
                Assert-MockCalled InvokeNuget -Times 2 -Scope It
            }

            It 'When ensure is absent, unregisters the source' {
                $class.Ensure = 'Absent'
                $class.Set()

                Assert-MockCalled Register-PackageSource -Times 0 -Scope It
                Assert-MockCalled Set-PackageSource -Times 0 -Scope It
                Assert-MockCalled Unregister-PackageSource -Times 1 -Scope It
                Assert-MockCalled InvokeNuget -Times 1 -Scope It
            }
        }

        Context 'Set, package source absent' {
            BeforeAll {
                Mock Get-PackageSource {
                    Write-Error 'Does not exist'
                }
            }

            It 'When ensure is present, registers a source' {
                $class.Set()

                Assert-MockCalled Register-PackageSource -Times 1 -Scope It
                Assert-MockCalled Set-PackageSource -Times 0 -Scope It
                Assert-MockCalled Unregister-PackageSource -Times 0 -Scope It
                Assert-MockCalled InvokeNuget -Times 2 -Scope It
            }
        }

        Context 'Set, nuget source absent' {
            BeforeAll {
                Mock GetNugetSource
            }

            It 'When ensure is present, registers a nuget source' {
                $class.Set()

                Assert-MockCalled Register-PackageSource -Times 0 -Scope It
                Assert-MockCalled Set-PackageSource -Times 1 -Scope It
                Assert-MockCalled Unregister-PackageSource -Times 0 -Scope It
                Assert-MockCalled InvokeNuget -Times 1 -Scope It
            }
        }

        Context 'Set, both sources absent' {
            BeforeAll {
                Mock Get-PackageSource {
                    Write-Error 'Does not exist'
                }
                Mock GetNugetSource
            }

            It 'When ensure is absent, does nothing' {
                $class.Ensure = 'Absent'
                $class.Set()

                Assert-MockCalled Register-PackageSource -Times 0 -Scope It
                Assert-MockCalled Set-PackageSource -Times 0 -Scope It
                Assert-MockCalled Unregister-PackageSource -Times 0 -Scope It
                Assert-MockCalled InvokeNuget -Times 0 -Scope It
            }
        }

        Context 'Test, both sources present' {
            It 'When ensure is present, and all settings match, returns true' {
                $class.Test() | Should -BeTrue
            }

            It 'When ensure is present, and one or more settings differs, returns false' {
                $class.Trusted = $false

                $class.Test() | Should -BeFalse
            }

            It 'When ensure is absent, returns false' {
                $class.Ensure = 'Absent'

                $class.Test() | Should -BeFalse
            }
        }

        Context 'Test, package source absent' {
            BeforeAll {
                Mock Get-PackageSource {
                    Write-Error 'Does not exist'
                }
            }

            It 'When ensure is present, returns false' {
                $class.Test() | Should -BeFalse
            }
        }

        Context 'Test, nuget source absent' {
            BeforeAll {
                Mock GetNugetSource
            }

            It 'When ensure is present, returns false' {
                $class.Test() | Should -BeFalse
            }
        }

        Context 'Set, both sources absent' {
            BeforeAll {
                Mock Get-PackageSource {
                    Write-Error 'Does not exist'
                }
                Mock GetNugetSource
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