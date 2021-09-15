# Set variables
$resourceGroup    = "apress-ch03-rg"
$location         = "westeurope"
$addressSpace     = "10.1.0.0/16"
$subnetIpRangeApp = "10.1.1.0/24"
$subnetIpRangeDb  = "10.1.2.0/24"
$appSubnetName    = "app-vm-subnet"
$dbSubnetName     = "db-vm-subnet"
$vnetName         = "apress-ch03-vnet"

# Create resource group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Define VNet Subnets
$appSubnet = New-AzVirtualNetworkSubnetConfig -Name $appSubnetName -AddressPrefix "$subnetIpRangeApp"
$dbSubnet = New-AzVirtualNetworkSubnetConfig -Name $dbSubnetName -AddressPrefix "$subnetIpRangeDb"

# Create Virtual Network
New-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroup -Location $location -AddressPrefix "$addressSpace" -Subnet $appSubnet, $dbSubnet
