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
      "podman"
    ];
    openshh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINlP79E5afLrWTGkIX92RqPeqUetb2oCfprwxLdPpxGZ ${admin}@NixBTW"
    ];
  };

  networking = {
    hostName = name;
    networkmanager.enable = lib.mkDefault false;
    firewall = {
      enable = true;
      trustedInterfaces = ["tailscale0"];
      allowedTCPPorts = lib.mkDefault [];
    };
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enable = true;
    };
  };

  services = {
    tailscale = {
      enable = true;
      useRoutingFeatures = lib.mkdDefault "client";
    };
    resolved.enable = true;
    openssh.enable = true;
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
  ];

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  security.sudo.wheelNeedsPassword = lib.mkDefault true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.11";
}
