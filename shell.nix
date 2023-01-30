{ pkgs, ... }:

let
  nix-config-switch = pkgs.writeShellScriptBin "switch" (builtins.readFile ./switch);
in
with pkgs;
mkShell {
  packages = [ nix-config-switch ];
}
