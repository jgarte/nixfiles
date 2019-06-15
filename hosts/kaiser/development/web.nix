{ config, pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_10;
    enableTCPIP = true;
    extraPlugins = [ (pkgs.plv8.override { postgresql = pkgs.postgresql_10; }) ];
    authentication = ''
      local all all trust
      host all all 10.0.0.28/0 trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
  };

  services.mysql = {
    enable = true;
    initialDatabases = [
      { name = "entries"; schema = /home/jtojnar/Projects/entries/install.sql; }
    ];
    package = pkgs.mariadb;
  };

  services.postfix = {
    enable = true;
  };

  services.httpd = {
    enable = true;
    adminAddr = "admin@localhost";
    documentRoot = "/home/jtojnar/Projects";
    enablePHP = true;
    phpOptions = ''
      display_errors = 1
      display_startup_errors = 1
      error_reporting = E_ALL;
    '';
    extraConfig = ''
      DirectoryIndex index.php
      <Directory "/home/jtojnar/Projects">
        Options Indexes FollowSymLinks
        AllowOverride All
      </Directory>
    '';
  };
}