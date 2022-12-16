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
    obsidian
    python3
    postman
    zip
    unzip
    unrar
  ];
}