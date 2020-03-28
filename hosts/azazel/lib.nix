{ config, lib, ... }: {
  mkVirtualHost = { path ? null, config ? "", acme ? null, redirect ? null }:
  (if lib.isString acme then {
    useACMEHost = acme;
    forceSSL = true;
  } else {}) // (if lib.isBool acme then {
    enableACME = acme;
    forceSSL = true;
  } else {}) // (if redirect != null then {
    globalRedirect = redirect;
  } else {}) // (if path != null then {
    root = "/var/www/" + path;
  } else {}) // {
    extraConfig = config;
  };
  mkPhpPool = { user, debug ? false }: {
    inherit user;
    settings = {
      "listen.owner" = "nginx";
      "listen.group" = "root";
      "pm" = "dynamic";
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
    } // (lib.optionalAttrs debug {
      # log worker's stdout, but this has a performance hit
      "catch_workers_output" = true;
    });
  };
  enablePHP = sockName: ''
    fastcgi_pass unix:${config.services.phpfpm.pools.${sockName}.socket};
    include ${config.services.nginx.package}/conf/fastcgi.conf;
    fastcgi_param PATH_INFO $fastcgi_path_info;
    fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
  '';
  mkCert = { domains }: {
    user = config.users.users.nginx.name;
    group = config.users.groups.nginx.name;
    allowKeysForGroup = true;
    webroot = "/var/lib/acme/acme-challenge";
    extraDomains = builtins.listToAttrs (map (d: {name = d; value = null;}) domains);
    postRun = ''
      systemctl reload nginx || true
    '';
  };
}
