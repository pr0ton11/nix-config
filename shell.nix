{ pkgs }:

let
  nix-config-upgrade = pkgs.writeShellScriptBin "switch" (builtins.readFile ./switch);
in
with pkgs;
mkShell {
  packages = [ nix-config-upgrade ];
}
