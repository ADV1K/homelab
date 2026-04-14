## Installation

```bash
nix-shell -p git gnumake
git clone https://github.com/adv1k/homelab
cd homelab
make partition  # creates efi and root partition on /dev/sda
make apply
```
