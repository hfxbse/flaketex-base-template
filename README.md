# FlakeTeX base template

This template provides a full [FlakeTeX](https://github.com/hfxbse/nixos-config/tree/derivation/flaketex) setup to get
started writing your LaTeX document instantly.
It is not just a simple LaTeX template but provides additional features like:

- **GitHub Actions integration**: Automatically release the matching PDF document on each push.
- **Easy LaTeX setup**: Installs LaTeX and the required dependencies reliably and automatically. Most additional TeX
  Live LaTeX packages can be added by just specifying their name in the project configuration file.
- **Predictable results**: Get the same output document every time thanks to [Nix](https://nixos.org/), regardless of
  where you run it.

The template is preconfigured but not limited to use German localization and IEEE as citation style based on
the [suggestions of the DHBW-Stuttgart Fakultät Technik](https://www.dhbw.de/fileadmin/user_upload/Dokumente/Dokumente_fuer_Studierende/Leitlinien_fuer_die_Bearbeitung_und_Dokumentation_Fakultaet_Technik_Okt_2017.pdf).

Check out the releases for the [documentation](https://github.com/hfxbse/flaketex-base-template/releases), which is
built using this template.
