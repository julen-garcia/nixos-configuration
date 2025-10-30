{...}: {
  programs.ssh = {
    enable = true;
    matchBlocks  = {
      "raspi5" = {
        hostname = "raspi5.trusted";
        user = "raspi5";
        forwardAgent = true;
        extraOptions.StreamLocalBindUnlink = "yes";
      };
      "raspiUrduliz" = {
        hostname = "raspiUrduliz.trusted";
        user = "urduliz";
        forwardAgent = true;
        extraOptions.StreamLocalBindUnlink = "yes";
      };
    };
  };
}
