{ pkgs ? import <nixpkgs> { } }:

let
  sharedLibDependencies = [ pkgs.zlib pkgs.zlib.dev ];
in
pkgs.mkShell {
  nativeBuildInputs = [ pkgs.pkg-config ];

  buildInputs = [
    # Haskell
    pkgs.stack
    pkgs.cabal-install
    pkgs.haskell.compiler.ghc8107
    pkgs.haskell.packages.ghc8107.haskell-language-server
  ] ++ (sharedLibDependencies);
}
