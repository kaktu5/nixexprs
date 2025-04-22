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
  }: let
    mkExprs = pkgs: (import ./exprs {
      inherit pkgs;
      sources = import ./npins;
    });
  in
    flake-utils.lib.eachSystem ["aarch64-linux" "x86_64-linux"] (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      inherit (pkgs) lib;
      exprs = mkExprs pkgs;
      readme = import ./readme.nix {inherit exprs lib pkgs;};
      treefmt = (treefmt-nix.lib.evalModule pkgs ./treefmt.nix).config.build;
    in {
      packages = exprs // {inherit readme;};
      formatter = treefmt.wrapper;
      checks.formatting = treefmt.check self;
    })
    // {overlays.default = _: prev: (mkExprs prev);};
}
