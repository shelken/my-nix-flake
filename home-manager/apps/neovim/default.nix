{
  pkgs,
  astronvim,
  astronvim-config,
  ...
}: {
  # 使用 lazygit
  imports = [
    ../lazygit.nix
  ];

  xdg.configFile = {
    # astronvim's config
    "nvim".source = astronvim;

    # my cusotom astronvim config, astronvim will load it after base config
    # https://github.com/AstroNvim/AstroNvim/blob/v3.32.0/lua/astronvim/bootstrap.lua#L15-L16
    # "astronvim/lua/user".source = astronvim-config;
    "astronvim/lua/user".source = ./astro-nvim-config;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    viAlias = false;
    vimAlias = true;

    withPython3 = true;
    withNodeJs = true;
  };

  home.packages = with pkgs; [
    # c
    gcc # 插件需要

    # nix
    nil

    # go
    go

    # lua

    # rust
    cargo

    # CloudNative
    #terraform
  ];
}
