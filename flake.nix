{
  inputs.systems = {
    url = "path:internal/systems.nix";
    flake = false;
  };

  outputs = {systems, ...}: let
    sources = import ./npins;
    lib = import (sources.nixpkgs + /lib);

    inherit (lib.attrsets) mapAttrs zipAttrsWith;
    inherit (lib.lists) foldl';
    inherit (lib.trivial) mergeAttrs;

    mapSystems = systems: f:
      systems
      |> map (s: f s |> mapAttrs (_: v: {${s} = v;}))
      |> zipAttrsWith (_: foldl' mergeAttrs {});
  in
    mapSystems (import systems) (system: let
      pkgs = import sources.nixpkgs {inherit system;};
    in {
      devShells.default = import ./internal/devshell.nix {inherit pkgs;};

      formatter = import ./internal/formatter.nix {inherit lib pkgs;};

      legacyPackages = import ./internal/legacy-packages.nix {inherit lib pkgs sources;};
    });
}
