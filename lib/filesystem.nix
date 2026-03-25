_: self: super: let
  inherit (self) filter hasSuffix;
  inherit (self.filesystem) listFilesRecursive;
in {
  collectNix = path: filter (hasSuffix ".nix") (listFilesRecursive path);
}
