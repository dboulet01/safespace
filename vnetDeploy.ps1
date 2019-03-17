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
        $PeerToNetbond

    )
    
    begin {

        Write-Host "Checking if Az module is installed." -ForegroundColor Yellow
        $module = Get-Module Az* -ListAvailable

        if(!$module){
            Write-Host "Az module not found.. Installing Az module." -ForegroundColor Yellow
            Install-Module Az -AllowClobber -Force
        } else {
            Write-Host "Az module found." -ForegroundColor Green
        }

        Write-Host "Setting Azure context." -ForegroundColor Yellow
        if($Subscription){
            Set-AzContext -Subscription $Subscription
        }
        else {
            Write-Host "Subscription not provided - using current context." -ForegroundColor Yellow
            Get-AzContext
        }

        $TemplateUri = "https://raw.githubusercontent.com/dboulet01/safespace/master/vnetarray.json"
        $paramObj = @{vnets = $VNetMetadata}
        $hubVnetId = "/subscriptions/779a66d5-d2b5-4c10-b8f3-1dc647a7f4a9/resourceGroups/TestHubVnet/providers/Microsoft.Network/virtualNetworks/TestHubVnet"

    }
    
    process {

        $rgcheck = Get-AzResourceGroup -Name $ResourceGroup -ErrorAction SilentlyContinue
        if (!$rgcheck) {
            Write-Host "Resource Group does not exist." -ForegroundColor Red
            Write-Host "Creating resource group..." -ForegroundColor Yellow
            Write-Host "Please enter a location for new resource group $($ResourceGroup)." -ForegroundColor Yellow
            New-AzResourceGroup -Name $ResourceGroup
        }

        $deployment = New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateParameterObject $paramObj -TemplateUri $TemplateUri -Verbose
        $obj = ConvertTo-Json $deployment | ConvertFrom-Json
        $resourceId = $obj.Outputs.resourceId.Value.Split(' ')

        if ($PeerToNetbond) {
            $paramObj = @{
                vnetName = $VNetMetadata.name
                remoteVnetId = $hubVnetId
            }
            New-Az
        }
    
    }
    
    end {
        $resourceId
    }
}