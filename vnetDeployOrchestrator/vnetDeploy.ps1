function New-AzureVnet {
    [CmdletBinding()]
    param (
        # Target Subscription - will accept subscription name or subscription Id
        [Parameter()]
        [String]
        $Subscription,

        # Resource Group to deploy Vnet into
        [Parameter()]
        [String]
        $ResourceGroup,

        # Meta data object defining the Vnet to create
        [Parameter()]
        [array]
        $VNetMetadata,

        # Enable Hub Peering - Boolean Switch
        [switch]
        $PeerToHub

    )
    
    begin {

        Write-Host ""
        Write-Host "Checking if Az module is installed." -ForegroundColor Yellow

        # Check to see if Az module is installed and available
        $module = Get-Module Az* -ListAvailable

        if(!$module){

            Write-Host ""
            Write-Host "Az module not found.. Installing Az module." -ForegroundColor Yellow

            # Install module using PowerShellGet if not found
            Install-Module Az -AllowClobber -Force

        } 
        else {

            Write-Host ""
            Write-Host "Az module found." -ForegroundColor Green

        }

        Write-Host ""
        Write-Host "Setting Azure context." -ForegroundColor Yellow

        if($Subscription){

            # Set subscription context if subscription was provided
            Set-AzContext -Subscription $Subscription

        }
        else {

            Write-Host ""
            Write-Host "Subscription not provided - using current context." -ForegroundColor Yellow

            # Display current context to user as it was not declared
            Get-AzContext
        
        }

        # Template Uris
        $VnetTemplateUri = "https://raw.githubusercontent.com/dboulet01/safespace/master/ARM-Templates/vnet.json"
        $PeeringTemplateUri = "https://raw.githubusercontent.com/dboulet01/safespace/master/ARM-Templates/vnetpeering.json"
        
        # Hub info parsing
        $hubVnetId = "ENTER HUB RESOURCE ID HERE AFTER CREATION"
        $hubVnetSubscription = $hubVnetId.Split('/')[2]
        $hubVnetRG = $hubVnetId.Split('/')[4]
        $hubVnetName = $hubVnetId.Split('/')[8]

        # Vnet deployment parameters
        $vnetParamObj = @{
            vnets = $VNetMetadata
        }

    }
    
    process {

        # Resource group check
        $rgcheck = Get-AzResourceGroup -Name $ResourceGroup -ErrorAction SilentlyContinue
        if (!$rgcheck) {
            Write-Host ""
            Write-Host "Resource Group does not exist." -ForegroundColor Red
            Write-Host "Creating resource group..." -ForegroundColor Yellow
            Write-Host "Please enter a location for new resource group $($ResourceGroup)." -ForegroundColor Yellow
            Write-Host ""
            New-AzResourceGroup -Name $ResourceGroup
        }

        # Vnet deployment
        $deployment = New-AzResourceGroupDeployment `
        -ResourceGroupName $ResourceGroup `
        -TemplateParameterObject $vnetParamObj `
        -TemplateUri $VnetTemplateUri `
        -Verbose

        # Getting resource Id of Vnet for use in peering
        $newVnet = Get-AzVirtualNetwork `
        -ResourceGroupName $ResourceGroup `
        -Name $VNetMetadata.name

        $resourceId = $newVnet.Id

        # If PeerToHub is set to True
        if ($PeerToHub) {

            # Spoke peer deployment parameters
            $spokeParamObj = @{
                vnetName = $VNetMetadata.name
                remoteVnetId = $hubVnetId

            }

            Write-Host ""
            Write-Host "Deploying peer configuration to $($VnetMetadata.name)." -ForegroundColor Yellow
            Write-Host ""

            # Spoke peer deployment
            $deployment = New-AzResourceGroupDeployment `
            -ResourceGroupName $ResourceGroup `
            -TemplateParameterObject $spokeParamObj `
            -TemplateUri $PeeringTemplateUri `
            -Verbose

            # Hub peer deployment parameters
            $hubParamObj = @{
                vnetName = $hubVnetName
                remoteVnetId = $resourceId
                isHub = $true
            }

            Write-Host ""
            Write-Host "Setting Hub Vnet subscription context." -ForegroundColor Yellow
            Write-Host ""

            # Set context to hub subscription as hub may live in another subscription
            Set-AzContext -Subscription $hubVnetSubscription

            Write-Host ""
            Write-Host "Deploying peer configuration to $($hubVnetName)." -ForegroundColor Yellow
            Write-Host ""

            # Hub peer deployment
            $deployment = New-AzResourceGroupDeployment `
            -ResourceGroupName $hubVnetRG `
            -TemplateParameterObject $hubParamObj `
            -TemplateUri $PeeringTemplateUri `
            -Verbose

            Write-Host ""
        } 
    }
    
    end {
        if ($PeerToHub) {

            Write-Host ""
            Write-Host "VNet has been created and peered to Hub." -ForegroundColor Green
            Write-Host ""

        }
        else{

            Write-Host ""
            Write-Host "Vnet has been created." -ForegroundColor Green
            Write-Host ""

        }
    }
}