{pkgs, ...}:
{
programs.firejail = {
  enable = true;
  wrappedBinaries = {
    librewolf = {
      executable = "${pkgs.librewolf}/bin/librewolf";
      profile = "${pkgs.firejail}/etc/firejail/librewolf.profile";
      extraArgs = [
        # Required for U2F USB stick
        "--ignore=private-dev"
        # Enforce dark mode
        "--env=GTK_THEME=Adwaita:dark"
        # Enable system notifications
        "--dbus-user.talk=org.freedesktop.Notifications"
      ];
    };

environment.etc = {
  "firejail/librewolf.local".text = ''
# Enable native notifications.
dbus-user.talk org.freedesktop.Notifications
# Allow inhibiting screensavers.
dbus-user.talk org.freedesktop.ScreenSaver
# Allow screensharing under Wayland.
dbus-user.talk org.freedesktop.portal.Desktop
  '';
};

services.tor = {
  enable = true;
  openFirewall = true;
  settings = {
    TransPort = [ 9040 ];
    DNSPort = 5353;
    VirtualAddrNetworkIPv4 = "172.30.0.0/16";
  };
};

networking = {
  useNetworkd = true;
  bridges."tornet".interfaces = [];
  nftables = {
    enable = true;
    ruleset = ''
      table ip nat {
        chain PREROUTING {
          type nat hook prerouting priority dstnat; policy accept;
          iifname "tornet" meta l4proto tcp dnat to 127.0.0.1:9040
          iifname "tornet" udp dport 53 dnat to 127.0.0.1:5353
        }
      }
    '';
  };
  nat = {
    internalInterfaces = [ "tornet " ];
    forwardPorts = [
      {
        destination = "127.0.0.1:5353";
        proto = "udp";
        sourcePort = 53;
      }
    ];
  };
  firewall = {
    enable = true;
    interfaces.tornet = {
      allowedTCPPorts = [ 9040 ];
      allowedUDPPorts = [ 5353 ];
    };
  };
};

systemd.network = {
  enable = true;
  networks.tornet = {
    matchConfig.Name = "tornet";
    DHCP = "no";
    networkConfig = {
      ConfigureWithoutCarrier = true;
      Address = "10.100.100.1/24";
    };
    linkConfig.ActivationPolicy = "always-up";
  };
};

boot.kernel.sysctl = {
  "net.ipv4.conf.tornet.route_localnet" = 1;
};

firejail --net=tornet --dns=46.182.19.48 --profile=$(nix --extra-experimental-features nix-command --extra-experimental-features flakes eval -f '<nixpkgs>' --raw 'firejail')/etc/firejail/firefox.profile librewolf



}
