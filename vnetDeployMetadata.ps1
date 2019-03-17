$arguments = @{
    VNetMetadata = @(
        @{
            name = "TestSpokeVnet"
            addressPrefixes = @(
                "192.168.0.0/16"
            )
            subnets = @(
                @{
                    name = "firstSubnet"
                    properties = @{
                        addressPrefix = "192.168.1.0/24"
                    }
                },
                @{
                    name = "secondSubnet"
                    properties = @{
                        addressPrefix = "192.168.2.0/24"
                    }
                }
            )
        }
    )
    ResourceGroup = "TestSpokeVnet"
    Subscription = ""
    PeerToHub = $true
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