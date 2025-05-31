{
  lib,
  pkgs,
  sources,
}: let
  inherit (lib) licenses substring;
  inherit (pkgs.rustPlatform) buildRustPackage;
  inherit (sources) babylonia-terminal downloader;
in
  buildRustPackage {
    pname = "babylonia-terminal";
    version = substring 0 8 babylonia-terminal.revision;
    src = babylonia-terminal;
    cargoLock = {
      lockFile = babylonia-terminal + /Cargo.lock;
      outputHashes."downloader-0.2.7" = downloader.hash;
    };
    nativeBuildInputs = with pkgs; [glib pkg-config];
    buildInputs = with pkgs; [
      gdk-pixbuf
      gtk4
      libadwaita
      openssl
      pango
      wayland
    ];
    stripAllList = ["bin"];
    meta = {
      mainProgram = "babylonia-terminal";
      description = "A launcher to play a certain anime game on linux";
      homepage = "https://github.com/alez-dev/babylonia-terminal";
      license = licenses.gpl3;
    };
  }
