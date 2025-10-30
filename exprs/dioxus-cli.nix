{
  lib,
  pkgs,
  sources,
}: let
  inherit (lib.licenses) asl20 mit;
  inherit (lib.strings) removePrefix;
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
    buildFeatures = ["no-downloads"];

    nativeCheckInputs = [pkgs.rustfmt];
    checkFlags = ["--skip=serve::proxy::test" "--skip=test_harnesses::run_harness"];

    meta = {
      description = "CLI tool for developing, testing, and publishing Dioxus apps";
      homepage = "https://github.com/dioxuslabs/dioxus";
      license = [asl20 mit];
      mainProgram = "dx";
    };
  }
