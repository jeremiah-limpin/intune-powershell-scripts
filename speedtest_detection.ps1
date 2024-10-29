# Get the file path of the Documents folder in OneDrive
$oneDriveDocuments = Join-Path $env:OneDrive "Documents"

# Define paths for the Speedtest folder, executable, results file, and timestamp file
$speedtestFolder = Join-Path $oneDriveDocuments "Speedtest"
$computerName = $env:COMPUTERNAME
$resultsFilePath = Join-Path $speedtestFolder "Speedtest_result_of_$computerName.xml"
$timestampFile = Join-Path $speedtestFolder "last_run_timestamp.txt"

# Check if the Speedtest folder and files exist
if (-Not (Test-Path $resultsFilePath)) {
    Write-Host "Required files or folder missing, triggering remediation."
    exit 1
}

# Check if 30 days have passed since the last run
$runInterval = 1  # in days
$currentDate = Get-Date

if (Test-Path $timestampFile) {
    $lastRunDate = Get-Content -Path $timestampFile | Out-String | Get-Date
    $daysSinceLastRun = ($currentDate - $lastRunDate).Days
    if ($daysSinceLastRun -ge $runInterval) {
        Write-Host "1 days have passed since last run. Triggering remediation."
        exit 1
    } else {
        Write-Host "Detection successful: All files are present and 30 days have not yet passed."
        exit 0
    }
} else {
    # If timestamp file doesn't exist, trigger remediation and create the file
    Write-Host "No previous timestamp found. Triggering initial remediation."
    exit 1
}

# Update the timestamp file after remediation runs
$currentDate | Out-File -FilePath $timestampFile -Force