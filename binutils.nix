{ pkgs, fetchurl, lib
, automake111
, disableMultilib ? false 
}:

let
  inherit (lib) optional;
in

let
  self = with pkgs; (overrideCC stdenv gcc10Stdenv).mkDerivation rec {
    pname = "arm-unknown-riscos-binutils";
    version = "2.24";
    src = fetchurl {
      url = "https://ftpmirror.gnu.org/binutils/binutils-${version}.tar.bz2";
      hash = "sha256-5ejFvpZk5/f5bg0JkZEQq1rVl3lPWxgJhxF3oPDxQTc=";
    };

    buildInputs = with pkgs; [automake111 autoconf264 gcc10 m4 libbfd];

    prePatch = ''
      cp -r ${./files/binutils}/* .
    '';

    patchFlags = [ "-p0" ];
    patches = [
      ./patches/binutils/ld.scripttempl.elf.sc.p
      ./patches/binutils/ld.emultempl.armelf.em.p
      ./patches/binutils/include.bfdlink.h.p
      ./patches/binutils/bfd.elf.c.p
      ./patches/binutils/ld.Makefile.am.p
      ./patches/binutils/ld.configure.tgt.p
      ./patches/binutils/bfd.opncls.c.p
      ./patches/binutils/gas.configure.tgt.p
      ./patches/binutils/bfd.config.bfd.p
      ./patches/binutils/gas.config.tc-arm.h.p
      ./patches/binutils/binutils.readelf.c.p
      ./patches/binutils/include.elf.common.h.p
      ./patches/binutils/bfd.elf32-arm.c.p
      ./patches/binutils/bfd.bfd-in.h.p
      ./patches/binutils/gas.config.tc-arm.c.p
    ];
    preConfigure = ''
      (cd ld && automake)
    '';
    configureFlags =
      [ "--target=arm-unknown-riscos"
        "--enable-maintainer-mode"
        "--disable-werror"
        "--with-gcc"
        "--enable-interwork"
        "--disable-nls"
        "target_alias=arm-unknown-riscos"
        "--no-create"
        "--no-recursion"
      ]
      ++ optional disableMultilib "--disable-multilib";

    postConfigure = ''
      ./config.status
    '';

    enableParallelBuilding = true;
  };
in self
