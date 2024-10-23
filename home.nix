{ lib, pkgs, ... }:



{

nixpkgs.config.allowUnfree = true;

 home = {
    packages = with pkgs; [
      jetbrains-mono
    ];

    language = {
      base = "en_US.UTF-8";
      address = "es_ES.UTF-8";
      measurement = "es_ES.UTF-8";
      monetary = "es_ES.UTF-8";
      name = "es_ES.UTF-8";
      paper = "es_ES.UTF-8";
      telephone = "es_ES.UTF-8";
      time = "es_ES.UTF-8";
    };

    # This needs to actually be set to your username
    username = "julen";
    homeDirectory = "/home/julen";

    # You do not need to change this if you're reading this in the future.
    # Don't ever change this after the first build.  Don't ask questions.
    stateVersion = "24.05";
  };



programs.git = {
    enable = true;
    userName = "julen";
    userEmail = "76101410+julen-garcia@users.noreply.github.com";
    ignores = [ "*~" "*.swp" ];
    extraConfig = {
      init.defaultBranch = "master";
    };
};
}

