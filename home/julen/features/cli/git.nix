{ ... }:

{

  programs.git = {
    enable = true;
    userName = "Julen Garcia";
    lfs.enable = true;
    userEmail = "76101410+julen-garcia@users.noreply.github.com";
    signing = {
       signByDefault = true;
    };
    extraConfig = {
        init.defaultBranch = "master";
        # Merge on pull conflicts
        pull.rebase = false;
        # Automatically track remote branch
        push.autoSetupRemote = true;
        # Fetch removed upstream branches
        fetch.prune = true;
        # Sign all commits using ssh key
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_ed25519_sk.pub";
      };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        language = "en";
        timeFormat = "2006-01-02T15:04:05-07:00";
        shortTimeFormat = "15:04";
        #nerdFontsVersion: "3";
      };
      git = {
        merging.manualCommit = true;
        autoFetch = false;
        #overrideGpg = true;
        disableForcePushing = true;
      };
      update.method = "never";
      os.editPreset = "nvim";
      disableStartupPopups = true;
    };
  };
}
