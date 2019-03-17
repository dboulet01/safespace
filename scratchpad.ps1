$arguments = @{
    VNetMetadata = @(
        @{
            name = "TestSpokeVnet0"
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
    ResourceGroup = "TestSpokeVnets"
    Subscription = ""
    PeerToHub = $true
}