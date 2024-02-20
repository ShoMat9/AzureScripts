Set-AzContext -SubscriptionName Sub
$IPs = "IP1","IP2","IP3"

foreach ($IP in $IPs)
{
$VMID = (Get-AzNetworkInterface | where {$_.IpConfigurations.PrivateIpAddress -eq $IP}).VirtualMachine.Id
If (!$VMID) {
Write-Host "$IP Not Found"
}
ELSE {
$VMName = $VMID.Substring($VMID.LastIndexOf('virtualMachines/')+16)
Write-Host "$VMName"
}
}
