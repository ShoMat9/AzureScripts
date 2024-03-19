# You know what to modify

Set-AzContext -SubscriptionName SUB1 ; $VmResourceGroup = "RG1"; $VmName = "VM1" 

#####################################
$vm = get-azvm -Name $VmName -ResourceGroupName $VmResourceGroup
$snapshotdisk = $vm.StorageProfile
$OSDiskSnapshotConfig = New-AzSnapshotConfig -SourceUri $snapshotdisk.OsDisk.ManagedDisk.id -CreateOption Copy -OsType Windows -AccountType Standard_LRS -location "Australia East"
$snapshotNameOS = "$($snapshotdisk.OsDisk.Name)_snapshot_$(Get-Date -Format "yyyyMMdd-HHmmss")"
#$snapshotNameOS = "$($vmname)_OSdisk_snapshot_$(Get-Date -Format "yyyyMMdd-HHmmss")"
try {New-AzSnapshot -ResourceGroupName $VmResourceGroup -SnapshotName $snapshotNameOS -Snapshot $OSDiskSnapshotConfig -ErrorAction Stop} catch {$_}
$dataDisks = ($snapshotdisk.DataDisks).name
foreach ($datadisk in $datadisks) 
{
$dataDisk = Get-AzDisk -ResourceGroupName $vm.ResourceGroupName -DiskName $datadisk
$DataDiskSnapshotConfig = New-AzSnapshotConfig -SourceUri $dataDisk.Id -CreateOption Copy -AccountType Standard_LRS -location "Australia East"
$snapshotNameData = "$($datadisk.name)_snapshot_$(Get-Date -Format "yyyyMMdd-HHmmss")"
#$snapshotNameData = "$($vmname)_datadisk_snapshot_$(Get-Date -Format "yyyyMMdd-HHmmss")"
New-AzSnapshot -ResourceGroupName $VmResourceGroup -SnapshotName $snapshotNameData -Snapshot $DataDiskSnapshotConfig -ErrorAction Stop
}
#####################################
