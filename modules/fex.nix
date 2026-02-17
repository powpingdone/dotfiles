{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.ppd.box64.enable {

  nix.settings.extra-sandbox-paths = [
    "/run/binfmt"
    "${pkgs.box64}"
  ];
  nix.settings.extra-platforms = [
    #"i686-linux"
    "x86_64-linux"
  ];

  boot.binfmt = lib.mkIf (config.nixpkgs.system == "aarch64-linux") {
    registrations = {
      # 64 bit
      fex-emu-amd64 = {
        # normal setup
        interpreter = "${pkgs.box64}/bin/box64";
        recognitionType = "magic";

        # magic bytes
        magicOrExtension = "\\x7fELF\\x02\\x01\\x01\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x02\\x00\\x3e\\x00";
        mask = "\\xff\\xff\\xff\\xff\\xff\\xfe\\xfe\\x00\\x00\\x00\\x00\\xff\\xff\\xff\\xff\\xff\\xfe\\xff\\xff\\xff";

        # flags
        offset = 0;
        preserveArgvZero = true;
        matchCredentials = true;
        fixBinary = true;
        wrapInterpreterInShell = false;
      };
      # 32 bit
      #fex-emu-x86 = {
      #  # normal setup
      #  interpreter = "${pkgs.fex}/bin/FEXInterpreter";
      #  recognitionType = "magic";

      #  # magic bytes
      #  magicOrExtension = "\\x7fELF\\x01\\x01\\x01\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x02\\x00\\x03\\x00";
      #  mask = "\\xff\\xff\\xff\\xff\\xff\\xfe\\xfe\\x00\\x00\\x00\\x00\\xff\\xff\\xff\\xff\\xff\\xfe\\xff\\xff\\xff";

      #  # flags
      #  offset = 0;
      #  preserveArgvZero = true;
      #  matchCredentials = true;
      #  fixBinary = true;
      #  wrapInterpreterInShell = false;
      #};
    };
  };
}
