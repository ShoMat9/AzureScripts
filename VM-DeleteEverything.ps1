# You know what to edit :)

$subscriptionName = sub1
$vmNames = "abc", "pqr", "xyz"

#######################################################
Select-AzSubscription $subscriptionName

foreach ($vmName in $vmNames) {

    $vm = Get-AzVM -Name $vmName
	$resourceGroupName = $vm.ResourceGroupName

       # Remove the VM
		Write-Host "Deleting VM $vmName"
        Remove-AzVM -ResourceGroupName $resourceGroupName -Name $vmName -Force
        
		# Remove the NICs
        $nics = Get-AzNetworkInterface -ResourceId $vm.NetworkProfile.NetworkInterfaces.Id
        foreach ($nic in $nics) {
			Write-Host "Deleting VM NIC $nic.name"
            Remove-AzNetworkInterface -Name $nic.Name -ResourceGroupName $resourceGroupName -Force
			}

        # Remove OS disk
		Write-Host "Deleting VM OS Disk $vm.StorageProfile.OsDisk.Name"
        Remove-AzDisk -ResourceGroupName $resourceGroupName -DiskName $vm.StorageProfile.OsDisk.Name -Force
				
        # Remove data disks
        foreach ($disk in $vm.StorageProfile.DataDisks) {
			Write-Host "Deleting VM Data Disk $disk.Name"
            Remove-AzDisk -ResourceGroupName $resourceGroupName -DiskName $disk.Name -Force
			}
}
#######################################################
