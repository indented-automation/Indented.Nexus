InModuleScope Indented.Nexus {
    Describe Update-NexusUserPassword {
        BeforeAll {
            Mock Get-NexusServer
            Mock Install-NexusScript -ParameterFilter { $Name -eq 'psUpdateUserPassword' }
            Mock Invoke-NexusScript -ParameterFilter { $Name -eq 'psUpdateUserPassword' }

            $defaultParams = @{
                UserName    = 'user'
                NewPassword = ConvertTo-SecureString -String NewPassword -AsPlainText -Force
            }
        }

        It 'Installs and invokes a nexus script' {
            Update-NexusUserPassword @defaultParams

            Assert-MockCalled Install-NexusScript -ParameterFilter { $Name -eq 'psUpdateUserPassword' }
            Assert-MockCalled Invoke-NexusScript -ParameterFilter { $Name -eq 'psUpdateUserPassword' }
        }
    }
}