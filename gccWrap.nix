{ stdenv, makeWrapper, rogcc, robinutils }:

stdenv.mkDerivation {
  name = "arm-unknown-riscos-gcc-wrapper";

  buildInputs = [ makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin

    # Create a wrapper around the real gcc
    makeWrapper ${rogcc}/bin/arm-unknown-riscos-gcc $out/bin/arm-unknown-riscos-gcc \
      --add-flags "-B${robinutils}/bin/arm-unknown-riscos-"

    makeWrapper ${rogcc}/bin/arm-unknown-riscos-g++ $out/bin/arm-unknown-riscos-g++ \
      --add-flags "-B${robinutils}/bin/arm-unknown-riscos-"
  '';
}
