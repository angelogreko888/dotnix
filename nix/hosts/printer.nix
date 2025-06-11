{ pkgs, ... }:
{
  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };
    printing = {
      enable = true;
      drivers = [ pkgs.brlaser ];
    };
  };
  hardware.sane.enable = true;
}
