{
  services.pihole-ftl = {
    enable = true;
    lists = [
      #"example.com"
      "https://media.githubusercontent.com/media/zachlagden/Pi-hole-Optimized-Blocklists/main/lists/advertising.txt"
      "https://media.githubusercontent.com/media/zachlagden/Pi-hole-Optimized-Blocklists/main/lists/tracking.txt"
      "https://media.githubusercontent.com/media/zachlagden/Pi-hole-Optimized-Blocklists/main/lists/malicious.txt"
      "https://media.githubusercontent.com/media/zachlagden/Pi-hole-Optimized-Blocklists/main/lists/suspicious.txt"
      "https://media.githubusercontent.com/media/zachlagden/Pi-hole-Optimized-Blocklists/main/lists/comprehensive.txt"
    ];
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
        #        hosts = [
        #          "192.168.178.1,router"
        #          "192.168.178.2,pihole"
        #          "192.168.178.4,jellyfin"
        #          #"MAC,IP,NAME"
        #        ];
      };
      webserver = {
        enable = true;
        ports = [80];
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
