{
  config,
  pkgs,
  ...
}: {
  # Allow Unfree pkgs
  nixpkgs.config.allowUnfree = true;

  # Home Manager info
  home.username = "huyen";
  home.homeDirectory = "/home/huyen";

  # Minimal essential packages
  home.packages = with pkgs; [
    # Core development
    git
    neovim
    pacman

    # Essential Nix tools
    nil          # Nix LSP (lightweight)
    alejandra    # Nix formatter (fastest)
    nixd  
  

    # Core system tools
    htop         # System monitor (choose one)
    fastfetch    # System info (fastest)
    
    # Essential shell tools
    eza          # ls replacement
    bat          # cat replacement
    fd           # find replacement
    ripgrep      # grep replacement
    fzf          # Fuzzy finder
    
    # Network tools
    curl         # HTTP client
    
    # Wayland essentials
    grim         # Screenshots
    slurp        # Screen selection
    wlogout      # Logout menu
    
    # Minimal notification
    mako         # Lightweight notifications
    libnotify    # Notification library
    
    # Essential font (one only)
    nerd-fonts.jetbrains-mono
    
    # File management
    lf           # Lightweight file manager
    
    # Development (minimal)
    nodejs       # Keep if needed for development
    python3      # Basic python without extra packages
    
    # Utilities
    unzip
  ];

  # Minimal FZF configuration
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--border"
    ];
    defaultCommand = "fd --type f";
  };

  # Minimal Bat configuration
  programs.bat = {
    enable = true;
    config = {
      style = "plain"; # No line numbers to save memory
    };
  };

  # Git configuration (essential)
  programs.git = {
    enable = true;
    userName = "huyen";
    userEmail = "your-email@example.com"; # Replace with your email
  };

  # Fish shell configuration (minimal)
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza";
      cat = "bat";
      find = "fd";
      grep = "rg";
      fetch = "fastfetch";
      top = "htop";
    };
  };

  # Minimal Neovim setup
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
