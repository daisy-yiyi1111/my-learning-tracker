$c = Get-WmiObject Win32_ComputerSystem
$c.AutomaticManagedPagefile = $true
$c.Put() | Out-Null
Write-Host "[OK] AutomaticManagedPagefile set to True"
Write-Host "Current status:"
(Get-WmiObject Win32_ComputerSystem).AutomaticManagedPagefile
Read-Host "Press Enter to exit"
