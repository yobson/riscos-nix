{ pkgs, fetchurl, lib
, automake111, rogmp
, useCloog ? false
}:

let
  inherit (lib) optional;
in

let
  self = with pkgs; (overrideCC stdenv gcc10Stdenv).mkDerivation rec {
    pname = "ppl-static";
    version = "1.2";
    src = fetchurl {
      url = "https://www.bugseng.com/external/ppl/download/ftp/releases/${version}/ppl-${version}.tar.gz";
      hash = "";
    };

    buildInputs = with pkgs; [
      automake111 autoconf264 gcc10 m4 rogmp
    ];
    hardeningDisable = ["format"];
    dontDisableStatic = true;

    configureFlags =
      [ "--disable-shared"
        "--disable-watchdog"
        "--with-gnu-ld"
        "--with-gmp=${rogmp}"
      ];

    enableParallelBuilding = true;
  };
in self
