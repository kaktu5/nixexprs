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
      inherit (pkgs) alejandra nixd npins nushell;
    };
  }
