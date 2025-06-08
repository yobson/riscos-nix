{ pkgs, fetchurl, lib
, automake111, rogmp, rompfr
, useCloog ? false
}:

let
  inherit (lib) optional;
in

let
  self = with pkgs; (overrideCC stdenv gcc10Stdenv).mkDerivation rec {
    pname = "mpc-static";
    version = "1.1.0";
    src = fetchurl {
      url = "https://ftpmirror.gnu.org/mpc/mpc-${version}.tar.gz";
      hash = "sha256-aYXFOBQ8EgjcsaxCztrW/1LiZ7R+X5cBg6PnUSW0PC4=";
    };

    buildInputs = with pkgs; [
      automake111 autoconf264 gcc10 m4 rogmp rompfr
    ];
    hardeningDisable = ["format"];

    configureFlags =
      [ "--disable-shared"
        "--with-gmp=${rogmp}"
        "--with-mpfr=${rompfr}"
      ];

    enableParallelBuilding = true;
  };
in self
