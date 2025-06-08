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
      hash = "sha256-fNY00LK0AbBAlrVFkVrGf4g1VumlJOjoA6a/YheoTV8=";
    };

    patchFlags = ["-p0"];
    patches = [
      ./patches/cloog/autogen.sh.p
      ./patches/cloog/configure.in.p
    ];

    preConfigure = ''
      echo "PRECONF"
      ( ./autogen.sh )
    '';

    buildInputs = with pkgs; [
      automake111 autoconf264 autogen perl gcc10 m4 rogmp roppl
      libtool
    ];
    hardeningDisable = ["format"];
    dontDisableStatic = true;

    configureFlags =
      [ "--disable-shared"
        "--with-gmp=${rogmp}"
        "--with-bits=gmp"
        "--with-ppl=${roppl}"
        "--disable-ppl-version-check"
        "--with-host-libstdcxx='-lstdc++'"
      ];

    enableParallelBuilding = true;
  };
in self
