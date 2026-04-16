# ---------- NAVIGATION SHORTCUTS ----------
function .. { Set-Location .. }  # go up one folder
function c { Set-Location C:\ }  # go to C
function d { Set-Location D:\ }  # go to D
function e { Set-Location E:\ }  # go to E

function mkcd { param($name) New-Item -ItemType Directory $name; Set-Location $name } # make + cd

# Remove built-in alias
Remove-Item Alias:history -ErrorAction SilentlyContinue

# ---------- INTERNAL HELPER ----------
function Get-HistoryList {
    param(
        [Alias("T")]
        [int]$Tail,
        [switch]$U,
        [Alias("M")]
        [string]$Match
    )

    $path = (Get-PSReadLineOption).HistorySavePath
    if (-not (Test-Path $path)) { return @() }

    $lines = Get-Content $path
    $clean = $lines -replace '^\s*\d+\s+', ''

    # Filter by keyword
    if ($Match) { $clean = $clean | Where-Object { $_ -match $Match } }

    # Keep only latest occurrence (-U)
    if ($U -and $clean.Count -gt 0) {
        $seen = @{}
        $result = @()
        for ($i = $clean.Count - 1; $i -ge 0; $i--) {
            if (-not $seen.ContainsKey($clean[$i])) {
                $result = , $clean[$i] + $result
                $seen[$clean[$i]] = $true
            }
        }
        $clean = $result
    }

    # Apply -Tail
    if ($Tail -and $clean.Count -gt 0) {
        $Tail = [Math]::Min($Tail, $clean.Count)
        $clean = $clean[ - $Tail..-1]
    }

    return $clean
}

# ---------- HISTORY FUNCTION ----------
function history {
    [CmdletBinding()]
    param(
        [Alias("T")]
        [int]$Tail,
        [switch]$U,
        [Alias("M")]
        [string]$Match
    )

    $lines = Get-HistoryList -Tail $Tail -U:$U -Match $Match

    if ($lines.Count -eq 0) {
        Write-Host "No history to show." -ForegroundColor Red
        return
    }

    $i = 1
    foreach ($line in $lines) {
        $tokens = $line -split '\s+'
        Write-Host ("{0,5}" -f $i) -ForegroundColor Yellow -NoNewline
        Write-Host "  " -NoNewline

        $first = $true
        foreach ($tok in $tokens) {
            $textToPrint = $tok

            # Highlight matched keyword in magenta
            if ($Match -and $tok -match [regex]::Escape($Match)) {
                $textToPrint = $tok -replace ([regex]::Escape($Match)), "`e[35m$($Match)`e[0m"
            }

            if ($first) {
                Write-Host $textToPrint -ForegroundColor Cyan -NoNewline
                $first = $false
            }
            elseif ($tok -match '^-') {
                Write-Host " $textToPrint" -ForegroundColor Red -NoNewline
            }
            elseif ($tok -match '[\\/]' -or $tok -match '^[A-Za-z]:') {
                Write-Host " $textToPrint" -ForegroundColor Green -NoNewline
            }
            else {
                Write-Host " $textToPrint" -NoNewline
            }
        }
        Write-Host ""
        $i++
    }
}

# ---------- USE FUNCTION ----------
function use {
    param(
        [int]$Id,
        [Alias("T")]
        [int]$Tail,
        [switch]$U,
        [Alias("M")]
        [string]$Match
    )

    $commands = @(Get-HistoryList -Tail $Tail -U:$U -Match $Match)

    if ($commands.Count -eq 0) {
        Write-Host "No commands found with the applied filters." -ForegroundColor Red
        return
    }

    if ($Id -le 0 -or $Id -gt $commands.Count) {
        Write-Host "Invalid history ID: $Id. Filtered list has $($commands.Count) command(s):" -ForegroundColor Red
        $i = 1
        foreach ($c in $commands) {
            Write-Host ("{0,5}  {1}" -f $i, $c)
            $i++
        }
        return
    }

    $cmd = $commands[$Id - 1]

    Write-Host $cmd -ForegroundColor Cyan
    Invoke-Expression $cmd
}

#clean duplicates and empty lines from Command History
function cleanhistory {
    $path = (Get-PSReadLineOption).HistorySavePath
    if (-not (Test-Path $path)) {
        Write-Host "History file not found: $path" -ForegroundColor Red
        return
    }

    $lines = Get-Content $path

    # Remove empty or whitespace-only lines
    $lines = $lines | Where-Object { $_.Trim() -ne "" }

    # Remove duplicates, keeping latest occurrence
    $seen = @{}
    $result = @()
    for ($i = $lines.Count - 1; $i -ge 0; $i--) {
        if (-not $seen.ContainsKey($lines[$i])) {
            $result = , $lines[$i] + $result
            $seen[$lines[$i]] = $true
        }
    }

    # Overwrite history file
    Set-Content -Path $path -Value $result

    Write-Host "History cleaned. Total lines now: $($result.Count)" -ForegroundColor Green
}

#completely clears your persistent PSReadLine history file
function deletehistory {
    $path = (Get-PSReadLineOption).HistorySavePath
    if (-not (Test-Path $path)) {
        Write-Host "History file not found: $path" -ForegroundColor Red
        return
    }

    # Clear the file
    Set-Content -Path $path -Value @()

    Write-Host "All history has been deleted." -ForegroundColor Red
}

function base64 {
    param(
        [switch]$d  # decode if -d is passed
    )
    process {
        if ($d) {
            [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($_))
        }
        else {
            [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($_))
        }
    }
}