[DscResource()]
class NexusUserPassword : NexusBase {
    [DscProperty(Key)]
    [String]$Username

    [DscProperty(Mandatory)]
    [PSCredential]$NewPassword

    [DscProperty(NotConfigurable)]
    [Boolean]$PasswordIsSet

    [NexusUserPassword] Get() {
        $this.PasswordIsSet = $this.Test()

        return $this
    }

    [Void] Set() {
        try {
            $params = @{
                ComputerName = $this.ComputerName
                Port         = $this.Port
                UseSSL       = $this.UseSSL
                Credential   = $this.Credential
                ErrorAction  = 'Stop'
            }
            Connect-NexusServer @params
        } catch {
            throw 'Unable to connect using the existing password'
        }

        $params = @{
            Username    = $this.Username
            NewPassword = $this.NewPassword.Password
        }
        Update-NexusUserPassword @params
    }

    [Boolean] Test() {
        try {
            $credential = [PSCredential]::new(
                $this.Username,
                $this.NewPassword.Password
            )

            $params = @{
                ComputerName = $this.ComputerName
                Port         = $this.Port
                UseSSL       = $this.UseSSL
                Credential   = $credential
                ErrorAction  = 'Stop'
            }
            Connect-NexusServer @params

            return $true
        } catch {
            return $false
        }
    }
}