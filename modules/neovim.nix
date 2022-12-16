{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    withRuby = true;
    withPython3 = true;
    withNodeJs = true;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
  ];
}