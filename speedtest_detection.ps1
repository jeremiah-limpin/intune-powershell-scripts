# Get the file path of the Documents folder in OneDrive
$oneDriveDocuments = Join-Path $env:OneDrive "Documents"

# Define paths for the Speedtest folder, executable, results file, and timestamp file
$speedtestFolder = Join-Path $oneDriveDocuments "Speedtest"
$computerName = $env:COMPUTERNAME
$resultsFilePath = Join-Path $speedtestFolder "speedtest_result_of_$computerName.txt"
$timestampFile = Join-Path $speedtestFolder "last_run_timestamp.txt"

# Check if the Speedtest folder and files exist
if (-Not (Test-Path $resultsFilePath)) {
    # Required files or folder missing, triggering remediation."
    exit 1
}

# Check if X number of days have passed since the last run
$runInterval = 30  # in days
$currentDate = Get-Date

if (Test-Path $timestampFile) {
    $lastRunDate = Get-Content -Path $timestampFile | Out-String | Get-Date
    $daysSinceLastRun = ($currentDate - $lastRunDate).Days
    if ($daysSinceLastRun -ge $runInterval) {
        # 30 day/s have passed since last run. Triggering remediation."
        exit 1
    } else {
        # Detection successful: All files are present and 30 days have not yet passed."
        exit 0
    }
} else {
    # If timestamp file doesn't exist, trigger remediation and create the file
    exit 1
}

# Update the timestamp file after remediation runs
$currentDate | Out-File -FilePath $timestampFile -Force

# This script is developed by Jeremiah Limpin https://github.com/jeremiah-limpin