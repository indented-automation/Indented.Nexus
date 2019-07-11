function GetNugetSource {
    <#
    .SYNOPSIS
        Convert the list of nuget sources into a collection of objects.
    .DESCRIPTION
        Convert the list of nuget sources into a collection of objects.
    #>

    [CmdletBinding()]
    param (
        # The name of a source.
        [String]$Name
    )

    $sources = InvokeNuget sources list | Where-Object { $_ -and $_ -notmatch '^Registered' }
    for ($i = 0; $i -lt $sources.Count; $i += 2) {
        $values = $sources[$i].Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)

        if (-not $Name -or $values[1] -like $Name) {
            [PSCustomObject]@{
                Name     = $values[1]
                State    = $values[2].Trim('[]')
                Location = $sources[$i + 1].Trim()
            }
        }
    }
}