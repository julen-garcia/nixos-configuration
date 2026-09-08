{ ... }:
{
  imports = [
    ../../../modules/myservices/wallaos.nix
  ];

  wallaos = {
    enable = true;
    version = "5.5.0";
  };
}
