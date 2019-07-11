[DscResource()]
class NexusRubyGemRepository : NexusRepository {
    NexusRubyGemRepository() {
        $this.Format = 'RubyGem'
    }
}