# Set variables
$resourceGroup = "apress-ch03-rg"
$location      = "westeurope"
$nsgName       = "apress-db-vm-subnet-nsg"

# Define set of rules
$rules = @{
    Name = 'allow-port-8080'
    Description = 'Allow HTTP'
    Access = 'Allow'
    Protocol = 'Tcp'
    Direction = 'Inbound'
    Priority = '120'
    SourceAddressPrefix = 'Internet'
    SourcePortRange = '*'
    DestinationAddressPrefix = '*'
    DestinationPortRange = '8080'
}

# Create Network Security Group
$nsg = New-AzNetworkSecurityGroup -Name $nsgName -ResourceGroupName $resourceGroup -Location $location
$nsg | Add-AzNetworkSecurityRuleConfig @rules | Set-AzNetworkSecurityGroup
