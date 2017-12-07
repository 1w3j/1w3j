#!/bin/bash
# date: 2017-11-17
# license: GPLv3 https://www.gnu.org/licenses/gpl-3.0.txt
# author: nanpuyue <nanpuyue@gmail.com> https://blog.nanpuyue.com

echo 'install: ~/.mozilla/native-messaging-hosts/hide_titlebar.json'
[[ -d ~/.mozilla/native-messaging-hosts ]] || mkdir -p ~/.mozilla/native-messaging-hosts
cat > ~/.mozilla/native-messaging-hosts/hide_titlebar.json << EOF
{
    "name": "hide_titlebar",
    "description": "Hide the Firefox titlebar.",
    "path": "$HOME/.local/bin/hide-firefox-titlebar.sh",
    "type": "stdio",
    "allowed_extensions": ["hide-titlebar@nanpuyue.com"]
}
EOF

echo 'install: ~/.local/bin/hide-firefox-titlebar.sh'
[[ -d ~/.local/bin ]] || mkdir -p ~/.local/bin
cat > ~/.local/bin/hide-firefox-titlebar.sh << "EOF"
#!/bin/bash
# date: 2017-11-17
# license: GPLv3 https://www.gnu.org/licenses/gpl-3.0.txt
# author: nanpuyue <nanpuyue@gmail.com> https://blog.nanpuyue.com

python3 -c "import gi; gi.require_version('Gdk', '3.0'); from gi.repository import Gdk, GdkX11;
default_display=GdkX11.X11Display.get_default();
$(for i in $(xdotool search --onlyvisible --class "Firefox|Nightly"); do
    echo "GdkX11.X11Window.foreign_new_for_display(default_display, $i).set_decorations(Gdk.WMDecoration.BORDER);"
done)
Gdk.Window.process_all_updates();"
EOF
chmod +x ~/.local/bin/hide-firefox-titlebar.sh

echo 'done'
