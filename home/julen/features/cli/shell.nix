{ pkgs, ... }:

{

  programs.bash = {
    enable = true;
    shellAliases = {
      la = "ls -la";
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      raspi5 = "ssh raspi5";
      raspiUrduliz = "ssh raspiUrduliz";
      serverSope = "ssh serverSope";
      vim = "nvim";
      "..." = "cd ../..";
      };
    interactiveShellInit = ''
      set fish_greeting ""
      oh-my-posh init fish --config https://raw.githubusercontent.com/julen-garcia/oh-my-posh-themes/refs/heads/main/amro_customized.omp.json | source
    '';
  };

  programs.oh-my-posh = {
    enable = true;
  };

  # replaced by oh-my-posh
  # programs.starship = {
  #   enable = true;
  # };

  programs.tmux = {
    enable = true;
  };

  # Better cat
  programs.bat = {
    enable = true;
  };

  # Better find (Yazi optional dependency)
  programs.fd = {
    enable = true;
  };

  # JSON sed,awk,etc.. alternative (Yazi optional dependency)
  programs.jq = {
    enable = true;
  };

  # File content searching (Yazi optional dependency)
  programs.ripgrep = {
    enable = true;
  };
 
  # Better resource monitor
  programs.btop = {
    enable = true;
  };

  # Better cd navigation
  programs.zoxide = {
    enable = true;
  };

  # TUI File manager
  programs.yazi = {
    enable = true;
  };

  # General purpose fuzzy finder (Yazi optional dependency)
  programs.fzf = {
    enable = true;
  };

  # CLI file editor
  programs.neovim = {
    enable = true;
  };

  home.packages = with pkgs; [
    yq
    neofetch
    file # File type detection (Yazi optional dependency)
    ffmpeg # Video thumbnail generation (Yazi optional dependency)
    p7zip # Archive extraction (Yazi optional dependency)
    poppler # PDF thumbnail generator (Yazi optional dependency)
    imagemagick # Image thumbnail generator (Yazi optional dependency)
    wl-clipboard # Clipboard manager (Yazi optional dependency)
    # productivity
    glow # markdown previewer in terminal
    #
    btop  # replacement of htop/nmon
    iftop # network monitoring
    # system tools
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];

}
