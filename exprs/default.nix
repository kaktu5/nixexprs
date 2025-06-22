{
  pkgs,
  sources,
}: let
  inherit (builtins) readDir;
  inherit (pkgs) callPackage;
  inherit (pkgs.lib) attrNames filter listToAttrs map removeSuffix;
in (
  readDir ./.
  |> attrNames
  |> (filter (file: file != "default.nix"))
  |> (map (file: {
    name = removeSuffix ".nix" file;
    value = callPackage ./${file} {inherit sources;};
  }))
  |> listToAttrs
)
