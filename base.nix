{ pkgs, lib, ... }:
{
  imports =
    [
      ./locale.nix
    ]
    ++ lib.optional (builtins.pathExists ./hardware-configuration.nix) ./hardware-configuration.nix
    ++ lib.optional (builtins.pathExists /etc/nixos/hardware-configuration.nix) /etc/nixos/hardware-configuration.nix;

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

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.plymouth.enable = true;

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
  environment.localBinInPath = true;

  environment.systemPackages = with pkgs; [
    # System utilities
    yadm
    zip
    unzip
    unrar
    bottom
    bat
    procs
    exa
    zoxide
  ];

  nix.settings.auto-optimise-store = true;
  system.stateVersion = "22.11";
}
