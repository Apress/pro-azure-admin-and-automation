# Parameters
$resourceGroupName = "apress-ch05-rg"
$aksName           = "apress2"
$nodeCount         = "1"
$KubernetesVersion = "1.18.14"
$NodeVmSize        = "Standard_B2ms"
$DnsNamePrefix     = "apress2-dns"
# Run this command and enter your SPN ID and Password
$ServicePrincipalIdAndSecret = Get-Credential

# Deploy AKS
New-AzAksCluster -ResourceGroupName $resourceGroupName -Name $aksName -NodeCount $nodeCount `
-KubernetesVersion "$KubernetesVersion" -NodeVmSize $NodeVmSize -DnsNamePrefix $DnsNamePrefix `
-ServicePrincipalIdAndSecret $ServicePrincipalIdAndSecret -NetworkPlugin kubenet
