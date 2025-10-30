{ config, lib, ...}:
{

  # Create the ssh-login group
  users.groups.ssh-login = { };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      AllowUsers = [ "julen" ];
      AllowGroups = [ "ssh-login" ];
      AllowTcpForwarding = true;
      AllowAgentForwarding = true;
      StreamLocalBindUnlink = true;
    };
  };
}
