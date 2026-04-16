$env:LS_COLORS = @(
  # ===== Core types =====
  "di=94",        # directories → blue
  "ln=36",        # symlinks → cyan
  "ex=32",        # executables → green
  "fi=37",        # regular files → white
  "or=31",        # broken symlinks → red

  # ===== Hidden / temp =====
  "*.bak=90",
  "*.tmp=90",
  "*.swp=90",

  # ===== Source code (grouped) =====
  "*.rs=35",
  "*.c=35",
  "*.cpp=35",
  "*.h=35",
  "*.go=35",
  "*.py=35",
  "*.java=35",
  "*.js=35",
  "*.ts=35",
  "*.jsx=35",
  "*.tsx=35",

  # ===== Web / styles =====
  "*.html=36",
  "*.css=36",
  "*.scss=36",

  # ===== Config / data =====
  "*.json=36",
  "*.toml=36",
  "*.yml=36",
  "*.yaml=36",
  "*.ini=36",
  "*.conf=36",
  "*.env=36",
  "*.xml=36",

  # ===== Docs =====
  "*.md=37",
  "*.txt=37",
  "*.pdf=37",

  # ===== Archives / disk images =====
  "*.zip=33",
  "*.tar=33",
  "*.gz=33",
  "*.bz2=33",
  "*.xz=33",
  "*.7z=33",
  "*.rar=33",
  "*.iso=33",

  # ===== Media =====
  "*.png=36",
  "*.jpg=36",
  "*.jpeg=36",
  "*.gif=36",
  "*.svg=36",
  "*.mp4=36",
  "*.mkv=36",
  "*.mp3=36",
  "*.flac=36",

  # ===== Binaries / installers =====
  "*.exe=32",
  "*.msi=32",
  "*.dll=32",

  # ===== Secrets / sensitive =====
  "*.pem=31",
  "*.key=31",
  "*.crt=31"
) -join ":"
