{
  description = "Optimized NixOS configuration for minimal RAM usage";
  
  inputs = {
    # Use stable channel for better memory efficiency and stability
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Use stable home-manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        
        # Additional memory optimizations
        {
          # Limit Nix daemon processes
          nix.settings.max-jobs = 2;
          nix.settings.cores = 2;
          
          # Reduce build memory usage
          nix.settings.max-free = 1000000000; # 1GB
          nix.settings.min-free = 500000000;  # 500MB
          
          # Optimize for low memory systems
          boot.kernel.sysctl = {
            "vm.swappiness" = 10; # Prefer zram over disk swap
            "vm.vfs_cache_pressure" = 50; # Reduce cache pressure
            "vm.dirty_background_ratio" = 5;
            "vm.dirty_ratio" = 10;
          };
          
          # Limit systemd services memory
          systemd.services = {
            systemd-resolved.serviceConfig.MemoryMax = "32M";
            systemd-networkd.serviceConfig.MemoryMax = "16M";
            dbus.serviceConfig.MemoryMax = "32M";
          };
        }
      ];
    };

    homeConfigurations = {
      "huyen" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home.nix
        ];
      };
    };
  };
}
