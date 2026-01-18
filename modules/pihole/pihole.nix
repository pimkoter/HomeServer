{
  services.pihole-ftl = {
    enable = true;
    lists = {
      allow.type = [./blocklists.nix];
      block.type = [./allowlists.nix];
    };
    settings = {
      dns = {
        upstreams = ["127.0.0.1#5354"];
        interface = "ens18";
        expandHosts = true;
      };
      dhcp = {
        active = true;
        start = "192.168.178.50";
        end = "192.168.178.254";
        router = "192.168.178.1";
        leaseTime = "12h";
        hosts = [
          "192.168.178.1,router"
          "192.168.178.2,pihole"
          "192.168.178.4,jellyfin"
          #"MAC,IP,NAME"
        ];
      };
      webserver = {
        enable = true;
        api = {
          pwhash = "";
        };
      };
      misc = {
        readOnly = false;
      };
    };
  };
}
