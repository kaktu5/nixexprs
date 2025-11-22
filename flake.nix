{
  inputs.systems = {
    url = "path:internal/systems.nix";
    flake = false;
  };

  outputs = {systems, ...}: let
    sources = import ./npins;
    lib = import (sources.nixpkgs + /lib);

    inherit (lib.attrsets) mapAttrs recursiveUpdate;
    inherit (lib.lists) foldl';

    mapSystems = systems: f: (foldl' (acc: system: (f system
      |> mapAttrs (_: value: {${system} = value;})
      |> recursiveUpdate acc)) {}
    systems);
  in
    mapSystems (import systems) (system: let
      pkgs = import sources.nixpkgs {inherit system;};
    in {
      devShells.default = import ./internal/devshell.nix {inherit pkgs;};

      formatter = import ./internal/formatter.nix {inherit lib pkgs;};

      legacyPackages = import ./internal/legacy-packages.nix {inherit lib pkgs sources;};
    });
}
