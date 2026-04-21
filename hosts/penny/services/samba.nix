{   config,
  pkgs,
  ...
}: let
  username = "julen";
  ifGroupExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  smbSecretPath = config.sops.secrets."${username}-smb-password".path;
in {
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
    hostname = "penny.junaga.com";
  };

  networking.firewall.allowPing = true;

  # Samba Password
  # Import the needed secrets
  sops = {
    secrets = {
      "julen-smb-password" = {
        sopsFile = ../../common/secrets.yaml;
      };
    };
  };

  system.activationScripts = {
    # The "init_smbpasswd" script name is arbitrary, but a useful label for tracking
    # failed scripts in the build output. An absolute path to smbpasswd is necessary
    # as it is not in $PATH in the activation script's environment. The password
    # is repeated twice with newline characters as smbpasswd requires a password
    # confirmation even in non-interactive mode where input is piped in through stdin. 
    "init_${username}_smbpasswd".text = ''
      /run/current-system/sw/bin/printf "$(/run/current-system/sw/bin/cat ${smbSecretPath})\n$(/run/current-system/sw/bin/cat ${smbSecretPath})\n" | ${pkgs.samba}/bin/smbpasswd -sa ${username}
    '';
  };
}

