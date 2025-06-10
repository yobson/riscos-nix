# /path/to/my-new-riscos-project/flake.nix
{
  description = "A new application for RISC OS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";

    # Point to your toolchain flake. This can be a local path or a git URL.
    riscos-nix.url = "github:yobson/riscos-nix";
  };

  outputs = { self, nixpkgs, utils, riscos-nix }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ riscos-nix.overlay ];
        };
      in
      {
        packages.default = pkgs.riscosPkgs.callPackage ./default.nix {};
      });
}
