{
  description = "A flake for an Electron + TypeScript application";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = [
          pkgs.nodejs_20
          pkgs.nodePackages.npm
          pkgs.nodePackages.typescript
          pkgs.nodePackages.eslint
          pkgs.nodePackages.prettier
          pkgs.electron
          pkgs.nodePackages.typescript-language-server
        ];
        
        ELECTRON_CACHE = "$HOME/.cache/electron";
        ELECTRON_BUILDER_CACHE = "$HOME/.cache/electron-builder";
        
        shellHook = ''
          export PATH=$PATH:./node_modules/.bin
        '';
      };

      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "nixos-control-center";
        version = "0.1.0";
        src = ./.;

        nativeBuildInputs = [
          pkgs.nodejs_20
          pkgs.nodePackages.npm
          pkgs.electron
          pkgs.makeWrapper
        ];

        buildPhase = ''
          npm ci
          npm run build
          npm run package
        '';

        installPhase = ''
          mkdir -p $out/bin
          mkdir -p $out/share/electron-app
          cp -r dist/* $out/share/electron-app/
          makeWrapper ${pkgs.electron}/bin/electron $out/bin/electron-app \
            --add-flags "$out/share/electron-app/main.js"
        '';

        meta = with pkgs.lib; {
          description = "NixOS Configuration Management Electron application built with TypeScript";
          maintainers = [];
          platforms = platforms.linux;
        };
      };
    };
}
