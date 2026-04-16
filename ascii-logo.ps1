# =========================
# Animated ASCII Logo - Cinematic Fade
# =========================

# Store ASCII art lines
$asciiArtLines = @(
" ***************************************************************************************************************************************************************************",
" *********                                                                                               dddddddd                                                  *********",
" *******      ((((((                       PPPPPPPPPPPPPPPPP                                             d::::::d                                        ))))))      *******",
" *****      ((::::::(                      P::::::::::::::::P                                            d::::::d                                       )::::::))      *****",
" ****     ((:::::::(                       P::::::PPPPPP:::::P                                           d::::::d                                        ):::::::))     ****",
" ***     (:::::::((                        PP:::::P     P:::::P                                          d:::::d                                          )):::::::)     ***",
" **      (::::::(                            P::::P     P:::::aaaaaaaaaaaaa nnnn  nnnnnnnn       ddddddddd:::::d  aaaaaaaaaaaaa                             )::::::)      **",
" *       (:::::(                             P::::P     P:::::a::::::::::::an:::nn::::::::nn   dd::::::::::::::d  a::::::::::::a                             ):::::)       *",
" *       (:::::(                             P::::PPPPPP:::::Paaaaaaaaa:::::n::::::::::::::nn d::::::::::::::::d  aaaaaaaaa:::::a                            ):::::)       *",
" *       (:::::(      ---------------        P:::::::::::::PP          a::::nn:::::::::::::::d:::::::ddddd:::::d           a::::a       ---------------      ):::::)       *",
" *       (:::::(      ###############        P::::PPPPPPPPP     aaaaaaa:::::a n:::::nnnn:::::d::::::d    d:::::d    aaaaaaa:::::a       ###############      ):::::)       *",
" *       (:::::(      ---------------        P::::P           aa::::::::::::a n::::n    n::::d:::::d     d:::::d  aa::::::::::::a       ---------------      ):::::)       *",
" **      (:::::(                             P::::P          a::::aaaa::::::a n::::n    n::::d:::::d     d:::::d a::::aaaa::::::a                            ):::::)      **",
" ***     (::::::(                            P::::P         a::::a    a:::::a n::::n    n::::d:::::d     d:::::da::::a    a:::::a                           )::::::)     ***",
" ****    (:::::::((                        PP::::::PP       a::::a    a:::::a n::::n    n::::d::::::ddddd::::::da::::a    a:::::a                         )):::::::)    ****",
" *****    ((:::::::(                       P::::::::P       a:::::aaaa::::::a n::::n    n::::nd:::::::::::::::::a:::::aaaa::::::a                        ):::::::))    *****",
" ******     ((::::::(                      P::::::::P        a::::::::::aa:::an::::n    n::::n d:::::::::ddd::::da::::::::::aa:::a                      )::::::)     *******",
" ********     ((((((                       PPPPPPPPPP         aaaaaaaaaa  aaaannnnnn    nnnnnn  ddddddddd   ddddd aaaaaaaaaa  aaaa                       ))))))    *********",
" ***************************************************************************************************************************************************************************"
)

# Define shades for "fade-in glow"
$fadeColors = @('White','Red','DarkRed')  # Start dim, then medium, then bright

Clear-Host

# Loop through each line
foreach ($line in $asciiArtLines) {
    # Fade-in the line by changing color gradually
    foreach ($color in $fadeColors) {
        Write-Host $line -ForegroundColor $color
        Start-Sleep -Milliseconds 5
        # Move cursor up to overwrite the line for next shade
        $pos = $Host.UI.RawUI.CursorPosition
        $Host.UI.RawUI.CursorPosition = @{X=0;Y=$pos.Y-1}
    }
    # After fade-in, leave line in final color (bright)
    Write-Host $line -ForegroundColor $fadeColors[-1]
}