{ config, pkgs, ... }:
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ./locale.nix
    ];

  # Luks
  boot.initrd = {
    availableKernelModules = [ 
      "aesni_intel"
      "cryptd"
    ];
    luks.devices = {
      cryptlvm = {
        device = "/dev/disk/by-partlabel/cryptlvm";
        preLVM = true;
      };
    };
  };

  # Bootloader.
  boot.loader = {
    timeout = 3;
    systemd-boot = {
      enable = true;
      configurationLimit = 3;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  # Network
  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  # Printing
  services.printing.enable = true;

  # Disable documentation
  documentation.nixos.enable = false;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "22.11";
}