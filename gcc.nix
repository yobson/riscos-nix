{ pkgs, fetchsvn, lib
, automake111, robinutils, rogmp, rompfr, rompc
, rogccSrc, riscosTargetTriple, roppl, rocloog
, disableMultilib ? false
}:

let
  inherit (lib) optional;
in

let
  self = with pkgs; (overrideCC stdenv gcc10Stdenv).mkDerivation rec {
    pname = "arm-unknown-riscos-gcc";
    version = rogccSrc.version;
    src = rogccSrc;

    nativeBuildInputs = with pkgs; [
      automake111 gcc10 autoconf264 m4 perl autogen gperf_3_0 robinutils rompfr rogmp rompc flex bison roppl rocloog
    ];
    hardeningDisable = ["format"];
    dontDisableStatic = true;

    preConfigure = ''
      cd ..
      mkdir build
      cd build
    '';
    configureScript = "../${rogccSrc.name}/configure";
    configureFlags =
      [ "--target=arm-unknown-riscos"
        "--with-mpfr=${rompfr}"
        "--with-mpc=${rompc}"
        "--with-gmp=${rogmp}"
        "--with-ppl=${roppl}"
        "--with-cloog=${rocloog}"
        "--with-host-libstdcxx=-lstdc++"
        "target_configargs=--enable-shared=libunixlib,libgcc,libstdc++"
        "--enable-lto"
        "--enable-threads=posix"
        "--enable-sjlj-exceptions=no"
        "--enable-c99"
        "--enable-cmath"
        "--disable-c-mbchar"
        "--disable-wchar_t"
        "--disable-libstdcxx-pch"
        "--disable-tls"
        "--enable-__cxa_atexit"
        "--enable-maintainer-mode"
        "--disable-werror"
        "--enable-interwork"
        "--disable-nls"
        "--disable-libquadmath"
        #"--enable-checking=release"
        "--enable-languages=c,c++"
      ]
      ++ optional disableMultilib "--disable-multilib";

    enableParallelBuilding = true;
    installTargets = [ "install" ];

    # Don't strip bootstrap compilers, sometimes causes issues for later stages
    dontStrip = true;

  };
in self
