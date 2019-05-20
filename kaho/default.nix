# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ../modules
      ../modules/desktop.nix
      ../modules/powersave.nix
  ];

  me = {
    # Use the default channel for less compilation.
    propagateNix = false;
    desktop = {
      enable = true;
      #wayland = true;
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "0";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.zfs.enableUnstable = true;
  boot.zfs.requestEncryptionCredentials = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "kaho"; # Define your hostname.
  networking.hostId = "a6825f89";
  networking.networkmanager.enable = true;

  zramSwap.enable = true;

  # Select internationalisation properties.
  i18n = {
     consoleFont = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  };

  environment.systemPackages = with pkgs; [
    acpi
  ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.extraModules = [
    pkgs.pulseaudio-modules-bt
  ];
  hardware.bluetooth.enable = true;

  # X11 settings.
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.videoDrivers = [ "intel" "modesetting" ];
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    s3tcSupport = true;
  };

  # Enable touchpad support.
  #services.xserver.libinput.enable = true;
  services.xserver.synaptics.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm = {
    autoLogin.enable = true;
    autoLogin.user = "svein";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

}