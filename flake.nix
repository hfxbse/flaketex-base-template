{
  description = "Tools to compile this FlakeTeX project template.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    flaketex = {
      url = "github:hfxbse/nixos-config?ref=derivation/flaketex";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, flaketex }: flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};

    # Additional TeX Live packages can be looked up at https://search.nixos.org/packages
    # For more information see https://wiki.nixos.org/wiki/TexLive
    latex = pkgs.texliveSmall.withPackages ( texlivePackages: with texlivePackages; [
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
      ]);

    compile-latex = flaketex.packages.${system}.compile-latex.override { inherit latex; };
  in
  {
    apps.pdftex = self.apps.${system}.pdflatex;
    apps.pdflatex = {
      type = "app";
      program = "${latex}/bin/pdflatex";
    };

    apps.biber = {
      type = "app";
      program = "${latex}/bin/biber";
    };

    packages.default = self.packages.${system}.build;
    packages.build = pkgs.writeShellScriptBin "build" ''
      ${compile-latex}/bin/compile-latex -f "src/main.tex" -o "out" -- $@;
    '';
  });
}
