{ config, pkgs, ... }:
{
  services.xserver = {
    enable = true;

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    desktopManager.gnome.enable = true;

    excludePackages = [ pkgs.xterm ];
    layout = "us";
    xkbVariant = "";
  };

  # Disable core gnome apps
  services.gnome = {
    core-utilities.enable = false;
    sushi.enable = true;
  };

  xdg = {
    portal = {
      enable = true;
    };
  };

  # Disable tour app
  environment.gnome.excludePackages = [ pkgs.gnome-tour ];

  # Apps
  environment.systemPackages = with pkgs; [
    wl-clipboard
    kitty
    gnome.geary
    gnome.eog
    gnome.gnome-calendar
    evince
    gnome.file-roller
    gnome.gnome-screenshot
    gnome.nautilus
    gnome.gnome-calculator
    gnome.gvfs
    gnome.gnome-tweaks
    gnome.totem
    rhythmbox

    # Gnome Shell
    gnomeExtensions.pop-shell
    gnomeExtensions.vertical-overview

    # Theming
    kora-icon-theme
  ]
}