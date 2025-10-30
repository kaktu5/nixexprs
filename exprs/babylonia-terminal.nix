{
  lib,
  pkgs,
  sources,
}: let
  inherit (lib.licenses) gpl3;
  inherit (lib.strings) substring;
  inherit (pkgs.rustPlatform) buildRustPackage;
  inherit (sources) babylonia-terminal babylonia-terminal-downloader;
in
  buildRustPackage {
    pname = "babylonia-terminal";
    version = substring 0 8 babylonia-terminal.revision;

    src = babylonia-terminal;
    cargoLock = {
      lockFile = babylonia-terminal + /Cargo.lock;
      outputHashes."downloader-0.2.7" = babylonia-terminal-downloader.hash;
    };

    nativeBuildInputs = [pkgs.glib pkgs.pkg-config];
    buildInputs = [
      pkgs.gdk-pixbuf
      pkgs.gtk4
      pkgs.libadwaita
      pkgs.openssl
      pkgs.pango
      pkgs.wayland
    ];

    meta = {
      description = "A launcher to play a certain anime game on linux";
      homepage = "https://github.com/alez-dev/babylonia-terminal";
      license = gpl3;
      mainProgram = "babylonia-terminal";
    };
  }
