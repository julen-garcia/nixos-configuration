{
  config,
  pkgs,
  ...
}: let
  ifGroupExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  #sops.secrets.julen-hashed-password.neededForUsers = true;

  users.users.julen = {
    isNormalUser = true;
    description = "Julen";
    #hashedPasswordFile = config.sops.secrets.julen-hashed-password.path;
    uid = 1000;
    extraGroups = ifGroupExist [
      "users"
      "docker"
      "downloads"
      "dialout"
      "gamemode"
      "immich"
      "input"
      "libvirtd"
      "lp"
      "multimedia"
      "networkmanager"
      "podman"
      "scanner"
      "ssh-login"
      "vboxusers"
      "wheel"
    ];
    # openssh.authorizedKeys.keyFiles = [
    #   ../../../../home/julen/ssh-gpg.pub
    # ];
    home = "/home/julen";
    createHome = true;
    shell = pkgs.fish;
  };

  nix.settings.trusted-users = ["julen"];
}
