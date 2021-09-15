# Parameters
$location           = "West Europe"
$resourceGroupName  = "apress-ch09-rg"
$addressSpace       = "10.1.0.0/16"
$subnetIpRangeVm    = "10.1.1.0/24"
$subnetIpRangeApGw  = "10.1.2.0/24"
$vmSubnetName       = "vm-subnet"
$apgwSubnetName     = "apgw-subnet"
$vnetName           = "apress-ch09-vnet"
$pipName            = "apress-apgw-pip"
$apgwName           = "apress02-apgw"

$ResourceGroup = New-AzResourceGroup -Name $resourceGroupName -Location $location

# Define VNet Subnets
$vmSubnet = New-AzVirtualNetworkSubnetConfig -Name $vmSubnetName -AddressPrefix "$subnetIpRangeVm"
$apgwSubnet = New-AzVirtualNetworkSubnetConfig -Name $apgwSubnetName -AddressPrefix "$subnetIpRangeApGw"

# Create Virtual Network
New-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroup.ResourceGroupName -Location $location -AddressPrefix "$addressSpace" -Subnet $vmSubnet, $apgwSubnet
$VNet = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroupName
$Subnet = Get-AzVirtualNetworkSubnetConfig -Name $apgwSubnetName -VirtualNetwork $VNet

# Create a public IP address
$PublicIp = New-AzPublicIpAddress -ResourceGroupName $resourceGroupName -Name $pipName -Location $location -AllocationMethod "Static" -Sku "Standard"

# Prepare Application gateway configuration
$GatewayIPconfig = New-AzApplicationGatewayIPConfiguration -Name "GatewayIp01" -Subnet $Subnet
$Pool = New-AzApplicationGatewayBackendAddressPool -Name "vmPool1" -BackendIPAddresses 10.1.1.10
$PoolSetting = New-AzApplicationGatewayBackendHttpSettings -Name "PoolSetting01"  -Port 80 -Protocol "Http" -CookieBasedAffinity "Disabled"
$FrontEndPort = New-AzApplicationGatewayFrontendPort -Name "FrontEndPort01"  -Port 80
$FrontEndIpConfig = New-AzApplicationGatewayFrontendIPConfig -Name "FrontEndConfig01" -PublicIPAddress $PublicIp
$Listener = New-AzApplicationGatewayHttpListener -Name "ListenerName01"  -Protocol "Http" -FrontendIpConfiguration $FrontEndIpConfig -FrontendPort $FrontEndPort
$Rule = New-AzApplicationGatewayRequestRoutingRule -Name "Rule01" -RuleType basic -BackendHttpSettings $PoolSetting -HttpListener $Listener -BackendAddressPool $Pool
$Sku = New-AzApplicationGatewaySku -Name "Standard_v2" -Tier "Standard_v2" -Capacity 2

# Create Application gateway using PowerShell Splatting
$parameters = @{
    Name                          = $apgwName
    ResourceGroupName             = $resourceGroupName
    Location                      = $location
    BackendAddressPools           = $Pool
    BackendHttpSettingsCollection = $PoolSetting
    FrontendIpConfigurations      = $FrontEndIpConfig
    GatewayIpConfigurations       = $GatewayIpConfig 
    FrontendPorts                 = $FrontEndPort 
    HttpListeners                 = $Listener 
    RequestRoutingRules           = $Rule 
    Sku                           = $Sku
}
New-AzApplicationGateway @parameters

# Create Application gateway without the use of Splatting
New-AzApplicationGateway -Name $apgwName -ResourceGroupName $resourceGroupName -Location $location -BackendAddressPools $Pool -BackendHttpSettingsCollection $PoolSetting -FrontendIpConfigurations $FrontEndIpConfig  -GatewayIpConfigurations $GatewayIpConfig -FrontendPorts $FrontEndPort -HttpListeners $Listener -RequestRoutingRules $Rule -Sku $Sku
