{ config, ... }:

{

  programs.keychain = {
    enable = true;
    keys = [ "/home/julen/.ssh/id_ed25519_sk" ];
  };

}
