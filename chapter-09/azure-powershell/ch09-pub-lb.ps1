# Parameters
$publicIpName       = "apress03-pub-lb-pip"
$publicLbName       = "apress03-pub-lb"
$frontendName       = "lbFrontend"
$location           = "West Europe"
$resourceGroupName  = "apress-ch09-rg"

# Create Resource group
New-AzResourceGroup -ResourceGroupName $resourceGroupName -Location $location

# Create Public IP
$publicip = New-AzPublicIpAddress -ResourceGroupName $resourceGroupName -name $publicIpName -Location $location -AllocationMethod Static -Sku Standard

# Create Public Load Balancer
$frontend = New-AzLoadBalancerFrontendIpConfig -Name $frontendName -PublicIpAddress $publicip
New-AzLoadBalancer -Name $publicLbName -ResourceGroupName $resourceGroupName -Location $location -FrontendIpConfiguration $frontend -Sku Standard -Tier Global
