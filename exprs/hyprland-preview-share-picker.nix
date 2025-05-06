{
  lib,
  pkgs,
  sources,
}: let
  inherit (lib) licenses removePrefix;
  inherit (pkgs.rustPlatform) buildRustPackage;
  inherit (sources) hyprland-preview-share-picker;
in
  buildRustPackage {
    pname = "hyprland-preview-share-picker";
    version = removePrefix "v" hyprland-preview-share-picker.version;
    src = hyprland-preview-share-picker;
    cargoLock.lockFile = hyprland-preview-share-picker + /Cargo.lock;
    nativeBuildInputs = [pkgs.pkg-config];
    buildInputs = with pkgs; [
      gdk-pixbuf
      gobject-introspection
      graphene
      gtk4
      gtk4-layer-shell
      hyprland-protocols
      pango
    ];
    preBuild = ''
      cp -r ${pkgs.hyprland-protocols}/share/hyprland-protocols/protocols lib/hyprland-protocols/
    '';
    stripAllList = ["bin"];
    meta = {
      description = "An alternative share picker for Hyprland with window and monitor previews";
      homepage = "https://github.com/whysobad/hyprland-preview-share-picker";
      license = licenses.mit;
    };
  }
