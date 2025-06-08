{ pkgs, fetchurl, lib
, automake111, rogmp, roppl
, useCloog ? false
}:

let
  inherit (lib) optional;
in

let
  self = with pkgs; (overrideCC stdenv gcc10Stdenv).mkDerivation rec {
    pname = "cloog-static";
    version = "0.15.11";
    src = fetchurl {
      url = "ftp://gcc.gnu.org/pub/gcc/infrastructure/cloog-ppl-${version}.tar.gz";
      hash = "";
    };

    buildInputs = with pkgs; [
      automake111 autoconf264 gcc10 m4 rogmp
    ];
    hardeningDisable = ["format"];
    dontDisableStatic = true;

    configureFlags =
      [ "--disable-shared"
        "--with-gmp=${rogmp}"
        "--with-bits=gmp"
        "--with-ppl=${roppl}"
        "--with-host-libstdcxx='-lstdc++'"
      ];

    enableParallelBuilding = true;
  };
in self
