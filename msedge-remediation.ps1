$scriptPath = "C:\Scripts\microsoft-edge.ps1"

if (Test-Path $scriptPath) {
    powershell.exe -ExecutionPolicy Bypass -File $scriptPath
} else {
    # Exit with code 2 to indicate an error, script is not found."
    exit 2
}

# This script is developed by Jeremiah Limpin https://github.com/jeremiah-limpin