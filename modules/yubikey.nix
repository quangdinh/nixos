{ config, pkgs, ... }:
{
  services.yubikey-agent.enable = true;
  services.pcscd.enable = true;
}
