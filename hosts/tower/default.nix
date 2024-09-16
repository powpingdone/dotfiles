
{ nixpkgs, unstable, lib, ... }:
{
  networking.hostName = "PPD-TOWER";

  modules.ppdesktop.enable = true;
}
