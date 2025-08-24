# My NixOS Configuration

This repository contains my personal NixOS configuration files managed with Home Manager and flakes. It includes customizations for system settings, development tools, and UI enhancements.

## Contents

* `home.nix` - Home Manager configuration
* `configuration.nix` - Main NixOS configuration
* `flake.nix` - Flake setup for reproducible builds
* `dotfiles/` - Personal dotfiles and scripts

## Features

* Customized shell environment (Fish, Starship prompt)
* Development tools and IDE configurations
* Waybar and other Hyprland enhancements
* Python environment with dependencies for scripts

## Usage

Clone the repository and apply the configuration:

```bash
git clone https://github.com/astudent-opus/my-nix-config.git ~/.config/nixos
cd ~/.config/nixos
home-manager switch --flake .
```

## Contributing

Feel free to fork and tweak it to your liking, but be cautious: some settings are specific to my hardware and workflow.
