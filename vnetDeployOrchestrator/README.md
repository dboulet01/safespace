# vnetOrchestrator
###### Assumes Az module is installed
>    Install-Module Az

###### Assume you're logged into Azure
>    Login-AzAccount

## Setup

1. Load vnetDeploy.ps1
    - clone repository
    - confirm current directory: vnetOrchestrator
    - dotsource vnetDeploy.ps1
> PS /Users/user/scripts/vnetOrchestrator>. ./vnetDeploy.ps1

2. Edit vnetDeployMetaData.ps1 and set additional arguments
    - define Vnet configuration
    - set deploy parameters

3. Save and run/dotsource metadata file to load arguments/metadata into $arguments variable
> PS /Users/user/scripts/vnetOrchestrator>. ./vnetDeployMetaData.ps1

4. Call function and splat arguments
> New-AzureVnet @arguments


## vnetDeployMetaData Structure

###### Full Structure

Example:

<pre>
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
    PeerToHub = $true/$false
}
</pre>

Description:

<pre>
    <i>Top level arguments variable that is fed to New-AzureVnet cmdlet.</i>

        $arguments = @{
            
    <i>VnetMetadata object that is consumed by vnetDeploy.ps1 and pushed to the ARM templates. It is an array of Vnet objects.</i>

            VNetMetadata = @(

    <i>Vnet object - defined by @{} - consists of name parameter, addressPrefixes array of strings, and subnets array of objects.</i>

                @{

    <i>name parameter - value is a string that indicates the name of the Vnet.</i>

                    name = "VnetName"

    <i>addressPrefixes array - defined by @() - contains an array of strings that defines the CIDR block addressSpace for the Vnet -  multiple addressPrefixes can be defined.</i>

                    addressPrefixes = @(
                        "192.168.0.0/16"
                    )

    <i>subnets array - defined by @() - contains an array of objects that define the subnets that will be created - multiple subnet   objects can be defined separated by ','</i>

                    subnets = @(

    <i>subnet object - defined by @{} - consists of name parameter and properties object.</i>

                        @{

    <i>subnet name parameter - value is a string that indicates the name of the subnet.</i>

                            name = "SubnetName"

    <i>subnet properties object - defined by @{} - consists of addressPrefix parameter - only one properties object can be defined per subnet.</i>

                            properties = @{

    <i>addressPrefix parameter - value is a string that indicates the CIDR block address space used by the subnet - only one  addressPrefix can be defined per subnet.</i>

                                addressPrefix = "192.168.1.0/24"
                            }
                        }
                    )
                }
            )

    <i>resourcegroup parameter - value is a string that declares the resource group the Vnet will be deployed into or currently exists in.</i>

            # Resource group to deploy vnet to
            ResourceGroup = "ResourceGroupName"

    <i>subscription parameter - value is a string that will be used to set the Azure context for Vnet deployment.</i>

            # Will accept Subscription Name or Subscription Id
            Subscription = "SubscriptionNameorId"

    <i>peer to hub switch - boolean value to indicate whether or not a newly created or existing Vnet should be peered to the hub Vnet -  $false = False, $true = True.</i>

            # Peer to hub (True) - Standalone vnet (False)
            PeerToHub = $true/$false
        }
</pre>

###### Vnet Object Structure

<pre>
    <i>Vnet Object</i>

    @{
        name = ""
        addressPrefixes = @()
        subnets = @()
    }
</pre>

###### Address Prefix Array

<pre>
    <i>Within Vnet Object</i>

    addressPrefixes = @(
        "10.0.0.0/16"
        "172.16.0.0/16"
        "192.168.0.0/16"
    )
</pre>


###### Multi-Subnet Structure

<pre>
    <i>Subnet Array within Vnet object</i>

    subnets = @(
        @{
            name = "Subnet1"
            properties = @{
                addressPrefix = "10.0.1.0/24"
            }
        },
        @{
            name = "Subnet2"
            properties = @{
                addressPrefix = "10.0.2.0/24"
            }
        },
        @{
            name = "Subnet3"
            properties = @{
                addressPrefix = "10.0.3.0/24"
            }
        }
    )
</pre>

## Additional Usage Information

###### Peer an existing Vnet to hub
1. Provide only a name of an existing Vnet within Vnet object
    - Do not define or provide addressPrefixes and subnets array
2. Set PeerToHub - $true
    
    <pre>

        <i>Vnet Object:</i>

        @{
            name = "VnetName"
        }

        <i>PeerToHub argument:</i>

        PeerToHub = $true
    </pre>

###### Create standalone Vnet
1. Provide Vnet object
2. Set PeerToHub - $false
    
    <pre>
        <i>Vnet Object:</i>

        @{
            name = "VnetName
            addressPrefixes = @(
                "10.0.0.0/16"
            )
            subnets = @(
                @{
                    name = "SubnetName"
                    properties = @{
                        addressPrefix = "10.0.1.0/24"
                    }
                }
            )
        }

        <i>PeerToHub argument:</i>
        
        PeerToHub = $false
    </pre>

###### Create Vnet and peer to hub
1. Provide Vnet object
2. Set PeerToHub - $true

    <pre>
        <i>Vnet Object:</i>

        @{
            name = "VnetName
            addressPrefixes = @(
                "10.0.0.0/16"
            )
            subnets = @(
                @{
                    name = "SubnetName"
                    properties = @{
                        addressPrefix = "10.0.1.0/24"
                    }
                }
            )
        }

        <i>PeerToHub argument:</i>
        
        PeerToHub = $true
    </pre>