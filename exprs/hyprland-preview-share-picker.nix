{
  lib,
  pkgs,
  sources,
}: let
  inherit (lib.licenses) mit;
  inherit (lib.strings) removePrefix;
  inherit (pkgs.rustPlatform) buildRustPackage;
  inherit (sources) hyprland-preview-share-picker;
in
  buildRustPackage {
    pname = "hyprland-preview-share-picker";
    version = removePrefix "v" hyprland-preview-share-picker.version;

    src = hyprland-preview-share-picker;
    cargoLock.lockFile = hyprland-preview-share-picker + /Cargo.lock;

    nativeBuildInputs = [pkgs.pkg-config];
    buildInputs = [
      pkgs.gdk-pixbuf
      pkgs.gobject-introspection
      pkgs.graphene
      pkgs.gtk4
      pkgs.gtk4-layer-shell
      pkgs.hyprland-protocols
      pkgs.pango
    ];

    preBuild = ''
      ln -s ${pkgs.hyprland-protocols}/share/hyprland-protocols/protocols lib/hyprland-protocols/
    '';

    meta = {
      description = "An alternative share picker for Hyprland with window and monitor previews";
      homepage = "https://github.com/whysobad/hyprland-preview-share-picker";
      license = mit;
      mainProgram = "hyprland-preview-share-picker";
    };
  }
