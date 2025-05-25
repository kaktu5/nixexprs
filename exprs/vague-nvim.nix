{
  lib,
  pkgs,
  sources,
}: let
  inherit (lib) licenses removePrefix;
  inherit (pkgs.vimUtils) buildVimPlugin;
  vague-nvim = sources."vague.nvim";
in
  buildVimPlugin {
    pname = "vague-nvim";
    version = removePrefix "v" vague-nvim.version;
    src = vague-nvim;
    meta = {
      description = "vague is a cool, dark, low contrast theme inspired by ThePrimeagen's use of rose-pine without fixing tmux's colors";
      homepage = "https://github.com/vague2k/vague.nvi";
      license = licenses.mit;
    };
  }
