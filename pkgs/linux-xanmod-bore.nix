{
  lib,
  pkgs,
  sources,
}: let
  inherit (lib) map;
  inherit (pkgs.linuxKernel.kernels) linux_xanmod_latest;
  inherit (sources) linux-xanmod-bore;
  patches = [
    "0001-bore"
    "0002-glitched-cfs"
    "0003-glitched-eevdf-additions"
    "0004-o3-optimization"
  ];
in
  linux_xanmod_latest.override {
    kernelPatches =
      map (patch: {
        name = patch;
        patch = linux-xanmod-bore + /${patch}.patch;
      })
      patches;
    argsOverride = {
      pname = "linux-xanmod-bore";
      extraMeta = {
        description = "Linux Xanmod (Stable) with BORE CPU scheduler and tickrate customizations";
        homepage = "https://github.com/micros24/linux-xanmod-bore";
      };
    };
  }
