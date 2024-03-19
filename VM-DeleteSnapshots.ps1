# you know what to modify

Set-AzContext -SubscriptionName SUB1 ; Remove-AzSnapshot -resourcegroupname RG1 -SnapshotName SNAP1 -force
Set-AzContext -SubscriptionName SUB2 ; Remove-AzSnapshot -resourcegroupname RG2 -SnapshotName SNAP2 -force
Set-AzContext -SubscriptionName SUB3 ; Remove-AzSnapshot -resourcegroupname RG3 -SnapshotName SNAP3 -force
