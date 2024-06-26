# You know what to edit :)

$subscriptionName = sub1
$vmNames = "abc", "pqr", "xyz"
$ShoReport = Get-Date -UFormat "C:\Reports\VM-NSG-x-%Y%b%d@%I%M%p.html"

#######################################################
Select-AzSubscription  $subscriptionName

$ShoStyle = "<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;Font-Size: 8pt;Font-Family: Tahoma, sans-serif;}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #bc64ed;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
</style>"

foreach ($vm in $vmName)
{   
$vmx = Get-AzVM -Name $vm
$resourceGroupName = $vmx.ResourceGroupName
$report +=  Get-AzVM -ResourceGroupName $ResourceGroupName -Name $vm | Select Name,
@{N='IP';E={(Get-AzNetworkInterface -Name $_.NetworkProfile.NetworkInterfaces.ID.Split('/')[-1]).IpConfigurations.PrivateIpAddress.Split('/')[-1]}},
@{N='NIC';E={$_.NetworkProfile.NetworkInterfaces.ID.Split('/')[-1]}}, 
@{N='Subnet';E={(Get-AzNetworkInterface -Name $_.NetworkProfile.NetworkInterfaces[0].Id.Split('/')[-1]).IpConfigurations[0].Subnet.Id.split('/')[-1]}},
@{N='NSG';E={(Get-AzNetworkInterface -Name $_.NetworkProfile.NetworkInterfaces.ID.Split('/')[-1]).NetworkSecurityGroup.Id.Split('/')[-1]}},
@{N='ASG';E={(Get-AzNetworkInterface -Name $_.NetworkProfile.NetworkInterfaces.ID.Split('/')[-1]).IpConfigurations.ApplicationSecurityGroups.Id.Split('/')[-1]}}
}

$report | ConvertTo-Html -head $ShoStyle | out-file $ShoReport
######################################################

$csvData = Import-Csv -Path "C:\X-Sho\Scripts\CSV\vms-csv.csv"
$vmData = @()

foreach ($row in $csvData) {
    $currentSubscription = (Get-AzContext).Subscription.Name
    $subscriptionname = $row.SUBSCRIPTION

    if ($subscriptionname -ne $currentSubscription) {
        Set-AzContext -SubscriptionName $subscriptionname
        $currentSubscription = $subscriptionname
    }

    $resourceGroupName = $row.'RESOURCEGROUP'
    $vmName = $row.NAME

    $vmInfo = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName | Select-Object Name,
    @{N='IP'; E={(Get-AzNetworkInterface -Name $_.NetworkProfile.NetworkInterfaces.ID.Split('/')[-1]).IpConfigurations.PrivateIpAddress.Split('/')[-1]}},
    @{N='NIC'; E={$_.NetworkProfile.NetworkInterfaces.ID.Split('/')[-1]}},
    @{N='Subnet'; E={(Get-AzNetworkInterface -Name $_.NetworkProfile.NetworkInterfaces[0].Id.Split('/')[-1]).IpConfigurations[0].Subnet.Id.Split('/')[-1]}},
    @{N='NSG'; E={(Get-AzNetworkInterface -Name $_.NetworkProfile.NetworkInterfaces.ID.Split('/')[-1]).NetworkSecurityGroup.Id.Split('/')[-1]}},
    @{N='ASG'; E={(Get-AzNetworkInterface -Name $_.NetworkProfile.NetworkInterfaces.ID.Split('/')[-1]).IpConfigurations.ApplicationSecurityGroups.Id.Split('/')[-1]}}

    $vmData += $vmInfo
}

$htmlContent = $vmData | ConvertTo-Html -head $ShoStyle -Property Name, IP, NIC, Subnet, NSG, ASG 
$htmlContent | Out-File $ShoReport
######################################################

