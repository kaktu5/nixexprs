{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    treefmt-nix,
    ...
  }:
    flake-utils.lib.eachSystem ["aarch64-linux" "x86_64-linux"] (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      inherit (pkgs) lib;
      packages = import ./pkgs {
        inherit lib pkgs;
        sources = import ./npins;
      };
      readme = import ./readme.nix {inherit lib packages pkgs;};
      treefmt = (treefmt-nix.lib.evalModule pkgs ./treefmt.nix).config.build;
    in {
      packages = packages // {inherit readme;};
      formatter = treefmt.wrapper;
      checks.formatting = treefmt.check self;
    });
}
