## Dirty but Quick script to get the dates when VMs were created in Azure.
## You know what to edit!!

Select-AzSubscription -SubscriptionName sub1

$vmName = "abc",
"prq",
"xyz"

foreach ($vmx in $vmName) {
	$vm = Get-AzVM -Name $vmx
    $vmName = $vm.Name
    $resourceGroupName = $vm.ResourceGroupName
    $vmDetails = Get-AzResource -ResourceGroupName $resourceGroupName -Name $vmName -ResourceType "Microsoft.Compute/virtualMachines"
    $creationDate = $vmDetails.Properties.storageProfile.osDisk.osType
	  $Diskname = $vmDetails.Properties.storageProfile.osDisk.name
	  $osDiskcreated = (Get-AzDisk -ResourceGroupName $resourceGroupName -DiskName $Diskname).timecreated
    Write-Output "VM Name: $vmName | Date Created: $osDiskcreated "
}
