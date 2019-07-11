[DscResource()]
class NexusRepository : NexusBase {
    [DscProperty()]
    [Ensure]$Ensure = 'Present'

    [DscProperty(Key)]
    [String]$Name

    [DscProperty()]
    [String]$BlobStoreName

    [DscProperty()]
    [Boolean]$StrictContentValidation

    [DscProperty()]
    [WritePolicy]$WritePolicy = 'ALLOW_ONCE'

    [DscProperty(NotConfigurable)]
    [String]$Type

    [DscProperty(NotConfigurable)]
    [String]$Format

    [NexusRepository] Get() {
        $this.Connect()
        $repository = Get-NexusRepository -Name $this.Name -ErrorAction SilentlyContinue
        if ($repository) {
            $this.Ensure = 'Present'
            $this.Type = $repository.Type
            $this.Format = $repository.Format
            $this.BlobStoreName = $repository.BlobStoreName
            $this.StrictContentValidation = $repository.StrictContentValidation
            $this.WritePolicy = $repository.WritePolicy
        } else {
            $this.Ensure = 'Absent'
        }

        return $this
    }

    [Void] Set() {
        $this.Connect()
        $repository = Get-NexusRepository -Name $this.Name -ErrorAction SilentlyContinue
        if ($this.Ensure -eq 'Present') {
            if (-not $this.Format) {
                throw 'The NexusRepository resource can only be used to remove redundant repositories.'
            }
            if (-not $this.BlobStoreName) {
                throw 'A blob store name must be specified when creating a repository.'
            }

            $params = @{
                Name                    = $this.Name
                BlobStoreName           = $this.BlobStoreName
                StrictContentValidation = $this.StrictContentValidation
                WritePolicy             = $this.WritePolicy
            }

            if ($repository) {
                $shouldRemove = $false
                if ($repository.Type -ne 'hosted') {
                    $shouldRemove = $true
                }
                if ($repository.Format -ne $this.Format) {
                    $shouldRemove = $true
                }
                if ($shouldRemove) {
                    Remove-NexusRepository -Name $repository.Name
                    $repository = $null
                }
            }

            if ($repository) {
                Set-NexusRepository @params
            } else {
                & ('New-Nexus{0}Repository' -f $this.Format) @params
            }
        } elseif ($this.Ensure -eq 'Absent') {
            if ($repository) {
                Remove-NexusRepository -Name $this.Name
            }
        }
    }

    [Boolean] Test() {
        $this.Connect()
        $repository = Get-NexusRepository -Name $this.Name -ErrorAction SilentlyContinue
        if ($this.Ensure -eq 'Present') {
            if (-not $repository) {
                return $false
            }
            if ($repository.Type -ne 'hosted') {
                return $false
            }
            if ($repository.Format -ne $this.Format) {
                return $false
            }
            if ($repository.BlobStoreName -ne $this.BlobStoreName) {
                return $false
            }
            if ($repository.StrictContentValidation -ne $this.StrictContentValidation) {
                return $false
            }
            if ($repository.WritePolicy -ne $this.WritePolicy) {
                return $false
            }
        } elseif ($this.Ensure -eq 'Absent') {
            if ($repository) {
                return $false
            }
        }

        return $true
    }
}