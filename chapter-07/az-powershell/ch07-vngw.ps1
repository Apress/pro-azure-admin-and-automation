# Parameters
$resourceGroupName = "apress-ch07-rg"
$vnet01Name        = "apress01-we-vnet"
$vnet02Name        = "apress02-we-vnet"
$location          = "West Europe"
$vngw01Name        = "vnet01-vngw"
$vngw02Name        = "vnet02-vngw"

# Putting the VNet object inside the variable
$vnet01 = Get-AzVirtualNetwork -Name $vnet01Name
$vnet02 = Get-AzVirtualNetwork -Name $vnet02Name

# Create Public IPs
$gwpip1 = New-AzPublicIpAddress -Name "$vngw01Name-pip" -ResourceGroupName $resourceGroupName -Location $Location -AllocationMethod Dynamic
$gwpip2 = New-AzPublicIpAddress -Name "$vngw02Name-pip" -ResourceGroupName $resourceGroupName -Location $Location -AllocationMethod Dynamic

# Putting the subnet object inside the variable
$vnet01Subnet = Get-AzVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet01
$vnet02Subnet = Get-AzVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet02

# Preparing vngw IP config
$gwipconf1 = New-AzVirtualNetworkGatewayIpConfig -Name $GWIPconfName1 -Subnet $vnet01Subnet -PublicIpAddress $gwpip1
$gwipconf2 = New-AzVirtualNetworkGatewayIpConfig -Name $GWIPconfName1 -Subnet $vnet02Subnet -PublicIpAddress $gwpip2

# Creating Gateway
New-AzVirtualNetworkGateway -Name $vngw01Name -ResourceGroupName $resourceGroupName -Location $location -IpConfigurations $gwipconf1 -GatewayType Vpn -VpnType RouteBased -GatewaySku VpnGw2
New-AzVirtualNetworkGateway -Name $vngw02Name -ResourceGroupName $resourceGroupName -Location $location -IpConfigurations $gwipconf2 -GatewayType Vpn -VpnType RouteBased -GatewaySku VpnGw2

# Putting the vngw object inside the variable
$vnet01vngw = Get-AzVirtualNetworkGateway -Name $vngw01Name -ResourceGroupName $resourceGroupName
$vnet02vngw = Get-AzVirtualNetworkGateway -Name $vngw02Name -ResourceGroupName $resourceGroupName

# Creating a connection
New-AzVirtualNetworkGatewayConnection -Name "peering-vnet" -ResourceGroupName $resourceGroupName -VirtualNetworkGateway1 $vnet01vngw -VirtualNetworkGateway2 $vnet02vngw -Location $location -ConnectionType Vnet2Vnet -SharedKey "Apress4Azure"
