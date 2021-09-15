# Parameters
$privateDnsZoneName = "designthe.local"
$location           = "West Europe"
$resourceGroupName  = "apress-ch07-rg"

# Create a resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Get the object of previously deployed VNet
$vnet = Get-AzVirtualNetwork -Name 'apress-ch03-vnet'

# Create Private DNS Zone
New-AzPrivateDnsZone -Name $privateDnsZoneName -ResourceGroupName $resourceGroupName

# Create a link between Zone and VNet
New-AzPrivateDnsVirtualNetworkLink -ZoneName $privateDnsZoneName -ResourceGroupName $resourceGroupName -Name 'newLink' -VirtualNetworkId $vnet.Id -EnableRegistration
