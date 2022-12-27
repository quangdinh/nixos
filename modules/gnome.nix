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
    albert
    gnome.gnome-terminal
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
    gnome-text-editor
    apostrophe
    amberol

    # Gnome Shell
    gnomeExtensions.espresso
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-panel

    # Theming
    kora-icon-theme
    phinger-cursors
    flat-remix-gnome
  ];
}
