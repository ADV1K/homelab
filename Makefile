.PHONY: apply

HOSTNAME := $(shell hostname)

apply:
	sudo nixos-rebuild switch --flake ./nixos#$(HOSTNAME)

disko:
	@echo "⚠️ DANGEROUS: wipes disk and applies partitioning"
	sudo nix run github:nix-community/disko -- --mode disko ./nixos/disko.nix

disko-mount:
	sudo nix run github:nix-community/disko -- --mode mount ./nixos/disko.nix
