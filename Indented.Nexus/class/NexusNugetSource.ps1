[DscResource()]
class NexusNugetSource {
    [DscProperty()]
    [Ensure]$Ensure = 'Present'

    [DscProperty(Key)]
    [String]$Name

    [DscProperty()]
    [String]$Location

    [DscProperty()]
    [PSCredential]$Credential

    [DscProperty()]
    [Boolean]$Trusted = $true

    [NexusNugetSource] Get() {
        $source = Get-PackageSource -Name $this.Name -ErrorAction SilentlyContinue
        if ($source) {
            $this.Ensure = 'Present'
            $this.Location = $source.Location
            $this.Trusted = $source.IsTrusted
        } else {
            $this.Ensure = 'Absent'
        }

        return $this
    }

    [Void] Set() {
        $source = Get-PackageSource -Name $this.Name -ErrorAction SilentlyContinue
        if ($this.Ensure -eq 'Present') {
            $params = @{
                Name    = $this.Name
                Trusted = $this.Trusted
            }
            if ($source) {
                if ($source.Location -ne $this.Location) {
                    $params.NewLocation = $this.Location
                }
                Set-PackageSource @params
            } else {
                Register-PackageSource @params -Location $this.Location -ProviderName Nuget
            }
        } elseif ($this.Ensure -eq 'Absent') {
            if ($source) {
                Unregister-PackageSource -Name $this.Name
            }
        }

        $nugetSource = GetNugetSource -Name $this.Name
        if ($this.Ensure -eq 'Present') {
            if ($nugetSource) {
                InvokeNuget sources remove -Name $this.Name
            }
            $argumentList = @(
                'sources'
                'add'
                '-name', $this.Name
                '-source', $this.Location
            )
            if ($this.Credential) {
                $argumentList += @(
                    '-username', $this.Credential.Username
                    '-password', $this.Credential.GetNetworkCredential().Password
                )
            }
            InvokeNuget @argumentList
        } elseif ($this.Ensure -eq 'Absent') {
            if ($nugetSource) {
                InvokeNuget sources remove -Name $this.Name
            }
        }
    }

    [Boolean] Test() {
        $source = Get-PackageSource -Name $this.Name -ErrorAction SilentlyContinue
        if ($this.Ensure -eq 'Present') {
            if (-not $source) {
                return $false
            }
            if ($source.Location -ne $this.Location) {
                return $false
            }
            if ($source.IsTrusted -ne $this.Trusted) {
                return $false
            }
        } elseif ($this.Ensure -eq 'Absent') {
            if ($source) {
                return $false
            }
        }

        $nugetSource = GetNugetSource -Name $this.Name
        if ($this.Ensure -eq 'Present') {
            if (-not $nugetSource) {
                return $false
            }
            if ($nugetSource.Location -ne $this.Location) {
                return $false
            }
        } elseif ($this.Ensure -eq 'Absent') {
            if ($nugetSource) {
                return $false
            }
        }

        return $true
    }
}