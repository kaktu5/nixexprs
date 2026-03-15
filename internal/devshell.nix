{
  lib,
  pkgs,
}: let
  inherit (lib.attrsets) attrValues;
  inherit (pkgs) mkShellNoCC;
in
  mkShellNoCC {
    name = "nixexprs-devshell";
    packages = attrValues {
      # nix
      inherit (pkgs) alejandra nixd npins nushell;
    };
  }
