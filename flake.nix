{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      callPackage = pkgs.lib.callPackageWith (pkgs // packages);
      packages = rec {
        riscosTargetTriple = "arm-unknown-riscos";
        automake111    = callPackage ./automake.nix {};
        robinutils     = callPackage ./binutils.nix {};
        rogccSrc       = callPackage ./gcc-src.nix  {};
        rogccLibs      = callPackage ./gcc-libs.nix {};
        rogmp          = callPackage ./gmp.nix      {};
        rompfr         = callPackage ./mpfr.nix     {};
        rompc          = callPackage ./mpc.nix      {};
        roppl          = callPackage ./mpc.nix      {};
        rocloog        = callPackage ./mpc.nix      {};
        rogcc          = callPackage ./gcc.nix      {};
        defaultPackage = rogcc;
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            robinutils
          ];
        };
      };
    in packages
  );
}
