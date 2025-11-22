{
  lib,
  pkgs,
  sources,
}: let
  inherit (lib.customisation) callPackageWith;
  inherit (lib.filesystem) packagesFromDirectoryRecursive;
  inherit (lib.fixedPoints) fix;
in
  fix (final:
    packagesFromDirectoryRecursive {
      callPackage = callPackageWith (pkgs // final // {inherit sources;});
      directory = ../exprs;
    })
