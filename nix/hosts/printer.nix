{ pkgs, ... }:
{
  services = {
    avahi = {
      enable = true;
    nssmdns4 = true;
      openFirewall = true;
    };
    printing = {
      enable = true;
      drivers = [ pkgs.brlaser ];
    };
  };
  hardware.sane.enable = true;
}
