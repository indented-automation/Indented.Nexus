InModuleScope Indented.Nexus {
    Describe Get-NexusServer {
        It 'When Connect-NexusServer has been called, returns the connection information' {
            $Script:nexusServer = [PSCustomObject]@{
                BaseUri    = 'http://localhost:8081'
                Credential = [PSCredential]::new('fake', (ConvertTo-SecureString -String 'password' -AsPlainText -Force))
            }

            $connection = Get-NexusServer
            $connection.BaseUri | Should -Be 'http://localhost:8081'
            $connection.Credential.Username | Should -Be 'fake'
        }

        It 'When a Connect-NexusServer has not been called, or the connection failed, returns an error' {
            $Script:nexusServer = $null

            { Get-NexusServer } | Should -Throw -ErrorId NexusEndPointNotDefined
        }
    }
}