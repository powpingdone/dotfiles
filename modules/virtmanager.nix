{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ppd.virtManager.enable {
    # base always installs my user, so just make him the god
    users.users.powpingdone.extraGroups = ["libvirtd"];

    programs.virt-manager.enable = true;
  };
}
