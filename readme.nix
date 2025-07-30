{
  lib,
  pkgs,
  exprs,
}: let
  inherit (lib) concatStringsSep mapAttrsToList singleton;
  inherit (pkgs) writeText;
in
  writeText "readme.md" (
    concatStringsSep "\n" (
      (singleton ''
        | Package | Version | Description |
        | :- | :-: | :-: |'')
      ++ (mapAttrsToList (
          _: expr: let
            name =
              expr.pname
              or expr.name
              or expr.kernel.pname
              or expr.kernel.name;
            version =
              expr.version
              or expr.kernel.version;
            description =
              expr.meta.description
              or expr.kernel.meta.description;
          in "| ${name} | ${version} | ${description} |"
        )
        exprs)
    )
  )
