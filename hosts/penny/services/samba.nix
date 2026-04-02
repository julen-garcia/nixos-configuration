{ ... }:
{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "penny";
        "netbios name" = "penny";
        "invalid users" = [
          "root"
        ];
        "passwd program" = "/run/wrappers/bin/passwd %u";
        security = "user";
      };
      julen = {
        path = "/zstorage/users/julen";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "julen";
      };
      nagore = {
        path = "/zstorage/users/nagore";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "nagore";
      };
      casa = {
        path = "/zstorage/users/casa";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "julen, nagore";
      };
    };
  };

  # Used to advertise the shares to windows hosts
  services.samba-wsdd = {
    enable = false;
    openFirewall = true;
    hostname = "penny.junaga.com"
  };

  networking.firewall.allowPing = true;
}
