{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
      google-chrome
      gimp
      _1password-gui
      slack
      libreoffice-fresh
    ];
}