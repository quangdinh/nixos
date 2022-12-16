{ config, pkgs, ... }:

{
  imports =
    [
      ./base.nix

      ./modules/apps.nix
      ./modules/bluetooth.nix
      ./modules/development.nix
      ./modules/docker.nix
      ./modules/fonts.nix
      ./modules/gnome.nix
      ./modules/neovim.nix
      ./modules/qdtc.nix
      ./modules/sound.nix
      ./modules/yubikey.nix
      ./modules/zsh.nix
    ];

  networking.hostName = "Carbon";
}