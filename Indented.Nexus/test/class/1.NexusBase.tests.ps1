InModuleScope Indented.Nexus {
    Describe NexusBase {
        BeforeAll {
            Mock Connect-NexusServer
        }

        It 'When Connect is called, invokes Connect-NexusServer' {
            $class = [NexusBase]@{
                Credential = [PSCredential]::new('fake', (ConvertTo-SecureString -String 'password' -AsPlainText -Force))
            }

            $class.Connect()

            Assert-MockCalled Connect-NexusServer
        }
    }
}