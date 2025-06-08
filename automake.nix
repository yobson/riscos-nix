{
  lib,
  stdenv,
  fetchurl,
  perl,
  autoconf,
}:

stdenv.mkDerivation rec {
  pname = "automake";
  version = "1.11.1";
  builder = ./scripts/builder.sh;
  setupHook = ./scripts/setup-hook.sh;

  src = fetchurl {
    url = "https://ftpmirror.gnu.org/automake/automake-${version}.tar.bz2";
    sha256 = "sha256-WxWdPA4KH4fecbaLy58aHEnp5xdJybcj8X4uHgKVx64=";
  };

  patchFlags = ["-p0"];
  patches = [
    ./patches/automake/perl.patch
  ];

  strictDeps = true;
  nativeBuildInputs = [
    perl
    autoconf
  ];
  buildInputs = [ autoconf ];

  doCheck = false; # takes _a lot_ of time, fails 11 of 782 tests

  # Don't fixup "#! /bin/sh" in Libtool, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;

  # Run the test suite in parallel.
  enableParallelBuilding = true;

  meta = {
    branch = "1.11";
    homepage = "https://www.gnu.org/software/automake/";
    description = "GNU standard-compliant makefile generator";

    longDescription = ''
      GNU Automake is a tool for automatically generating
      `Makefile.in' files compliant with the GNU Coding
      Standards.  Automake requires the use of Autoconf.
    '';

    license = lib.licenses.gpl2Plus;

    platforms = lib.platforms.all;
  };
}
