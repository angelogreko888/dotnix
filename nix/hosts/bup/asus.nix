{ config, lib, pkgs, modulesPath,  ... }:

{
  imports =
    [ 
	./configuration.nix 
	../shared-configuration.nix
	../hyprland .nix
    ];
  
  environment.systemPackages = with pkgs; [
  ];


}
