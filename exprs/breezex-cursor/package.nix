{
  lib,
  sources,
  clickgen,
  resvg,
  stdenvNoCC,
  baseName ? "BreezeX",
  baseColor ? "#000000",
  outlineColor ? "#ffffff",
  watchColor ? "#000000",
  xcursorSizes ? [16 20 22 24 28 32 40 48 56 64 72 80 88 96],
}: let
  inherit (lib.licenses) gpl3;
  inherit (lib.strings) concatMapStringsSep removePrefix;
  inherit (sources) breezex-cursor;
  inherit (stdenvNoCC) mkDerivation;

  bitmapDir = "bitmaps/${baseName}";
in
  mkDerivation {
    pname = "breezex-cursor";
    version = removePrefix "v" breezex-cursor.version;

    src = breezex-cursor;

    nativeBuildInputs = [clickgen resvg];

    buildPhase = ''
      mkdir -p ${bitmapDir}

      render_svg() {
        local src="$1" name="$2"
        echo "Rendering: $src -> $name.png"
        sed \
          "$src" \
          -e 's/#00FF00/${baseColor}/g' \
          -e 's/#0000FF/${outlineColor}/g' \
          -e 's/#FF0000/${watchColor}/g' \
            | resvg \
              --resources-dir "$(dirname "$src")" \
              --width 222 --height 222 \
              - ${bitmapDir}/$name.png
      }

      for svgFile in svg/*.svg; do
        render_svg "$svgFile" "$(basename "$svgFile" .svg)"
      done

      for svgFile in svg/*/*.svg; do
        render_svg "$svgFile" "$(basename "$svgFile" .svg)"
      done

      ctgen configs/x.build.toml \
        -s ${xcursorSizes |> concatMapStringsSep " " toString} \
        -p x11 \
        -d ${bitmapDir} \
        -n ${baseName}
    '';

    installPhase = ''
      install -dm 755 $out/share/icons
      cp -r themes/${baseName} $out/share/icons/
    '';

    meta = {
      description = "Extended KDE cursor";
      homepage = "https://github.com/ful1e5/breezex_cursor";
      license = gpl3;
    };
  }
