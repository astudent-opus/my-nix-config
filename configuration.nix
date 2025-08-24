{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Allow Unfree (minimal)
  nixpkgs.config.allowUnfree = true;

  # Bootloader → Minimal GRUB
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    # Removed theme to save RAM
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Memory optimization - Enable zram
  zramSwap = {
    enable = true;
    memoryPercent = 50; # Use 50% of RAM for zram compression
  };

  # Kernel parameters for memory efficiency
  boot.kernelParams = [
    "quiet"
    "mitigations=off" # Disable CPU mitigations for performance
    "preempt=voluntary" # Better for desktop responsiveness
  ];

  # Networking
  networking.networkmanager.enable = true;
  # Disable unnecessary network services
  networking.networkmanager.wifi.powersave = true;

  # Time & Locale
  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n.defaultLocale = "en_US.UTF-8";

  # Minimal display setup - Remove X server, use only Wayland
  # services.xserver.enable = false; # Disabled to save RAM

  # Lightweight login manager instead of GDM
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # Enable features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Aggressive garbage collection
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d"; # More aggressive - 7 days instead of 30
  };

  # Auto-optimize nix store
  nix.settings.auto-optimise-store = true;

  # Hyprland (minimal)
  programs.hyprland = {
    enable = true;
    xwayland.enable = false; # Disable X11 support to save RAM
  };

  # Minimal PipeWire setup
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    # Removed JACK to save RAM
  };

  # User configuration
  users.users.huyen = {
    isNormalUser = true;
    description = "Nguyen Huyen";
    shell = pkgs.fish; # Keep fish as it's lighter than zsh
    extraGroups = [
      "wheel"
      "users"
      "audio"
      "video"
    ];
  };

  programs.fish.enable = true;

  # Use only doas (lighter than sudo)
  security.doas = {
    enable = true;
    extraRules = [
      {
        users = [ "huyen" ];
        keepEnv = true;
        persist = true;
      }
    ];
  };

  # Minimal DBus
  services.dbus.enable = true;

  # Minimal portals
  xdg.portal = {
    enable = true;
    wlr.enable = true; # Lightweight wlr portal instead of hyprland-specific
  };

  # Essential packages only
  environment.systemPackages = with pkgs; [
    # Core Hyprland
    hyprland
    waybar # Keep for system tray
    wofi # Single menu system
    rofi-wayland # Better menu system
    eww
    swww

    # Essential apps
    kitty # Lightweight terminal
    firefox # Browser

    # System tools
    home-manager
  ];

  # Disable unnecessary services
  services.printing.enable = false;
  services.avahi.enable = false;
  services.gnome.gnome-keyring.enable = false;
  services.udisks2.enable = false;

  # Disable unnecessary font packages
  fonts.fontDir.enable = false;
  fonts.fontconfig.enable = true; # Keep basic fontconfig

  # Power management
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Limit systemd journal size
  services.journald.extraConfig = ''
    SystemMaxUse=50M
    RuntimeMaxUse=10M
  '';

  system.stateVersion = "25.11";
}
