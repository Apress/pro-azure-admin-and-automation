# Parameters
$routeTableName = "apress02-vm-udr"
$location = "West Europe"
$resourceGroupName = "apress-ch09-rg"

# Create UDR
$routeTable = New-AzRouteTable -ResourceGroupName $resourceGroupName -Location $location -Name $routeTableName

# Associate UDR with Subnet
$vnetName = "apress02-we-vnet"
$subnetName = "vm-subnet"
$routeTableId = $routeTable.Id

$vNet = Get-AzVirtualNetwork -Name $vnetName
$vmSubnet = Get-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vNet
$addressPrefix = $vmSubnet.AddressPrefix

Set-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vNet -RouteTableId $routeTableId -AddressPrefix $addressPrefix
$vNet | Set-AzVirtualNetwork