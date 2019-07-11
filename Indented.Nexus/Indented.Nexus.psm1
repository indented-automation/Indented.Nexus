$enumeration = @(
    'Ensure'
    'Realm'
    'WritePolicy'
)

foreach ($file in $enumeration) {
    . ("{0}\enum\{1}.ps1" -f $psscriptroot, $file)
}

$class = @(
    '1.NexusBase'
    '2.NexusRepository'
    'NexusBlobStore'
    'NexusNugetRepository'
    'NexusNugetSource'
    'NexusRealm'
    'NexusRubyGemRepository'
    'NexusSyncNugetRepository'
    'NexusUserPassword'
)

foreach ($file in $class) {
    . ("{0}\class\{1}.ps1" -f $psscriptroot, $file)
}

$private = @(
    'GetNugetSource'
    'InvokeNexusRestMethod'
    'InvokeNuget'
)

foreach ($file in $private) {
    . ("{0}\private\{1}.ps1" -f $psscriptroot, $file)
}

$public = @(
    'Connect-NexusServer'
    'Get-NexusBlobStore'
    'Get-NexusRealm'
    'Get-NexusRepository'
    'Get-NexusScript'
    'Get-NexusServer'
    'Install-NexusScript'
    'Invoke-NexusScript'
    'New-NexusBlobStore'
    'New-NexusNugetRepository'
    'New-NexusRubyGemRepository'
    'Remove-NexusBlobStore'
    'Remove-NexusRepository'
    'Remove-NexusScript'
    'Set-NexusRealm'
    'Set-NexusRepository'
    'Sync-NexusNugetRepository'
    'Update-NexusUserPassword'
)

foreach ($file in $public) {
    . ("{0}\public\{1}.ps1" -f $psscriptroot, $file)
}

$functionsToExport = @(
    'Connect-NexusServer'
    'Get-NexusBlobStore'
    'Get-NexusRealm'
    'Get-NexusRepository'
    'Get-NexusScript'
    'Get-NexusServer'
    'Install-NexusScript'
    'Invoke-NexusScript'
    'New-NexusBlobStore'
    'New-NexusNugetRepository'
    'New-NexusRubyGemRepository'
    'Remove-NexusBlobStore'
    'Remove-NexusRepository'
    'Remove-NexusScript'
    'Set-NexusRealm'
    'Set-NexusRepository'
    'Sync-NexusNugetRepository'
    'Update-NexusUserPassword'
)
Export-ModuleMember -Function $functionsToExport


