{ pkgs, ... }:
{
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-extra
    noto-fonts-emoji
    liberation_ttf
    fira-code
  ];
}
