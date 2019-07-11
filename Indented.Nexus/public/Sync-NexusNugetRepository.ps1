function Sync-NexusNugetRepository {
    <#
    .SYNOPSIS
        Synchronise content between nuget repositories.
    .DESCRIPTION
        Synchronise content between nuget repositories.
    #>

    [CmdletBinding()]
    param (
        # The name of the source respository.
        [Parameter(Mandatory)]
        [String]$Source,

        # The name of the destination repositories.
        [Parameter(Mandatory)]
        [String[]]$Destination,

        # The syncrhonisation direction. By default, content is mirrored.
        [ValidateSet('Pull', 'Push', 'Both')]
        [String]$Direction = 'Both',

        # A working directory used to hold packages as they are copied.
        [String]$WorkingDirectory = (Join-Path $env:TEMP (New-Guid))
    )

    try {
        if (-not (Test-Path $WorkingDirectory)) {
            $null = New-Item $WorkingDirectory -ItemType Directory -Force
        }

        if ($Direction -in 'Pull', 'Both') {
            foreach ($name in $Destination) {
                Find-Package -Source $name -AllVersions -Verbose:$false | ForEach-Object {
                    Write-Verbose ('PULL: Checking {0}, version {1} on {2}' -f $_.Name, $_.Version, $Source)

                    $params = @{
                        Name            = $_.Name
                        Source          = $Source
                        RequiredVersion = $_.Version
                        ErrorAction     = 'SilentlyContinue'
                        Verbose         = $false
                    }
                    if (-not (Find-Package @params)) {
                        $package = $_ | Save-Package -Path $WorkingDirectory
                        $path = Join-Path $WorkingDirectory $package.PackageFilename

                        Write-Verbose ('PULL: Uploading {0} to {1}' -f $path, $Source)

                        InvokeNuget push $path -Source $Source

                        Remove-Item $path
                    }
                }
            }
        }

        if ($Direction -in 'Push', 'Both') {
            Find-Package -Source $Source -AllVersions -Verbose:$false | ForEach-Object {
                $pushTo = foreach ($name in $Destination) {
                    Write-Verbose ('PUSH: Checking {0}, version {1} on {2}' -f $_.Name, $_.Version, $name)

                    $params = @{
                        Name            = $_.Name
                        Source          = $name
                        RequiredVersion = $_.Version
                        ErrorAction     = 'SilentlyContinue'
                        Verbose         = $false
                    }
                    if (-not (Find-Package @params)) {
                        $name
                    }
                }
                if ($pushTo) {
                    $package = $_ | Save-Package -Path $WorkingDirectory -Verbose:$false
                    $path = Join-Path $WorkingDirectory $package.PackageFilename

                    foreach ($name in $pushTo) {
                        Write-Verbose ('PUSH: Uploading {0} to {1}' -f $path, $name)

                        InvokeNuget push $path -Source $name
                    }

                    Remove-Item $path
                }
            }
        }
    } catch {
        $pscmdlet.ThrowTerminatingError($_)
    } finally {
        Remove-Item $WorkingDirectory -Recurse -Confirm:$false -ErrorAction SilentlyContinue
    }
}