{ pkgs, fetchurl, lib
, automake111, rogmp
, useCloog ? false
}:

let
  inherit (lib) optional;
in

let
  self = with pkgs; (overrideCC stdenv gcc10Stdenv).mkDerivation rec {
    pname = "mpfr-static";
    version = "3.0.1";
    src = fetchurl {
      url = "https://www.mpfr.org/mpfr-${version}/mpfr-${version}.tar.bz2";
      hash = "sha256-4ZdwmbtJQxnA8MH4V1kFDEGKVohOnGzvHFQLmxPjjn8=";
    };

    buildInputs = with pkgs; [
      automake111 autoconf264 gcc10 m4 rogmp
    ];
    hardeningDisable = ["format"];
    dontDisableStatic = true;

    configureFlags =
      [ "--disable-shared"
        "--with-gmp=${rogmp}"
      ];

    enableParallelBuilding = true;
  };
in self
