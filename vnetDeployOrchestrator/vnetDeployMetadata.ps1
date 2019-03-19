$arguments = @{
    VNetMetadata = @(
        @{
            name = "VnetName"
            addressPrefixes = @(
                "192.168.0.0/16"
            )
            subnets = @(
                @{
                    name = "SubnetName"
                    properties = @{
                        addressPrefix = "192.168.1.0/24"
                    }
                }
            )
        }
    )
    # Resource group to deploy vnet to
    ResourceGroup = "ResourceGroupName"

    # Will accept Subscription Name or Subscription Id
    Subscription = "SubscriptionNameorId"

    # Peer to hub (True) - Standalone vnet (False)
    PeerToHub = $false
}