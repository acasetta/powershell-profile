$processes = "DesktopInterface"
foreach ($process in $processes)
{
    Write-Host “Stopping process $process ...”
    Get-Process $process -ErrorAction SilentlyContinue | Stop-Process
}