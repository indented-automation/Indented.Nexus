class NexusBase {
    [DscProperty()]
    [String]$ComputerName = 'localhost'

    [DscProperty()]
    [ValidateRange(1, 65535)]
    [Int32]$Port = 8081

    [DscProperty()]
    [Boolean]$UseSSL = $false

    [DscProperty(Mandatory)]
    [PSCredential]$Credential

    [Void] Connect() {
        $params = @{
            ComputerName = $this.ComputerName
            Port         = $this.Port
            UseSSL       = $this.UseSSL
            Credential   = $this.Credential
        }
        Connect-NexusServer @params
    }
}