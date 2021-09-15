# Set variables
$rgName         = "apress-ch04-rg"
$location       = "northeurope"
$vnetName       = "apress-vmss-vnet"
$subnetName     = "vmss-servers"
$addressPrefix  = "10.123.0.0/16"
$subnetIpRange  = "10.123.1.0/24"
$nsgName        = "$vnetName-nsg"
$vmssName       = "apressvmss"
$vmssSize       = "Standard_B1s"
$galleryImageId = "/subscriptions/62cc79e0-66dd-4bb9-9aa0-77fdf43493da/resourceGroups/cmd-images/providers/Microsoft.Compute/galleries/image_gallery/images/learn-azure-nginx/versions/3.0.0"
$lbName         = "$vmssName-lb"
$lbPipName      = "$lbName-pip"
$adminUsername  = 'apressadmin'
$adminPassword  = 'Pa$$w0rd123' | ConvertTo-SecureString -AsPlainText -Force
$tags           =  @{'deployment-method'='azure-powershell'}

# Create a resource group
New-AzResourceGroup -ResourceGroupName $rgName -Location $location -Tag $tags

# Create network security group, virtual network, and subnet for the VMSS
$nsgRule = New-AzNetworkSecurityRuleConfig -Name 'allow-remote-access' -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 22,80 -Access Allow
$nsg     = New-AzNetworkSecurityGroup -ResourceGroupName $rgName -Location $location -Name $nsgName -SecurityRules $nsgRule -Tag $tags
$subnet  = New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix $subnetIpRange -NetworkSecurityGroupId $nsg.Id
$vnet    = New-AzVirtualNetwork -ResourceGroupName $rgName -Name $vnetName -Location $location -AddressPrefix $addressPrefix -Subnet $subnet -Tag $tags

# Create a load balancer and needed configuration
$lbPip        = New-AzPublicIpAddress -ResourceGroupName $rgName -Location $location -AllocationMethod Static -Name $lbPipName -Sku Standard -Tag $tags
$frontend     = New-AzLoadBalancerFrontendIpConfig -Name "$vmssName-frontend" -PublicIpAddress $lbPip
$backendPool  = New-AzLoadBalancerBackendAddressPoolConfig -Name "$vmssName-backend"
$natPool      = New-AzLoadBalancerInboundNatPoolConfig -Name "$vmssName-natPool" -FrontendIpConfigurationId $frontend.Id -Protocol TCP -FrontendPortRangeStart 50000 -FrontendPortRangeEnd 50119 -BackendPort 22
$loadBalancer = New-AzLoadBalancer -ResourceGroupName $rgName -Name $lbName -Location $location -FrontendIpConfiguration $frontend -BackendAddressPool $backendPool -InboundNatPool $natPool -Sku Standard -Tag $tags
Add-AzLoadBalancerProbeConfig -Name "httpProbe" -LoadBalancer $loadBalancer -Protocol TCP -Port 80 -IntervalInSeconds 5 -ProbeCount 2
Add-AzLoadBalancerRuleConfig -Name "vmssRule" -LoadBalancer $loadBalancer -FrontendIpConfiguration $loadBalancer.FrontendIpConfigurations[0] -BackendAddressPool $loadBalancer.BackendAddressPools[0] -Protocol TCP -FrontendPort 80 -BackendPort 80 -Probe (Get-AzLoadBalancerProbeConfig -Name "httpProbe" -LoadBalancer $loadBalancer -OutVariable httpProbe)
Set-AzLoadBalancer -LoadBalancer $loadBalancer

# Set the parameters and create VMSS
$ipConfig   = New-AzVmssIpConfig -Name "ipConfig" -LoadBalancerBackendAddressPoolsId $loadBalancer.BackendAddressPools[0].Id -LoadBalancerInboundNatPoolsId $natPool.Id -SubnetId $vnet.Subnets[0].Id
$vmssConfig = New-AzVmssConfig -Location $location -SkuCapacity 2 -SkuName $vmssSize -UpgradePolicyMode "Rolling" -SkuTier Standard -Zone 1,2,3 -HealthProbeId $httpProbe.Id

Set-AzVmssRollingUpgradePolicy -VirtualMachineScaleSet $vmssConfig -MaxBatchInstancePercent 20 -MaxUnhealthyInstancePercent 20 -MaxUnhealthyUpgradedInstancePercent 20 -PauseTimeBetweenBatches "PT1M"
Set-AzVmssStorageProfile -VirtualMachineScaleSet $vmssConfig -ImageReferenceId $galleryImageId -OsDiskCreateOption "FromImage"
Set-AzVmssOsProfile -VirtualMachineScaleSet $vmssConfig -ComputerNamePrefix "apress" -AdminUsername $adminUsername -AdminPassword $adminPassword
Add-AzVmssNetworkInterfaceConfiguration -VirtualMachineScaleSet $vmssConfig -Name "vmssNetworkConfig" -Primary $true -IPConfiguration $ipConfig
New-AzVmss -ResourceGroupName $rgName -Name $vmssName -VirtualMachineScaleSet $vmssConfig

# Configure auto-scale profile and attach to the VMSS
$vmss = Get-AzVmss -ResourceGroupName $rgName -VMScaleSetName $vmssName
$myRuleScaleOut = New-AzAutoscaleRule -MetricName "Percentage CPU" -MetricResourceId $vmss.Id -TimeGrain 00:01:00 -MetricStatistic "Average" -TimeWindow 00:05:00 -Operator "GreaterThan" -Threshold 75 -ScaleActionDirection "Increase" -ScaleActionScaleType "ChangeCount" -ScaleActionValue 1 -ScaleActionCooldown 00:05:00
$myRuleScaleIn = New-AzAutoscaleRule -MetricName "Percentage CPU" -MetricResourceId $vmss.Id -Operator "LessThan" -MetricStatistic "Average" -Threshold 30 -TimeGrain 00:01:00   -TimeWindow 00:05:00 -ScaleActionCooldown 00:05:00 -ScaleActionDirection "Decrease" -ScaleActionScaleType "ChangeCount" -ScaleActionValue 1
$myScaleProfile = New-AzAutoscaleProfile -DefaultCapacity 2  -MaximumCapacity 5 -MinimumCapacity 2 -Rule $myRuleScaleOut,$myRuleScaleIn -Name "auto-scale-profile"
Add-AzAutoscaleSetting -Location $location -Name "autoScalingBasedOnCPU" -ResourceGroup $rgName -TargetResourceId $vmss.Id -AutoscaleProfile $myScaleProfile