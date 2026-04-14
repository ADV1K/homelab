{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # configuration.nix
  system.stateVersion = "25.11";

  services.qemuGuest.enable = true;

  networking.hostName = "capybara";
  networking.wireless.enable = true;
  networking.useDHCP = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # core.nix
  time.timeZone = "Asia/Kolkata";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Nix Settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "advik" "@wheel" ];
  };

  # Cleanup old generations
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Automatic updates (Monthly cycle)
  system.autoUpgrade = {
    enable = true;
    flake = "github:advik/nixos-config#capybara"; # Placeholder, update with your repo
    dates = "monthly"; # Effectively a 1-month threshold for major updates
    allowReboot = true;
  };


  # modules/networking.nix
  networking.useNetworkd = true;
  systemd.network.enable = true;
  systemd.network.networks."10-wired" = {
    matchConfig.Type = "ether";
    networkConfig.DHCP = "yes";
  };

  programs.mosh.enable = true;
  services.fail2ban.enable = true;
  services.tailscale.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
    allowedUDPPortRanges = [
      { from = 60000; to = 61000; } # Mosh
    ];
    trustedInterfaces = [ "tailscale0" ];
  };


  # modules/users.nix
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = true; # No root login, no password.
  users.users.advik = {
    initialPassword = "nixie";
    isNormalUser = true;
    description = "Advik";
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.nushell;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPfBhL4psTGBlo+emwtTPdaySzaoScsbiKl4Z1tx1SXF"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMc4CmyjdX1qaResQVgFLipk2hK1YiUpCI1dJROIoHEP"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMV6lTfN9wnRCQEMrRmBRGMN6uRXQv+tCYU33KXeVTXW"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOyg+AejaQa5XoFMJnvWaQMmGR2YH9U3v1Tgw0oSQU6c"
    ];
  };

  # modules/shell.nix
  nixpkgs.config.allowUnfree = true;
  programs.starship.enable = true;
  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [
    # Shell
    nushell
    starship
    zoxide
    direnv

    # Core CLI
    osc
    git
    man
    bat
    #bat-extras
    gnumake
    neovim
    vim
    tmux
    htop
    btop
    ripgrep
    fd
    trash-cli
    netcat-gnu
    ncdu
    jq
    fzf
    eza
    uv
    direnv
    just
    stow
    fish
    curlie
    delta
    atuin
    curl
    docker-compose
  ];

  # TODO: this doesn't work, find another way
  #system.activationScripts.githubPackages.text = ''
  #    mkdir -p /usr/local/bin
  #    curl -fsSL https://i.jpillora.com/theimpostor/osc! | bash
  #    curl -fsSL https://i.jpillora.com/jesseduffield/lazydocker! | bash
  #    curl -fsSL https://i.jpillora.com/moncho/dry! | bash
  #    curl -fsSL https://i.jpillora.com/isacikgoz/tldr! | bash
  #    curl -fsSL https://i.jpillora.com/Bhupesh-V/ugit! | bash
  #    curl -fsSL https://i.jpillora.com/ogham/dog! | bash
  #  '';

  environment.variables = {
    EDITOR = "neovim";
    SHELL = "${pkgs.nushell}/bin/nu";
  };
}
