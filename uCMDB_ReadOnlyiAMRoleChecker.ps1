Login-AzureRmAccount

$ucmdbserviceprincipal = Get-AzureRmADServicePrincipal | Where-Object {$_.DisplayName -eq "uCMDB_ReadOnly"}
$subscriptions = Get-AzureRmSubscription

foreach ($subscription in $subscriptions){

Set-AzureRmContext -Subscription $subscription.Id

$rolecheck = Get-AzureRmRoleAssignment | Where-Object {$_.DisplayName -eq "uCMDB_ReadOnly"}

    if(!$rolecheck){

    $scope = "/subscriptions/" + $subscription.Id
    
    Write-Host "uCMDB_ReadOnly iAM role does not exist... Creating Reader iAM role..." -ForegroundColor Yellow
    Write-Host ""
    New-AzureRmRoleAssignment -ObjectId $ucmdbserviceprincipal.Id -RoleDefinitionName Reader -Scope $scope

        Do {

            $counter++

            Write-Host "Checking for proper creation of iAM role..." -ForegroundColor Yellow
            Write-Host ""
            
            $newazurermrolecheck = Get-AzureRmRoleAssignment | Where-Object {$_.DisplayName -eq "uCMDB_ReadOnly"}



        }While(!$newazurermrolecheck -or $counter -gt 10)

            If($newazurermrolecheck){

            Write-Host "iAM role properly created!" -ForegroundColor Green
            Write-Host ""

            }

            If($counter -gt 10){

            Write-Host "iAM role failed to create... Please investigate..." -ForegroundColor Red
            Write-Host ""
    
            }

    }
    else{
    
    Write-Host "$($ucmdbserviceprincipal.DisplayName) iAM role already exists in $($subscription.Name) subscription." -ForegroundColor Green
    Write-Host ""

    }


}

Write-Host "End." -ForegroundColor Yellow