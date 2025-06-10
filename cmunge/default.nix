{ pkgs, fetchurl, lib
, automake111, libtool242
, robinutils, gccWrap
}:

let
  inherit (lib) optional;
in

let
  self = with pkgs; (overrideCC stdenv gcc10Stdenv).mkDerivation rec {
    pname = "cmunge";
    version = "2.24";
    src = ./. ;

    buildInputs = with pkgs; [automake111 autoconf264 gcc10 m4 libbfd libtool242
                              robinutils gccWrap ];

    configureFlags = [
      "--target=arm-unknown-riscos"
    ];
    enableParallelBuilding = true;
    hardeningDisable = ["format"];
    dontDisableStatic = true;
  };
in self
