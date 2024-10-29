# Define the file path for the powershell script that opens MS Edge
$scriptPath = "C:\Scripts\microsoft-edge.ps1"

if (-not (Test-Path $scriptPath)) {
    # If file not found, proceeds the remediation script
    exit 1
}else{
    exit 0
}