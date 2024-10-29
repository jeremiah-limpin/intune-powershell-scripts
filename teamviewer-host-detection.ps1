# Check if "TeamViewer Host" is installed
$TeamViewer = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -eq "TeamViewer Host"}
if ($TeamViewer) {
    # TeamViewer Host is installed
    exit 1
} else {
    # TeamViewer Host is not installed
    exit 0
}
