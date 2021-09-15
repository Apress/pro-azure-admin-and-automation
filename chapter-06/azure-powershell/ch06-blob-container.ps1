# Setting the variables
$resourceGroup      = 'apress-ch06-rg'
$storageAccountName = 'apressch06standard'
$blobContainerName  = 'mycontainer'

# Getting a storage account
$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName

# Creating a blob container
New-AzStorageContainer -Name $blobContainerName -Context $storageAccount.Context