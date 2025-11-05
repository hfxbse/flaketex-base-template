{
  description = "Tools to compile this FlakeTeX project template.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    flaketex = {
      url = "github:hfxbse/nixos-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      flaketex,
    }:
    flake-utils.lib.eachDefaultSystemPassThrough (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Additional TeX Live packages can be looked up at https://search.nixos.org/packages
        # For more information see https://wiki.nixos.org/wiki/TexLive
        latex = pkgs.texliveSmall.withPackages (
          texlivePackages: with texlivePackages; [
            babel
            biber
            biblatex
            biblatex-ieee
            csquotes
            csquotes-de
            ec
            translation-biblatex-de

            # Not limited to TeX Live packages
            # Other dependencies can be accessed using `pkgs.<package-name>`
            # Search for packages at https://search.nixos.org/packages
          ]
        );

        compile-latex = flaketex.packages.${system}.flaketex.override { inherit latex; };
      in
      {
        templates.default = {
          path = ./.;
        };

        apps.${system} = {
          pdftex = self.apps.${system}.pdflatex;
          pdflatex = {
            type = "app";
            program = "${latex}/bin/pdflatex";
          };

          biber = {
            type = "app";
            program = "${latex}/bin/biber";
          };
        };

        packages.${system} = {
          default = self.packages.${system}.pdf;
          pdf = pkgs.callPackage (
            { stdenvNoCC, ... }:
            stdenvNoCC.mkDerivation rec {
              name = "flaketex-base-template";
              src = ./src;
              nativeBuildInputs = [ compile-latex ];

              buildPhase = ''
                HOME=$(mktemp -d);
                compile-latex -f "main.tex" -- -interaction=nonstopmode -halt-on-error;
              '';

              installPhase = ''
                install -Dm 644 "main.pdf" "$out/${name}.pdf";
              '';
            }
          ) { };

          builder = pkgs.writeShellScriptBin "builder" ''
            ${compile-latex}/bin/compile-latex -f "src/main.tex" -o "out" -- $@;
          '';
        };
      }
    );
}
