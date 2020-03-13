{ pkgs }:

self: super: {
  zipp = super.zipp.overridePythonAttrs(old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ [
      self.toml
    ];
  });

  nixops = super.zipp.overridePythonAttrs(old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [
      self.poetry
    ];
  });

}
