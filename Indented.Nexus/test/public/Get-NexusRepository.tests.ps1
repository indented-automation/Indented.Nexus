InModuleScope Indented.Nexus {
    Describe Get-NexusRepository {
        BeforeAll {
            Mock Get-NexusServer
            Mock Install-NexusScript -ParameterFilter { $Name -eq 'psGetRepository' }
            Mock Invoke-NexusScript -ParameterFilter { $Name -eq 'psGetRepository' }
        }

        It 'Installs and invokes a nexus script' {
            Get-NexusRepository

            Assert-MockCalled Install-NexusScript -ParameterFilter { $Name -eq 'psGetRepository' }
            Assert-MockCalled Invoke-NexusScript -ParameterFilter { $Name -eq 'psGetRepository' }
        }
    }
}