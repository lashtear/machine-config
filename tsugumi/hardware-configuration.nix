# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "nvmpool/nixos";
      fsType = "zfs";
    };

  fileSystems."/var" =
    { device = "nvmpool/nixos/var";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/BFA4-84D9";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "stash/home";
      fsType = "zfs";
    };

  fileSystems."/home/aquagon" =
    { device = "stash/home/aquagon";
      fsType = "zfs";
    };

  fileSystems."/home/svein" =
    { device = "stash/home/svein";
      fsType = "zfs";
    };

  fileSystems."/home/svein/dev" =
    { device = "nvmpool/svein/dev";
      fsType = "zfs";
    };

  fileSystems."/home/svein/fast" =
    { device = "nvmpool/svein";
      fsType = "zfs";
    };

  fileSystems."/home/svein/Media" =
    { device = "stash/home/svein/Media";
      fsType = "zfs";
    };

  fileSystems."/home/svein/Games" =
    { device = "stash/home/svein/Games";
      fsType = "zfs";
    };

  fileSystems."/home/svein/Documents" =
    { device = "stash/home/svein/Documents";
      fsType = "zfs";
    };

  fileSystems."/home/svein/backups" =
    { device = "stash/home/svein/backups";
      fsType = "zfs";
    };

  fileSystems."/home/svein/dcc" =
    { device = "stash/home/svein/dcc";
      fsType = "zfs";
    };

  fileSystems."/home/svein/web" =
    { device = "stash/home/svein/web";
      fsType = "zfs";
    };

  fileSystems."/home/svein/secure-encfs" =
    { device = "stash/home/svein/secure-encfs";
      fsType = "zfs";
    };

  fileSystems."/home/svein/secure" =
    { device = "stash/home/svein/secure";
      fsType = "zfs";
    };

  fileSystems."/home/svein/short-term" =
    { device = "stash/home/svein/short-term";
      fsType = "zfs";
    };

  fileSystems."/home/minecraft" =
    { device = "minecraft";
      fsType = "zfs";
    };

  fileSystems."/home/minecraft/erisia" =
    { device = "minecraft/erisia";
      fsType = "zfs";
    };

  fileSystems."/home/minecraft/erisia/dynmap" =
    { device = "minecraft/erisia/dynmap";
      fsType = "zfs";
    };

  fileSystems."/home/minecraft/incognito" =
    { device = "minecraft/incognito";
      fsType = "zfs";
    };

  fileSystems."/home/minecraft/incognito/dynmap" =
    { device = "minecraft/incognito/dynmap";
      fsType = "zfs";
    };

  fileSystems."/home/minecraft/testing" =
    { device = "minecraft/testing";
      fsType = "zfs";
    };

  fileSystems."/home/minecraft/testing/dynmap" =
    { device = "minecraft/testing/dynmap";
      fsType = "zfs";
    };

  fileSystems."/var/lib/plex/mount" =
    { device = "stash/plex-media";
      fsType = "zfs";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/591e487a-926d-4dbe-b5ce-623b81a8d1bf"; }
    ];

  nix.maxJobs = lib.mkDefault 12;
}
