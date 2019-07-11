InModuleScope Indented.Nexus {
    Describe New-NexusRubyGemRepository {
        BeforeAll {
            Mock Get-NexusServer
            Mock Install-NexusScript -ParameterFilter { $Name -eq 'psNewRubyGemRepository' }
            Mock Invoke-NexusScript -ParameterFilter { $Name -eq 'psNewRubyGemRepository' }

            $defaultParams = @{
                Name          = 'repo'
                BlobStoreName = 'blob'
            }
        }

        It 'Installs and invokes a nexus script' {
            New-NexusRubyGemRepository @defaultParams

            Assert-MockCalled Install-NexusScript -ParameterFilter { $Name -eq 'psNewRubyGemRepository' }
            Assert-MockCalled Invoke-NexusScript -ParameterFilter { $Name -eq 'psNewRubyGemRepository' }
        }
    }
}