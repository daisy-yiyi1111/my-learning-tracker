# Fix page file configuration - remove corrupted E: setting, restore system-managed on C:
$path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"

try {
    # Remove the broken PagingFiles entry pointing to E:
    Remove-ItemProperty -Path $path -Name "PagingFiles" -Force -ErrorAction Stop
    Write-Host "[OK] Removed broken PagingFiles entry (was: E:\pagefile.sys 0 0)"
} catch {
    Write-Host "[!] Failed to remove PagingFiles: $_"
}

# Enable automatic page file management
try {
    $comp = Get-WmiObject -Class Win32_ComputerSystem
    $comp.AutomaticManagedPagefile = $true
    $comp.Put() | Out-Null
    Write-Host "[OK] Enabled system-managed page file"
} catch {
    Write-Host "[!] WMI method failed, trying alternative..."
    # Alternative: set PagingFiles to empty (Windows defaults to system-managed on OS drive)
    try {
        New-ItemProperty -Path $path -Name "PagingFiles" -Value @("") -PropertyType MultiString -Force | Out-Null
        Write-Host "[OK] Set PagingFiles to default (empty)"
    } catch {
        Write-Host "[!] Alternative also failed: $_"
    }
}

# Show the result
Write-Host ""
Write-Host "Current PagingFiles config:"
Get-ItemProperty -Path $path | Select-Object PagingFiles, ExistingPageFiles | Format-List

Write-Host ""
Write-Host "Done! Restart your computer for changes to take effect."
Read-Host "Press Enter to exit"
