{ pkgs, ... }:

{
  imports =
    [
      "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/lenovo/thinkpad/x1/7th-gen"
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

  boot.kernelParams = [ "quiet" "loglevel=3" "splash" "rd.systemd_show_status=auto" "rd.udev.log_priority=3" "module_blacklist=iTCO_wdt,iTCO_vender_support" "fbcon=nodefer"];
}
