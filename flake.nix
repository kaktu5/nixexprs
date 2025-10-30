{
  outputs = {self, ...}: let
    sources = import ./npins;
    lib = import (sources.nixpkgs + /lib);

    inherit (lib.attrsets) attrValues mapAttrs recursiveUpdate;
    inherit (lib.lists) foldl';

    forEachSystem = systems: f: (foldl' (acc: system: (f system
      |> mapAttrs (_: value: {${system} = value;})
      |> recursiveUpdate acc)) {}
    systems);

    mkExprs = pkgs: import ./exprs {inherit pkgs sources;};
  in
    forEachSystem [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ] (system: let
      pkgs = let
        nixpkgs = import sources.nixpkgs {inherit system;};
        flake-compat = import sources.flake-compat;
        statix = (flake-compat {src = sources.statix;}).defaultNix.packages.${system}.default;
      in
        nixpkgs.extend (_: _: {inherit statix;});
    in {
      legacyPackages = mkExprs pkgs;

      devShells.default = pkgs.mkShellNoCC {
        packages = attrValues {
          inherit (pkgs) deadnix nil nixd npins statix;
        };
      };

      formatter = pkgs.writeShellApplication {
        name = "fmt";
        runtimeInputs = attrValues {
          inherit (pkgs) alejandra deadnix fd statix;
        };
        text = ''
          fd "$@" -t f -e nix -E npins/ -X alejandra --quiet '{}'
          fd "$@" -t f -e nix -E npins/ -X deadnix --fail '{}'
          fd "$@" -t f -e nix -E npins/ -x statix check '{}'
        '';
      };
    })
    // {
      overlays = {
        kkts = _: prev: {kkts = mkExprs prev;};
        default = self.overlays.kkts;
      };
    };
}
