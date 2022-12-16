{ config, pkgs, ... }:
{
  users.users.qdtc = {
    uid = 1000;
    isNormalUser = true;
    description = "Quang Dinh Le";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    home = "/home/qdtc";
    hashedPassword = "$6$43helWNzfEuDYcJ5$Sa2RTU0A1itX.MQWjj5PwSM.rMtrq6juENhiSKAgJl3kyUYxVWRLN9WkTJtFENJh8I9l26RchKk8H7PRwvLjG/";
  };
}