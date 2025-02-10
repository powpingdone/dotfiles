{
  lib,
  config,
  ...
}: {
  imports = [
    ./base.nix
    ./idevice.nix
    ./desktop.nix
    ./nixindex.nix
    ./emacs.nix
    ./steam.nix
    ./peekpoke.nix
  ];
}
