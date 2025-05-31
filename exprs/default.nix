{
  pkgs,
  sources,
}: let
  inherit (builtins) readDir;
  inherit (lib) attrNames filter listToAttrs map removeSuffix;
  inherit (pkgs) lib;
in (
  readDir ./.
  |> attrNames
  |> (filter (file: file != "default.nix"))
  |> (map (file: {
    name = removeSuffix ".nix" file;
    value = import ./${file} {inherit lib pkgs sources;};
  }))
  |> listToAttrs
)
