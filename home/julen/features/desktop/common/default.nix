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
    bitwarden-desktop
    # veracrypt
    # moonlight-qt
    # ente-auth
    # freecad-wayland
    # scrcpy
  ];

}
