InModuleScope Indented.Nexus {
    Describe New-NexusBlobStore {
        BeforeAll {
            Mock Get-NexusServer
            Mock Install-NexusScript -ParameterFilter { $Name -eq 'psNewBlobStore' }
            Mock Invoke-NexusScript -ParameterFilter { $Name -eq 'psNewBlobStore' }

            $defaultParams = @{
                Name = 'Name'
                Path = 'C:\Folder'
            }
        }

        It 'Installs and invokes a nexus script' {
            New-NexusBlobStore @defaultParams

            Assert-MockCalled Install-NexusScript -ParameterFilter { $Name -eq 'psNewBlobStore' }
            Assert-MockCalled Invoke-NexusScript -ParameterFilter { $Name -eq 'psNewBlobStore' }
        }
    }
}