{
  lib,
  pkgs,
  command_prefix ? (lib.getExe pkgs.gamemode),
  pipewire_latency ? "256/44100",
  release_stream ? "lazer",
  ...
}: let
  inherit (builtins) fromJSON;
  inherit (lib) isString licenses optionalString readFile;
  inherit (pkgs) fetchurl makeWrapper;
  inherit (pkgs.appimageTools) extract wrapType2;
  info = ((readFile ./info.json) |> fromJSON).${release_stream};
  osu-appimage = fetchurl {inherit (info) url hash;};
in
  wrapType2 rec {
    pname = "osu-lazer-bin";
    inherit (info) version;
    src = osu-appimage;
    extraPkgs = pkgs: [pkgs.icu];
    extraInstallCommands = let
      contents = extract {inherit pname version src;};
    in ''
      . ${makeWrapper}/nix-support/setup-hook
      mv -v $out/bin/${pname} $out/bin/osu!

      wrapProgram $out/bin/osu! \
        --set PIPEWIRE_LATENCY "${pipewire_latency}" \
        --set OSU_EXTERNAL_UPDATE_PROVIDER "1" \
        --set OSU_EXTERNAL_UPDATE_STREAM "${release_stream}" \
        --set vblank_mode "0"

      ${
        optionalString (isString command_prefix) ''
          sed -i '$s:exec -a "$0":exec ${command_prefix}:' $out/bin/osu!
        ''
      }

      install -m 444 -D ${contents}/osu!.desktop -t $out/share/applications
      for i in 16 32 48 64 96 128 256 512 1024; do
        install -D ${contents}/osu.png $out/share/icons/hicolor/''${i}x$i/apps/osu.png
      done
    '';
    meta = {
      description = "Rhythm is just a *click* away";
      homepage = "https://osu.ppy.sh";
      license = with licenses; [cc-by-nc-40 mit unfreeRedistributable];
      mainProgram = "osu!";
      passthru.updateScript = ./update.nu;
      platforms = ["x86_64-linux"];
    };
  }
