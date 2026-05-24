{ ... }:
{
  imports = [
    ../../../modules/myservices/wallaos.nix
  ];

  wallaos = {
    enable = true;
    version = "4.9.0";
  };
}
