{
  config,
  pkgs,
  ...
}: {
  services.logrotate.enable = config.services.nginx.enable;
  services.logrotate.settings.header = ''
    compress
    compresscmd ${pkgs.zstd}/bin/zstd
    compressext zst

    /var/log/nginx/*.log {
      rotate 5
      weekly
      postrotate
        ${pkgs.psmisc}/bin/killall -USR1 nginx
      endscript
  '';
}
