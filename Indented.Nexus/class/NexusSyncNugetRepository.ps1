[DscResource()]
class NexusSyncNugetRepository {
    [DscProperty(Key)]
    [String]$Source

    [DscProperty(Mandatory)]
    [String[]]$Destination

    [DscProperty()]
    [ValidateSet('Pull', 'Push', 'Both')]
    [String]$Direction = 'Both'

    [NexusSyncNugetRepository] Get() {
        return $this
    }

    [Void] Set() {
        $params = @{
            Source      = $this.Source
            Destination = $this.Destination
            Direction   = $this.Direction
        }
        Sync-NexusNugetRepository @params
    }

    [Boolean]Test() {
        return $false
    }
}