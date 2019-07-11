function InvokeNuget {
    <#
    .SYNOPSIS
        Invokes the nuget command.
    .DESCRIPTION
        Invokes the nuget command.
    #>

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSAvoidUsingCmdletAliases', '')]
    [CmdletBinding()]
    param (
        [Parameter(ValueFromRemainingArguments)]
        [String[]]$ArgumentList
    )

    $ArgumentList = $ArgumentList | ForEach-Object { $_ }

    & 'nuget' @ArgumentList
}