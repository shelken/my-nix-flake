{mylib, ...}: {
  imports =
    (mylib.scanPaths ./.)
    ++ [
    ];
}