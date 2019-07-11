InModuleScope Indented.Nexus {
    Describe Sync-NexusNugetRepository {
        BeforeAll {
            function NewMockPackage {
                Add-Type -AssemblyName System.Xml.Linq
                $packageData = [System.Xml.Linq.XDocument](@(
                        '<?xml version="1.0" encoding="utf-16" standalone="yes"?>'
                        '<SoftwareIdentity'
                        '  name="packagename"'
                        '  version="1.0.0"'
                        '  versionScheme="semver" xmlns="http://standards.iso.org/iso/19770/-2/2015/schema.xsd">'
                        '  <Meta'
                        '    summary="summary"'
                        '    description="description"'
                        '    published="01/01/2019 00:00:00 +00:00"'
                        '    title="packagetitle"'
                        '    developmentDependency="False" />'
                        '  <Entity'
                        '    name="Author"'
                        '    regId="Author"'
                        '    role="author" />'
                        '</SoftwareIdentity>'
                    ) | Out-String)
                $package = [Microsoft.PackageManagement.Packaging.SoftwareIdentity]::new($packageData)
                $null = [Microsoft.PackageManagement.Packaging.SoftwareIdentity].GetProperty('Source').GetSetMethod($true).Invoke(
                    $package,
                    'http://server/repository/nuget/'
                )
                $package
            }

            Mock Find-Package {
                NewMockPackage
            }
            Mock New-Item
            Mock Remove-Item
            Mock Save-Package {
                NewMockPackage
            }
            Mock InvokeNuget

            $defaultParams = @{
                Source      = 'source'
                Destination = 'destination'
            }
        }

        Context 'Pull, package exists on both' {
            It 'When the package exists on both servers, does nothing' {
                Sync-NexusNugetRepository @defaultParams -Direction Pull

                Assert-MockCalled Find-Package -Times 2 -Scope It
                Assert-MockCalled Save-Package -Times 0 -Scope It
                Assert-MockCalled InvokeNuget -Times 0 -Scope It
            }
        }

        Context 'Pull, package does not exist on source' {
            BeforeAll {
                Mock Find-Package -ParameterFilter { $Source -eq 'source' }
                Mock Find-Package -ParameterFilter { $Source -eq 'destination' } {
                    NewMockPackage
                }
            }

            It 'When the package does not exist on the source, saves and uploads the package' {
                Sync-NexusNugetRepository @defaultParams -Direction Pull

                Assert-MockCalled Find-Package -Times 1 -Scope It -ParameterFilter { $Source -eq 'destination' }
                Assert-MockCalled Find-Package -Times 1 -Scope It -ParameterFilter { $Source -eq 'source' }
                Assert-MockCalled Save-Package -Times 1 -Scope It
                Assert-MockCalled InvokeNuget -Times 1 -Scope It
            }
        }

        Context 'Push, package exists on both' {
            It 'When the package exists on both servers, does nothing' {
                Sync-NexusNugetRepository @defaultParams -Direction Push

                Assert-MockCalled Find-Package -Times 2 -Scope It
                Assert-MockCalled Save-Package -Times 0 -Scope It
                Assert-MockCalled InvokeNuget -Times 0 -Scope It
            }
        }

        Context 'Push, package does not exist on destination' {
            BeforeAll {
                Mock Find-Package -ParameterFilter { $Source -eq 'destination' }
            }

            It 'When the package does not exist on the destination, saves and uploads the package' {
                Sync-NexusNugetRepository @defaultParams -Direction Push

                Assert-MockCalled Find-Package -Times 1 -Scope It
                Assert-MockCalled Find-Package -Times 1 -Scope It -ParameterFilter { $Source -eq 'destination' }
                Assert-MockCalled Save-Package -Times 1 -Scope It
                Assert-MockCalled InvokeNuget -Times 1 -Scope It
            }
        }
    }
}