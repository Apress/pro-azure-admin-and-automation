# Set variables for the virtual machine networking
$resourceGroup  = 'apress-ch04-rg'
$location       = 'northeurope'
$vnetName       = 'apress-ch04-vnet'
$addressSpace   = '10.123.0.0/16'
$subnetIpRange  = '10.123.1.0/24'
$subnetName     = 'servers-subnet'
$nsgName        = "$vnetName-nsg"
$storageAccount = 'apressch04diagstorage'
$tags           =  @{'deployment-method'='azure-powershell'}

# Create resource group and the boot diagnostic storage account
New-AzResourceGroup -Name $resourceGroup -Location $location -Tag $tags
New-AzStorageAccount -Name $storageAccount -ResourceGroupName $resourceGroup -Location $location -SkuName Standard_LRS -Kind StorageV2 -Tag $tags

# Create network security group, virtual network and subnet for the virtual machine
$nsgRule = New-AzNetworkSecurityRuleConfig -Name 'allow-remote-access' -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 22 -Access Allow
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroup -Location $location -Name $nsgName -SecurityRules $nsgRule -Tag $tags
$virtualNetwork = New-AzVirtualNetwork -ResourceGroupName $resourceGroup -Name $vnetName -AddressPrefix $addressSpace -Location $location -Tag $tags
Add-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $virtualNetwork -AddressPrefix $subnetIpRange -NetworkSecurityGroup $nsg
Set-AzVirtualNetwork -VirtualNetwork $virtualNetwork

# Set variables for the virtual machine configuration
$vnet       = Get-AzVirtualNetwork -ResourceGroupName $resourceGroup -Name $vnetName
$subnet     = Get-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet
$vmName 	= 'apress-ch04-linux'
$pubName	= 'Canonical'
$offerName	= 'UbuntuServer'
$skuName	= '19.10-DAILY'
$vmSize 	= "Standard_B2s"
$pipName    = "$vmName-pip" 
$nicName    = "$vmName-nic"
$osDiskName = "$vmName-OsDisk"
$osDiskSize = 30
$osDiskType = 'Premium_LRS'

# Create Admin Credentials
$adminUsername = 'apressadmin'
$adminPassword = ConvertTo-SecureString ' ' -AsPlainText -Force
$adminCreds    = New-Object PSCredential $adminUsername, $adminPassword
$adminSshKey   = Get-Content "$env:USERPROFILE\.ssh\id_rsa.pub"

# Create a public IP and NIC
$pip = New-AzPublicIpAddress -Name $pipName -ResourceGroupName $resourceGroup -Location $location -AllocationMethod Static -Tag $tags
$nic = New-AzNetworkInterface -Name $nicName -ResourceGroupName $resourceGroup -Location $location -SubnetId $subnet.Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id -Tag $tags

# Set and deploy virtual machine
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize
Add-AzVMNetworkInterface -VM $vmConfig -Id $nic.Id
Set-AzVMOperatingSystem -VM $vmConfig -Linux -ComputerName $vmName -Credential $adminCreds -DisablePasswordAuthentication
Add-AzVMSshPublicKey -VM $vmConfig -KeyData $adminSshKey -Path "/home/$adminUsername/.ssh/authorized_keys"
Set-AzVMBootDiagnostic -Enable -ResourceGroupName $resourceGroup -VM $vmConfig -StorageAccountName $storageAccount
Set-AzVMSourceImage -VM $vmConfig -PublisherName $pubName -Offer $offerName -Skus $skuName -Version 'latest'
Set-AzVMOSDisk -VM $vmConfig -Name $osDiskName -DiskSizeInGB $osDiskSize -StorageAccountType $osDiskType -CreateOption fromImage
New-AzVM -ResourceGroupName $resourceGroup -Location $location -VM $vmConfig -Tag $tags