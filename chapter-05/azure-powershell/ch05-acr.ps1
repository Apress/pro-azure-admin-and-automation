# Parameters
$resourceGroupName     = "apress-ch05-rg"
$containerRegistryname = "apress"
$sku                   = "Standard"

# Create ACR with Standard SKU
$registry = New-AzContainerRegistry -ResourceGroupName $resourceGroupName -Name $containerRegistryname -Sku $sku