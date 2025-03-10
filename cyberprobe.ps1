# CyberProbe - Basic Troubleshooting Commands for Windows

# Function to check network connectivity
function Test-NetworkConnectivity {
    param (
        [string]$Target = "google.com"
    )
    Write-Host "Pinging $Target..."
    Test-Connection -ComputerName $Target -Count 4
}

# Function to check disk usage
function Get-DiskUsage {
    Write-Host "Checking disk usage..."
    Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{Name="Used(GB)";Expression={[math]::round($_.Used/1GB,2)}}, @{Name="Free(GB)";Expression={[math]::round($_.Free/1GB,2)}}, @{Name="Total(GB)";Expression={[math]::round($_.Used/1GB + $_.Free/1GB,2)}}
}

# Function to get system information
function Get-SystemInfo {
    Write-Host "Getting system information..."
    Get-ComputerInfo
}

# Function to check running processes
function Get-RunningProcesses {
    Write-Host "Checking running processes..."
    Get-Process | Select-Object Id, ProcessName, CPU, WS
}

# Function to check installed updates
function Get-InstalledUpdates {
    Write-Host "Checking installed updates..."
    Get-HotFix
}

# Function to check event logs
function Get-EventLogs {
    param (
        [string]$LogName = "System"
    )
    Write-Host "Checking event logs for $LogName..."
    Get-EventLog -LogName $LogName -Newest 20
}

# Function to check if the user has administrative privileges
function Check-AdminPrivileges {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    if ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "You have administrative privileges."
        return $true
    } else {
        Write-Host "You do not have administrative privileges."
        return $false
    }
}

# Function to backup Windows
function Backup-Windows {
    param (
        [string]$BackupLocation
    )
    if (-not (Check-AdminPrivileges)) {
        Write-Host "You need to run this script as an administrator to perform a backup."
        return
    }
    Write-Host "Starting Windows backup to $BackupLocation..."
    wbadmin start backup -backupTarget:$BackupLocation -include:C: -allCritical -quiet
    Write-Host "Backup completed."
}

# Main script
Write-Host "Choose a troubleshooting command:"
Write-Host "1) Test Network Connectivity"
Write-Host "2) Check Disk Usage"
Write-Host "3) Get System Information"
Write-Host "4) Check Running Processes"
Write-Host "5) Check Installed Updates"
Write-Host "6) Check Event Logs"
Write-Host "7) Backup Windows"
Write-Host "8) Check User Privileges"
Write-Host "9) Exit"
$choice = Read-Host "Enter the number of your choice"

switch ($choice) {
    1 {
        $target = Read-Host "Enter the target to ping (default: google.com)"
        if (-not $target) { $target = "google.com" }
        Test-NetworkConnectivity -Target $target
    }
    2 {
        Get-DiskUsage
    }
    3 {
        Get-SystemInfo
    }
    4 {
        Get-RunningProcesses
    }
    5 {
        Get-InstalledUpdates
    }
    6 {
        $logName = Read-Host "Enter the event log name (default: System)"
        if (-not $logName) { $logName = "System" }
        Get-EventLogs -LogName $logName
    }
    7 {
        $backupLocation = Read-Host "Enter the backup location (e.g., D:\Backup)"
        Backup-Windows -BackupLocation $backupLocation
    }
    8 {
        Check-AdminPrivileges
    }
    9 {
        Write-Host "Exiting..."
        exit
    }
    default {
        Write-Host "Invalid choice. Please choose a number between 1 and 9."
    }
}