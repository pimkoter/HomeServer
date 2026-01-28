{
  lib,
  pkgs,
  admin,
  name,
  ...
}: {
  users.users.${admin} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDhphwXEOkJNBVIZ12mCxz+KFbf5PaU0N1KX3hyWQRBN ${admin}@NixBTW"
    ];
    shell = pkgs.zsh;
  };

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  networking = {
    hostName = lib.mkDefault name;
    networkmanager.enable = lib.mkDefault true;
    firewall = {
      enable = true;
      trustedInterfaces = ["tailscale0"];
      allowedTCPPorts = lib.mkDefault [];
    };
  };

  services = {
    tailscale = {
      enable = true;
      useRoutingFeatures = lib.mkDefault "client";
    };
    openssh = {
      enable = true;
      passwordAuthentication = false;
    };
    fail2ban = {
      enable = true;
      bantime = "10m";
      bantime-increment.factor = "6";
    };
    resolved.enable = true;
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
  ];

  programs.zsh = {
    enable = true;
    shellInit = ''
      if [[ $- == *i* ]]; then
        echo welcome to ${name}
      fi
    '';

    shellAliases = {
      v = "nvim";
      sv = "sudo nvim";
      c = "clear";
      ll = "ls -l";
      la = "ls -al";
      ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      test = "cd ~/homeserver && git pull && sudo nixos-rebuild switch --flake .#${name}";
      upgrade = "cd ~/homeserver && git pull && sudo nixos-rebuild switch --flake .#${name}";
    };
  };

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  security.sudo.wheelNeedsPassword = lib.mkDefault true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.11";
}
