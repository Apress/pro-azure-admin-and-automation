# Set variables
$resourceGroup = "apress-ch03-rg"
$location      = "westeurope"
$vnetName      = "apress-ch03-vnet"

# Define configuration
$vnet = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroup
$IPconfig = New-AzNetworkInterfaceIpConfig -Name "IPConfig1" -PrivateIpAddressVersion IPv4 -PrivateIpAddress "10.1.1.4" -SubnetId $vnet.Subnets[0].Id

# Create Network Interface
New-AzNetworkInterface -Name "apress-vm01-nic" -ResourceGroupName $resourceGroup -IpConfiguration $IPconfig -Location $location
