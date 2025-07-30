{
  lib,
  pkgs,
  sources,
}: let
  inherit (lib) licenses substring;
  inherit (pkgs.vimUtils) buildVimPlugin;
  inherit (sources) indentmini-nvim;
in
  buildVimPlugin {
    pname = "indentmini-nvim";
    version = substring 0 8 indentmini-nvim.revision;
    src = indentmini-nvim;
    meta = {
      description = "An indentation plugin born for the pursuit of minimal, speed and stability.";
      homepage = "https://github.com/nvimdev/indentmini.nvim";
      license = licenses.mit;
    };
  }
