{ nixopsSrc ? { outPath = ./.; revCount = 0; shortRev = "awsjal"; rev = "HEAD"; }
, officialRelease ? false
, nixpkgs ? <nixpkgs>
}:

let
  pkgs = import nixpkgs { };
  version = "1.7" + (if officialRelease then "" else "pre${toString nixopsSrc.revCount}_${nixopsSrc.shortRev}");
in

rec {
  build = pkgs.lib.genAttrs [ "x86_64-linux" "i686-linux" "x86_64-darwin" ] (system:
    with import nixpkgs { inherit system; };

#   python2Packages.buildPythonApplication rec {
    python2Packages.buildPythonPackage rec {
      name = "nixops-aws-${version}";
      namePrefix = "";

      src = ./.;

      prePatch = ''
        for i in setup.py; do
          substituteInPlace $i --subst-var-by version ${version}
        done
      '';

      buildInputs = [ python2Packages.nose python2Packages.coverage ];

      propagatedBuildInputs = with python2Packages;
        [
          boto
          boto3
        ];

      # For "nix-build --run-env".
      shellHook = ''
        export PYTHONPATH=$(pwd):$PYTHONPATH
        export PATH=$(pwd)/scripts:${openssh}/bin:$PATH
      '';

      doCheck = true;

#      postCheck = ''
#        # We have to unset PYTHONPATH here since it will pick enum34 which collides
#        # with python3 own module. This can be removed when nixops is ported to python3.
#        PYTHONPATH= mypy --cache-dir=/dev/null nixops
#
#        # smoke test
#        HOME=$TMPDIR $out/bin/nixops --version
#      '';

#      # Needed by libcloud during tests
#      SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

#      # Add openssh to nixops' PATH. On some platforms, e.g. CentOS and RHEL
#      # the version of openssh is causing errors when have big networks (40+)
#      makeWrapperArgs = ["--prefix" "PATH" ":" "${openssh}/bin" "--set" "PYTHONPATH" ":"];

      postInstall =
        ''
          mkdir -p $out/share/nix/nixops-aws
          cp -av nix/* $out/share/nix/nixops-aws
        '';

#      meta.description = "Nix package for ${stdenv.system}";
    });

#  tests.none_backend = (import ./tests/none-backend.nix {
#    nixops = build.x86_64-linux;
#    system = "x86_64-linux";
#  }).test;
}
