# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [
    ../modules
    ./hardware-configuration.nix
    ./minecraft.nix
    #./mediawiki.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.devices = [
    "/dev/nvme0n1"
    "/dev/nvme1n1"
  ];
  boot.zfs.enableUnstable = true;
  
  ## Boot ##
  # Start up if at all possible.
  systemd.enableEmergencyMode = false;

  security.pam.loginLimits = [{
    domain = "minecraft";
    type = "-";
    item = "memlock";
    value = "16777216";
  }];

  services.bitlbee = {
    #enable = true;
    plugins = [ pkgs.bitlbee-discord ];
  };

  ## Backups ##
  services.zrepl = {
    enable = true;
    push.tsugumi = {
      rootFs = "rpool/home";
      exclude = [
        "rpool/home/minecraft/erisia/dynmap"
        "rpool/home/minecraft/incognito/dynmap"
        "rpool/home/minecraft/leisurely/dynmap"
        "rpool/home/minecraft/staging/dynmap"
      ];
      targetHost = "10.40.0.1";
    };
  };

  ## Networking ##
  networking.hostName = "madoka";
  networking.hostId = "8425e349";
  # Doesn't work due to missing interface specification.
  #networking.defaultGateway6 = "fe80::1";
  #networking.localCommands = ''
  #  ${pkgs.nettools}/bin/route -6 add default gw fe80::1 dev eth0 || true
  #'';
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];
  #networking.interfaces.eth0 = {
  #  ipv6.addresses = [{
  #    address = "2a01:4f9:2b:808::1";
  #    prefixLength = 64;
  #  }];
  #};
  networking.firewall = {
    allowPing = true;
    allowedTCPPorts = [ 
      80 443  # Web-server
      25565 25566 25567  # Minecraft
      25523  # Minecraft testing
      4000  # ZNC
      12345  # JMC's ZNC
    ];
    allowedUDPPorts = [
      34197  # Factorio
      10401  # Wireguard
    ];
  };
  #networking.nat = {
  #  enable = true;  # For mediawiki.
  #  externalIP = "138.201.133.39";
  #  externalInterface = "eth0";
  #  internalInterfaces = [ "ve-eln-wiki" ];
  #};

  # Wireguard link between my machines
  networking.wireguard = {
    interfaces.wg0 = {
      ips = [ "10.40.0.2/24" ];
      listenPort = 10401;
      peers = [
        # Tsugumi
        {
          allowedIPs = [ "10.40.0.1/32" ];
          endpoint = "brage.info:10401";
          persistentKeepalive = 30;
          publicKey = "H70HeHNGcA5HHhL2vMetsVj5CP7M3Pd/uI8yKDHN/hM=";
        }
        # Saya
        {
          allowedIPs = [ "10.40.0.3/32" ];
          persistentKeepalive = 30;
          publicKey = "VcQ9no2+2hSTa9BO2fEpickKC50ibWp5uo0HrNBFmk8=";
        }
      ];
      privateKeyFile = "/secrets/wg.key";
    };
  };


  users.include = [
    "mei" "einsig" "prospector" "minecraft" "bloxgate" "buizerd"
    "darqen27" "david" "jmc" "kim" "luke" "simplynoire" "vindex"
    "xgas" "will" "lucca" "dusk" "ahigerd"
  ];

  ## Postgresql **
  services.postgresql = {
    enable = true;
  };

  ## ACME ##
  security.acme = {
    certs = {
      "madoka.brage.info" = {
        email = "sveina@gmail.com";
        group = "wheel";
        allowKeysForGroup = true;
        postRun = "systemctl reload nginx.service";
        webroot = "/var/lib/acme/acme-challenge";
        extraDomains = {
          "status.brage.info" = null;
          "grafana.brage.info" = null;
          "tppi.brage.info" = null;
          "alertmanager.brage.info" = null;
          "map.brage.info" = null;
          "incognito.brage.info" = null;
          "tppi-map.brage.info" = null;
          "cache.brage.info" = null;
          "znc.brage.info" = null;
          "quest.brage.info" = null;
          "warmroast.brage.info" = null;
          "hydra.brage.info" = null;
          "pw.brage.info" = null;
        };
      };
    };
  };

  ## Webserver ##
  services.nginx = {
    package = pkgs.nginxMainline.override {
#      modules = with pkgs.nginxModules; [ njs dav moreheaders ];
    };
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    sslDhparam = ./nginx/dhparams.pem;
    statusPage = true;
    appendHttpConfig = ''
      add_header Strict-Transport-Security "max-age=31536000; includeSubdomains";
      add_header X-Clacks-Overhead "GNU Terry Pratchett";
      autoindex on;
      etag on;
    '';
    virtualHosts = let
      base = locations: {
        forceSSL = true;
        useACMEHost = "madoka.brage.info";
        inherit locations;
      };
      proxy = port: base {
        "/".proxyPass = "http://127.0.0.1:" + toString(port) + "/";
      };
      root = dir: base {
        "/".root = dir;
      };
      minecraft = {
        root = "/home/minecraft/web";
        tryFiles = "\$uri \$uri/ =404";
        extraConfig = ''
          add_header Cache-Control "public";
          expires 1h;
        '';
      };
    in {
      "madoka.brage.info" = base {
        "/" = minecraft;
        "/warmroast".proxyPass = "http://127.0.0.1:23000/";
        "/baughn".extraConfig = "alias /home/svein/web;";
        "/tppi".extraConfig = "alias /home/tppi/web;";
      } // { default = true; };
      "status.brage.info" = proxy 9090;
      "grafana.brage.info" = proxy 3000;
      "tppi.brage.info" = root "/home/tppi/web";
      "alertmanager.brage.info" = proxy 9093;
      "map.brage.info" = proxy 8123;
      "incognito.brage.info" = proxy 8124;
      "tppi-map.brage.info" = proxy 8126;
      "cache.brage.info" = root "/home/svein/web/cache";
      "znc.brage.info" = base { 
         "/" = {
           proxyPass = "https://127.0.0.1:4000";
           extraConfig = "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;";
         };
      };
      "quest.brage.info" = proxy 2222;
      "warmroast.brage.info" = proxy 23000;
      "hydra.brage.info" = proxy 3001;
      "pw.brage.info" = proxy 1057;
    };
  };
}
