InModuleScope Indented.Nexus {
    Describe Set-NexusRepository {
        BeforeAll {
            Mock Get-NexusServer
            Mock Install-NexusScript -ParameterFilter { $Name -eq 'psSetRepository' }
            Mock Invoke-NexusScript -ParameterFilter { $Name -eq 'psSetRepository' }

            $defaultParams = @{
                Name          = 'Name'
                BlobStoreName = 'NewBlob'
            }
        }

        It 'Installs and invokes a nexus script' {
            Set-NexusRepository @defaultParams

            Assert-MockCalled Install-NexusScript -ParameterFilter { $Name -eq 'psSetRepository' }
            Assert-MockCalled Invoke-NexusScript -ParameterFilter { $Name -eq 'psSetRepository' }
        }
    }
}