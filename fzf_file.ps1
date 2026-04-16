# ============================================================
# PowerShell FZF + EZA Setup (Windows Native)
# ============================================================

# ---------- FZF GLOBAL UI ----------
$env:FZF_DEFAULT_OPTS = @"
--height=40%
--layout=reverse
--border
--prompt=❯ 
--pointer=▶
--marker=✓
--info=inline
--cycle
--scroll-off=3
"@

# ---------- Ensure PSReadLine ----------
Import-Module PSReadLine

# Better history experience
Set-PSReadLineOption `
    -HistorySearchCursorMovesToEnd `
    -PredictionSource History `
    -PredictionViewStyle ListView

# ============================================================
# Ctrl+R → Fuzzy search command history
# ============================================================
Set-PSReadLineKeyHandler -Key Ctrl+r -ScriptBlock {

    $command = Get-History |
    Select-Object -ExpandProperty CommandLine |
    fzf

    if ($command) {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($command)
    }
}

# ============================================================
# Ctrl+T → Fuzzy find files (recursive, safe)
# ============================================================
Set-PSReadLineKeyHandler -Key Ctrl+t -ScriptBlock {

    $path = Get-ChildItem -Recurse -File -ErrorAction SilentlyContinue `
        -Exclude node_modules, .git |
    Select-Object -ExpandProperty FullName |
    fzf

    if ($path) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($path)
    }
}

# ============================================================
# Ctrl+F → File browser with EZA preview (FIXED for Windows)
# ============================================================
Set-PSReadLineKeyHandler -Key Ctrl+f -ScriptBlock {

    $items = Get-ChildItem -Force |
    Select-Object FullName, PSIsContainer |
    ForEach-Object {
        if ($_.PSIsContainer) {
            "[DIR]  $($_.FullName)"
        }
        else {
            "       $($_.FullName)"
        }
    }

    $selection = $items | fzf `
        --preview 'powershell -NoProfile -Command "
            $p = \"{}\".Substring(7)
            if (Test-Path $p -PathType Container) {
                eza --icons --color=always --git --group-directories-first $p
            } else {
                eza --icons --color=always --git --long --no-time $p
            }
        "' `
        --preview-window=right:60%

    if ($selection) {
        $finalPath = $selection.Substring(7)
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($finalPath)
    }
}

# ============================================================
# Alt+A → Jump to directory using fzf + eza preview
# ============================================================
Set-PSReadLineKeyHandler -Key Alt+a -ScriptBlock {

    $dir = Get-ChildItem -Directory -Recurse -ErrorAction SilentlyContinue `
        -Exclude node_modules, .git |
    Select-Object -ExpandProperty FullName |
    fzf --preview 'powershell -NoProfile -Command "eza --icons --color=always {}"'

    if ($dir) {
        Set-Location $dir
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
}

# ============================================================
# Optional: Aliases for EZA (Windows-friendly)
# ============================================================
Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue


function l {
    eza --icons --color=always --group-directories-first `
        --long --git --header --time-style=long-iso @args
}

function ll {
    eza `
        --color=always `
        --color-scale=all `
        --color-scale-mode=gradient `
        --icons=always `
        --hyperlink `
        --group-directories-first `
        --group `
        --header `
        --classify `
        --git `
        --sort=name `
        --time=modified `
        --time-style=long-iso `
        -a -l -h `
        @args
}

function la { l @args }
function ls { l @args }

#function ls { Get-ChildItem @Args }          # normal list
#function la { Get-ChildItem -Force @Args }   # show hidden
#function ll { Get-ChildItem -Force | Format-Table Mode, LastWriteTime, Length, Name -AutoSize } # long list
#function l { Get-ChildItem -Force | Select-Object Name } # single column

# ============================================================
# ff: Fuzzy file finder with preview and actions
# ============================================================
function ff {
    fd --type file --follow --hidden --exclude .git --absolute-path |
    fzf `
        --height 90% `
        --layout reverse `
        --prompt "Files> " `
        --header-first `
        --header "CTRL-S: Files/Dirs │ CTRL-O: Open │ CTRL-E: Edit │ CTRL-D: Delete" `
        --bind 'ctrl-s:transform:if not "%FZF_PROMPT%"=="Files> " (echo ^change-prompt^(Files^> ^)^+^reload^(fd --type file --follow --hidden --exclude .git --absolute-path^)) else (echo ^change-prompt^(Directory^> ^)^+^reload^(fd --type directory --follow --hidden --exclude .git --absolute-path^))' `
        --bind 'ctrl-o:execute:powershell -NoProfile -Command "Start-Process -FilePath \"{}\""' `
        --bind 'ctrl-e:execute:powershell -NoProfile -Command "if (Get-Command code -ErrorAction SilentlyContinue) { code \"{}\" } else { notepad \"{}\" }"' `
        --bind 'ctrl-d:execute:powershell -NoProfile -Command "Remove-Item \"{}\" -Confirm"' `
        --preview-window right:60%:wrap `
        --preview 'if "%FZF_PROMPT%"=="Files> " (bat --color=always {} --style=plain) else (eza -T --colour=always --icons=always {})'
}
# ============================================================  