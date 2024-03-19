## You know what to edit!!

$SubscriptionName = "sub1"  
$SourceVM = "abc"
$DestinationVM = "xyz"

Set-AzContext -SubscriptionName $SubscriptionName
$SVM = Get-AzVM -name $SourceVM
$sourceTags = ($SVM).Tags
$DVM = Get-AzVM -name $DestinationVM

Set-AzResource -ResourceID ($DVM).ID -Tag $sourceTags -Force

