{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs = {
    self,
    nixpkgs,
  }: let
    lib = import ./lib {inherit (nixpkgs) lib;};
    mkExprs = pkgs: (import ./exprs {
      inherit pkgs;
      sources = import ./npins;
    });
  in
    lib.kkts.forEachSystem [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ] (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      exprs = mkExprs pkgs;
      readme = import ./readme.nix {inherit exprs lib pkgs;};
    in {
      packages = exprs // {inherit readme;};
      devShells.default = pkgs.mkShellNoCC {packages = [pkgs.npins];};
      formatter = pkgs.writeShellApplication {
        name = "format";
        runtimeInputs = with pkgs; [alejandra fd];
        text = ''
          fd "$@" -t f -e nix -E npins/ -X alejandra '{}'
        '';
      };
    })
    // {
      lib = lib.kkts;
      overlays = {
        default = self.overlays.kkts;
        kkts = _: prev: {kkts = mkExprs prev;};
      };
    };
}
