# Parameters
$resourceGroupName     = "apress-ch05-rg"
$containerInstanceName = "apress"
$imageName             = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
$osType                = "Linux"
$DnsNameLabel          = "apress"

# Create ACI
New-AzContainerGroup -ResourceGroupName $resourceGroupName -Name $containerInstanceName -Image $imageName -OsType $osType -DnsNameLabel $DnsNameLabel