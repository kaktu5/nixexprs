{
  exprs,
  lib,
  pkgs,
}: let
  inherit (pkgs) writeText;
in
  writeText "README.md" (let
    inherit (lib) concatStringsSep mapAttrsToList singleton;
  in
    concatStringsSep "\n" (
      (singleton ''
        | Package | Version | Description |
        | :- | :-: | :-: |'')
      ++ (mapAttrsToList (
          _: expr: let
            name = expr.pname or expr.name;
            inherit (expr) version;
            inherit (expr.meta) description;
          in "| ${name} | ${version} | ${description} |"
        )
        exprs)
    ))
