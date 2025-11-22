{
  lib,
  pkgs,
  sources,
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  pkgs' = import sources.nixpkgs-for-xanmod {inherit system;};

  inherit (lib.meta) getExe';
  inherit (lib.strings) removeSuffix;
  inherit (pkgs') buildLinux linuxPackagesFor lld llvm llvmPackages stdenvAdapters;
  inherit (sources) xanmod;
in
  linuxPackagesFor (buildLinux {
    pname = "linux-xanmod";
    version = removeSuffix "-xanmod1" xanmod.version;
    modDirVersion = xanmod.version;

    src = xanmod;

    stdenv = stdenvAdapters.overrideInStdenv llvmPackages.stdenv [lld llvm];
    makeFlags = {
      LLVM = 1;
      AR = getExe' llvm "llvm-ar";
      CC = getExe' llvmPackages.clang-unwrapped "clang";
      LD = getExe' lld "ld.lld";
      NM = getExe' llvm "llvm-nm";
      KCFLAGS = ["-pipe" "-O2" "-fomit-frame-pointer" "-march=x86-64-v3"];
    };

    ignoreConfigErrors = true;
    structuredExtraConfig = let
      inherit (lib.kernel) freeform no yes;
      mkOverride' = lib.modules.mkOverride 60;
    in {
      # toolchain
      CC_IS_CLANG = mkOverride' yes;
      LTO = mkOverride' yes;
      LTO_CLANG = mkOverride' yes;
      LTO_CLANG_THIN = mkOverride' yes;

      # BORE Scheduler
      # SCHED_BORE = yes;

      # CPUFreq governor Performance
      CPU_FREQ_DEFAULT_GOV_PERFORMANCE = mkOverride' yes;
      CPU_FREQ_DEFAULT_GOV_SCHEDUTIL = mkOverride' no;

      # Preemption
      PREEMPT_VOLUNTARY = mkOverride' no;

      # Google's BBRv3 TCP congestion Control
      TCP_CONG_BBR = yes;
      DEFAULT_BBR = yes;

      # Preemptive tickless idle kernel
      HZ = freeform "500";
      HZ_250 = yes;
      NO_HZ = no;
      NO_HZ_FULL = mkOverride' no;
      NO_HZ_IDLE = yes;

      # CPU idle governors favored
      CPU_IDLE_GOV_HALTPOLL = yes; # Already enabled
      CPU_IDLE_GOV_LADDER = yes;
      CPU_IDLE_GOV_TEO = yes;

      # RCU_BOOST and RCU_EXP_KTHREAD
      RCU_EXPERT = yes;
      RCU_FANOUT = freeform "64";
      RCU_FANOUT_LEAF = freeform "16";
      RCU_BOOST = yes;
      RCU_BOOST_DELAY = freeform "0";
      RCU_EXP_KTHREAD = yes;
      RCU_NOCB_CPU = yes;
      RCU_DOUBLE_CHECK_CB_TIME = yes;

      # x86 features
      X86_FRED = yes;
      X86_POSTED_MSI = yes;

      # Lazy preemption
      PREEMPT = mkOverride' no;
      PREEMPT_LAZY = yes;
    };
  })