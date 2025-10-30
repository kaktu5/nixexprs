{
  lib,
  pkgs,
  sources,
}: let
  inherit (lib.attrsets) attrValues getLib;
  inherit (lib.licenses) gpl3;
  inherit (lib.strings) removePrefix;
  inherit (pkgs.python312Packages) buildPythonApplication buildPythonPackage setuptools;
  inherit (sources) gamma-launcher python-unrar;

  unrar = buildPythonPackage {
    pname = "unrar";
    inherit (python-unrar) version;

    src = python-unrar;
    pyproject = true;

    build-system = [setuptools];

    postPatch = ''
      substituteInPlace unrar/unrarlib.py --replace \
        "lib_path = os.environ.get('UNRAR_LIB_PATH', None)" \
        "lib_path = os.environ.get('UNRAR_LIB_PATH', '${getLib pkgs.unrar}/lib/libunrar.so')"
    '';
  };
in
  buildPythonApplication {
    pname = "gamma-launcher";
    version = removePrefix "v" gamma-launcher.version;

    src = gamma-launcher;
    pyproject = true;

    build-system = [setuptools];
    dependencies = attrValues {
      inherit
        (pkgs.python312Packages)
        beautifulsoup4
        cloudscraper
        gitpython
        platformdirs
        py7zr
        requests
        tenacity
        tqdm
        ;
      inherit unrar;
    };

    meta = {
      description = "Just another Launcher to setup S.T.A.L.K.E.R.: G.A.M.M.A.";
      homepage = "https://github.com/mord3rca/gamma-launcher";
      license = gpl3;
      mainProgram = "gamma-launcher";
    };
  }
