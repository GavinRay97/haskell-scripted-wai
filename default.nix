{ pkgs ? import <nixpkgs> { } }:

let
  sharedLibDependencies = [ pkgs.zlib pkgs.zlib.dev ];
in
pkgs.mkShell rec {
  nativeBuildInputs = [ pkgs.pkg-config ];

  buildInputs = [
    # Haskell
    pkgs.stack
    pkgs.cabal-install
    pkgs.haskell.compiler.ghc8107
    pkgs.haskell.packages.ghc8107.haskell-language-server
  ] ++ (sharedLibDependencies);

  # Ensure that libz.so and other libraries are available to TH
  # splices, cabal repl, etc.
  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
}
