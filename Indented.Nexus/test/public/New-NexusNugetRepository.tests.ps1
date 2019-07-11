InModuleScope Indented.Nexus {
    Describe New-NexusNugetRepository {
        BeforeAll {
            Mock Get-NexusServer
            Mock Install-NexusScript -ParameterFilter { $Name -eq 'psNewNugetRepository' }
            Mock Invoke-NexusScript -ParameterFilter { $Name -eq 'psNewNugetRepository' }

            $defaultParams = @{
                Name          = 'repo'
                BlobStoreName = 'blob'
            }
        }

        It 'Installs and invokes a nexus script' {
            New-NexusNugetRepository @defaultParams

            Assert-MockCalled Install-NexusScript -ParameterFilter { $Name -eq 'psNewNugetRepository' }
            Assert-MockCalled Invoke-NexusScript -ParameterFilter { $Name -eq 'psNewNugetRepository' }
        }
    }
}