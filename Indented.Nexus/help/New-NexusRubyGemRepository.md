---
external help file: Indented.Nexus-help.xml
Module Name: Indented.Nexus
online version:
schema: 2.0.0
---

# New-NexusRubyGemRepository

## SYNOPSIS
Create a new hosted Ruby Gem repository.

## SYNTAX

```
New-NexusRubyGemRepository [-Name] <String> -BlobStoreName <String> [-StrictContentValidation <Boolean>]
 [-WritePolicy <WritePolicy>] [-Connection <PSObject>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Create a new hosted Ruby Gem repository.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Name
The name of the blob store to create.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -BlobStoreName
The name of the blob store which should be used by this repository.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -StrictContentValidation
Whether or not strict content validation should be enabled.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -WritePolicy
The write policy for the repository.

```yaml
Type: WritePolicy
Parameter Sets: (All)
Aliases:
Accepted values: ALLOW, ALLOW_ONCE, DENY

Required: False
Position: Named
Default value: ALLOW_ONCE
Accept pipeline input: False
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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS
