Set-AzureRmContext -Subscription "Data Analytics"
$storageAccount = Get-AzureRmStorageAccount -ResourceGroupName NetworkWatcherRG -Name nsgflowlogstosplunk
$storageAccount

$subscriptions = Get-AzureRmSubscription
foreach ($subscription in $subscriptions) {

    Set-AzureRmContext -Subscription $subscription.Name
    $networkSecurityGroup = $null
    $networkSecurityGroups = $null
    $networkSecurityGroups = Get-AzureRmNetworkSecurityGroup

    foreach ($networkSecurityGroup in $networkSecurityGroups){
        $networkWatcher = $null
        $networkWatcher = Get-AzureRmNetworkWatcher
        $flowLogStatus = $null
        try{
        $flowLogStatus = Get-AzureRmNetworkWatcherFlowLogStatus -NetworkWatcher $networkWatcher -TargetResourceId $networkSecurityGroup.Id 2>> errors.txt
        }
        catch{
            $_ | Out-File errors.txt -Append
        }
            if ($flowLogStatus.Enabled -eq $true) {
                Write-Host "Flow logs are already enabled."
                $flowLogStatus | select * | Export-Csv -Append -Path "FlowLoggingEnabled$($subscription.Name).csv"
            }else{
                Write-Host "Flow Logging Not Enabled"
                $flowLogStatus | select * | Export-Csv -Append -Path "FlowLoggingNotEnabled$($subscription.Name).csv"
            }
    }
}


# Set-AzureRmNetworkWatcherConfigFlowLog -NetworkWatcher $networkWatcher -TargetResourceId $networkSecurityGroup.Id -EnableFlowLog $true -StorageAccountId $storageAccount.Id