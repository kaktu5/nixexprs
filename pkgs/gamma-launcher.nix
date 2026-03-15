{
  lib,
  sources,
  python314Packages,
}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.licenses) gpl3;
  inherit (lib.strings) removePrefix;
  inherit (python314Packages) buildPythonApplication;
  inherit (sources) gamma-launcher;
in
  buildPythonApplication {
    pname = "gamma-launcher";
    version = removePrefix "v" gamma-launcher.version;

    src = gamma-launcher;
    pyproject = true;

    build-system = [python314Packages.setuptools];
    dependencies = attrValues {
      inherit
        (python314Packages)
        beautifulsoup4
        cloudscraper
        gitpython
        platformdirs
        py7zr
        python-unrar
        requests
        tenacity
        tqdm
        ;
    };

    meta = {
      description = "Just another Launcher to setup S.T.A.L.K.E.R.: G.A.M.M.A.";
      homepage = "https://github.com/mord3rca/gamma-launcher";
      license = gpl3;
      mainProgram = "gamma-launcher";
    };
  }
