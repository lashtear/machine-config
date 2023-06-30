# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "uas" "sd_mod" "bcache" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/sda:/dev/sdb:/dev/nvme1n1p4";
      fsType = "bcachefs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/CDA0-8C4E";
      fsType = "vfat";
    };

  fileSystems."/home/svein/mnt" = {
    device = "svein@brage.info:";
    fsType = "fuse.sshfs";
    options = [
      "noauto"
      "x-systemd.automount"
      "_netdev"
      "users"
      "idmap=user"
      "IdentityFile=/home/svein/.ssh/id_ed25519"
      "allow_other"
      "default_permissions"
      "uid=1000"
      "gid=100"
      "exec"
      "reconnect"
      "ServerAliveInterval=15"
      "ServerAliveCountMax=3"
    ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp11s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0f0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0f1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp7s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
