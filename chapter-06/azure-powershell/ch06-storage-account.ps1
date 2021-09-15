# Setting the variables
$resourceGroup      = 'apress-ch06-rg'
$location           = 'northeurope'
$storageAccountName = 'apressch06standard'
$storageAccountType = 'StorageV2'
$storageAccountSku  = 'Standard_LRS'
$tags               = @{'deployment-method' = 'azure-powershell' }

# Creating resource group
New-AzResourceGroup -Name $resourceGroup -Location $location -Tag $tags

# Creating a storage account
New-AzStorageAccount -ResourceGroupName $resourceGroup -Location $location -Name $storageAccountName -SkuName $storageAccountSku -Kind $storageAccountType -Tag $tags