{ config, lib,  ... }:
let
  myLib = import ../../lib.nix { inherit lib config; };
  inherit (myLib) mkVirtualHost;
in {
  services = {
    nginx = {
      enable = true;

      virtualHosts = {
        "mediacache.fan-club-penguin.cz" = mkVirtualHost {
          acme = "fan-club-penguin.cz";
          path = "fan-club-penguin.cz/mediacache";
        };
      };
    };
  };
}
