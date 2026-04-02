# README

## How to use a flake config

```bash
sudo nixos-rebuild switch --flake ~/<nixos-config-repo-folder>#<hostname>
```

## Create `networking.hostId`

The 32-bit host ID of the machine, formatted as 8 hexadecimal characters.

You should try to make this ID unique among your machines. You can generate a random 32-bit ID using the following commands:

`head -c 8 /etc/machine-id`

(this derives it from the machine-id that systemd generates) or

`head -c4 /dev/urandom | od -A none -t x4`

The primary use case is to ensure when using ZFS that a pool isn’t imported accidentally on a wrong machine.
