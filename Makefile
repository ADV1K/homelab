.PHONY: apply

export NIX_CONFIG="experimental-features = nix-command flakes"

HOSTNAME := $(shell hostname)

apply:
	sudo nixos-rebuild switch --flake ./nixos#$(HOSTNAME)

format:
	@echo "⚠️ DANGEROUS: wipes disk and applies partitioning"
	sudo nix run github:nix-community/disko -- --mode disko ./nixos/disko.nix

disko-mount:
	sudo nix run github:nix-community/disko -- --mode mount ./nixos/disko.nix
