{
  lib,
  pkgs,
}: let
  inherit (lib.attrsets) attrValues;
  inherit (pkgs) writeShellApplication;
in
  writeShellApplication {
    name = "nixexprs-nix3-fmt-wrapper";

    runtimeInputs = attrValues {
      inherit (pkgs) alejandra fd;
    };

    text = ''
      fd "$@" -t f -e nix -E npins/default.nix -X alejandra --quiet '{}'
    '';
  }
