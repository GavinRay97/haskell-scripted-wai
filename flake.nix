{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        };
      in
      {
        devShell = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.pkg-config ];

          buildInputs = [
            pkgs.zlib
            pkgs.zlib.dev

            pkgs.stack
            pkgs.cabal-install
            pkgs.haskell.compiler.ghc901
            pkgs.haskell.packages.ghc901.haskell-language-server
          ];

          shellHook = "export PS1='\\e[1;34mdev > \\e[0m'";
        };
      }
    );
}
