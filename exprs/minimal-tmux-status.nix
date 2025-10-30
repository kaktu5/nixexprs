{
  lib,
  pkgs,
  sources,
}: let
  inherit (lib.licenses) mit;
  inherit (lib.sources) cleanSourceWith;
  inherit (lib.strings) hasSuffix substring;
  inherit (pkgs.tmuxPlugins) mkTmuxPlugin;
  inherit (sources) minimal-tmux-status;
in
  mkTmuxPlugin {
    namePrefix = "";
    pluginName = "minimal-tmux-status";
    version = substring 0 8 minimal-tmux-status.revision;

    src = cleanSourceWith {
      src = minimal-tmux-status;
      filter = path: _: (hasSuffix ".tmux" path);
    };

    rtpFilePath = minimal-tmux-status + /minimal.tmux;

    meta = {
      homepage = "https://github.com/niksingh710/minimal-tmux-status";
      description = "A simple minimal tmux theme that does shows prefix key press status";
      license = mit;
    };
  }
