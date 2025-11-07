{ pkgs, ... }:

{

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default = {
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        # General
        mkhl.direnv
        gruntfuggly.todo-tree
        yzhang.markdown-all-in-one
        streetsidesoftware.code-spell-checker
        # git
        eamodio.gitlens
        # Better configuration files support
        tamasfe.even-better-toml
        redhat.vscode-xml
        redhat.vscode-yaml
        # C/C++
        ms-vscode.cpptools-extension-pack
        twxs.cmake
        # C#
        ms-dotnettools.csdevkit
        ms-dotnettools.csharp
        ms-dotnettools.vscodeintellicode-csharp
        # Nix
        jnoortheen.nix-ide
        # PlantUML
        jebbs.plantuml
        # Python
        ms-python.python
        ms-python.vscode-pylance
        ms-python.pylint
        ms-python.debugpy
        #ms-python.vscode-python-envs
        #kevinrose.vsc-python-indent
        oderwat.indent-rainbow
        # Rust
        rust-lang.rust-analyzer
        # Remote development extensions
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-containers
        # Theme
        pkief.material-icon-theme
      ];
      userSettings = {
        "workbench.colorTheme" = "Default Dark Modern";
        "workbench.startupEditor" = "none";
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'Droid Sans Mono', 'monospace'";
        "editor.renderWhitespace" = "all";
        "editor.minimap.enabled" = false;
        "telemetry.feedback.enabled" = false;
        "telemetry.telemetryLevel" = "off";
        "remote.SSH.useLocalServer" = false; # Fix SSH connection issues
        "chat.disableAIFeatures" = true;
        "files.autoSave" = "afterDelay";
        "editor.rulers" = [120];
        "workbench.iconTheme" = "material-icon-theme";
        "material-icon-theme.folders.theme" = "specific";
        "material-icon-theme.folders.color" = "#90a4ae";
        "todo-tree.general.tags" = " 'BUG', 'FIXME', 'TODO', '[ ]', '[x]', 'TEST'";
        "todo-tree.highlights.defaultHighlight" = "{
          'icon': 'alert',
          'type': 'tag',
          'foreground': 'black',
          'background': 'white',
          'opacity': 10,
          'iconColour': 'blue',
          'gutterIcon': true
          }";
      };
    };
  };
}
