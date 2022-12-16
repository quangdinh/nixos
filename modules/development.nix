{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # System utilities
    yadm
    vscode
    git
    gitui
    delta
    rustup
    go
    nodejs-18_x
    yarn
    nodePackages.npm
    obsidian
    python3
    postman
    gnumake
    gcc
  ];
}