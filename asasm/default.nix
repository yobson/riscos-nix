{ pkgs, fetchurl, lib
, automake111, libtool242
, robinutils, gccWrap
}:

let
  inherit (lib) optional;
in

let
  self = with pkgs; (overrideCC stdenv gcc10Stdenv).mkDerivation rec {
    pname = "asasm";
    version = "2.24";
    src = ./. ;

    buildInputs = with pkgs; [automake111 autoconf264 gcc10 m4 libbfd libtool242
                              robinutils gccWrap libarchive.dev pkg-config
                              flex bison ];

    configureFlags = [
      "--target=arm-unknown-riscos"
      "--disable-building-tool"
    ];
    enableParallelBuilding = true;
    hardeningDisable = ["format"];
    dontDisableStatic = true;
  };
in self
