{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      callPackage = pkgs.lib.callPackageWith (pkgs // riscosTools);
      riscosTools = rec {
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
        elf2aif        = callPackage ./elf2aif/default.nix {};
        cmunge         = callPackage ./cmunge/default.nix {};
        mkresfs        = callPackage ./mkresfs/default.nix {};
      };

      riscosPkgs = import nixpkgs {
        inherit system;
        crossSystem = {
          system = "arm-none-elf";
          config = "arm-unknown-riscos";
        };
        overlays = [
          (final: prev: {
            stdenv = prev.stdenv.override {
              cc = riscosTools.gccWrap;
              binutils = riscosTools.robinutils;
              binutils-unwrapped = riscosTools.robinutils;
            };
          })
        ];
      };
    in {
      packages   = riscosTools;
      riscosPkgs = riscosPkgs;

      devShell = pkgs.mkShell {
        nativeBuildInputs = with riscosTools; [
          robinutils gccWrap elf2aif cmunge mkresfs
        ];
      };
      overlays.default = final: prev: {
        riscosPkgs = self.riscosPkgs.${system};
      };

      defaultPackage = riscosTools.gccWrap;
    }
  );
}
