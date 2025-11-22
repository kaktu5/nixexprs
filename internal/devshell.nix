{pkgs}: let
  inherit (pkgs) mkShellNoCC;
in
  mkShellNoCC {
    name = "nixexprs-devshell";
    packages = [
      pkgs.nixd
      pkgs.npins
    ];
  }
