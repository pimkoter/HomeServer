{pkgs, ...}: {
  services.unbound = {
    enable = true;
    settings = {
      interface = "127.0.0.1";
      port = 5354;
      accessControl = ["127.0.0.1/32"];
      rootHints = pkgs.unbound-root-hints;
      prefetch = true;
      msgCacheSize = "16m";
      rrsetCacheSize = "16m";

      cacheMinTtl = 600;
      cacheMaxTtl = 604800;
    };
  };

  environment.systemPackages = with pkgs; [
    unbound-root-hints
  ];
}
