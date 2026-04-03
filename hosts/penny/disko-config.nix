# USAGE in your configuration.nix.
# Update devices to match your hardware.
# {
#  imports = [ ./disko-config.nix ];
# }

# To store the passphrase for luks
# echo -n "passphrase" > /tmp/cryptroot.key
{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
  ];
  
  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/mmc-DV4064_0xda31b932";
        type = "disk";
          content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
          };
        };
      };
    };
  };
}
