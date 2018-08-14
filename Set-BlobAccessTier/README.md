<#  
.SYNOPSIS  
    Set access tier for all blobs in an Azure Blob Storage container.
  
.DESCRIPTION  
    This script changes the access tier of all blobs in a Azure Blob Storage container to the desired access tier.

 .PARAMETER StorageAccountName 
    Name of the Azure Storage Account
      
.PARAMETER ContainerName  
    Target Azure Blob Container name

.PARAMETER StorageAccountKey  
    Access key for Azure Storage Account

.PARAMETER AccessTier  
    Desired access tier
    
.EXAMPLE  

    $context = New-AzureStorageContext `
        -StorageAccountName $Using:storageaccountName `
        -StorageAccountKey $Using:storageaccountKey `

    $blob=Get-AzureStorageBlob `
	-Container $containerName `
        -Context $context

    $blob.icloudblob.setstandardblobtier("$Using:accessTier")

    
  
.NOTES  
    Author: Dave Boulet   
    Last Updated: 4/23/2018     
#>