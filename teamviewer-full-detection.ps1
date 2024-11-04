# Define the TeamViewer uninstall executable file
$UninstallPath = "C:\Program Files\TeamViewer\uninstall.exe"

# Check if the uninstall string is found
if (Test-Path $UninstallPath) {
    # Run the uninstall executable file (uninstall)
    exit 1
} else {
    # TeamViewer Full is not found
    exit 0
}
# This script is developed by Jeremiah Limpin https://github.com/jeremiah-limpin