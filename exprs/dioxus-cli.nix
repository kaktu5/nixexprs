{
  lib,
  pkgs,
  sources,
}: let
  inherit (lib) licenses removePrefix;
  inherit (pkgs.rustPlatform) buildRustPackage;
  inherit (sources) dioxus-cli;
in
  buildRustPackage {
    pname = "dioxus-cli";
    version = removePrefix "v" dioxus-cli.version;
    src = dioxus-cli;
    cargoLock.lockFile = dioxus-cli + /Cargo.lock;
    buildAndTestSubdir = "packages/cli";
    nativeBuildInputs = [pkgs.pkg-config];
    buildInputs = [pkgs.openssl];
    OPENSSL_NO_VENDOR = 1;
    doCheck = false;
    stripAllList = ["bin"];
    meta = {
      description = "CLI tool for developing, testing, and publishing Dioxus apps.";
      homepage = "https://github.com/dioxuslabs/dioxus";
      license = with licenses; [asl20 mit];
      mainProgram = "dx";
      platforms = ["aarch64-linux" "x86_64-linux"];
    };
  }
