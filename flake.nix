{
  inputs.nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

  outputs = {
    self,
    nixpkgs,
  }: let
    sources = import ./npins;

    inherit (nixpkgs) lib;
    inherit (lib.attrsets) mapAttrs zipAttrsWith;
    inherit (lib.lists) foldl';

    mapSystems = systems: f:
      systems
      |> map (s: f s |> mapAttrs (_: v: {${s} = v;}))
      |> zipAttrsWith (_: foldl' (a: b: a // b) {});
  in
    mapSystems ["aarch64-linux" "x86_64-linux"] (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = import ./internal/devshell.nix {inherit lib pkgs;};

      formatter = import ./internal/formatter.nix {inherit lib pkgs;};

      packages = import ./internal/packages.nix {inherit lib pkgs sources;};
    })
    // {
      overlays.default = _: prev: let
        inherit (prev.stdenv.hostPlatform) system;
      in {kkts = self.packages.${system};};
    };
}
