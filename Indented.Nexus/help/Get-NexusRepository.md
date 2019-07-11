---
external help file: Indented.Nexus-help.xml
Module Name: Indented.Nexus
online version:
schema: 2.0.0
---

# Get-NexusRepository

## SYNOPSIS
Get the repositories on a Nexus server.

## SYNTAX

```
Get-NexusRepository [[-Name] <String>] [-Connection <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Get the repositories on a Nexus server.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Name
The name of a repository.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Connection
The Nexus server used to perform this action.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-NexusServer)
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Indented.Nexus.Repository
## NOTES

## RELATED LINKS
