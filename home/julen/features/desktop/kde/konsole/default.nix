{ pkgs, ... } :
{
  programs.konsole = {
    enable = true;
    defaultProfile = "julen";
    extraConfig = {
      KonsoleWindow = {
        RememberWindowSize = false;
      };
    };

    profiles.default = {
      name = "julen";
      command = "${pkgs.fish}/bin/fish";
      colorScheme = "Breeze";
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 10;
      };
      extraConfig = {
        General = {
          TerminalColumns = 120;
          TerminalRows = 40;
        };
      };
    };
  };
}
