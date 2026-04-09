{ config, pkgs, ... }:
let
  local-user = "healthchecks";
in {
  # Import the needed secrets
  sops.secrets = {
    "healthchecks/ping-url" = {
      sopsFile = ../secrets.yaml;
      owner = local-user;
    };
  };

  users.groups.${local-user} = {};
  users.users.${local-user} = {
    group = local-user;
    isSystemUser = true;
  };

  systemd.services."healthchecks" = {
    description = "Ping healthchecks.io";
    serviceConfig = {
      Type = "oneshot";
      User = local-user;
      Group = local-user;
    };

    script = ''
      ${pkgs.curl}/bin/curl $(${pkgs.coreutils}/bin/cat "${config.sops.secrets."healthchecks/ping-url".path}")
    '';
  };

  systemd.timers."healthchecks" = {
    description = "Ping healthchecks.io periodically";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "1m";
      Unit = "healthchecks.service";
    };
  };
}

