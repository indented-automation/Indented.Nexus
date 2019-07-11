InModuleScope Indented.Nexus {
    Describe InvokeNexusRestMethod {
        BeforeAll {
            Mock Get-NexusServer {
                [PSCustomObject]@{
                    BaseUri    = 'http://localhost:8081'
                    Credential = [PSCredential]::new('fake', (ConvertTo-SecureString -String 'password' -AsPlainText -Force))
                    PSTypeName = 'Indented.Nexus.Server'
                }
            }
            Mock Invoke-RestMethod -ParameterFilter { $Body -like '{*' }
            Mock Invoke-RestMethod -ParameterFilter { $Body -eq 'value' }
            Mock Invoke-RestMethod -ParameterFilter { -not $Body }

            $defaultParams = @{
                RestMethod = 'MethodName'
            }
        }

        It 'When body is defined, and the content type is json, serializes and passes the body to Invoke-RestMethod' {
            InvokeNexusRestMethod @defaultParams -Body @{ name = 'value' }

            Assert-MockCalled Invoke-RestMethod -ParameterFilter { $Body -like '{*' }
        }

        It 'When body is defined, and the content type is text, passes the body to Invoke-RestMethod as-is' {
            InvokeNexusRestMethod @defaultParams -Body 'value' -ContentType 'text/plain'

            Assert-MockCalled Invoke-RestMethod -ParameterFilter { $Body -eq 'value' }
        }

        It 'When a body is not defined, calls Invoke-RestMethod without the Body parameter' {
            InvokeNexusRestMethod @defaultParams

            Assert-MockCalled Invoke-RestMethod -ParameterFilter { -not $Body }
        }
    }
}