{...}: {
  ppd.desktop.enable = true;
  ppd.steam.enable = false;
  ppd.peekPoke.enable = true;
  ppd.isHIDPI = true;
  ppd.system = "aarch64-linux";
  ppd.overlays = [
    (final: prev: {
      # custom kernel
      x1e80100-kernel = final.callPackage ./kernel.nix {};

      # custom firmware needed
      x1e80100-lenovo-yoga-slim7x-firmware = final.callPackage ./x1e80100-lenovo-yoga-slim7x-firmware.nix {};
      x1e80100-lenovo-yoga-slim7x-firmware-json = final.callPackage ./x1e80100-lenovo-yoga-slim7x-firmware-json.nix {};

      # along with loader for the firmware
      libqrtr = final.callPackage ./libqrtr.nix {};
      pd-mapper = final.callPackage ./pd-mapper.nix {};
    })
  ];
}
