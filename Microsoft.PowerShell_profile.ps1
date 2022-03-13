using namespace System.Management.Automation
using namespace System.Management.Automation.Language

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

Set-Alias -name "title" -value Set-WindowTitle

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
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