{ config, lib, pkgs, modulesPath, home-manager, ... }:
{
 imports =
    [ 
        ./configuration.nix 
        ../shared-configuration.nix
	../../modules/loq
	../hyprland.nix
	./nvidia.nix
    ];


  environment.systemPackages = with pkgs; [
  
  ];

  programs.hyprland.enable = true;



}
