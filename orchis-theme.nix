let
  src = builtins.fetchGit {
    url = "https://github.com/codebyallan/orchis-nixos";
    rev = "d026288880d1d13f0d29f98a78cea35e0918e720";
  };
in
import "${src}/orchis.nix"