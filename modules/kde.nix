{ pkgs, ... }:
{
  services.xserver = {
    enable = true;

    displayManager.sddm = {
      enable = true;
    };

    desktopManager.plasma5.enable = true;

    excludePackages = [ pkgs.xterm ];
    layout = "us";
    xkbVariant = "";
  };

  programs.kdeconnect.enable = true;

  xdg = {
    portal = {
      enable = true;
    };
  };
}
