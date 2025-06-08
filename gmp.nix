{ pkgs, fetchurl, lib
, automake111
, useCloog ? false
}:

let
  inherit (lib) optional;
in

let
  self = with pkgs; (overrideCC stdenv gcc10Stdenv).mkDerivation rec {
    pname = "gmp-static";
    version = "5.0.1";
    src = fetchurl {
      url = "https://gmplib.org/download/gmp-${version}/gmp-${version}.tar.bz2";
      hash = "sha256-oqYQ8B/TKY3AjIe/MEmMJAJZDhvLIn/ECxXubSgJOfs=";
    };

    buildInputs = with pkgs; [
      automake111 autoconf264 gcc10 m4
    ];
    hardeningDisable = ["format"];

    patchFlags = [ "-p0" ];
    patches = [
      ./patches/gmp/mpn.arm.invert_limb.asm.p
    ];
    configureFlags =
      [ "--disable-shared"
        "--enable-cxx"
      ];

    enableParallelBuilding = true;
  };
in self
