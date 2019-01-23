$subscriptions = Get-AzureRmSubscription

foreach ($subscription in $subscriptions) {
    Set-AzureRmContext -Subscription $subscription.Name
    Get-AzureRmResource | ForEach-Object {Get-AzureRmRoleAssignment -ResourceGroupName $_.Name | Export-Csv -Append -Path "RBAC.csv"}
}