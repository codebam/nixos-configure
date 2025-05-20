{
  description = "A flake for a Rust + Qt6 application";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      qtPkgs = pkgs.qt6;
      rustToolchain = pkgs.rustPlatform;
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = [
          pkgs.pkg-config
          pkgs.cargo
          pkgs.rustc
          pkgs.rustfmt
          pkgs.rust-analyzer
          pkgs.clippy
          qtPkgs.qtbase
          qtPkgs.qtdeclarative
          qtPkgs.wrapQtAppsHook
        ];
        buildInputs = [
          qtPkgs.qtbase
          qtPkgs.qtdeclarative
        ];
        # QT_LOGGING_RULES = "qt6.debug=false";
      };

      packages.${system}.default = rustToolchain.buildRustPackage {
        pname = "nixos-configure";
        version = "0.1.0";
        src = ./.;
        cargoLock = {
          lockFile = ./Cargo.lock;
        };
        nativeBuildInputs = [
          pkgs.pkg-config
          qtPkgs.qtbase
          qtPkgs.qtdeclarative
          qtPkgs.wrapQtAppsHook
        ];
        buildInputs = [
          qtPkgs.qtbase
          qtPkgs.qtdeclarative
        ];
      };
    };
}
