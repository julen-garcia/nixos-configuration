{ lib, config, ... }:
let
  dataPath = "/var/lib/isponsorblocktv";
in {

  # Import the needed secrets
  sops = {
    secrets = {
      "isponsorblocktv/screen-id" = {
        sopsFile = ../secrets.yaml;
      };
    };
  };

  system.activationScripts.serviceConfig = ''
    mkdir -p ${dataPath}
    SCREEN_ID="$(cat ${config.sops.secrets."isponsorblocktv/screen-id".path})"

    cat > ${dataPath}/config.json <<EOF
    {
      "devices": [
        { "screen_id": "$SCREEN_ID", "name": "TV Sope Nagore", "offset": 0 },
        { "screen_id": "$SCREEN_ID", "name": "TV Sope Julen", "offset": 0 }
      ],
      "apikey": "",
      "skip_categories": ["sponsor", "selfpromo"],
      "channel_whitelist": [],
      "skip_count_tracking": true,
      "mute_ads": true,
      "skip_ads": true,
      "minimum_skip_length": 1,
      "auto_play": true,
      "join_name": "iSponsorBlockTV",
      "use_proxy": true
    }
    EOF
  '';


  virtualisation.oci-containers.containers.isponsorblocktv = {
    image = "dmunozv04/isponsorblocktv";

    volumes = [
      "${dataPath}:/app/data"
    ];

  };

}
