{
  config,
  pkgs,
  ...
}: let
  ifGroupExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  sops.secrets.julen-hashed-password.neededForUsers = true;

  users.users.julen = {
    isNormalUser = true;
    description = "Julen";
    hashedPasswordFile = config.sops.secrets.julen-hashed-password.path;
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
    openssh.authorizedKeys.keys = ["sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILxQX6l7c6W8tX8fcsjcdl7aH5DxaPkrGPFAzaOs1mnxAAAABHNzaDo= julen"];
    home = "/home/julen";
    createHome = true;
    shell = pkgs.fish;
  };

  nix.settings.trusted-users = ["julen"];
}
