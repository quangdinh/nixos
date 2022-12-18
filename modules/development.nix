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
    python3
    postman
    gcc
    gnumake
    clang
    zig
    cl
  ];
}
