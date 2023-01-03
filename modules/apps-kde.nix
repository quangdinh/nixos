{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    dragon
    kmail
    kcalc
    krusader
    kalendar
    kaddressbook
    kate
    firefox
    krita 
    _1password-gui
    slack
    libreoffice-fresh
    digikam
  ];
}
