# Parameters
$fdProfileName = "apress02-fd"
$resourceGroupName = "apress-ch09-rg"

#Create the frontend object
$FrontendEndObject = New-AzFrontDoorFrontendEndpointObject `
    -Name "frontendEndpoint01" `
    -HostName $fdProfileName".azurefd.net"

# Create backend objects that points to the hostname of the web apps
$backendObject1 = New-AzFrontDoorBackendObject `
    -Address "designthe.cloud"

# Create a health probe object
$HealthProbeObject = New-AzFrontDoorHealthProbeSettingObject `
    -Name "HealthProbeSetting"

# Create the load balancing setting object
$LoadBalancingSettingObject = New-AzFrontDoorLoadBalancingSettingObject `
    -Name "Loadbalancingsetting" `
    -SampleSize "4" `
    -SuccessfulSamplesRequired "2" `
    -AdditionalLatencyInMilliseconds "0"

# Create a backend pool using the backend objects, health probe, and load balancing settings
$BackendPoolObject = New-AzFrontDoorBackendPoolObject `
    -Name "BackendPool01" `
    -FrontDoorName $fdProfileName `
    -ResourceGroupName $resourceGroupName `
    -Backend $backendObject1 `
    -HealthProbeSettingsName "HealthProbeSetting" `
    -LoadBalancingSettingsName "Loadbalancingsetting"

# Create a routing rule mapping the frontend host to the backend pool
$RoutingRuleObject = New-AzFrontDoorRoutingRuleObject `
    -Name LocationRule `
    -FrontDoorName $fdProfileName `
    -ResourceGroupName $resourceGroupName `
    -FrontendEndpointName "frontendEndpoint01" `
    -BackendPoolName "BackendPool01" `
    -PatternToMatch "/*"

# Creates the Front Door
New-AzFrontDoor `
    -Name $fdProfileName `
    -ResourceGroupName $resourceGroupName `
    -RoutingRule $RoutingRuleObject `
    -BackendPool $BackendPoolObject `
    -FrontendEndpoint $FrontendEndObject `
    -LoadBalancingSetting $LoadBalancingSettingObject `
    -HealthProbeSetting $HealthProbeObject