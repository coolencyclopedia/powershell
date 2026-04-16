# ===== Standard ANSI foreground colors =====
# 30  Black
# 31  Red
# 32  Green
# 33  Yellow
# 34  Blue
# 35  Magenta
# 36  Cyan
# 37  White

# ===== Bright / high-contrast foreground colors =====
# 90  Bright Black (Dark Gray)
# 91  Bright Red
# 92  Bright Green
# 93  Bright Yellow
# 94  Bright Blue
# 95  Bright Magenta
# 96  Bright Cyan
# 97  Bright White

# ===== Core file types =====
# di   directory
# fi   regular file
# ex   executable file
# ln   symbolic link
# or   broken symbolic link
# so   socket
# pi   named pipe (FIFO)
# bd   block device
# cd   character device

# ===== Extension patterns =====
# *.js     JavaScript files
# *.ts     TypeScript files
# *.rs     Rust files
# *.py     Python files
# *.go     Go files
# *.c      C source
# *.cpp    C++ source
# *.java   Java source
# *.json   JSON files
# *.yml    YAML files
# *.yaml   YAML files
# *.toml   TOML files
# *.ini    INI files
# *.conf   Config files
# *.md     Markdown
# *.txt    Text files
# *.zip    Zip archives
# *.tar    Tar archives
# *.gz     Gzip archives
# *.iso    ISO images
# *.png    PNG images
# *.jpg    JPEG images
# *.mp4    Video files
# *.mp3    Audio files

# Format:
# key=color_code

# Examples:
# di=34        # directories in blue
# ex=32        # executables in green
# *.js=35     # JavaScript files in magenta
# *.json=36   # JSON files in cyan

#di=34:ex=32:*.js=35:*.json=36

# Navigation / structure
# di=34        # blue

# Runnable / active
# ex=32        # green
# *.exe=32
# *.sh=32
# *.ps1=32

# Source code
# *.js=35
# *.ts=35
# *.rs=35
# *.py=35
# *.go=35

# Config / metadata
# *.json=36
# *.yml=36
# *.yaml=36
# *.toml=36
# *.env=36

# Archives / heavy files
# *.zip=33
# *.tar=33
# *.gz=33
# *.iso=33

# Media
# *.png=36
# *.jpg=36
# *.mp4=36
# *.mp3=36

# Docs / secondary
# *.md=37
# *.txt=37

# Hidden / temp
# *.bak=90
# *.tmp=90
# *.swp=90

# Dangerous / sensitive
# *.pem=31
# *.key=31
# *.crt=31
