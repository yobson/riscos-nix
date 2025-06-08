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
        rogccBoot      = callPackage ./gcc-bootstrap.nix      {};
        rogmp          = callPackage ./gmp.nix      {};
        rompfr         = callPackage ./mpfr.nix     {};
        rompc          = callPackage ./mpc.nix      {};
        defaultPackage = rogccBoot;
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            robinutils
          ];
        };
      };
    in packages
  );
}
