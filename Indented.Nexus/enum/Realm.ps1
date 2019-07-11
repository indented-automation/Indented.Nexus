[Flags()]
enum Realm {
    DockerToken              = 1
    LdapRealm                = 2
    NexusAuthenticatingRealm = 4
    NexusAuthorizingRealm    = 8
    NpmToken                 = 16
    NuGetApiKey              = 32
    RutAuthRealm             = 64
}