# Set variables
$resourceGroup = "apress-ch03-rg"
$location      = "westeurope"
$vnetName      = "apress-ch03-vnet"

$storage = New-AzStorageAccount -ResourceGroupName $resourceGroup -Name "apressch03st"

# Create private endpoint connection
$parameters1 = @{
    Name = "apressch03st-02-privep"
    PrivateLinkServiceId = $storage.ID
    GroupID = "blob"
}
$privateEndpointConnection = New-AzPrivateLinkServiceConnection @parameters1

# Place virtual network into variable
$vnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroup -Name $vnetName

# Disable private endpoint network policy
$vnet.Subnets[2].PrivateEndpointNetworkPolicies = "Disabled"
$vnet | Set-AzVirtualNetwork

# Create private endpoint
$parameters2 = @{
    ResourceGroupName = $resourceGroup
    Name = "apressch03st-02-privep"
    Location = $location
    Subnet = $vnet.Subnets[2]
    PrivateLinkServiceConnection = $privateEndpointConnection
}
New-AzPrivateEndpoint @parameters2

# Create private dns zone
$parameters1 = @{
    ResourceGroupName = $resourceGroup
    Name = "privatelink3.blob.core.windows.net"
}
$zone = Get-AzPrivateDnsZone @parameters1 -ErrorAction SilentlyContinue
if (!$zone) {$zone = New-AzPrivateDnsZone @parameters1}


# Create DNS network link
$parameters2 = @{
    ResourceGroupName = $resourceGroup
    ZoneName = "privatelink.blob.core.windows.net"
    Name = "myLink"
    VirtualNetworkId = $vnet.Id
}
$link = New-AzPrivateDnsVirtualNetworkLink @parameters2

# Create DNS configuration
$parameters3 = @{
    Name = "privatelink.blob.core.windows.net"
    PrivateDnsZoneId = $zone.ResourceId
}
$config = New-AzPrivateDnsZoneConfig @parameters3

# Create DNS zone group
$parameters4 = @{
    ResourceGroupName = $resourceGroup
    PrivateEndpointName = "apressch03st-02-privep"
    Name = 'myZoneGroup'
    PrivateDnsZoneConfig = $config
}
New-AzPrivateDnsZoneGroup @parameters4
