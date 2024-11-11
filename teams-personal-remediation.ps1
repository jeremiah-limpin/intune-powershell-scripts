# Script to remove the Microsoft Teams consumer app on Windows 11
$teamsApp = Get-AppxPackage -Name MicrosoftTeams -ErrorAction SilentlyContinue

if ($teamsApp) {
    # Attempt to remove the Microsoft Teams (personal) app
    try {
        $teamsApp | Remove-AppxPackage -ErrorAction Stop
        exit 0  # Exit with code 0 if successful
    } catch {
        # If removal fails, exit with code 2 (indicating an error occurred)
        exit 2
    }
} else {
    # Exit with code 0 if Teams was not found, indicating no action needed
    exit 0
}
# This script is developed by Jeremiah Limpin https://github.com/jeremiah-limpin