using namespace System.Management.Automation
using namespace System.Management.Automation.Language

# Import Modules and External Profiles
# Ensure Terminal-Icons module is installed before importing
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -SkipPublisherCheck
}
Import-Module -Name Terminal-Icons

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

$profileDir = $PSScriptRoot;
$SWPDM_Scripts = "$profileDir\SolidworksPDM.ps1"
$PSReadLine_Scripts = "$profileDir\PSReadLineProfile.ps1"

. $SWPDM_Scripts
. $PSReadLine_Scripts

$env:path += ";$ProfileDir\Scripts"

function Set-WindowTitle {
    $host.UI.RawUI.WindowTitle = [string]::Join(" ", $args)
}

function prompt {
    Write-Host $ExecutionContext.SessionState.Path.CurrentLocation -ForegroundColor Green
    Write-Host "$('>:' * ($nestedPromptLevel + 1))" -NoNewLine
    return " "
}

function Show-Colors( ) {
    $colors = [Enum]::GetValues( [ConsoleColor] )
    $max = ($colors | ForEach-Object { "$_ ".Length } | Measure-Object -Maximum).Maximum
    foreach ( $color in $colors ) {
        Write-Host (" {0,2} {1,$max} " -f [int]$color, $color) -NoNewline
        Write-Host "$color" -Foreground $color
    }
}

Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

Set-Alias -name "title" -value Set-WindowTitle

## Final Line to set prompt

# Starship
Invoke-Expression (&starship init powershell)

# oh-my-posh
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\cobalt2.omp.json" | Invoke-Expression
# if (Get-Command zoxide -ErrorAction SilentlyContinue) {
#     Invoke-Expression (& { (zoxide init powershell | Out-String) })
# } else {
#     Write-Host "zoxide command not found. Attempting to install via winget..."
#     try {
#         winget install -e --id ajeetdsouza.zoxide
#         Write-Host "zoxide installed successfully. Initializing..."
#         Invoke-Expression (& { (zoxide init powershell | Out-String) })
#     } catch {
#         Write-Error "Failed to install zoxide. Error: $_"
#     }
# }