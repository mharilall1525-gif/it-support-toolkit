# ===============================
# Windows IT Support Toolkit
# ===============================

function Show-SystemInfo {
    Write-Host "`n[System Information]" -ForegroundColor Yellow
    Get-ComputerInfo | Select-Object CsName, WindowsVersion, OsArchitecture
}

function Show-Performance {
    Write-Host "`n[Performance]" -ForegroundColor Yellow
    Get-CimInstance Win32_OperatingSystem | 
    Select-Object @{Name="TotalRAM(GB)";Expression={[math]::round($_.TotalVisibleMemorySize/1MB,2)}},
                  @{Name="FreeRAM(GB)";Expression={[math]::round($_.FreePhysicalMemory/1MB,2)}}
}

function Show-TopProcesses {
    Write-Host "`n[Top Processes by CPU]" -ForegroundColor Yellow
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name, CPU
}

function Show-DiskUsage {
    Write-Host "`n[Disk Usage]" -ForegroundColor Yellow
    Get-PSDrive C | Select-Object Used, Free
}

function Show-Network {
    Write-Host "`n[Network Info]" -ForegroundColor Yellow
    ipconfig
}

function Test-Network {
    Write-Host "`n[Pinging Google]" -ForegroundColor Yellow
    Test-Connection google.com -Count 2
}

function Show-Errors {
    Write-Host "`n[Recent System Errors]" -ForegroundColor Yellow
    Get-EventLog -LogName System -EntryType Error -Newest 5 |
    Select-Object TimeGenerated, Source, Message
}

function Clear-Temp {
    Write-Host "`n[Clearing Temp Files]" -ForegroundColor Yellow
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Temp files cleared." -ForegroundColor Green
}

function Export-Report {
    Write-Host "`n[Exporting Report]" -ForegroundColor Yellow

    $output = @()

    $output += "=== SYSTEM INFO ==="
    $output += Get-ComputerInfo | Select-Object CsName, WindowsVersion, OsArchitecture | Out-String

    $output += "=== PERFORMANCE ==="
    $output += Get-CimInstance Win32_OperatingSystem | 
    Select-Object @{Name="TotalRAM(GB)";Expression={[math]::round($_.TotalVisibleMemorySize/1MB,2)}},
                  @{Name="FreeRAM(GB)";Expression={[math]::round($_.FreePhysicalMemory/1MB,2)}} | Out-String

    $output += "=== TOP PROCESSES ==="
    $output += Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name, CPU | Out-String

    $output += "=== NETWORK ==="
    $output += ipconfig | Out-String

    $output | Out-File "report.txt"

    Write-Host "Report saved as report.txt" -ForegroundColor Green
}

# ===============================
# MAIN MENU LOOP
# ===============================

while ($true) {
    Write-Host "`n=== IT Support Toolkit ===" -ForegroundColor Cyan
    Write-Host "1. Full System Scan"
    Write-Host "2. Check Network"
    Write-Host "3. View Error Logs"
    Write-Host "4. Clear Temp Files"
    Write-Host "5. Export Report"
    Write-Host "6. Exit"

    $choice = Read-Host "Select an option"

    switch ($choice) {
        "1" {
            Show-SystemInfo
            Show-Performance
            Show-TopProcesses
            Show-DiskUsage
            Test-Network
            Show-Errors
        }
        "2" {
            Show-Network
            Test-Network
        }
        "3" {
            Show-Errors
        }
        "4" {
            Clear-Temp
        }
        "5" {
            Export-Report
        }
        "6" {
            Write-Host "Exiting..." -ForegroundColor Red
            break
        }
        default {
            Write-Host "Invalid option. Try again." -ForegroundColor Red
        }
    }
}