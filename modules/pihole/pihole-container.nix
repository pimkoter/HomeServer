{
  virtualisation = {
    oci-containers.backend = "docker";
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
  };

  virtualisation.oci-containers.containers = {
    pihole = {
      image = "pihole/pihole:latest";
      environment = {
        "TZ" = "Europe/Amsterdam";
        "ServerIP" = "192.168.178.2";
      };
      volumes = [
        "/home/pim/homeserver/modules/pihole/config/pihole:/etc/pihole:rw"
      ];
      ports = [
        "80:80/tcp"
        "67:67/udp"
      ];
      extraOptions = [
        "--network=host"
        "--cap-add=NET_ADMIN"
      ];
      log-driver = "journald";
    };
  };
}
