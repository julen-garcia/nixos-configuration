{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
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
      "penny" = {
        hostname = "penny.junaga.com";
        user = "julen";
        forwardAgent = true;
        extraOptions.StreamLocalBindUnlink = "yes";
      };
    };
  };
}
