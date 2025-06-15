{ stdenv, lib, ... }:

stdenv.mkDerivation {
  name = "brother-fax-driver";
  version = "2.0.2-1";
  
  src = ./extracted_contents;
  
  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
  '';
  
  meta = with lib; {
    description = "Brother fax driver";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
