{mylib, ...}: {
  imports = (mylib.scanPaths ./.)
  ++ [
  ];
}
