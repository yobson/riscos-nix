{lib, stdenv}:

stdenv.mkDerivation {
  pname = "hello-riscos";
  version = "1.0";

  src = ./.;
}
