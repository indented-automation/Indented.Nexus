InModuleScope Indented.Nexus {
    Describe NexusUserPassword {
        BeforeAll {
            Mock Connect-NexusServer -ParameterFilter { $Credential.GetNetworkCredential().Password -eq 'password' }
            Mock Connect-NexusServer -ParameterFilter { $Credential.GetNetworkCredential().Password -eq 'newpassword' }
            Mock Update-NexusUserPassword
        }

        BeforeEach {
            $class = [NexusUserPassword]@{
                Username    = 'fake'
                NewPassword = [PSCredential]::new('new', (ConvertTo-SecureString -String 'newpassword' -AsPlainText -Force))
                Credential  = [PSCredential]::new('fake', (ConvertTo-SecureString -String 'password' -AsPlainText -Force))
            }
        }

        Context 'Get, password is set' {
            It 'Calls Test to determine if the credential is already set' {
                $instance = $class.Get()

                $instance.PasswordIsSet | Should -BeTrue

                Assert-MockCalled Connect-NexusServer -ParameterFilter { $Credential.GetNetworkCredential().Password -eq 'newpassword' } -Times 1 -Scope It
            }
        }

        Context 'Get, password is not' {
            BeforeAll {
                Mock Connect-NexusServer -ParameterFilter { $Credential.GetNetworkCredential().Password -eq 'newpassword' } {
                    throw 'Invalid password'
                }
            }

            It 'Calls Test to determine if the credential is already set' {
                $instance = $class.Get()

                $instance.PasswordIsSet | Should -BeFalse

                Assert-MockCalled Connect-NexusServer -ParameterFilter { $Credential.GetNetworkCredential().Password -eq 'newpassword' } -Times 1 -Scope It
            }
        }

        Context 'Set' {
            It 'Connects using the exising credential and resets the password' {
                $class.Set()

                Assert-MockCalled Connect-NexusServer -ParameterFilter { $Credential.GetNetworkCredential().Password -eq 'password' } -Times 1 -Scope It
                Assert-MockCalled Update-NexusUserPassword -Times 1 -Scope It
            }
        }

        Context 'Test, password is set' {
            It 'When the password is set, returns true' {
                $class.Test() | Should -BeTrue
            }
        }

        Context 'Test, password is not set' {
            BeforeAll {
                Mock Connect-NexusServer -ParameterFilter { $Credential.GetNetworkCredential().Password -eq 'newpassword' } {
                    throw 'Invalid password'
                }
            }

            It 'When the password is not set, returns false' {
                $class.Test() | Should -BeFalse
            }
        }
    }
}