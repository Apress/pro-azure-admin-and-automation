# Parameters
$tmProfileName = "apress-tm"
$resourceGroupName = "apress-ch09-rg"

# Create Traffic manager profile
New-AzTrafficManagerProfile -Name $tmProfileName -ResourceGroupName $resourceGroupName -ProfileStatus Enabled -RelativeDnsName 'apress011' -TrafficRoutingMethod Priority -MonitorProtocol HTTP -MonitorPort 80 -Ttl 30 -MonitorPath '/'
