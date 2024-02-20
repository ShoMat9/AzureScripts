$ShoReport = Get-Date -UFormat "C:\X-Sho\Scripts\Reports\vNET-Subnet-%Y%b%d@%I%M%p.csv" <# Change Output Location /#>
$ShoStyle = "<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;Font-Size: 8pt;Font-Family: Tahoma, sans-serif;}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #bc64ed;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
</style>"

Get-AzSubscription | Foreach-Object {
    $sub = Set-AzContext -SubscriptionId $_.SubscriptionId
    $vnets = Get-AzVirtualNetwork

    foreach ($vnet in $vnets) {
        [PSCustomObject]@{
            Subscription = $sub.Subscription.Name
            Name = $vnet.Name
            Vnet = $vnet.AddressSpace.AddressPrefixes -join ', '
            Subnets = $vnet.Subnets.AddressPrefix -join ', '
			SubnetName = $vnet.Subnets.name -join  ', '
        }
    }
} | ConvertTo-Html -head $ShoStyle | out-file $ShoReport
