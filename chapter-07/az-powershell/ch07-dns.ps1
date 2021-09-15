# Parameters
$dnsZoneName        = "designthe.cloud"
$location           = "West Europe"
$resourceGroupName  = "apress-ch07-rg"

# Create a resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create a DNS zone
New-AzDnsZone -Name $dnsZoneName -ResourceGroupName $resourceGroupName