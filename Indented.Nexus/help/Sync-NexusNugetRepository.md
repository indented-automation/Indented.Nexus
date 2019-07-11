---
external help file: Indented.Nexus-help.xml
Module Name: Indented.Nexus
online version:
schema: 2.0.0
---

# Sync-NexusNugetRepository

## SYNOPSIS
Synchronise content between nuget repositories.

## SYNTAX

```
Sync-NexusNugetRepository [-Source] <String> [-Destination] <String[]> [[-Direction] <String>]
 [[-WorkingDirectory] <String>] [<CommonParameters>]
```

## DESCRIPTION
Synchronise content between nuget repositories.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Source
The name of the source respository.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Destination
The name of the destination repositories.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Direction
The syncrhonisation direction.
By default, content is mirrored.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Both
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkingDirectory
A working directory used to hold packages as they are copied.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: (Join-Path $env:TEMP (New-Guid))
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
