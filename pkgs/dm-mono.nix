{
  lib,
  pkgs,
  sources,
}: let
  inherit (lib) licenses;
  inherit (pkgs.stdenv) mkDerivation;
in
  mkDerivation {
    name = "dm-mono";
    src = sources.dm-mono;
    installPhase = "install -Dm444 $src/exports/*.ttf -t $out/share/fonts/truetype";
    meta = {
      description = "DM Mono is a 3 weight, 3 style family designed for DeepMind";
      homepage = "https://fonts.google.com/specimen/DM+Mono";
      license = licenses.ofl;
    };
  }
