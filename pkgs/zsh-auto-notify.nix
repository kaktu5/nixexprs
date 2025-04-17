{
  lib,
  pkgs,
  sources,
}: let
  inherit (lib) licenses;
  inherit (pkgs.stdenv) mkDerivation;
  inherit (sources) zsh-auto-notify;
in
  mkDerivation {
    pname = "zsh-auto-notify";
    inherit (zsh-auto-notify) version;
    src = zsh-auto-notify;
    installPhase = ''
      mkdir -p $out/share/zsh-auto-notify
      cp $src/auto-notify.plugin.zsh $out/share/zsh-auto-notify
    '';
    meta = {
      description = "Simple zsh plugin that automatically sends out a notification when a long running task has completed";
      homepage = "https://github.com/michaelaquilina/zsh-auto-notify";
      license = licenses.gpl3;
    };
  }
