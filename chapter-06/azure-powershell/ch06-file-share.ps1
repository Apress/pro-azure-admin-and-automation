# Setting the variables
$resourceGroup      = 'apress-ch06-rg'
$storageAccountName = 'apressch06standard'
$fileShareName      = 'myfileshare'

# Getting a storage account
$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName

# Creating a blob container
New-AzStorageShare -Name $fileShareName -Context $storageAccount.Context