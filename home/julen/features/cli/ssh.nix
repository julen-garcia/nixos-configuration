{...}: {
  programs.ssh = {
    enable = true;
    matchBlocks  = {
      "raspi5" = {
        hostname = "raspi5.trusted";
        user = "raspi5";
        port = 2222;
        forwardAgent = true;
        extraOptions.StreamLocalBindUnlink = "yes";
      };
      "raspiUrduliz" = {
        hostname = "raspiUrduliz.trusted";
        user = "urduliz";
        forwardAgent = true;
        extraOptions.StreamLocalBindUnlink = "yes";
      };
      "serverSope" = {
        hostname = "server.trusted";
        user = "julen";
        forwardAgent = true;
        extraOptions.StreamLocalBindUnlink = "yes";
      };
    };
  };
}
