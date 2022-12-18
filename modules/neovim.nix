{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    withRuby = true;
    withPython3 = true;
    withNodeJs = true;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;
    configure = {
      customRC = ''
        luafile ~/.config/nvim/init.lua
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    nodePackages.prettier
    black
    stylua
    google-java-format
    python310
    python310Packages.flake8
    python310Packages.pip
    gcc
    luajit
    luarocks
  ];
}
