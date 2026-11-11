# Orchis for KDE Plasma 6 on NixOS

NixOS module that installs the [Orchis-KDE](https://github.com/vinceliuice/Orchis-kde) theme for Plasma 6 (Plasma style, color schemes, window decorations, look-and-feel, wallpapers), the GTK theme [`orchis-theme`](https://search.nixos.org/packages?query=orchis-theme), and the Kvantum style for Qt applications.

Everything is handled by Nix. No `install.sh` is run, nothing is written to `/usr`, and `sudo` is not needed for the user theme files.

## What gets installed

| Component | Package | Purpose |
|---|---|---|
| Plasma theme (Orchis) | `orchis-kde` (derivation in this repository) | Global theme, colors, window decorations, look-and-feel |
| GTK theme (Orchis) | `pkgs.orchis-theme` | GTK applications (Firefox, GNOME apps, etc.) |
| Qt/Kvantum | `pkgs.kdePackages.qtstyleplugin-kvantum` | Applies the Kvantum style to Qt apps |

## Layout

```
orchis-nixos/
├── README.md         this file
├── orchis.nix        NixOS module: theme.orchis.enable option and packages
└── orchis-kde.nix    Plasma theme derivation, with the Orchis-KDE source fetched via fetchGit
```

## Requirements

- NixOS 26.05 with Plasma 6.
- GitHub access during the build (the source is fetched with `builtins.fetchGit`).
- Configuration in `/etc/nixos` using a flake (`nixos-rebuild switch --flake .#cosmos`). Without a flake, use `nixos-rebuild switch` instead.

## Usage

### 1. Bridge file in `/etc/nixos`

Create `/etc/nixos/orchis-theme.nix`:

```nix
# Bridge: loads the orchis.nix module from this repository, at a pinned commit.
let
  src = builtins.fetchGit {
    url = "https://github.com/YOUR_USERNAME/orchis-nixos";
    rev = "COMMIT_OF_THIS_REPOSITORY";
  };
in
import "${src}/orchis.nix"
```

### 2. Configuration

In `/etc/nixos/configuration.nix`:

```nix
imports = [
  ./hardware-configuration.nix
  # ...
  ./orchis-theme.nix
];

theme.orchis.enable = true;
```

If you have an older `theme.nix` with the same packages, remove it and drop it from `imports`.

### 3. Apply

```bash
cd /etc/nixos
git add orchis-theme.nix     # flakes only see files tracked by git
sudo nixos-rebuild switch --flake .#cosmos
```

### 4. Choose the theme in Plasma

In **System Settings → Appearance**:

- **Global theme:** Orchis or Orchis-dark
- **Plasma style, colors, window decorations:** Orchis
- **Application style:** Kvantum, with the Orchis theme
- **GTK application style:** Orchis or Orchis-Dark

If a theme does not appear in the list, log out and back in.

## Verify

```bash
ls /run/current-system/sw/share/plasma/desktoptheme
ls /run/current-system/sw/share/plasma/look-and-feel
ls /run/current-system/sw/share/color-schemes
```

## Updating Orchis-KDE

1. Check the latest upstream commit:
   ```bash
   git ls-remote https://github.com/vinceliuice/Orchis-kde refs/heads/main
   ```
2. Change `rev` in `orchis-kde.nix`, commit, and push to your repository.
3. Change `rev` in `/etc/nixos/orchis-theme.nix` to the new commit of this repository.
4. Run the `switch` command again.

## Finding the upstream layout

The copy paths in `orchis-kde.nix` must match the upstream repository. To check:

```bash
git clone https://github.com/vinceliuice/Orchis-kde /tmp/orchis
find /tmp/orchis -maxdepth 3 -type d | sort
```

The `copy` function skips paths that do not exist, so a wrong name does not break the build, but the theme ends up incomplete. After adjusting the paths, check with the **Verify** section.

## Troubleshooting

- **Theme does not appear in Plasma:** check that the files exist under `/run/current-system/sw/share/`, then log out and back in.
- **`file not found` or `attribute missing` during build:** a folder name changed upstream. See **Finding the upstream layout**.
- **Qt apps still use the Breeze style:** confirm in Appearance that the application style is Kvantum.
- **A change in `orchis-kde.nix` has no effect:** you did not update `rev` in the bridge file, or you did not `git add` the new file.

## Notes

- The theme choices made in Plasma are stored in `~/.config`, which Nix does not manage. To make those declarative too, you can use [plasma-manager](https://github.com/nix-community/plasma-manager) as a flake input.
- If you already installed Orchis with `install.sh`, delete the `~/.local/share/plasma/desktoptheme/Orchis*` folders and similar to avoid conflicts with the Nix package.