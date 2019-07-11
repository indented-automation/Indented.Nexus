[DscResource()]
class NexusBlobStore : NexusBase {
    [DscProperty()]
    [Ensure]$Ensure = 'Present'

    [DscProperty(Key)]
    [String]$Name

    [DscProperty()]
    [String]$Path

    # Gets the resource's current state.
    [NexusBlobStore] Get() {
        $this.Connect()
        $blobStore = Get-NexusBlobStore -Name $this.Name -ErrorAction SilentlyContinue
        if ($blobStore) {
            $this.Ensure = 'Present'
            $this.Path   = $blobStore.Path
        } else {
            $this.Ensure = 'Absent'
        }

        return $this
    }

    # Sets the desired state of the resource.
    [Void] Set() {
        $this.Connect()
        $blobStore = Get-NexusBlobStore -Name $this.Name -ErrorAction SilentlyContinue
        if ($this.Ensure -eq 'Present') {
            if ($blobStore -and $blobStore.Path -ne $this.Path) {
                # This will fail if the blob store is in use.
                $blobStore | Remove-NexusBlobStore
                $blobStore = $null
            }
            if (-not $blobStore) {
                $params = @{
                    Name = $this.Name
                    Path = $this.Path
                }
                New-NexusBlobStore @params
            }
        } elseif ($this.Ensure -eq 'Absent') {
            if ($blobStore) {
                Remove-NexusBlobStore -Name $this.Name
            }
        }
    }

    # Tests if the resource is in the desired state.
    [Boolean] Test() {
        $this.Connect()
        $blobStore = Get-NexusBlobStore -Name $this.Name -ErrorAction SilentlyContinue
        if ($this.Ensure -eq 'Present') {
            if (-not $blobStore) {
                return $false
            }
            if ($blobStore.Path -ne $this.Path) {
                return $false
            }
        } elseif ($this.Ensure -eq 'Absent') {
            if ($blobStore) {
                return $false
            }
        }
        return $true
    }
}