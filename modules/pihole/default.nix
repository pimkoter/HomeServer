let
  configDir = ./config;
in {
  #### Persistent storage for Pi-hole
  systemd.tmpfiles.rules = [
    "d /var/lib/pihole 0755 root root -"
    "d /var/lib/pihole/dnsmasq.d 0755 root root -"
  ];

  #### Pi-hole container
  virtualisation.oci-containers = {
    backend = "podman";

    containers.pihole = {
      image = "docker.io/pihole/pihole:latest";
      autoStart = true;

      ports = [
        "53:53/tcp"
        "53:53/udp"
        "8080:80/tcp" # Web UI
      ];

      volumes = [
        "/var/lib/pihole:/etc/pihole"
        "/var/lib/pihole/dnsmasq.d:/etc/dnsmasq.d"
      ];

      environment = {
        TZ = "Europe/Amsterdam";
        DNSMASQ_LISTENING = "all";
        WEBPASSWORD = "pimiseenleukejongen";
      };

      extraOptions = [
        "--cap-add=NET_ADMIN"
      ];

      restartPolicy = "always";
    };
  };

  # Firewall rules
  networking.firewall.allowedTCPPorts = [53 8080];
  networking.firewall.allowedUDPPorts = [53];

  # File Management
  environment.etc = {
    "pihole/adlists.list".source = "${configDir}/adlists.list";
    "pihole/pihole.toml".source = "${configDir}/pihole.toml";
  };
}
