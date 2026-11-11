let
  src = builtins.fetchGit {
    url = "https://github.com/codebyallan/orchis-nixos";
    rev = "af2c6e2fdb6d0fdc4973c6caa2796b1d2b62e5ac";
  };
in
import "${src}/orchis.nix"