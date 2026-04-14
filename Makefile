.PHONY: apply partition format mount install

NIX_FLAGS=--extra-experimental-features "nix-command flakes"

test:
	nixos-rebuild $(NIX_FLAGS) dry-build --flake ./nixos#capybara

apply:
	nixos-rebuild $(NIX_FLAGS) switch --flake ./nixos#capybara

partition:
	nix $(NIX_FLAGS) run github:nix-community/disko -- --mode disko --flake ./nixos#capybara

mount:
	nix $(NIX_FLAGS) run github:nix-community/disko -- --mode mount --flake ./nixos#capybara

install: partition
	nixos-install --flake ./nixos#capybara --no-root-passwd
