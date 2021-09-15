# Parameters
$resourceGroupName = "apress-ch07-rg"
$vnet01Name = "apress01-we-vnet"
$vnet02Name = "apress02-we-vnet"

# Putting the VNet object inside the variable
$vnet01 = Get-AzVirtualNetwork -Name $vnet01Name
$vnet02 = Get-AzVirtualNetwork -Name $vnet02Name

# Create peering on source VNet side
Add-AzVirtualNetworkPeering `
    -Name $vnet01Name'-to-'$vnet02Name `
    -VirtualNetwork $vnet01 `
    -RemoteVirtualNetworkId $vnet02.Id

Add-AzVirtualNetworkPeering `
    -Name $vnet02Name'-to-'$vnet01Name `
    -VirtualNetwork $vnet02 `
    -RemoteVirtualNetworkId $vnet01.Id

# Confirming the state - the output should state 'Connected'
Get-AzVirtualNetworkPeering `
    -ResourceGroupName $resourceGroupName `
    -VirtualNetworkName $vnet01Name `
| Select-Object PeeringState