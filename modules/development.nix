{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # System utilities
    vscode
    git
    gitui
    delta
    rustup
    go
    nodejs-18_x
    yarn
    postman
    wget
    jdk8
  ];
}
