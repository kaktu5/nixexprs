{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs = {nixpkgs, ...}: let
    inherit (nixpkgs) lib;
    forEachSystem = lib.genAttrs [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    mkExprs = pkgs: (import ./exprs {
      inherit pkgs;
      sources = import ./npins;
    });
    systemOutputs = forEachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      exprs = mkExprs pkgs;
      readme = import ./readme.nix {inherit exprs lib pkgs;};
    in {
      packages = exprs // {inherit readme;};
      formatter = pkgs.alejandra;
    });
  in {
    packages = lib.mapAttrs (_: attrs: attrs.packages) systemOutputs;
    formatter = lib.mapAttrs (_: attrs: attrs.formatter) systemOutputs;
    overlays.default = _: prev: {kkts = mkExprs prev;};
  };
}
