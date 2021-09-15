# Parameters
$resourceGroupName = "apress-ch07-rg"
$vnetName          = "apress04-ne-vnet"
$location          = "West Europe"
$bastionName       = "apress-bastion"
$publicIpName      = "$bastionName-pip"

# Putting the VNet object inside the variable
$vnet = Get-AzVirtualNetwork -Name $vnetName

# Create Public IP for Bastion
$publicip = New-AzPublicIpAddress -ResourceGroupName $resourceGroupName -name $publicIpName -location $location -AllocationMethod Static -Sku Standard

# Creating Bastion
New-AzBastion -ResourceGroupName $resourceGroupName -Name $bastionName -PublicIpAddress $publicip -VirtualNetwork $vnet
