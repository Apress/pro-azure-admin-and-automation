# Parameters
$appServicePlanName = "apress-ch05-win-plan"
$location           = "West Europe"
$resourceGroupName  = "apress-ch05-rg"
$webAppName         = "apress"

# Create a Web App
New-AzWebApp -ResourceGroupName $resourceGroupName -Location $location -Name $webAppName -AppServicePlan $appServicePlanName