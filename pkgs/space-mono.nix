{
  lib,
  sources,
  installFonts,
  stdenvNoCC,
}: let
  inherit (lib.licenses) ofl;
  inherit (lib.strings) substring;
  inherit (sources) space-mono;
  inherit (stdenvNoCC) mkDerivation;
in
  mkDerivation {
    pname = "space-mono";
    version = substring 0 7 space-mono.revision;

    outputs = ["out" "webfont"];

    src = space-mono + /fonts;

    nativeBuildInputs = [installFonts];

    meta = {
      description = "Space Mono is an original monospace display typeface family designed by Colophon Foundry for Google Design";
      homepage = "https://github.com/googlefonts/spacemono";
      license = ofl;
    };
  }
