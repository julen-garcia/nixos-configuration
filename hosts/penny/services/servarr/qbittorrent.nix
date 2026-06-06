{ config, ... }:
{
  services.qbittorrent = {
    enable = true;
    user = "qbittorrent";
    group = "media";
    webuiPort = 18080;
    torrentingPort = 56259;
    serverConfig = {
      LegalNotice.Accepted = true;
      Preferences = {
        General.StatusbarExternalIPDisplayed = true;
        WebUI = {
          Username = "julen";
          Password_PBKDF2 = "@ByteArray(n5mP47a0xJChuoINVI1OBQ==:fuAR3XTpDRgXVZ4SEZGUeZEpy4srsiXQR+RIqnpcIjEIly5BnOUObSDufRxF4yqGQCPcmasEeUvVJ81k/8n2dw==)";
          CSRFProtection = false;
          ClickjackingProtection = false;
          HostHeaderValidation = false;
          SecureCookie = false;
        };
      };
      Core.AutoDeleteAddedTorrentFile = "IfAdded";
      BitTorrent.Session = {
        Preallocation = true;
        DefaultSavePath = "/zstorage/media/torrents";
        TempPath = "/zstorage/media/incomplete_torrents";
        TempPathEnabled = true;
        DisableAutoTMMByDefault = false;
        DisableAutoTMMTriggers = {
          CategorySavePathChanged = false;
          DefaultSavePathChanged = false;
        };
        MaxActiveDownloads=10;
        MaxActiveUploads=10;
        MaxActiveTorrents=20;
      };
      Network.PortForwardingEnabled = false;
    };
  };

  # Serve it through VPN
  vpnNamespaces.wg = {
    portMappings = [{
      from = config.services.qbittorrent.webuiPort;
      to = config.services.qbittorrent.webuiPort;
    }];
  };
  systemd.services.qbittorrent.vpnconfinement = {
    enable = true;
    vpnnamespace = "wg";
  };

  networking.firewall.allowedTCPPorts = [ config.services.qbittorrent.torrentingPort ];

  reverseProxy.hosts.qbittorrent = {
    httpPort = config.services.qbittorrent.webuiPort;
    ip = "192.168.15.1";
  };
  reverseProxy.hosts.torrent = {
    httpPort = config.services.qbittorrent.webuiPort;
    ip = "192.168.15.1";
  };
}
