function New-AzureVnet {
    [CmdletBinding()]
    param (
        #Target Subscription - will accept subscription name or subscription Id
        [Parameter()]
        [String]
        $Subscription,

        #Resource Group
        [Parameter()]
        [String]
        $ResourceGroup,

        #ARM Param Object
        [Parameter()]
        [array]
        $VNetMetadata,

        #Enable Netbond Peer - Boolean Switch
        [switch]
        $PeerToHub

    )
    
    begin {
        Write-Host ""
        Write-Host "Checking if Az module is installed." -ForegroundColor Yellow
        $module = Get-Module Az* -ListAvailable

        if(!$module){
            Write-Host ""
            Write-Host "Az module not found.. Installing Az module." -ForegroundColor Yellow
            Install-Module Az -AllowClobber -Force
        } else {
            Write-Host ""
            Write-Host "Az module found." -ForegroundColor Green
        }
        Write-Host ""
        Write-Host "Setting Azure context." -ForegroundColor Yellow
        if($Subscription){
            Set-AzContext -Subscription $Subscription
        }
        else {
            Write-Host ""
            Write-Host "Subscription not provided - using current context." -ForegroundColor Yellow
            Get-AzContext
        }

        $VnetTemplateUri = "https://raw.githubusercontent.com/dboulet01/safespace/master/vnet.json"
        $PeeringTemplateUri = "https://raw.githubusercontent.com/dboulet01/safespace/master/vnetpeering.json"
        $paramObj = @{vnets = $VNetMetadata}
        $hubVnetId = "/subscriptions/779a66d5-d2b5-4c10-b8f3-1dc647a7f4a9/resourceGroups/TestHubVnet/providers/Microsoft.Network/virtualNetworks/TestHubVnet"
        $hubVnetSubscription = $hubVnetId.Split('/')[2]
        $hubVnetRG = $hubVnetId.Split('/')[4]
        $hubVnetName = $hubVnetId.Split('/')[8]

    }
    
    process {

        $rgcheck = Get-AzResourceGroup -Name $ResourceGroup -ErrorAction SilentlyContinue
        if (!$rgcheck) {
            Write-Host ""
            Write-Host "Resource Group does not exist." -ForegroundColor Red
            Write-Host "Creating resource group..." -ForegroundColor Yellow
            Write-Host "Please enter a location for new resource group $($ResourceGroup)." -ForegroundColor Yellow
            Write-Host ""
            New-AzResourceGroup -Name $ResourceGroup
        }

        $deployment = New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateParameterObject $paramObj -TemplateUri $VnetTemplateUri -Verbose
        $newVnet = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroup -Name $VNetMetadata.name
        $resourceId = $newVnet.Id

        if ($PeerToHub) {
            $spokeParamObj = @{
                vnetName = $VNetMetadata.name
                remoteVnetId = $hubVnetId
            }
            Write-Host ""
            Write-Host "Deploying peer configuration to $($VnetMetadata.name)." -ForegroundColor Yellow
            Write-Host ""
            $deployment = New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateParameterObject $spokeParamObj -TemplateUri $PeeringTemplateUri -Verbose

            $hubParamObj = @{
                vnetName = $hubVnetName
                remoteVnetId = $resourceId
                isHub = $true
            }

            Write-Host ""
            Write-Host "Setting Hub Vnet subscription context." -ForegroundColor Yellow
            Write-Host ""

            Set-AzContext -Subscription $hubVnetSubscription

            Write-Host ""
            Write-Host "Deploying peer configuration to $($hubVnetName)." -ForegroundColor Yellow
            Write-Host ""
            $deployment = New-AzResourceGroupDeployment -ResourceGroupName $hubVnetRG -TemplateParameterObject $hubParamObj -TemplateUri $PeeringTemplateUri -Verbose
            Write-Host ""
        }
    
    }
    
    end {
        if ($PeerToHub) {
            Write-Host ""
            Write-Host "VNet has been created and peered to Hub." -ForegroundColor Green
            Write-Host ""
        }else{
            Write-Host ""
            Write-Host "Vnet has been created." -ForegroundColor Green
            Write-Host ""
        }
    }
}