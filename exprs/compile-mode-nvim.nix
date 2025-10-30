{
  lib,
  pkgs,
  sources,
}: let
  inherit (lib.licenses) unlicense;
  inherit (lib.strings) removePrefix;
  inherit (pkgs) vimPlugins;
  inherit (pkgs.vimUtils) buildVimPlugin;
  inherit (sources) compile-mode-nvim;
in
  buildVimPlugin {
    pname = "compile-mode-nvim";
    version = removePrefix "v" compile-mode-nvim.version;

    src = compile-mode-nvim;

    buildInputs = [
      vimPlugins.baleia-nvim
      vimPlugins.plenary-nvim
    ];

    meta = {
      description = "A plugin for Neovim inspired by Emacs Compilation Mode";
      homepage = "https://github.com/ej-shafran/compile-mode.nvim";
      license = unlicense;
    };
  }
