# Script to remove the Microsoft Teams consumer app on Windows 11
try {
    
    # Check if the app is installed before attempting removal
    $teamsApp = Get-AppxPackage -Name MicrosoftTeams -ErrorAction SilentlyContinue
    if ($null -eq $teamsApp) {
        # Microsoft Teams (personal) app not found. Nothing to remove
        exit 0
    }
    # Remove the Teams app
    $teamsApp | Remove-AppxPackage -ErrorAction Stop
    # Microsoft Teams (personal) app successfully removed
    exit 0

} catch {
    # Error removing Microsoft Teams (personal) app
    exit 2
}
# This script is developed by Jeremiah Limpin https://github.com/jeremiah-limpin