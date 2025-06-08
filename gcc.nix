{ pkgs, fetchsvn, lib
, automake111, robinutils, rogmp, rompfr, rompc
, riscosTargetTriple, roppl, rocloog, libtool242
, disableMultilib ? false
}:

let
  inherit (lib) optional;
in

let
  self = with pkgs; (overrideCC stdenv gcc10Stdenv).mkDerivation rec {
    pname = "arm-unknown-riscos-gcc";
    version = "4.7.4";
    src = fetchsvn {
      url = "svn://gcc.gnu.org/svn/gcc/branches/gcc-4_7-branch";
      rev = "280157";
      hash = "sha256-lBrys9TNa80hNMqXgoK1gJFdemiBnd/hfZqWzFzx0BQ=";
    };

    nativeBuildInputs = with pkgs; [
      automake111 gcc10 autoconf264 m4 perl autogen gperf_3_0 robinutils
      rompfr rogmp rompc flex bison roppl rocloog libtool242 coreutils
    ];
    hardeningDisable = ["format"];
    dontDisableStatic = true;
    dontUseAutoreconf = true;
    dontFixLibtool = true;

    prePatch = ''
      chmod -R +w .
      ./contrib/gcc_update
      cp -r ${./files/gcc}/* .
    '';

    patchFlags = [ "-p0" ];
    patches = [
      ./patches/gcc/libstdc++-v3.config.os.generic.error_constants.h.p
      ./patches/gcc/libstdc++-v3.libsupc++.eh_personality.cc.p
      # ./patches/gcc/unused/ltconfig.p
      # ./patches/gcc/unused/ltcf-cxx.sh.p
      # ./patches/gcc/unused/gcc.flow.c.p
      # ./patches/gcc/unused/ltcf-c.sh.p
      # ./patches/gcc/unused/gcc.global.c.p
      # ./patches/gcc/unused/gcc.reload1.c.p
      # ./patches/gcc/unused/ltmain.sh.p
      # ./patches/gcc/unused/gcc.mklibgcc.in.p
      ./patches/gcc/libtool.m4.p
      ./patches/gcc/gcc.ada.env.c.p
      ./patches/gcc/gcc.config.host.p
      ./patches/gcc/libstdc++-v3.libsupc++.Makefile.am.p
      # ./patches/gcc/todo/gcc.c-opts.c.p
      # ./patches/gcc/todo/libcpp.Makefile.in.p
      # ./patches/gcc/todo/gcc.diagnostic.c.p
      # ./patches/gcc/todo/libcpp.errors.c.p
      # ./patches/gcc/todo/libcpp.include.cpplib.h.p
      # ./patches/gcc/todo/libcpp.directives.c.p
      ./patches/gcc/gcc.ada.cstreams.c.p
      ./patches/gcc/gcc.cp.cfns.gperf.p
      ./patches/gcc/gcc.config.arm.arm-protos.h.p
      ./patches/gcc/Makefile.def.p
      ./patches/gcc/libjava.configure.ac.p
      ./patches/gcc/gcc.opts-common.c.p
      ./patches/gcc/libstdc++-v3.src.Makefile.am.p
      ./patches/gcc/gcc.config.arm.arm.opt.p
      ./patches/gcc/gcc.defaults.h.p
      ./patches/gcc/gcc.config.arm.arm.md.p
      ./patches/gcc/libgcc.config.arm.unwind-arm.h.p
      ./patches/gcc/gcc.ginclude.unwind-arm-common.h.p
      ./patches/gcc/libstdc++-v3.acinclude.m4.p
      ./patches/gcc/gcc.config.arm.arm-opts.h.p
      ./patches/gcc/gcc.ada.raise-gcc.c.p
      ./patches/gcc/gcc.config.arm.elf.h.p
      ./patches/gcc/libcpp.Makefile.in.p
      ./patches/gcc/Makefile.tpl.p
      ./patches/gcc/gcc.configure.ac.p
      ./patches/gcc/libiberty.configure.ac.p
      ./patches/gcc/libgcc.gthr-posix.h.p
      ./patches/gcc/gcc.doc.invoke.texi.p
      ./patches/gcc/gcc.config.arm.arm.c.p
      ./patches/gcc/gcc.config.arm.arm.h.p
      ./patches/gcc/gcc.incpath.c.p
      ./patches/gcc/libgcc.unwind-arm-common.inc.p
      ./patches/gcc/libstdc++-v3.configure.host.p
      ./patches/gcc/gcc.gcc.c.p
      ./patches/gcc/gcc.builtins.c.p
      ./patches/gcc/libgcc.config.host.p
      ./patches/gcc/libstdc++-v3.crossconfig.m4.p
      ./patches/gcc/gcc.testsuite.ada.acats.run_acats.p
      ./patches/gcc/gcc.ada.adaint.c.p
      ./patches/gcc/gcc.ira.c.p
      ./patches/gcc/gcc.config.gcc.p
      ./patches/gcc/gcc.collect2.c.p
      ./patches/gcc/gcc.ada.gcc-interface.Makefile.in.p
      ./patches/gcc/configure.ac.p
      ./patches/gcc/gcc.toplev.c.p
      ./patches/gcc/libgcc.unwind-pe.h.p
      ./patches/gcc/libstdc++-v3.configure.ac.p
      ./patches/gcc/gcc.reload1.c.p
      ./patches/gcc/gcc.testsuite.ada.acats.run_all.sh.p
      ./patches/gcc/gcc.ada.argv.c.p
      ./patches/gcc/gcc.dwarf2cfi.c.p
      ./patches/gcc/gnattools.Makefile.in.p
      ./patches/gcc/libcpp.directives.c.p
      ./patches/gcc/libstdc++-v3.src.c++11.Makefile.am.p
      ./patches/gcc/libgcc.config.arm.unwind-arm.c.p
      ./patches/gcc/gcc.dwarf2out.c.p
      ./patches/gcc/libgcc.crtstuff.c.p
      ./patches/gcc/libstdc++-v3.src.c++98.Makefile.am.p
      ./patches/gcc/libcpp.configure.ac.p
      ./patches/gcc/gcc.doc.gcc.texi.p
    ];
    preConfigure = ''
      chmod -R +w .
      ( autogen Makefile.def )
      ( autoconf )
      ( cd libcpp && ACLOCAL='aclocal -I .. -I ../config' autoreconf -v )
      ( cd libiberty && ACLOCAL='aclocal -I .. -I ../config' autoreconf -v )
      ( cd libstdc++-v3 && ACLOCAL='aclocal -I .. -I ../config' autoreconf -v )
      patchShebangs --build libunixlib/gen-auto.pl
      echo PATCHED
      ./libunixlib/gen-auto.pl
      ( cd libunixlib && ACLOCAL='aclocal -I .. -I ../config' autoreconf -v )
      cd ..
      mkdir build
      cd build
    '';
    configureScript = "../gcc-gcc-4_7-branch-r${src.rev}/configure";
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
        "--enable-checking=release"
        "AR_FOR_TARGET=${robinutils}/bin/arm-unknown-riscos-ar"
        "AS_FOR_TARGET=${robinutils}/bin/arm-unknown-riscos-as"
        "LD_FOR_TARGET=${robinutils}/bin/arm-unknown-riscos-ld"
        "NM_FOR_TARGET=${robinutils}/bin/arm-unknown-riscos-nm"
        "OBJDUMP_FOR_TARGET=${robinutils}/bin/arm-unknown-riscos-objdump"
        "RANLIB_FOR_TARGET=${robinutils}/bin/arm-unknown-riscos-ranlib"
        "READELF_FOR_TARGET=${robinutils}/bin/arm-unknown-riscos-readelf"
        "STRIP_FOR_TARGET=${robinutils}/bin/arm-unknown-riscos-strip"
      ]
      ++ optional disableMultilib "--disable-multilib";

    enableParallelBuilding = true;
    dontFixup = true;
    dontStrip = true;
    dontPatchELF = true;
  };
in self
