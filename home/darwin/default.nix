{mylib, ...}: {
  imports = (mylib.scanPaths ./.) 
  ++ [
    ../base/core
    ../base/home.nix
    ../apps/neovim
  ];
}
