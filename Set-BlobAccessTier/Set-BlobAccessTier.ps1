function Set-BlobAccessTier
{
    param
    (
        # Name of the Azure Storage Account
        [parameter(Mandatory=$true)] 
        [string] $storageaccountName,

        # Target Azure Blob Storage Container 
        [parameter(Mandatory=$true)] 
        [string] $containerName,

        # Access key for Azure Storage Account
        [parameter(Mandatory=$true)] 
        [string] $storageaccountKey,

        # Current Access Tier
        [parameter(Mandatory=$true)]
        [string] $currentaccessTier,

	    # Desired Access Tier
        [parameter(Mandatory=$true)] 
        [string] $desiredaccessTier

    )

            Write-Output "Creating Storage Context..."

    $context = New-AzureStorageContext `
        -StorageAccountName $storageaccountName `
        -StorageAccountKey $storageaccountKey
        
            Write-Output "Done."

	##Set access tier

            Write-Output "Getting $($currentaccessTier)  Tier Storage Blobs..."

    $blob = Get-AzureStorageBlob -Container $containerName -Context $context | Where-Object{$_.icloudblob.properties.standardblobtier -eq $currentaccessTier}

    	##Set tier of all the blobs to Archive

            if($null -eq $blob){

                Write-Output "No blobs were found."

            }
            else{

                Write-Output "Done."

                Write-Output "Found $($blob.count) $($currentaccessTier) Blobs ..."

                Write-Output "Setting access tier to $($desiredaccessTier) ..."

                $blob.icloudblob.setstandardblobtier("$($desiredaccessTier)")

                Write-Output "Access tier set to $($desiredaccessTier) ."

            }
}