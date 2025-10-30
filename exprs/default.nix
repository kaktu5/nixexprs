{
  pkgs,
  sources,
}: let
  inherit (builtins) readDir;
  inherit (pkgs) callPackage;
  inherit (pkgs.lib.attrsets) attrNames listToAttrs;
  inherit (pkgs.lib.lists) filter map;
  inherit (pkgs.lib.strings) removeSuffix;
in
  readDir ./.
  |> attrNames
  |> (filter (file: file != "default.nix"))
  |> (map (file: {
    name = removeSuffix ".nix" file;
    value = callPackage ./${file} {inherit sources;};
  }))
  |> listToAttrs
