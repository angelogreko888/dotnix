{ config, lib, pkgs, modulesPath, home-manager, ... }:
{
 imports =
    [ 
        ./configuration.nix 
        ../shared-configuration.nix
	../../modules/legion
	../hyprland.nix
    ];


  environment.systemPackages = with pkgs; [
  
  ];

  programs.hyprland.enable = true;



}
