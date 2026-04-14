## Installation

To partition a fresh disk and install NixOS on it, run the following. this will create a user `advik` with password `nixie`.

```bash
nix-shell -p git gnumake
git clone https://github.com/adv1k/homelab
cd homelab
sudo make install
```
