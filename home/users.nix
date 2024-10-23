{ inputs, lib, config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.users.gid = 100;

  users.users."julen" = {
    isNormalUser = true;
    description = "Julen";
    uid = 1000;
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDD3VRBhHVtnYrloTnHPvzcB+Z6GhvTdLmk3W0kFnARtgDnDrkELPaGAutp4dX7C6OfPgBuEUrlq0Urr5+OUfPLUffZZwBr4XOsWvRzqSIk99f5RjnBt/PiGMCcGEs/7eqNnnPGK3Pb02JG0HLFrWFTWjMc1IWLYJEFl98KTcMRdPuLt/kc7wG7Ud6qK+0+A7qKq/3c9LRc5YNgGbOvSmQ/I2qTMbb048noN/ICn2MksjpeVdHtZHhUkTqXhc/xyCln+sZNt+7rAPxtZFSSJPB6YBrYaFWvzJ8igetGbfwidq5by5uo3h/q1as1etF9J49TvOo6PF4jkOCBdi0/KMYTIrAJXeAAtqsylgwCAYzkspNhOTUfD1VRPTCQIUdXJAHGJRsNCbpHE+18iWHwgVZWpPtIpp5JE/QmZPMmO6l0Nskgkdr5915nBIz2Wdie9mU4t0G1zZL3a45BtPdip3/trXdWESD8v9+s6An+THMMGhgv3ozSP8To+/Vrk8MDb1E4jfmygcV05GXx0uE1OqgX6NCiXS9k9eJghvpanlYnbHMFxsyD5patB7hNK67OjWVcfLe4PJCC284I7wzMjglW+s92Ff9XFkope7eknbZQiPXUF9kRWWocGLUiKtcghhmLI1Nv+uzqf5K8sOv+Cy6eyEAWYDkFq3i8l7bHsaZz9w== openpgp:0xB7681FF7"
    ];
    home = "/home/julen";
    createHome = true;
  };

  users.motd = "this is my wonderful motd";

  nix.settings.trusted-users = [ "julen" ];
}
