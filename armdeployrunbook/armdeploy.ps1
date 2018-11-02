param
(
    [Parameter (Mandatory = $false)]
    [object] $WebhookData
)

# Check for Webhook Data
if ($WebhookData) {

    # Convert input JSON to PSObject
    $data = ConvertFrom-Json $WebhookData.RequestBody

    # Get RunAs Account Service Principal
    $ServicePrincipalConnection = Get-AutomationConnection -Name "AzureRunAsConnection"

    # Check for RunAs Service Principal
    if (!$ServicePrincipalConnection) {

        # No service principal found error
        Write-Host "No service principal"

    }
    else {
        
        # Authenticate with RunAs Service Principal
        Login-AzureRmAccount -ServicePrincipal -TenantId $ServicePrincipalConnection.TenantId -ApplicationId $ServicePrincipalConnection.ApplicationId -CertificateThumbprint $ServicePrincipalConnection.CertificateThumbprint | Write-Verbose
        
        # Get target subscription and set context
        $subscription = Get-AzureRmSubscription | Where-Object {$_.Name -eq $data.scriptData.subscriptionName}
        Set-AzureRmContext -SubscriptionID $subscription.Id
        
        # Set target Resource Group
        $resourcegroup = New-AzureRmResourceGroup -Name $data.params.projectName -Location "eastus2" -Force
        
        # Connect to template store and set SAS Token and template uri
        Set-AzureRmCurrentStorageAccount -ResourceGroupName Cloud-Eng-Testing -Name cloudengtesting
        $templateuri = New-AzureStorageBlobSASToken -Container armtemplates -Blob azuredeploy.json -Permission r -ExpiryTime (Get-Date).AddHours(1.0) -FullUri
        
        # Parse input data, convert to hash table, and set template parameters
        $params = @{}
        $data.params.psobject.properties | ForEach-Object {$params.add($_.Name, $_.Value)}
        $params.add('location', $resourcegroup.location)
        
        # Deploy template
        New-AzureRmResourceGroupDeployment -ResourceGroupName $params.projectName -TemplateUri $templateuri -TemplateParameterObject $params -Verbose
                
    }

}
else {

    # No data was sent in Webhook
    Write-Output "No data in Webhook"

}