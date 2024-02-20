Set-AzContext -SubscriptionName sub

$SourceVM = "abc"
$DestinationVM = "xyz"
$SVM = Get-AzVM -name $SourceVM
$sourceTags = ($SVM).Tags
$DVM = Get-AzVM -name $DestinationVM

Set-AzResource -ResourceID ($DVM).ID -Tag $sourceTags -Force

