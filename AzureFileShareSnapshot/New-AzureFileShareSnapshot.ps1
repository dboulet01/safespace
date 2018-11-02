<#  
.SYNOPSIS  
    Create Azure File Share Snapshot
  
.DESCRIPTION  
    This runbook enables automated creation of Azure File Share Snapshots. This can be triggered by webhook, schedule, or other alert.

 .PARAMETER StorageAccountName 
    Name of the Azure Storage Account 
      
.PARAMETER FileShare  
    Target Azure File Share name

.PARAMETER StorageAccountKey  
    Access key for Azure Storage Account
    
.EXAMPLE  

    $context = New-AzureStorageContext `
        -StorageAccountName $storageaccountName `
        -StorageAccountKey $storageaccountKey `
        -Endpoint core.windows.net `
        -Protocol Https

    $share=Get-AzureStorageShare `
        -Context $context `
        -Name $fileShare
	$share.Properties.LastModified
	$share.IsSnapshot
	$snapshot=$share.Snapshot() 
  
.NOTES  
    Author: Dave Boulet   
    Last Updated: 12/19/2017     
#> 

function New-AzureFileShareSnapshot
{
    param
    (
        # Name of the Azure Storage Account
        [parameter(Mandatory=$true)] 
        [string] $storageaccountName,

        # Target Azure File Share name 
        [parameter(Mandatory=$true)] 
        [string] $fileShare,

        # Access key for Azure Storage Account
        [parameter(Mandatory=$true)] 
        [string] $storageaccountKey

    )
    
    Write-Output "Creating Storage Context..."

    $context = New-AzureStorageContext `
        -StorageAccountName $storageaccountName `
        -StorageAccountKey $storageaccountKey `
        -Endpoint core.windows.net `
        -Protocol Https

            Write-Output "Done."

	##Create snapshot

            Write-Output "Getting Storage Share..."

	$share=Get-AzureStorageShare `
        -Context $context `
        -Name $fileShare

            Write-Output "Done."

            Write-Output "Creating Share Snapshot..."

	$snapshot=$share.Snapshot()

            Write-Output "Snapshot Created."

    $snapshot
}