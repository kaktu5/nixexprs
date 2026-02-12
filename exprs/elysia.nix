{
  alsa-lib,
  clangStdenv,
  fetchurl,
  ffmpeg,
  fontconfig,
  freetype,
  libGL,
  libGLU,
  libclang,
  libxkbcommon,
  makeWrapper,
  openssl,
  pkg-config,
  python3,
  rustPlatform,
  wayland,
  lib,
  sources,
}: let
  inherit (clangStdenv.cc) libc;
  inherit (lib.licenses) gpl3;
  inherit (lib.strings) makeLibraryPath removePrefix;
  inherit (sources) elysia;

  buildRustPackage = rustPlatform.buildRustPackage.override {stdenv = clangStdenv;};

  skiaBinaries = fetchurl {
    url = "https://github.com/rust-skia/skia-binaries/releases/download/0.87.0/skia-binaries-e551f334ad5cbdf43abf-x86_64-unknown-linux-gnu-egl-gl-pdf-svg-textlayout-wayland-x11.tar.gz";
    sha256 = "sha256-m6Zb7mTlt+c3OgX+Sge+upTl8nXfBQhfFCuzkvFmhJg=";
  };
in
  buildRustPackage {
    pname = "elysia";
    version = removePrefix "v" elysia.version;

    src = elysia;
    cargoLock = {
      lockFile = elysia + /Cargo.lock;
      outputHashes."freya-0.4.0" = "sha256-dBDz5/gnpqi6EcS1Mp8vaFSR7f5kN6gr0elu4NtbPt8=";
    };

    nativeBuildInputs = [
      libclang
      makeWrapper
      pkg-config
      python3
    ];
    buildInputs = [
      alsa-lib
      ffmpeg
      fontconfig
      freetype
      libGL
      libGLU
      openssl
      wayland
    ];

    env = {
      BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${libc.dev}/include";
      LIBCLANG_PATH = libclang.lib + /lib;
      SKIA_BINARIES_URL = "file://${skiaBinaries}";
    };

    postInstall = ''
      wrapProgram $out/bin/elysia --prefix LD_LIBRARY_PATH : ${makeLibraryPath [libGL libxkbcommon wayland]}
    '';

    meta = {
      description = "A launcher for anime games on Linux, supporting Wine and Proton";
      homepage = "https://dawn.wine/elysia/elysia";
      license = gpl3;
      mainProgram = "elysia";
    };
  }
