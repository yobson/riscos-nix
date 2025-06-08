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
        libtool242     = callPackage ./libtool.nix  {};
        robinutils     = callPackage ./binutils.nix {};
        rogmp          = callPackage ./gmp.nix      {};
        rompfr         = callPackage ./mpfr.nix     {};
        rompc          = callPackage ./mpc.nix      {};
        roppl          = callPackage ./ppl.nix      {};
        rocloog        = callPackage ./cloog.nix    {};
        rogcc          = callPackage ./gcc.nix      {};
        gccWrap        = callPackage ./gccWrap.nix  {};
        asasm          = callPackage ./asasm/default.nix   {};
        elf2aif        = callPackage ./elf2aif/default.nix {};
        defaultPackage = gccWrap;
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            robinutils gccWrap elf2aif
          ];
        };
      };
    in packages
  );
}
