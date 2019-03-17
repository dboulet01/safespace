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
        $ResourceGroup

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

    }
    
    process {
        $deployment = New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateParameterObject $param -TemplateUri $TemplateUri -Verbose
        $obj = ConvertTo-Json $deployment | ConvertFrom-Json
        $resourceId = $obj.Outputs.resourceId.Value.Split(' ')
    }
    
    end {
        $resourceId
    }
}