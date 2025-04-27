{
  lib,
  config,
  ...
}: {
  imports = [
    ./base.nix
    ./desktop.nix
    ./nixindex.nix
    ./emacs.nix
    ./steam.nix
    ./peekpoke.nix
    ./virtmanager.nix
    ./libvirtd.nix
  ];
}
