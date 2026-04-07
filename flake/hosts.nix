{ lib, ... }:

{
  options.hosts = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
      options = {
        system = lib.mkOption {
          type = lib.types.str;
          default = "x86_64-linux";
          description = "System type for host ${name}";
        };

        users = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "Home-manager users on host ${name}";
        };
      };
    }));
    default = {};
    description = "Host definitions (system + home-manager users)";
  };

  config.hosts = {
    penny = {
      users = [ "julen" ];
    };

    sheldon = {
      users = [ "julen" ];
    };

  };
}