$scriptPath = "C:\Scripts\microsoft-edge.ps1"

if (Test-Path $scriptPath) {
    powershell.exe -ExecutionPolicy Bypass -File $scriptPath
} else {
    exit 2 # Exit with code 2 to indicate an error, script is not found."
}