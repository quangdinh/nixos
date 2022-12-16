{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    noto-fonts
    noto-fonts-extra
    noto-fonts-emoji
  ];
}