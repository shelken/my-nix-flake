{
  description = "My flake configuration";

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
    #substituters = [
    #  # replace official cache with a mirror located in China
    #  # "https://mirrors.ustc.edu.cn/nix-channels/store"
    #  "https://cache.nixos.org/"
    #];

    # nix communitys cache server
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };


  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    inherit (inputs.nixpkgs) lib;
    mylib = import ./lib {inherit lib;};
    myvars = import ./vars {inherit lib;};
    
    specialArgs =
      inputs
      // {
        inherit mylib myvars; 
        inherit (myvars) username userfullname useremail;
      };
    args = {inherit inputs lib mylib myvars specialArgs; };
    pve155Modules = {
      nixos-modules = (map mylib.relativeToRoot [
        "hosts/pve155"
        "modules/nixos/hyprland.nix"
      ]);
      home-modules = (map mylib.relativeToRoot [
        "home/home.nix"
      ]);
    };
    pve156Modules = {
      nixos-modules = (map mylib.relativeToRoot [
        "hosts/pve156"
      ]);
      home-modules = (map mylib.relativeToRoot [
        "home/home.nix"
      ]);
    };
    yuukoModules = {
      darwin-modules = (map mylib.relativeToRoot [
        "modules/darwin"
        "hosts/yuuko"
      ]);
      home-modules = (map mylib.relativeToRoot [
        "home/darwin"
      ]);
    };
    
    allSystemAbove = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
  in {
    # linux x86
    nixosConfigurations = {
      nixos = mylib.nixosSystem (pve155Modules // args // {system = "x86_64-linux";});
      pve156 = mylib.nixosSystem (pve156Modules // args // {system = "x86_64-linux";});
    };
    
    darwinConfigurations = {
      # mac mini
      yuuko = mylib.macosSystem (yuukoModules // args // {system = "aarch64-darwin";});
      yuuko-test = mylib.macosSystem (yuukoModules // args // {system = "x86_64-darwin";});
    };

    formatter = 
    nixpkgs.lib.genAttrs allSystemAbove (system: nixpkgs.legacyPackages.${system}.alejandra);
  };


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # darwin
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    # astronvim
    astronvim = {
      url = "github:AstroNvim/AstroNvim/v3.41.2";
      flake = false;
    };

    # my astronvim config
    astronvim-config = {
      url = "github:shelken/astro-nvim-config";
      flake = false;
    };

    # hyprland
    hyprland.url = "github:hyprwm/Hyprland";

    # my dotfiles
    dotfiles.url = "github:shelken/dotfiles.nix";

#          ╭──────────────────────────────────────────────────────────╮
#          │                          theme                           │
#          ╰──────────────────────────────────────────────────────────╯
    # btop主题
    catppuccin-btop = {
      url = "github:catppuccin/btop";
      flake = false;
    };

    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = false;
    };

  };
}
