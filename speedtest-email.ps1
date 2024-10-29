# Get the file path of Documents folder in OneDrive
$oneDriveDocuments = Join-Path $env:OneDrive "Documents"

# Validate if OneDrive path exists
if (-Not (Test-Path $oneDriveDocuments)) {
    Write-Error "OneDrive path not found: $oneDriveDocuments"
    exit
}

# Create a folder for Speedtest
$speedtestFolder = "$oneDriveDocuments\Speedtest"
$speedtestExe = Join-Path $speedtestFolder "speedtest.exe"
$resultsFilePath = Join-Path $speedtestFolder "Speedtest_result_of_$env:COMPUTERNAME.txt"
$logFile = Join-Path $speedtestFolder "log.txt"

# Ensure speedtest folder exists
try {
    if (-Not (Test-Path $speedtestFolder)) {
        New-Item -Path $speedtestFolder -ItemType Directory -Force
        Write-Host "Speedtest folder created at: $speedtestFolder"
    }
} catch {
    Write-Error "Failed to create Speedtest folder: $_"
    "[$(Get-Date)] Error: $_" | Out-File -FilePath $logFile -Append
    exit
}

# Download Speedtest CLI with retry logic
try {
    if (-Not (Test-Path $speedtestExe)) {
        Write-Host "Speedtest CLI not found. Downloading..."
        $maxRetries = 3
        for ($retryCount = 0; $retryCount -lt $maxRetries; $retryCount++) {
            try {
                Invoke-WebRequest -Uri "https://install.speedtest.net/app/cli/ookla-speedtest-1.0.0-win64.zip" -OutFile "$speedtestFolder\speedtest.zip"
                Expand-Archive -Path "$speedtestFolder\speedtest.zip" -DestinationPath $speedtestFolder
                Remove-Item "$speedtestFolder\speedtest.zip" -Force  # Cleanup
                break
            } catch {
                if ($retryCount -eq $maxRetries - 1) {
                    throw "Max retries reached for downloading Speedtest CLI."
                }
                Write-Warning "Retrying download... Attempt $($retryCount + 1) of $maxRetries"
                Start-Sleep -Seconds 5
            }
        }
    }
} catch {
    Write-Error "Error downloading or extracting Speedtest CLI: $_"
    "[$(Get-Date)] Error: $_" | Out-File -FilePath $logFile -Append
    exit
}

# Run Speedtest and output results
try {
    & $speedtestExe --accept-license --accept-gdpr | Out-File -FilePath $resultsFilePath -Encoding UTF8
    Write-Host "Speedtest results saved to: $resultsFilePath"
} catch {
    Write-Error "Error running Speedtest: $_"
    "[$(Get-Date)] Error: $_" | Out-File -FilePath $logFile -Append
    exit
}

# Send email with results
try {
    $Outlook = Get-Process -Name "OUTLOOK" -ErrorAction SilentlyContinue
    if (-Not $Outlook) {
        Write-Warning "Outlook is not running or installed. Cannot send the email."
        exit
    }

    $OutlookApp = New-Object -ComObject Outlook.Application
    $Mail = $OutlookApp.CreateItem(0)
    $Mail.Subject = "Speedtest Results for $env:COMPUTERNAME"
    $Mail.Body = "Attached are the Speedtest results for $env:COMPUTERNAME."
    $Mail.To = "helpdesk@thebackroomop.com"
    $Mail.Attachments.Add($resultsFilePath)
    $Mail.Send()
    Write-Host "Email sent successfully with Speedtest results."
} catch {
    Write-Error "Error sending email: $_"
    "[$(Get-Date)] Error: $_" | Out-File -FilePath $logFile -Append
}

# Clean up temporary files
$temporaryFiles = Join-Path $speedtestFolder "*.tmp"
if (Test-Path $temporaryFiles) {
    Remove-Item $temporaryFiles -Force -ErrorAction SilentlyContinue
}