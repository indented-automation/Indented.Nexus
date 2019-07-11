# Indented.Nexus

[![Build status](https://ci.appveyor.com/api/projects/status/7f3irmwsaww563n2?svg=true)](https://ci.appveyor.com/project/indented-automation/indented-nexus)

Nexus OSS commands and DSC resources.

## Installation

```powershell
Install-Module Indented.Nexus
```

## Commands

* Connect-NexusServer
* Get-NexusBlobStore
* Get-NexusRealm
* Get-NexusRepository
* Get-NexusScript
* Get-NexusServer
* Install-NexusScript
* Invoke-NexusScript
* New-NexusBlobStore
* New-NexusNugetRepository
* New-NexusRubyGemRepository
* Remove-NexusBlobStore
* Remove-NexusRepository
* Remove-NexusScript
* Set-NexusRealm
* Set-NexusRepository
* Sync-NexusNugetRepository
* Update-NexusUserPassword

## DSC resources

All resources support the following properties:

* ComputerName - localhost by default.
* Port - 8081 by default.
* UseSSL - false by default.
* Credential - Mandatory for all resources.

### NexusBlobStore

Creates a folder-based blob store.

* Ensure
* Name - Key - The name of the blob store to create.
* Path

### NexusNugetRepository

Creates a nuget repository.

* Ensure
* Name - Key - The name of the repository.
* BlobStoreName - The name of the blob store the repository should use.
* StrictContentValidation - Whether or not strict content validation should be enabled.
* WritePolicy - The write policy to use. ALLOW, ALLOW_ONCE, or DENY.

The NexusNugetRepository resource also sets values indicating the type and format.

### NexusNugetSource

Registers a nuget and package management source, for use with the synchronisation resource.

* Ensure
* Name
* Location
* Credential
* Trusted

### NexusRealm

Configuration authentication realms.

* Realm - A flags field defining the possible realms. Possible values are DockerToken, LdapRealm, NexusAuthenticatingRealm, NexusAuthorizingRealm, NpmToken, NuGetApiKey, and RutAuthRealm. Multiple values are supplied as a comma separated list.

### NexusRubyGemRepository

Creates a gem repository.

* Ensure
* Name - Key - The name of the repository.
* BlobStoreName - The name of the blob store the repository should use.
* StrictContentValidation - Whether or not strict content validation should be enabled.
* WritePolicy - The write policy to use. ALLOW, ALLOW_ONCE, or DENY.

The NexusRubyGemRepository resource also sets values indicating the type and format.

### NexusSyncNugetRepository

Used to synchronise a set of repositories.

* Source - Key - The name of the source repository.
* Destination - One or more destination repositories.
* Direction - Push, Pull, or Both.

Repositories must be registered with nuget and the PackageManagement module to synchronise.

### NexusUserPassword

Sets a new password for the authenticating user, the user described by the Credential parameter.

* Username
* NewPassword

A PasswordIsSet property indicates whether or not the requested password is set or not.
