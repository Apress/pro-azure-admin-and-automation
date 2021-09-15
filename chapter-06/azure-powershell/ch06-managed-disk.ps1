# Setting the variables
$resourceGroup = 'apress-ch06-rg'
$location      = 'northeurope'
$diskName      = 'apress-P10-premium'
$diskSku       = 'Premium_LRS'
$diskSize      = 128
$tags          = @{'deployment-method' = 'azure-powershell' }

# Creating resource group
New-AzResourceGroup -Name $resourceGroup -Location $location -Tag $tags

# Creating a managed disk
$azDiskConfig = New-AzDiskConfig -Location $location -DiskSizeGB $diskSize -CreateOption "Empty" -SkuName $diskSku -Tag $tags
New-AzDisk -ResourceGroupName $resourceGroup -DiskName $diskName -Disk $azDiskConfig