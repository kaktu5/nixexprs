{
  lib,
  pkgs,
  sources,
}: let
  inherit (lib) licenses substring;
  inherit (pkgs.stdenv) mkDerivation;
  inherit (sources) dm-mono;
in
  mkDerivation {
    pname = "dm-mono";
    version = substring 0 8 dm-mono.revision;
    src = dm-mono;
    installPhase = "install -Dm444 $src/exports/*.ttf -t $out/share/fonts/truetype";
    meta = {
      description = "DM Mono is a 3 weight, 3 style family designed for DeepMind";
      homepage = "https://fonts.google.com/specimen/DM+Mono";
      license = licenses.ofl;
    };
  }
