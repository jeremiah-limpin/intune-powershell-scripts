# Define the TeamViewer uninstall executable file
$UninstallPath = "C:\Program Files\TeamViewer\uninstall.exe"

# Check if the uninstall string is found
if (-Not(Test-Path $UninstallPath)) {
    # Run the uninstall executable file
    exit 1
} else {
    # File not found
    exit 0
}
