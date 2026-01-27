{config, ...}: {
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  services = {
    tailscale = {
      useRoutingFeatures = "server";
      extraUpFlags = [
        "--advertise-exit-node"
        "--accept-dns"
      ];
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [config.services.tailscale.port];
    };
  };
}
