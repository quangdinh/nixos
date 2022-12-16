{ config, pkgs, ... }:
{
  # ZSH
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;
  environment.shells = [ pkgs.zsh ];
  environment.systemPackages = with pkgs; [
  ];
}