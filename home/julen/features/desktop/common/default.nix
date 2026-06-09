{ pkgs, inputs, ... }:

{

  imports = [
    ./firefox.nix
    ./chromium.nix
    ./vscode.nix
    ./default-applications.nix
  ];

  home.packages = with pkgs; [
    jetbrains-mono
    # bitwarden-desktop # Temporary disabled until electron 39 not used
    # veracrypt
    # moonlight-qt
    # ente-auth
    # freecad-wayland
    # scrcpy
  ];

}
