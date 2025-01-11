{ ... }: {
  channel = "stable-24.05";
  idx = {
    extensions = [
      "anwar.papyrus-pdf"
      "bbenoist.Nix"
      "valentjn.vscode-ltex"
      "emeraldwalk.RunOnSave"
    ];
  };
}