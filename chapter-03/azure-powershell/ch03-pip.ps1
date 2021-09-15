# Set variables
$resourceGroup = "apress-ch03-rg"
$location      = "westeurope"
$publicIpName = "apress-ch03-pip"
$domainNameLabel = "apress-vm01"

# Create Public IP Address
New-AzPublicIpAddress -Name $publicIpName -ResourceGroupName $resourceGroup -AllocationMethod Static -DomainNameLabel $domainNameLabel -Location $location -Sku Standard
