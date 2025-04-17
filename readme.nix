{
  lib,
  packages,
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
          _: pkg: let
            name = pkg.pname or pkg.name;
            inherit (pkg) version;
            inherit (pkg.meta) description;
          in "| ${name} | ${version} | ${description} |"
        )
        packages)
    ))
