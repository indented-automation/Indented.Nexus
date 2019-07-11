InModuleScope Indented.Nexus {
    Describe Remove-NexusRepository {
        BeforeAll {
            Mock Get-NexusServer
            Mock Install-NexusScript -ParameterFilter { $Name -eq 'psRemoveRepository' }
            Mock Invoke-NexusScript -ParameterFilter { $Name -eq 'psRemoveRepository' }

            $defaultParams = @{
                Name = 'Name'
            }
        }

        It 'Installs and invokes a nexus script' {
            Remove-NexusRepository @defaultParams

            Assert-MockCalled Install-NexusScript -ParameterFilter { $Name -eq 'psRemoveRepository' }
            Assert-MockCalled Invoke-NexusScript -ParameterFilter { $Name -eq 'psRemoveRepository' }
        }
    }
}