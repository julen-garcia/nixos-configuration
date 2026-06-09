{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings.raspi5 = {
      HostName = "raspi5.trusted";
      User = "raspi5";
      Port = 2222;
      ForwardAgent = true;
      StreamLocalBindUnlink = "yes";
    };
    settings."raspiUrduliz" = {
      HostName = "raspiUrduliz.trusted";
      User = "urduliz";
      ForwardAgent = true;
      StreamLocalBindUnlink = "yes";
    };
    settings."serverSope" = {
      HostName = "server.trusted";
      User = "julen";
      ForwardAgent = true;
      StreamLocalBindUnlink = "yes";
    };
    settings."penny" = {
      HostName = "penny.junaga.com";
      User = "julen";
      ForwardAgent = true;
      StreamLocalBindUnlink = "yes";
    };
  };
}
