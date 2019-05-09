Set-AzContext -subscription "subscriptionName"

$param = @{
    vm = @(
        @{
            Name = "TestTemplateVM"
            vmSize = "small"
            os = "linux"
            osDisk = @{
                diskSize = ""
                diskType = "ssd"
            }
            dataDisks = @(
                @{
                    diskSize = "50"
                    diskType = "ssd"
                }
            )
            diagStorageAccount = "storageaccountID"
            vnetID = "vnetID"
            subnetName = "subnet1"
            username = "azure-user"
            password = {Read-Host -Prompt "Password" -AsSecureString}
        }
    )
}

$resourcegroup = ""

$templateFile = "./vmdeploy.json"

New-AzResourceGroupDeployment -ResourceGroupName $resourcegroup -TemplateFile $templateFile -TemplateParameterObject $param