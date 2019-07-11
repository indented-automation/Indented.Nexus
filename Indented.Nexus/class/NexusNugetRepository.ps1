[DscResource()]
class NexusNugetRepository : NexusRepository {
    NexusNugetRepository() {
        $this.Format = 'Nuget'
    }
}