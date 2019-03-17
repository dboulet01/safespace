$arguments = @{
    VNetMetadata = @(
        @{
            name = "TestHubVnet"
            addressPrefixes = @(
                "172.16.0.0/16"
            )
            subnets = @(
                @{
                    name = "firstSubnet"
                    properties = @{
                        addressPrefix = "172.16.1.0/24"
                    }
                },
                @{
                    name = "secondSubnet"
                    properties = @{
                        addressPrefix = "172.16.2.0/24"
                    }
                }
            )
        }
    )
    ResourceGroup = "TestHubVnet"
    Subscription = ""
    PeerToHub = $false
}

######################################################################################################################
#                                             How to run vnetDeploy                                                  #
######################################################################################################################
#                                                                                                                    #
#  1. Load vnetDeploy.ps1                                                                                            #
#       - download and save ps1                                                                                      #
#       - dot-source ps1 file                                                                                        #
#                                                                                                                    #
#     If in same directory as script      PS C:\Users\user\scripts>. .\vnetDeploy.ps1                                #
#     If in different directory           PS C:\Users\user\differentdirectory>. C:\Users\user\scripts\vnetDeploy.ps1 #
#                                                                                                                    #
#  2. Build VnetMetaData and set additional arguments                                                                #
#                                                                                                                    #
#  3. Save and run metadata file to load arguments/metadata into $arguments variable                                 #
#           - PS C:\Users\user\scripts>. .\vnetDeployMetadata.ps1                                                    #                                            
#                                                                                                                    #
#  4. Issue 'New-AzureVnet @arguments' to call function and splat parameters                                         #
#                                                                                                                    #
#  5. Popcorn                                                                                                        #
#                                                                                                                    #
######################################################################################################################