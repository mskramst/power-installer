# Making XFCE Look Good
https://www.youtube.com/watch?v=fw4dLnMNecE&list=WL&index=3i

Download Customization Resources 

        🌐 Nordic GTK Theme: https://www.gnome-look.org/p/1267246
        🎨 Zafiro Nord Icon Pack: https://www.pling.com/p/1891042/
        🖱️ Future Cursors: https://www.gnome-look.org/p/998388
        🖼️ Nordic Wallpaper: https://www.pling.com/p/1683121/
        🔤 JetBrains Mono Font: https://www.jetbrains.com/lp/mono/
              Nerd Fonts: https://www.nerdfonts.com/font-downloads

Suggested nerd fonts: CaskaydiaCove, FiraCode Nerd

Extract all downloaded files 

Create custom directories (if not present)
Move Files to appropriate locations
    GTK Theme → ~/.themes/
    Icons & Cursor → ~/.local/share/icons/
    Fonts → ~/.fonts/
    Wallpaper → ~/Pictures/Wallpapers/

Apply Theme & Icons via Appearance Settings

If icons show cache error, run:

  $ gtk-update-icon-cache ~/.local/share/icons/Zafiro-Nord

Set JetBrains Mono as System Font

Set Cursor via Mouse & Touchpad Settings

Set Wallpaper
_______________________________________________________

Install Extra Tools (Polybar, Rofi, Plank)

  $ sudo apt install polybar rofi plank

Clean XFCE Panel

Adjust Panel Position

    Right-click - Panel - Panel Preferences

    Move panel to bottom, enable auto-hide, set size to ~25px

Make Panel Transparent

    Panel - Appearance - Style: Solid Color - Set transparency

Remove Panel Shadow

    Open Window Manager Tweaks - Compositor Tab

    Uncheck “Show shadows under dock windows”

Configure Polybar

    GitHub Repo: https://github.com/itsfoss/text-scrip... 

    Clone repo and move config to ~/.config/

    Edit config.ini to match display name (e.g., HDMI-1 or Virtual1)

   Use this command to get display name: xrandr

    Set update checker script (mintupdates.sh, etc.)

-Set Rofi with Catppuccin Theme

    Rofi Theme Repo: https://github.com/catppuccin/rofi

    Create config directory:

mkdir -p ~/.config/rofi

-Save catppuccin-default.rasi and selected theme (frappe)

Modify .rasi to use frappe

Create config.rasi with:

    @theme "catppuccin-default"

Test Rofi

rofi -show drun

Set Window Titlebar Transparency

    Window Manager Tweaks - Compositor - Adjust window decoration opacity

Autostart Polybar & Plank

    Open Session and Startup - Application Autostart

    Add:

        Name: Polybar
        Command: polybar

        Name: Plank
        Command: plank

Set Rofi Shortcut

    Open Keyboard - Application Shortcuts

    Add:

    rofi -show drun -show-icons

    Set to Super + R

Configure Plank

    Ctrl + Right Click - Preferences

    Set:

        Theme: Transparent

        Position: Left, Alignment: Center

        Icon size, Zoom, IntelliHide

Remove Whisker Menu (Optional)

    After Rofi is configured

Create Workspaces

    Settings - Workspaces

    Set to 5+, rename to 1, 2, etc.

XFCE Terminal Color Scheme

    Catppuccin XFCE Theme: https://github.com/catppuccin/xfce-te...

    Move theme to:

    mkdir -p ~/.local/share/xfce4/terminal/colorschemes
    Move downloaded files to /.local/share/xfce4/terminal/colorschemes/

Enable Application Menu on Desktop

    Right-click - Desktop Settings - Menu

    Enable: "Include applications menu on desktop right-click"
