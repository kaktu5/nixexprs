{
  lib,
  pkgs,
  sources,
}: let
  inherit (lib) licenses removePrefix;
  inherit (pkgs.vimUtils) buildVimPlugin;
  inherit (sources) compile-mode-nvim;
in
  buildVimPlugin {
    pname = "compile-mode-nvim";
    version = removePrefix "v" compile-mode-nvim.version;
    src = compile-mode-nvim;
    buildInputs = with pkgs.vimPlugins; [baleia-nvim plenary-nvim];
    meta = {
      description = "A plugin for Neovim inspired by Emacs Compilation Mode";
      homepage = "https://github.com/ej-shafran/compile-mode.nvim";
      license = licenses.unlicense;
    };
  }
