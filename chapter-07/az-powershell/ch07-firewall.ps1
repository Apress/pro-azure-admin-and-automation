# Parameters
$resourceGroupName = "apress-ch07-rg"
$vnetName          = "apress04-ne-vnet"
$location          = "West Europe"
$firewallName      = "apress03-fw"
$publicIpName      = $firewallName + "-pip"

# create Public IP
New-AzPublicIpAddress -Name $publicIpName -ResourceGroupName $resourceGroupName -Location $Location -AllocationMethod Static -Sku Standard

#Create AZFW
New-AzFirewall -Name $firewallName -ResourceGroupName $resourceGroupName -Location $Location -VirtualNetworkName $vnetName -PublicIpName $publicIpName -Zone 1,2,3
