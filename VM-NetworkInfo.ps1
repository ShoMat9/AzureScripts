## You know what to edit :)

$resourceGroupName = "RG Name"
$vmName = "VM1","VM2","VM3"
$ShoReport = Get-Date -UFormat "C:\Reports\VM-NSG-x-%Y%b%d@%I%M%p.html"

######################################################
$ShoStyle = "<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;Font-Size: 8pt;Font-Family: Tahoma, sans-serif;}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #bc64ed;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
</style>"

foreach ($vm1 in $vmName)
{   
$report +=  Get-AzVM -ResourceGroupName $resourceGroupName -Name $vm1 | Select Name,
@{N='NIC';E={$_.NetworkProfile.NetworkInterfaces.ID.Split('/')[-1]}}, 
@{N='IP';E={(Get-AzNetworkInterface -Name $_.NetworkProfile.NetworkInterfaces.ID.Split('/')[-1]).IpConfigurations.PrivateIpAddress.Split('/')[-1]}},
@{N='NSG';E={(Get-AzNetworkInterface -Name $_.NetworkProfile.NetworkInterfaces.ID.Split('/')[-1]).NetworkSecurityGroup.Id.Split('/')[-1]}},
@{N='subnetName';E={(Get-AzNetworkInterface -Name $_.NetworkProfile.NetworkInterfaces[0].Id.Split('/')[-1]).IpConfigurations[0].Subnet.Id.split('/')[-1]}} 
}

$report | ConvertTo-Html -head $ShoStyle | out-file $ShoReport
######################################################
