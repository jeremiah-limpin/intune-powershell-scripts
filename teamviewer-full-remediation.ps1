# Define the TeamViewer uninstall executable file
$UninstallPath = "C:\Program Files\TeamViewer\uninstall.exe"
# Execute the uninstall command
Start-Process -FilePath $UninstallPath -ArgumentList '/S' -Wait -PassThru