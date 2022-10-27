Param([parameter(mandatory=$true)][string]$File)
#Select right subscription
$AllSubscriptions = Get-AzSubscription | Out-String
Write-Host $AllSubscriptions
$AllSubscriptions=Get-AzSubscription
$Context = Read-Host "In which context you want to proceed ? (1 first line, 2 second line etc.)"
$Context = $Context -1
if ($Context -lt $AllSubscriptions.length) {
    Set-AzContext $AllSubscriptions[$Context]
	Get-AZContext
	#check context after change
	$Proced = Read-Host "Are you sure to proced in this context ?"
	#Parse config file
	if(($Proced -eq "yes") -or ($Proced -eq "y") -or ($Proced -eq "o") -or ($Proced -eq "oui")){
		Get-Content "$file" | ForEach-Object -Begin {$settings=@{}} -Process {$store = [regex]::split($_,'='); if(($store[0].CompareTo("") -ne 0) -and ($store[0].StartsWith("[") -ne $True) -and ($store[0].StartsWith("#") -ne $True)) {$settings.Add($store[0], $store[1])}}
		$Vnet_name = $settings.Get_Item("Vnet_name")
		$Subnet_name = $settings.Get_Item("Subnet_name")
		$Subnet_Addr = $settings.Get_Item("Subnet_Addr")
		$Route_Table_name = $settings.Get_Item("Route_Table_name")
		$Resource_group = $settings.Get_Item("Resource_group")
		$Route_Table_next_hop = $settings.Get_Item("Route_Table_next_hop")
		#Parse subnet name and subnet Addr in array
		$Subnet_name = $Subnet_name -split ","
		$Subnet_Addr = $Subnet_Addr -split ","
		$Route_Table_name = $Route_Table_name -split ","
		#Verify number of subnet name=number of subnet Addr
		if($Subnet_Addr.Count -eq $Subnet_name.Count){
			#get the Vnet informations
			$Vnet = Get-AzVirtualNetwork -Name $Vnet_name -ResourceGroupName $Resource_group
			$VnetLocation = $Vnet.location
			$VnetAdressPrefixes = $vnet.AddressSpace.AddressPrefixes
			for ($i=0; $i -lt $Subnet_name.length; $i++) {
				$route1 = New-AzRouteConfig -Name "Default" -AddressPrefix 0.0.0.0/0 -NextHopType "VirtualAppliance" -NextHopIpAddress $Route_Table_next_hop
				$route2 = New-AzRouteConfig -Name "Subnet" -AddressPrefix $Subnet_Addr[$i] -NextHopType "VnetLocal"
				$RouteList = @($route1, $route2)
				foreach ($AdressPrefixe in $VnetAdressPrefixes) {
					$route = New-AzRouteConfig -Name "Vnet" -AddressPrefix $AdressPrefixe -NextHopType "VirtualAppliance" -NextHopIpAddress $Route_Table_next_hop
					$RouteList = $RouteList + $route
				}
				$RouteTable = New-AzRouteTable -Name $Route_Table_name[$i] -ResourceGroupName $Resource_group -Location $VnetLocation -Route $RouteList
				#Create the subnet with info at position i
				Add-AzVirtualNetworkSubnetConfig -Name $Subnet_name[$i]  -VirtualNetwork $Vnet -AddressPrefix $Subnet_Addr[$i] -RouteTable $RouteTable
				#write all the modification in Azure
				$Vnet | Set-AzVirtualNetwork
			}
		}Else{Write-Host "ERROR : not the same number of subnet name and subnet addr"}
	}Else{Write-Host "ERROR : user interuption at proced level"}
}else {$test = $AllSubscriptions.length;Write-Host "ERROR : context number not valid. must be between 0 and "$test}