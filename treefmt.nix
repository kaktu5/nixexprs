_: let
  excludes = ["npins/default.nix"];
in {
  projectRootFile = "flake.nix";
  programs = {
    alejandra = {enable = true;} // {inherit excludes;};
    deadnix = {enable = true;} // {inherit excludes;};
    statix = {enable = true;} // {inherit excludes;};
  };
}
