<#  
.SYNOPSIS  
    Remove an Azure File Share Snapshot.
  
.DESCRIPTION  
    This runbook enables automated deletion of Azure File Share Snapshots. This runbook deletes snapshots older than 48 hours. This can be triggered by webhook, schedule, or other alert.

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
        -Context $context

    $oldsnapshot = $share | Where-Object{$_.IsSnapshot -eq $true -and $_.SnapshotTime -lt (date).addhours(-48)} | Select -First 1

    $oldsnapshot

    Remove-AzureStorageShare `
	-Share $oldsnapshot

    
  
.NOTES  
    Author: Dave Boulet   
    Last Updated: 12/20/2017     
#> 

function Remove-AzureFileShareSnapshot
{
    param
    (
        # Name of the Azure Storage Account
        [parameter(Mandatory=$true)] 
        [string] $storageaccountName,

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

	##Delete Snapshot

            Write-Output "Getting Storage Share..."

    $share = Get-AzureStorageShare `
        -Context $context

            Write-Output "Done."

            Write-Output "Deleting Share Snapshot Older Than 48 Hours..."

    $oldsnapshot = $share | Where-Object{$_.Name -eq "quotewerks" -and $_.IsSnapshot -eq $true -and $_.SnapshotTime -lt (Get-Date).addhours(-48)} | Select-Object -First 1

    $oldsnapshot

            Remove-AzureStorageShare -Share $oldsnapshot

            Write-Output "Snapshot Deleted."

}