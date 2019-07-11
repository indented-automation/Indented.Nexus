function Install-NexusScript {
    <#
    .SYNOPSIS
        Install a script on the Nexus server.
    .DESCRIPTION
        Scripts must be added to the Nexus server before they can be used.

        If the script exists, and the content does not match, the existing script is replaced.
    #>

    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Indented.Nexus.Script')]
    param (
        # The name of a script.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
        [String]$Name,

        # The script content.
        [Parameter(Mandatory, Position = 2, ValueFromPipelineByPropertyName)]
        [AllowEmptyString()]
        [String[]]$Content,

        # The Nexus server used to perform this action.
        [PSTypeName('Indented.Nexus.Server')]
        [PSObject]$Connection = (Get-NexusServer)
    )

    process {
        $Content = $Content -join "`n"

        $params = @{
            Name       = $Name
            Connection = $Connection
        }
        $script = Get-NexusScript @params -ErrorAction SilentlyContinue
        if ($script -and $script.content -cne $Content) {
            Remove-NexusScript @params
            $script = $null
        }
        if (-not $script) {
            $params = @{
                RestMethod = 'script'
                Method     = 'POST'
                Body       = @{
                    name    = $Name
                    type    = 'groovy'
                    content = [String]$Content
                }
                Connection = $Connection
            }
            if ($pscmdlet.ShouldProcess(('Installing new script named {0}' -f $Name))) {
                $null = InvokeNexusRestMethod @params
            }
        }
    }
}