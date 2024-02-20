Set-AzContext -SubscriptionName <Subscription Name>
$newVMSize = "Standard_B1ms"  
$resourceGroupName = "<Resource Group Name>"
$vmName = "VM-1","VM-2"
foreach ($vm1 in $vmName)
{
$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vm1
        $vm = Get-AzVM -ResourceGroupName $ResourceGroupName -VMName $vm1
        $vm.HardwareProfile.VmSize = $newVMSize
        Update-AzVM -VM $vm -ResourceGroupName $ResourceGroupName
        Write-Host "$vm1 resized to $newVMSize."
}
