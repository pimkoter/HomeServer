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
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINlP79E5afLrWTGkIX92RqPeqUetb2oCfprwxLdPpxGZ ${admin}@NixBTW"
    ];
    shell = pkgs.zsh;
  };

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  networking = {
    hostName = name;
    networkmanager.enable = lib.mkDefault false;
    firewall = {
      enable = true;
      trustedInterfaces = ["tailscale0"];
      allowedTCPPorts = lib.mkDefault [];
    };

    #   interfaces = {
    #     ens18 = {
    #       ipv4.addresses = [
    #         {
    #           # adresses = "IP";
    #           prefixLength = 24;
    #         }
    #       ];
    #     };
    #   };
  };

  services = {
    tailscale = {
      enable = true;
      useRoutingFeatures = lib.mkDefault "client";
    };
    resolved.enable = true;
    openssh.enable = true;
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
  ];

  programs.zsh = {
    enable = true;
    shellInit = ''
      echo welcome to ${name}
    '';
    shellAliases = {
      v = "nvim";
      sv = "sudo nvim";
      c = "clear";
      ll = "ls -l";
      la = "ls -al";
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
