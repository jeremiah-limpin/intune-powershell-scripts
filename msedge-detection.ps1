# Define the PowerShell script content to open Microsoft Edge
$scriptContent = @"
Start-Process 'msedge.exe'
"@

# Define the file path for the PowerShell script
$scriptPath = "C:\Scripts\microsoft-edge.ps1"

if (-not (Test-Path $scriptPath)) {
    # If the script file is not found, create it with specified content
    Set-Content -Path $scriptPath -Value $scriptContent
    
    # Define the task action to run the script
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File `"$scriptPath`""
    
    # Define the task trigger for system startup
    $trigger = New-ScheduledTaskTrigger -AtStartup
    
    # Define the task settings
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
    
    # Register the scheduled task
    Register-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -TaskName "OpenMicrosoftEdge" -Description "Opens Microsoft Edge at startup if the script is missing"
    
    # Exit with code 1 to indicate remediation occurred
    exit 1
} else {
    # Exit with code 0 if the script exists
    exit 0
}
# This script is developed by Jeremiah Limpin https://github.com/jeremiah-limpin