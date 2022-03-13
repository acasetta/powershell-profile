function Restart-SWPDMExplorer {
    Get-Process addinsrv -ErrorAction SilentlyContinue | Stop-Process
    Get-Process EdmServer -ErrorAction SilentlyContinue | Stop-Process
    Get-Process Explorer -ErrorAction SilentlyContinue | Stop-Process
    Get-Process ViewServer -ErrorAction SilentlyContinue | Stop-Process
    
    Start-Process explorer.exe
}