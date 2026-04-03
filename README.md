# README

## Check new SSD drive

`sudo smartctl -a /dev/nvme1n1`

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

## Samba

Create user passwords

`sudo smbpasswd -a <user_name>`

## sops

problems with the SSH keys in sheldon, created age key directly

```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```

## install from other computer

- create the ssh keys

```bash
mkdir -p /tmp/<host_name>/etc/ssh
ssh-keygen -t ed25519 -C <host_name> -f /tmp/<host_name>/etc/ssh/ssh_host_ed25519_key
nix-shell -p ssh-to-age --run 'cat /tmp/<hostname>/etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'
```

- Register the age key for the new host into `.sops.yaml` and update any related secrets file

``` bash
nix-shell -p sops --run "sops updatekeys hosts/common/secrets.yaml"
```

- Perform the installation over SSH

```bash
nix run github:nix-community/nixos-anywhere -- \
--extra-files /tmp/<host_name> \
--flake '.#<host_name>' \
--target-host nixos@<host_ip>
```
