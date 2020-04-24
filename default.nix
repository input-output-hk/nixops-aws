{ pkgs ? import <nixpkgs> {} }:

let

  overrides = import ./overrides.nix { inherit pkgs; };

in pkgs.poetry2nix.mkPoetryApplication {
  projectDir = ./.;
  overrides = pkgs.poetry2nix.overrides.withDefaults overrides;

  postInstall = ''
    mkdir -p $out/share/nix/nixopsaws
    cp -av nix/* $out/share/nix/nixopsaws
  '';
}
