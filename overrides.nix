{ pkgs }:

self: super: {
  zipp = super.zipp.overridePythonAttrs(old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ [
      self.toml
    ];
  });

  nixops = super.nixops.overridePythonAttrs (
    old: {
      format = "pyproject";

      nativeBuildInputs = old.nativeBuildInputs ++ [
        self.poetry
      ];
    }
  );
}
