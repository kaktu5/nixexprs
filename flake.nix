{
  outputs = _: let
    sources = import ./npins;
    lib = import (sources.nixpkgs + /lib);

    inherit (lib.attrsets) mapAttrs zipAttrsWith;
    inherit (lib.lists) foldl';

    mapSystems = systems: f:
      systems
      |> map (s: f s |> mapAttrs (_: v: {${s} = v;}))
      |> zipAttrsWith (_: foldl' (a: b: a // b) {});
  in
    mapSystems ["aarch64-linux" "x86_64-linux"] (system: let
      pkgs = import sources.nixpkgs {inherit system;};
    in {
      devShells.default = import ./internal/devshell.nix {inherit lib pkgs;};

      formatter = import ./internal/formatter.nix {inherit lib pkgs;};

      legacyPackages = import ./internal/legacy-packages.nix {inherit lib pkgs sources;};
    });
}
