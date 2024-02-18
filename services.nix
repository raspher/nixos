{ config, pkgs, ... }:
{
  # local dns
  services.unbound = {
    enable = true;
    resolveLocalQueries = true;
    enableRootTrustAnchor = true;
    settings = {
      server = {
	interface = [ "127.0.0.1" ];
	do-ip4 = "yes";
	do-udp = "yes";
	do-tcp = "yes";
        do-ip6 = "no";
	prefer-ip6 = "no";
	use-caps-for-id = "no";
	prefetch = "yes";
	num-threads = 1;
	so-rcvbuf = "1m";
	private-address = [ "192.168.0.0/16" "169.254.0.0/16" "172.16.0.0/12" "10.0.0.0/8" ];
      };
      forward-zone = {
	name = ".";
	forward-addr = [ "9.9.9.9" "149.112.112.112" "1.1.1.1" "1.0.0.1"];
      };
    };
  };

  # Add virtualization support
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable  = true; # virt-manager requires dconf to remember settings

  # docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  virtualisation.docker.daemon.settings = {
    dns = [ "127.0.0.1" "9.9.9.9" ];
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [ 25000 25001 25002 25003 25004 25005 ];
  #networking.firewall.allowedUDPPorts = [ 1337 25000 25001 25002 25003 25003 25004 25005 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
}
