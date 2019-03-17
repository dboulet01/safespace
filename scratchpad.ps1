$arguments = @{
    VNetMetadata = @(
        @{
            name = "TestSpokeVnet2"
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
    ResourceGroup = "TestSpokeVnet2"
    Subscription = ""
    PeerToNetbond = $true
}