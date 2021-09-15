# Parameters
$resourceGroupName = "apress-ch10-rg"

# Get user object ID
$objectId = (Get-AzADUser -DisplayName "Miloš Katinski").Id

# List all available roles in the Subscription mentioning 'Storage'
$filteredRoles = Get-AzRoleDefinition | Where-Object { $_.Name -match 'Storage' }

$roleName = $filteredRoles[(Get-Random -Minimum 0 -Maximum ($filteredRoles.count - 1))]

# Assign a role to a user
New-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $roleName.Name -ResourceGroupName $resourceGroupName
