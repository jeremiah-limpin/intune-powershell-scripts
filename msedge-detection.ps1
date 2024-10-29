# Define the PowerShell script to open Microsoft Edge
$scriptContent = @"
Start-Process "msedge.exe"
"@

# Define the file path for the powershell script that opens MS Edge
$scriptPath = "C:\Scripts\microsoft-edge.ps1"

if (-not (Test-Path $scriptPath)) {
    # If file not found, proceeds the remediation script
    Set-Content -Path $scriptPath -Value $scriptContent

    # Define the task trigger for first boot
    $trigger = New-ScheduledTaskTrigger -AtStartup

    # Define the task settings
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

    # Register the task in Task Scheduler >> Register-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -TaskName "OpenMicrosoftEdgeAtFirstBoot" -Description "Opens Microsoft Edge upon the first boot of the device"

    # Proceeds with running the remediation script.
    exit 1
}else{
    exit 0
}