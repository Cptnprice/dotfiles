#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../utils/logging/logging.sh"

VSCODE_DEB="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
VSCODE_RPM="https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64"
CHROME_DEB="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
CHROME_RPM="https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
ONEPASSWORD_DEB="https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb"
ONEPASSWORD_RPM="https://downloads.1password.com/linux/rpm/stable/x86_64/1password-latest.rpm"
DISCORD_URL="https://discord.com/api/download?platform=linux&format=tar.gz"
POSTMAN_URL="https://dl.pstmn.io/download/latest/linux_64"
CALIBRE_INSTALLER="https://download.calibre-ebook.com/linux-installer.sh"

install_pkg_file() {
    local name="$1" bin="$2" deb_url="$3" rpm_url="$4"

    if command -v "$bin" &>/dev/null; then
        ok "$name is already installed."
        return
    fi

    local tmp
    if command -v apt &>/dev/null; then
        tmp="$(mktemp --suffix=.deb)"
        ok "Downloading $name..."
        curl -fsSL "$deb_url" -o "$tmp"
        sudo apt install -y "$tmp"
    elif command -v dnf &>/dev/null; then
        tmp="$(mktemp --suffix=.rpm)"
        ok "Downloading $name..."
        curl -fsSL "$rpm_url" -o "$tmp"
        sudo dnf install -y "$tmp"
    else
        warn "$name has no generic package for this system — install manually (e.g. via the AUR on Arch)."
        return
    fi
    rm -f "$tmp"

    if command -v "$bin" &>/dev/null; then
        ok "$name has been installed."
    else
        error "Failed to install $name."
    fi
}

install_tarball_app() {
    local name="$1" bin="$2" url="$3" install_dir="$4" bin_relpath="$5" icon_relpath="$6" exec_args="$7" categories="$8"

    if command -v "$bin" &>/dev/null; then
        ok "$name is already installed."
        return
    fi

    ok "Downloading $name..."
    local tmp
    tmp="$(mktemp -d)"
    curl -fsSL "$url" -o "$tmp/app.tar.gz"

    sudo mkdir -p "$install_dir"
    sudo tar -xzf "$tmp/app.tar.gz" -C "$install_dir" --strip-components=1
    rm -rf "$tmp"

    sudo ln -sf "$install_dir/$bin_relpath" "/usr/local/bin/$bin"

    sudo tee "/usr/share/applications/${bin}.desktop" > /dev/null <<EOF
[Desktop Entry]
Name=$name
Exec=$install_dir/$bin_relpath $exec_args
Icon=$install_dir/$icon_relpath
Type=Application
Categories=$categories
EOF

    if [[ -x "$install_dir/$bin_relpath" ]]; then
        ok "$name has been installed."
    else
        error "Failed to install $name."
    fi
}

install_calibre() {
    if command -v calibre &>/dev/null; then
        ok "Calibre is already installed."
        return
    fi

    ok "Downloading and installing Calibre..."
    if curl -fsSL "$CALIBRE_INSTALLER" | sudo sh /dev/stdin; then
        ok "Calibre has been installed."
    else
        error "Failed to install Calibre."
    fi
}

install_pkg_file "Visual Studio Code" "code" "$VSCODE_DEB" "$VSCODE_RPM"
install_pkg_file "Google Chrome" "google-chrome-stable" "$CHROME_DEB" "$CHROME_RPM"
install_pkg_file "1Password" "1password" "$ONEPASSWORD_DEB" "$ONEPASSWORD_RPM"
install_tarball_app "Discord" "discord" "$DISCORD_URL" "/opt/discord" "discord" "discord.png" "--url -- %u" "Network;InstantMessaging;"
install_tarball_app "Postman" "postman" "$POSTMAN_URL" "/opt/postman" "Postman" "app/resources/app/assets/icon.png" "" "Development;"
install_calibre
