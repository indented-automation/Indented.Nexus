InModuleScope Indented.Nexus {
    Describe Get-NexusBlobStore {
        BeforeAll {
            Mock Get-NexusServer
            Mock Install-NexusScript -ParameterFilter { $Name -eq 'psGetBlobStore' }
            Mock Invoke-NexusScript -ParameterFilter { $Name -eq 'psGetBlobStore' }
        }

        It 'Installs and invokes a nexus script' {
            Get-NexusBlobStore

            Assert-MockCalled Install-NexusScript -ParameterFilter { $Name -eq 'psGetBlobStore' }
            Assert-MockCalled Invoke-NexusScript -ParameterFilter { $Name -eq 'psGetBlobStore' }
        }
    }
}