{
  lib,
  pkgs,
  sources,
}: let
  inherit (lib) licenses substring;
  inherit (pkgs.rustPlatform) buildRustPackage;
  inherit (sources) dioxus;
in
  buildRustPackage {
    pname = "dioxus-cli";
    version = substring 0 8 dioxus.revision;
    src = dioxus;
    cargoLock.lockFile = dioxus + /Cargo.lock;
    buildAndTestSubdir = "packages/cli";
    nativeBuildInputs = [pkgs.pkg-config];
    buildInputs = [pkgs.openssl];
    useFetchCargoVendor = true;
    OPENSSL_NO_VENDOR = 1;
    doCheck = false;
    meta = {
      description = "CLI tool for developing, testing, and publishing Dioxus apps.";
      homepage = "https://github.com/dioxuslabs/dioxus";
      license = with licenses; [asl20 mit];
    };
  }
