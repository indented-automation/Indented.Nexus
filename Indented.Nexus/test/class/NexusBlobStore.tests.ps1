InModuleScope Indented.Nexus {
    Describe NexusBlobStore {
        BeforeAll {
            Mock Connect-NexusServer
            Mock Get-NexusBlobStore {
                [PSCustomObject]@{
                    Name       = 'Blob'
                    Path       = 'C:\Folder'
                    PSTypeName = 'Indented.Nexus.BlobStore'
                }
            }
            Mock Remove-NexusBlobStore
            Mock New-NexusBlobStore
        }

        BeforeEach {
            $class = [NexusBlobStore]@{
                Ensure     = 'Present'
                Name       = 'Blob'
                Path       = 'C:\Folder'
                Credential = [PSCredential]::new('fake', (ConvertTo-SecureString -String 'password' -AsPlainText -Force))
            }
        }

        Context 'Get, blob store present' {
            It 'Fills properties based on the output from Get-NexusBlobStore' {
                $instance = $class.Get()

                $instance.Ensure | Should -Be 'Present'
                $instance.Path | Should -Be 'C:\Folder'
            }
        }

        Context 'Get, blob store absent' {
            BeforeAll {
                Mock Get-NexusBlobStore {
                    Write-Error 'Does not exist'
                }
            }

            It 'Fills properties based on the output from Get-NexusBlobStore' {
                $class.Ensure = 'Absent'
                $instance = $class.Get()

                $instance.Ensure | Should -Be 'Absent'
            }
        }

        Context 'Set, blob store present' {
            It 'When ensure is present, and the path matches, does nothing' {
                $class.Set()

                Assert-MockCalled New-NexusBlobStore -Times 0 -Scope It
                Assert-MockCalled Remove-NexusBlobStore -Times 0 -Scope It
            }

            It 'When ensure is present, and the path does not match, removes and recreates the blob store' {
                $class.Path = 'C:\NewPath'
                $class.Set()

                Assert-MockCalled New-NexusBlobStore -Times 1 -Scope It
                Assert-MockCalled Remove-NexusBlobStore -Times 1 -Scope It
            }

            It 'When ensure is absent, removes the blob store' {
                $class.Ensure = 'Absent'
                $class.Set()

                Assert-MockCalled New-NexusBlobStore -Times 0 -Scope It
                Assert-MockCalled Remove-NexusBlobStore -Times 1 -Scope It
            }
        }

        Context 'Set, blob store absent' {
            BeforeAll {
                Mock Get-NexusBlobStore {
                    Write-Error 'Does not exist'
                }
            }

            It 'When ensure is present, creates a new blob store' {
                $class.Set()

                Assert-MockCalled New-NexusBlobStore -Times 1 -Scope It
                Assert-MockCalled Remove-NexusBlobStore -Times 0 -Scope It
            }

            It 'When ensure is absent, does nothing' {
                $class.Ensure = 'Absent'
                $class.Set()

                Assert-MockCalled New-NexusBlobStore -Times 0 -Scope It
                Assert-MockCalled Remove-NexusBlobStore -Times 0 -Scope It
            }
        }

        Context 'Test, blob store present' {
            It 'When ensure is present, and the path matches, returns true' {
                $class.Test() | Should -BeTrue
            }

            It 'When ensure is prseent, and the path does not match, returns false' {
                $class.Path = 'C:\NewwPath'

                $class.Test() | Should -BeFalse
            }

            It 'When ensure is absent, returns false' {
                $class.Ensure = 'Absent'

                $class.Test() | Should -BeFalse
            }
        }

        Context 'Test, blob store absent' {
            BeforeAll {
                Mock Get-NexusBlobStore {
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