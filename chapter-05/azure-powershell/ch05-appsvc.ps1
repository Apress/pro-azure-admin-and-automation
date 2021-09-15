# Parameters
$appServicePlanName = "apress-ch05-win-plan"
$location           = "West Europe"
$resourceGroupName  = "apress-ch05-rg"

# Create a resource group.
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create an App Service plan in Basic tier.
New-AzAppServicePlan -Name $appServicePlanName `
-Location $location `
-ResourceGroupName $resourceGroupName `
-Tier Basic `
-NumberofWorkers 1 `
-WorkerSize Small