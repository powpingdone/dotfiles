
{ nixpkgs, unstable, lib, ... }:
{
  networking.hostName = "PPD-TOWER";

  ppdesktop.enable = true;
}
