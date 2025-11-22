{
  appimageTools,
  fetchurl,
  icu,
  makeWrapper,
  lib,
  releaseStream ? "lazer",
}: let
  inherit (appimageTools) extract wrapType2;
  inherit (lib.licenses) cc-by-nc-40 mit unfreeRedistributable;
  inherit (lib.strings) fromJSON readFile;

  sources = (fromJSON <| readFile ./sources.json).${releaseStream};

  pname = "osu-lazer-bin";
  inherit (sources) version;
  src = fetchurl {inherit (sources) url hash;};
in
  wrapType2 {
    inherit pname version src;

    extraPkgs = _: [icu];

    extraInstallCommands = let
      contents = extract {inherit pname version src;};
    in ''
      source ${makeWrapper}/nix-support/setup-hook

      mv -v $out/bin/${pname} $out/bin/osu!

      wrapProgram $out/bin/osu! \
        --set OSU_EXTERNAL_UPDATE_PROVIDER "1" \
        --set OSU_EXTERNAL_UPDATE_STREAM "${releaseStream}" \
        --set vblank_mode "0"

      install -m 444 -D ${contents}/osu!.desktop -t $out/share/applications
      for i in 16 32 48 64 96 128 256 512 1024; do
        install -D ${contents}/osu.png $out/share/icons/hicolor/''${i}x$i/apps/osu.png
      done
    '';

    meta = {
      description = "Rhythm is just a *click* away";
      homepage = "https://osu.ppy.sh";
      license = [cc-by-nc-40 mit unfreeRedistributable];
      mainProgram = "osu!";
      passthru.updateScript = ./update.nu;
    };
  }
