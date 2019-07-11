[DscResource()]
class NexusRealm : NexusBase {
    [DscProperty(Key)]
    [String]$Realm

    Hidden [Realm[]]$realmList

    Hidden [Void] ConvertToRealmList() {
        $this.realmList = $this.Realm -split ', *'
    }

    [NexusRealm] Get() {
        $this.Connect()
        $this.Realm = (Get-NexusRealm) -join ', '

        return $this
    }

    [Void] Set() {
        try {
            $this.ConvertToRealmList()
            $this.Connect()
            Set-NexusRealm -Realm $this.realmList
        } catch {
            throw
        }
    }

    [Boolean] Test() {
        try {
            $this.ConvertToRealmList()
            $this.Connect()
            $currentRealm = Get-NexusRealm

            if (Compare-Object $currentRealm $this.realmList -SyncWindow 0) {
                return $false
            }
            return $true
        } catch {
            throw
        }
    }
}