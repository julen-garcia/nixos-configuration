{ pkgs, config, ... }: 
let 
  port = 444;
in
{

  # Import the needed secrets
  sops = {
    secrets = {
      "pihole/pwhash" = {
        sopsFile = ../secrets.yaml;
      };
      "pihole/app_pwhash" = {
        sopsFile = ../secrets.yaml;
      };
    };
  };


  # Disable systemd-resolved DNS stub
  services.resolved = {
    enable = true;
    extraConfig = ''
      DNSStubListener=no
      MulticastDNS=off
    '';
  };

  services.pihole-ftl = {
    enable = true;

    openFirewallDNS = true;

    # DHCP and web server ports closed
    openFirewallDHCP = false;
    openFirewallWebserver = false;

    # Optional query log cleaner
    queryLogDeleter = {
      enable = true;
      age = 30;
    };

    lists = [
      {
        url = "https://big.oisd.nl";
        type = "block";
        enabled = true;
        description = "oisd big";
      }

      {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        type = "block";
        enabled = true;
        description = "StevenBlack Hosts";
      }
    ];

    settings = {

      misc = {
        # Allow API/UI changes
        readOnly = false;
      };

      dns = {

        upstreams = [
          "1.1.1.1"
          "1.0.0.1"
          "76.76.2.2"
        ];

        hosts = [
          "10.2.1.15 telf-julen.trusted"
          "10.2.1.36 server.trusted"
          "10.2.1.35 raspi5.trusted"
          "10.2.1.30 tv.trusted"
          "10.2.1.18 jgsaenz-port.trusted"
          "10.2.1.19 jgsaenz-port-dock.trusted"
          "10.2.1.1 unifi.trusted"
          "10.2.1.10 sheldon.trusted"
          "10.2.1.16 telf-nagore.trusted"
          "10.2.1.17 telf-julen-trabajo.trusted"
          "10.2.1.37 penny.junaga.com"
        ];

        cnameRecords = [
          "junaga.com,raspi5.trusted"
          "raspi5.junaga.com,junaga.com"
          "radarr.junaga.com,junaga.com"
          "sonarr.junaga.com,junaga.com"
          "qbittorrent.junaga.com,junaga.com"
          "jackett.junaga.com,junaga.com"
          "bitwarden.junaga.com,penny.junaga.com"
          "router.junaga.com,penny.junaga.com"
          "ntfy.junaga.com,penny.junaga.com"
          "pocketid.junaga.com,penny.junaga.com"
          "actual.junaga.com,penny.junaga.com"
          "fotos.junaga.com,penny.junaga.com"
          "homer.junaga.com,penny.junaga.com"
          "donetick.junaga.com,penny.junaga.com"
          "gatus.junaga.com,penny.junaga.com"
          "casa.junaga.com,penny.junaga.com"
          "sheldon.junaga.com,sheldon.trusted"
          "lubelogger-penny.junaga.com,penny.junaga.com"
          "pihole.junaga.com,penny.junaga.com"
        ];

        expandHosts = true;

        listeningMode = "LOCAL";
      };

      dhcp = {
        active = false;
      };

      webserver = {
        #domain = "junaga.com";

        headers = [
          "X-DNS-Prefetch-Control: off"
          "Content-Security-Policy: default-src 'self' 'unsafe-inline';"
          "X-Frame-Options: DENY"
          "X-XSS-Protection: 0"
          "X-Content-Type-Options: nosniff"
          "Referrer-Policy: strict-origin-when-cross-origin"
        ];

        api = {
          # Permit destructive actions via API
          allow_destructive = true;

          pwhash = "$(cat ${config.sops.secrets."pihole/pwhash".path})";

          app_pwhash = "$(cat ${config.sops.secrets."pihole/app_pwhash".path})";

          # Allow API clients/apps to modify settings
          app_sudo = false;

        };
      };
    };
  };

  services.pihole-web = {
    enable = true;

    ports = [
      port
    ];
  };

  reverseProxy.hosts.pihole.httpPort = port;

}