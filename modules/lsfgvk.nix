{lib, config, pkgs, ...}: lib.mkIf config.ppd.lsfgvk.enable {
  environment.systemPackages = with pkgs; [
    lsfg-vk
  ];
 
  nixpkgs.overlays = [
    (final: prev: {
      lsfg-vk = prev.lsfg-vk.overrideAttrs (finalAttrs: let
          rev = "8b0da2661c6f3473a7fccc8ba643880050e71642";
        in {
          version = rev;

          src = prev.fetchFromGitHub {
            owner = "PancakeTAS";
            repo = "lsfg-vk";
            inherit rev;
            hash = "sha256-SDZXT+eYkOPr/qqZgCip9YSSf6SWwuvv1Y20+hlqGCw=";
            fetchSubmodules = true;
          };

          buildInputs = with pkgs; [
            vulkan-headers
            vulkan-loader
          ];

          postPatch = null;
  
          postFixup = ''
              substituteInPlace "$out/share/vulkan/implicit_layer.d/VkLayer_LSFGVK_frame_generation.json" \
                --replace-fail "liblsfg-vk-layer.so" "$out/lib/liblsfg-vk-layer.so"
              patchelf --add-needed "${pkgs.vulkan-loader}/lib/libvulkan.so.1" "$out/bin/lsfg-vk-cli"
            '';
      });
    })
  ];
}
