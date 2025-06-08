{
  lib,
  stdenv,
  fetchurl,
  automake111,
  pkgs
}:

with pkgs; (overrideCC stdenv gcc10Stdenv).mkDerivation rec {
  pname = "libtool";
  version = "2.4.2";

  src = fetchurl {
    url = "https://ftpmirror.gnu.org/libtool/libtool-${version}.tar.gz";
    sha256 = "sha256-s43kSGKphyk809jfrhxAnVFLbE55TryTZI/r+a/DiRg=";
  };

  buildInputs = with pkgs; [ automake111 autoconf264 gcc10 m4 ];
  hardeningDisable = ["format"];
  dontDisableStatic = true;
}
