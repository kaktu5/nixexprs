{
  lib,
  pkgs,
  sources,
}: let
  inherit (lib) licenses;
  inherit (pkgs.stdenv) mkDerivation;
  arkenfox = sources."user.js";
in
  mkDerivation {
    pname = "arkenfox";
    inherit (arkenfox) version;
    src = arkenfox;
    installPhase = ''
      mkdir -p $out/share/arkenfox
      cp $src/user.js $out/share/arkenfox/
    '';
    meta = {
      description = "Firefox privacy, security and anti-tracking: a comprehensive user.js template for configuration and hardening";
      homepage = "https://github.com/arkenfox/user.js";
      license = licenses.mit;
    };
  }
