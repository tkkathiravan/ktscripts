(Get-AzPolicyAlias -NamespaceMatch 'Microsoft.compute').Aliases |where {$_.Name -like "*osDisk*"}

(Get-AzPolicyAlias -NamespaceMatch 'Microsoft.compute').Aliases

get-help New-AzVM -Full

(Get-AzPolicyAlias -NamespaceMatch 'Microsoft.Resources/subscriptions').Aliases