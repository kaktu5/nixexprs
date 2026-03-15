{
  config,
  lib,
  sources,
  autoAddDriverRunpath,
  cmake,
  rocmPackages,
  stdenv,
  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
}: let
  inherit (lib.attrsets) getLib;
  inherit (lib.licenses) asl20;
  inherit (lib.lists) optional;
  inherit (lib.platforms) linux;
  inherit (lib.strings) optionalString removePrefix;
  inherit (sources) btop;
  inherit (stdenv) mkDerivation;
in
  mkDerivation {
    pname = "btop-custom";
    version = removePrefix "v" btop.version;

    src = btop;
    patches = [
      ./collapse-process-tree-branches.patch
      ./shorten-process-command-paths.patch
    ];

    nativeBuildInputs = [cmake] ++ optional cudaSupport autoAddDriverRunpath;

    postPhases = optional rocmSupport "postPatchelf";
    postPatchelf = optionalString rocmSupport ''
      patchelf --add-rpath ${getLib rocmPackages.rocm-smi}/lib $out/bin/btop
    '';

    meta = {
      description = "Custom build of btop";
      homepage = "https://github.com/aristocratos/btop";
      license = asl20;
      platforms = linux;
      mainProgram = "btop";
    };
  }
