{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # System utilities
    vscode
    textpieces
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
