{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        python-env = pkgs.python312.withPackages (
          ps: with ps; [
            ipykernel
            jupyterlab
            ipywidgets
            pandas
            scipy
            numpy
            matplotlib
            seaborn
            python-dotenv
            requests
            pyarrow
            tqdm
            pywavelets
            scikit-image
          ]
        );

      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            python-env
          ];

          shellHook = ''
            export PYTHONPATH="${python-env}/${pkgs.python312.sitePackages}:$PYTHONPATH"
            echo "Polymarket API Dev Environment"
            echo "Python version: $(python --version)"
            echo "To start Jupyter Lab, run: jupyter lab"
          '';
        };
      }
    );
}
