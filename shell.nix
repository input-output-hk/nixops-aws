{ pkgs ? import (
  fetchTarball {
    url = https://github.com/nixos/nixpkgs-channels/archive/10100a97c8964e82b30f180fda41ade8e6f69e41.tar.gz;
    sha256 = "011f36kr3c1ria7rag7px26bh73d1b0xpqadd149bysf4hg17rln";
  }
) {} }:

let

  overrides = import ./overrides.nix { inherit pkgs; };

in pkgs.mkShell {

  buildInputs = [
    # (pkgs.poetry2nix.mkPoetryEnv {
    #   projectDir = ./.;
    #   poetrylock = ./poetry.lock;
    #   overrides = pkgs.poetry2nix.overrides.withDefaults(overrides);
    # })
    pkgs.poetry
  ];

}
