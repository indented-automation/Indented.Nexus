InModuleScope Indented.Nexus {
    Describe Remove-NexusBlobStore {
        BeforeAll {
            Mock Get-NexusServer
            Mock Install-NexusScript -ParameterFilter { $Name -eq 'psRemoveBlobStore' }
            Mock Invoke-NexusScript -ParameterFilter { $Name -eq 'psRemoveBlobStore' }

            $defaultParams = @{
                Name = 'Name'
            }
        }

        It 'Installs and invokes a nexus script' {
            Remove-NexusBlobStore @defaultParams

            Assert-MockCalled Install-NexusScript -ParameterFilter { $Name -eq 'psRemoveBlobStore' }
            Assert-MockCalled Invoke-NexusScript -ParameterFilter { $Name -eq 'psRemoveBlobStore' }
        }
    }
}